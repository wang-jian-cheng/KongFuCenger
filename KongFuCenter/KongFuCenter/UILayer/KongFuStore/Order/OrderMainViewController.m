//
//  OrderMainViewController.m
//  KongFuCenter
//
//  Created by Wangjc on 16/1/21.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "OrderMainViewController.h"



@interface OrderMainViewController ()<UIAlertViewDelegate>
{
    NSArray *cateArr;
    NSMutableArray *btnArr;
    
    CGFloat _cellHeight;
    
    UITableView *_mainTableView;
    
    OrderMode orderMode;
    
    UIButton *selectBtn;
    BOOL loading;
    BOOL headLoading;
}

@end

@implementation OrderMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    headLoading = YES;
    cateArr = @[@"待付款",@"待发货",@"待收货",@"已收货"];
    btnArr = [NSMutableArray array];
    orderType = OrderTypeNeedPay;
    [self addLeftButton:@"left"];
    [self initViews];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

-(void)initViews
{
    UIView *viewForBtns = [[UIView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, 44)];
    for (int i = orderNeedPay;i< (cateArr.count+orderNeedPay); i++) {
        UIButton *cateBtn = [[UIButton alloc] initWithFrame:CGRectMake(0 + i*(SCREEN_WIDTH/cateArr.count), 0,(SCREEN_WIDTH/cateArr.count) , viewForBtns.frame.size.height)];
        
        if(i == 0)
        {
            cateBtn.selected = YES;
        }
        
        [cateBtn setTitle:cateArr[i] forState:UIControlStateNormal];
        cateBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        cateBtn.backgroundColor = ItemsBaseColor;
        [cateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cateBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        cateBtn.tag = i;
        
        [cateBtn addTarget:self action:@selector(cateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [viewForBtns addSubview:cateBtn];
        [btnArr addObject:cateBtn];
    }
    
    [self.view addSubview:viewForBtns];
    
    _cellHeight = 100;
    pageSize = 5;
    
//    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height+44, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height )];
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height+44, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height - 44 ) style:UITableViewStyleGrouped];
    _mainTableView.backgroundColor = BACKGROUND_COLOR;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorColor =  Separator_Color;
//    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.tableFooterView = [[UIView alloc] init];
    //_mainTableView.scrollEnabled = NO;
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    _mainTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{

        pageNo=0;
        // 结束刷新
        [_mainTableView.mj_footer setState:MJRefreshStateIdle];
        headLoading = YES;
        
        [weakSelf getOrderlist];
        
    }];
    [_mainTableView.mj_header beginRefreshing];
    
    // 上拉刷新
    _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        headLoading = NO;
        [weakSelf getOrderlist];
        
    }];

    [self.view addSubview:_mainTableView];
    
}

#pragma mark - click actions

-(void)cateBtnClick:(UIButton *)sender
{
    
    
    if(loading == YES)
        return;
    
    
    if(selectBtn != sender)
    {
        [self.orderArr removeAllObjects];
        [_mainTableView reloadData];
    }
    selectBtn = sender;
    sender.selected = YES;
    orderMode = (OrderMode)sender.tag;
    
//    [self.orderArr removeAllObjects];
    
    for(int i =0;i<btnArr.count;i++)
    {
        if(i != sender.tag)
        {
            ((UIButton *)btnArr[i]).selected = NO;
        }
    }
    
    switch (sender.tag) {
        case 0:
            orderType = OrderTypeNeedPay;
            break;
        case 1:
            orderType = OrderTypeNeedSend;
            break;
        case 2:
            orderType = OrderTypeAlreadySend;
            break;
        case 3:
            orderType = OrderTypeAlReadyReceive;
            break;
            
        default:
            break;
    }
    
    //更新数据
    [_mainTableView.mj_header beginRefreshing];
//    [_mainTableView reloadData];
}

