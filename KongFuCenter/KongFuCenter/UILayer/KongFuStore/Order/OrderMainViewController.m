//
//  OrderMainViewController.m
//  KongFuCenter
//
//  Created by Wangjc on 16/1/21.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "OrderMainViewController.h"



@interface OrderMainViewController ()
{
    NSArray *cateArr;
    NSMutableArray *btnArr;
    
    CGFloat _cellHeight;
    
    UITableView *_mainTableView;
    
    OrderMode orderMode;
}
@end

@implementation OrderMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    cateArr = @[@"待付款",@"待发货",@"待收货",@"已收货"];
    btnArr = [NSMutableArray array];
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
    pageSize = 10;
    
//    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height+44, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height )];
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height+44, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height ) style:UITableViewStyleGrouped];
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
        [_mainTableView.mj_header endRefreshing];
    }];
    [_mainTableView.mj_header beginRefreshing];
    
    // 上拉刷新
    _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [weakSelf FooterRefresh];
        [_mainTableView.mj_footer endRefreshing];
    }];

    [self.view addSubview:_mainTableView];
    
}

#pragma mark - click actions

-(void)cateBtnClick:(UIButton *)sender
{
    orderMode = (OrderMode)sender.tag;
    sender.selected = YES;
    for(int i =0;i<btnArr.count;i++)
    {
        if(i != sender.tag)
        {
            ((UIButton *)btnArr[i]).selected = NO;
        }
    }
    //更新数据
    [_mainTableView.mj_header beginRefreshing];
    [_mainTableView reloadData];
}

#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
    
}

#pragma mark - setting for cell

#define GapToLeft 20
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight)];;
    cell.backgroundColor = ItemsBaseColor;
    @try {
        
    
        
        if(indexPath.row == 2)
        {
            UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 20 - 80), 10, 80, 30)];
            btnRight.backgroundColor = YellowBlock;
            btnRight.titleLabel.font = [UIFont systemFontOfSize:14];
            [cell addSubview:btnRight];
            
            UIButton *btnLeft = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 20 - 80-20-btnRight.frame.size.width),
                                                                           10, 80, 30)];
            btnLeft.backgroundColor = [UIColor grayColor];
            btnLeft.titleLabel.font = [UIFont systemFontOfSize:14];
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
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(GapToLeft, 10, _cellHeight, _cellHeight - 20)];
            imgView.image = [UIImage imageNamed:@"KongFuStoreProduct"];
            [cell addSubview:imgView];
            
            UILabel *nowPriceLab = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 10 - 80), 10, 80, 30)];
            nowPriceLab.textColor = Separator_Color;
            nowPriceLab.text = @"¥20.00";
            nowPriceLab.textAlignment = NSTextAlignmentRight;
            nowPriceLab.font = [UIFont systemFontOfSize:14];
            [cell addSubview:nowPriceLab];
            
            UILabel *oldPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(nowPriceLab.frame.origin.x,
                                                                             (nowPriceLab.frame.origin.y+nowPriceLab.frame.size.height),
                                                                             nowPriceLab.frame.size.width, 20)];
            oldPriceLab.textColor = Separator_Color;
            oldPriceLab.text = @"¥20.00";
            oldPriceLab.textAlignment = NSTextAlignmentRight;
            oldPriceLab.font = [UIFont systemFontOfSize:12];
            [cell addSubview:oldPriceLab];

            UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(oldPriceLab.frame.origin.x,
                                                                             (oldPriceLab.frame.origin.y+oldPriceLab.frame.size.height),
                                                                             oldPriceLab.frame.size.width, 20)];
            numLab.textColor = Separator_Color;
            numLab.text = @"x1";
            numLab.textAlignment = NSTextAlignmentRight;
            numLab.font = [UIFont systemFontOfSize:12];
            [cell addSubview:numLab];
            
            UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake((imgView.frame.origin.x + imgView.frame.size.width)+5,
                                                                          10, (SCREEN_WIDTH), 30)];
            titleLab.text = @"男士哑铃一对10公斤";
            titleLab.textColor = [UIColor whiteColor];
            
            titleLab.font = [UIFont systemFontOfSize:14];
            [cell addSubview:titleLab];
            
            
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
    
    if(indexPath.row == 2)
    {
        return 50;
    }
    
    return _cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    NSLog(@"click cell section : %ld row : %ld",(long)indexPath.section,(long)indexPath.row);
    
    OrderDetailViewController *orderDetailViewCtl = [[OrderDetailViewController alloc] init];
    orderDetailViewCtl.orderMode = orderMode;
    orderDetailViewCtl.navtitle = @"订单详情";
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