-(void)rightBtnClick:(UIButton *)sender
{
    if([sender.titleLabel.text isEqualToString:@"去付款"])
    {
        PayOrderViewController *payOrderViewCtl = [[PayOrderViewController alloc] init];
        payOrderViewCtl.navtitle = @"确认订单";
        payOrderViewCtl.goodDicts = self.orderArr[sender.tag][@"ProList"];
        payOrderViewCtl.payOrderId = self.orderArr[sender.tag][@"Id"];
        payOrderViewCtl.postage = [self.orderArr[sender.tag][@"Postage"] floatValue];
        payOrderViewCtl.paytype = PayByOrderId;
        [self.navigationController pushViewController:payOrderViewCtl animated:YES];
    }
    else if([sender.titleLabel.text isEqualToString:@"评价商品"])
    {
        CommentOrderViewController *commentOrderViewCtl = [[CommentOrderViewController alloc] init];
        commentOrderViewCtl.navtitle = @"评价订单";
        commentOrderViewCtl.GoodsArray = self.orderArr[sender.tag][@"ProList"];
        [self.navigationController pushViewController:commentOrderViewCtl animated:YES];
    }
    else if ([sender.titleLabel.text isEqualToString:@"取消订单"]) {
        [self CancleOrder:sender];
    }
    else if([sender.titleLabel.text isEqualToString:@"确认收货"])
    {
        [self SureForOrder:sender];
    }
}

-(void)leftBtnClick:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"取消订单"]) {
        [self CancleOrder:sender];
    }
    else if ([sender.titleLabel.text isEqualToString:@"查看物流"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://m.kuaidi100.com/index_all.html?type=%@&postid=%@",self.orderArr[sender.tag][@"LiveryType"],self.orderArr[sender.tag][@"LiveryNo"]]]];
    }
}

#pragma mark - self property
-(NSMutableArray *) orderArr
{
    if(_orderArr == nil)
    {
        _orderArr = [NSMutableArray array];
    }
    
    return _orderArr;
}
#pragma mark - self data source

-(void)getOrderlist
{
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getOrderlistCallBack:"];
    [dataProvider getOrderList:[Toolkit getUserID] andState:ZY_NSStringFromFormat(@"%d",orderType) andProNum:ZY_NSStringFromFormat(@"%u",10000) andStartRowIndex:ZY_NSStringFromFormat(@"%d",pageNo*pageSize) andMaximumRows:ZY_NSStringFromFormat(@"%d",pageSize)];
    
    loading = YES;
}


-(void)getOrderlistCallBack:(id)dict
{
    loading = NO;
    DLog(@"%@",dict);
    [_mainTableView.mj_header endRefreshing];
    [_mainTableView.mj_footer endRefreshing];
    if([dict[@"code"] intValue] == 200)
    {
        [SVProgressHUD dismiss];
        pageNo ++;
        if(headLoading == YES)
        {
            [self.orderArr removeAllObjects];
        }
        [self.orderArr addObjectsFromArray:dict[@"data"]];
        
        
        
        if(self.orderArr.count >= [dict[@"recordcount"] integerValue])
        {
            [_mainTableView.mj_footer setState:MJRefreshStateNoMoreData];
        }
        [_mainTableView reloadData];

    }
    else
    {
        [SVProgressHUD showErrorWithStatus:dict[@"data"] maskType:SVProgressHUDMaskTypeBlack];
    }
}

/**
 *  取消订单
 *
 *  @param sender
 */
-(void)CancleOrder:(UIButton *)sender
{
    
    UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"是否取消该订单" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alert.delegate=self;
    alert.tag=1*100000+sender.tag;
    [alert show];
}
-(void)CancleOrderCallBack:(id)dict
{
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        [SVProgressHUD showSuccessWithStatus:@"订单取消成功" maskType:SVProgressHUDMaskTypeBlack];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"订单取消出错" maskType:SVProgressHUDMaskTypeBlack];
    }
    
    [_mainTableView.mj_header beginRefreshing];
}
/**
 *  确认收货
 *
 *  @param sender
 */
-(void)SureForOrder:(UIButton *)sender
{
    UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"确认收货？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.delegate=self;
    alert.tag=2*100000+sender.tag;
    [alert show];
}
-(void)SureForOrderCallBack:(id)dict
{
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        [SVProgressHUD showSuccessWithStatus:@"订单确认成功" maskType:SVProgressHUDMaskTypeBlack];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"订单确认出错" maskType:SVProgressHUDMaskTypeBlack];
    }
    [_mainTableView.mj_header beginRefreshing];
}

#pragma mark - alert delegate


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {//取消订单
        if ((alertView.tag/100000)==1) {
            DataProvider * dataprovider=[[DataProvider alloc] init];
            
            [dataprovider setDelegateObject:self setBackFunctionName:@"CancleOrderCallBack:"];
            
            [dataprovider CancleOrderWithOrderID:self.orderArr[alertView.tag%100000][@"Id"] andUserId:[Toolkit getUserID]];
            
        }
        else
        {//确认收货
            DataProvider * dataprovider=[[DataProvider alloc] init];
            
            [dataprovider setDelegateObject:self setBackFunctionName:@"SureForOrderCallBack:"];
            
            [dataprovider sureForOrder:[Toolkit getUserID] andBillId:self.orderArr[alertView.tag%200000][@"Id"]];
            
        }
    }
}



#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.orderArr.count;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *tempArr = self.orderArr[section][@"ProList"];
    
    return tempArr.count+1;
    
}

#pragma mark - setting for cell

#define GapToLeft 20
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight)];
    cell.backgroundColor = ItemsBaseColor;
    @try {
        
        NSArray *tempArr = self.orderArr[indexPath.section][@"ProList"];
        
        if(indexPath.row == tempArr.count)
        {
            UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 20 - 80), 10, 80, 30)];
            btnRight.backgroundColor = YellowBlock;
            btnRight.titleLabel.font = [UIFont systemFontOfSize:14];
            btnRight.tag = indexPath.section;
            [cell addSubview:btnRight];
            [btnRight addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *btnLeft = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 20 - 80-20-btnRight.frame.size.width),
                                                                           10, 80, 30)];
            btnLeft.backgroundColor = [UIColor grayColor];
            btnLeft.titleLabel.font = [UIFont systemFontOfSize:14];
            btnLeft.tag=indexPath.section;
            [btnLeft addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btnLeft];
            
            switch (orderMode) {
                case orderNeedPay:
                {
                    [btnRight setTitle:@"去付款" forState:UIControlStateNormal];
                    [btnLeft setTitle:@"取消订单" forState:UIControlStateNormal];
                    btnLeft.hidden = NO;
                }
                    break;
                case orderNeedSend:
                {
                    [btnRight setTitle:@"取消订单" forState:UIControlStateNormal];
                    btnLeft.hidden = YES;
                }
                    break;
                case orderNeedReceive:
                {
                    [btnRight setTitle:@"确认收货" forState:UIControlStateNormal];
                    [btnLeft setTitle:@"查看物流" forState:UIControlStateNormal];
                    btnLeft.hidden = NO;

                }
                    break;
                case orderFinish:
                {
                    [btnRight setTitle:@"评价商品" forState:UIControlStateNormal];
                    btnLeft.hidden = YES;
                }
                    break;
                default:
                    break;
            }
        }
        else
        {
            
            NSDictionary *tempDict = tempArr[indexPath.row];
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(GapToLeft, 10, _cellHeight, _cellHeight - 20)];
//            imgView.image = [UIImage imageNamed:@"KongFuStoreProduct"];
            
            NSString *url = ZY_NSStringFromFormat(@"%@%@",Kimg_path,tempDict[@"MiddleImagePath"]);
            [imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"KongFuStoreProduct"]];
            [cell addSubview:imgView];
            
            UILabel *nowPriceLab = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 10 - 80), 10, 80, 30)];
            nowPriceLab.textColor = Separator_Color;
            nowPriceLab.text = ZY_NSStringFromFormat(@"¥%.02f",[tempDict[@"ProductPriceTotalPrice"] floatValue]);
            nowPriceLab.textAlignment = NSTextAlignmentRight;
            nowPriceLab.font = [UIFont systemFontOfSize:14];
            [cell addSubview:nowPriceLab];
            
//            UILabel *oldPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(nowPriceLab.frame.origin.x,
//                                                                             (nowPriceLab.frame.origin.y+nowPriceLab.frame.size.height),
//                                                                             nowPriceLab.frame.size.width, 20)];
//            oldPriceLab.textColor = Separator_Color;
//            oldPriceLab.text = @"¥20.00";
//            oldPriceLab.textAlignment = NSTextAlignmentRight;
//            oldPriceLab.font = [UIFont systemFontOfSize:12];
//            [cell addSubview:oldPriceLab];

            UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(nowPriceLab.frame.origin.x,
                                                                             (nowPriceLab.frame.origin.y+nowPriceLab.frame.size.height),
                                                                             nowPriceLab.frame.size.width, 20)];
            numLab.textColor = Separator_Color;
            numLab.text = ZY_NSStringFromFormat(@"x%ld",[tempDict[@"Number"] integerValue]);
            numLab.textAlignment = NSTextAlignmentRight;
            numLab.font = [UIFont systemFontOfSize:12];
            [cell addSubview:numLab];
            
            UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake((imgView.frame.origin.x + imgView.frame.size.width)+5,
                                                                          10, (nowPriceLab.frame.origin.x - ((imgView.frame.origin.x + imgView.frame.size.width)+5)), 30)];
            titleLab.text = tempDict[@"ProductName"];
            titleLab.textColor = [UIColor whiteColor];
            
            titleLab.font = [UIFont systemFontOfSize:14];
            [cell addSubview:titleLab];
            
            
            UILabel *infolab = [[UILabel alloc] initWithFrame:CGRectMake(titleLab.frame.origin.x,
                                                                        titleLab.frame.size.height+titleLab.frame.origin.y,
                                                                         titleLab.frame.size.width, 40)];
            infolab.textColor = [UIColor grayColor];
            infolab.font = [UIFont systemFontOfSize:14];
            infolab.numberOfLines = 0;
            infolab.text = ZY_NSStringFromFormat(@"规格:%@/%@",tempDict[@"ProductSizeName"],tempDict[@"ProductColorName"]);
            [cell addSubview:infolab];
            
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
    return cell;
    
}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSArray *tempArr = self.orderArr[indexPath.section][@"ProList"];
    
    if(indexPath.row == tempArr.count)
    {
        return 50;
    }
    
    
    return _cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    NSLog(@"click cell section : %ld row : %ld",(long)indexPath.section,(long)indexPath.row);
    
    if(self.orderArr==nil || self.orderArr.count ==0 || self.orderArr.count-1<indexPath.section)
    {
        return;
    }
    OrderDetailViewController *orderDetailViewCtl = [[OrderDetailViewController alloc] init];
    orderDetailViewCtl.orderMode = orderMode;
    orderDetailViewCtl.navtitle = @"订单详情";
    orderDetailViewCtl.OrderDict = self.orderArr[indexPath.section];
    [self.navigationController pushViewController:orderDetailViewCtl animated:YES];
    
}

//设置划动cell是否出现del按钮，可供删除数据里进行处理

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

- (UITableViewCellEditingStyle)tableView: (UITableView *)tableView editingStyleForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  @"删除";
}

//设置选中的行所执行的动作

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return indexPath;
    
}

#pragma mark - setting for section
//设置section的header view

#define SectionHeight  0

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView = [[UIView alloc] init];
    tempView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
    return tempView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *tempView = [[UIView alloc] init];
    tempView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 10);
    return tempView;
}

//设置section header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

//设置section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
