//
//  ShoppinCartViewController.m
//  KongFuCenter
//
//  Created by Wangjc on 16/1/20.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "ShoppingCartViewController.h"

#define GapToLeft   30

@interface ShoppingCartViewController ()

@property(nonatomic) NSMutableArray<CartModel *> *goodsArr;
@property(nonatomic) NSMutableArray *selectArr;
@end

@implementation ShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"left"];
    [self addRightbuttontitle:@"编辑"];
    [self initData];
    [self initViews];
    // Do any additional setup after loading the view.
}




-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

-(void)initData
{
    cellBtnArr = [NSMutableArray array];
    numLabArr = [NSMutableArray array];
    pageSize = 0x0FFFFFFF;
    pageNo = 0;
    self.moneySum = 0;
}

-(void)initViews
{
    _cellHeight = 100;
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height - 60 )];
    _mainTableView.backgroundColor = ItemsBaseColor;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorColor =  Separator_Color;
    _mainTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_mainTableView];
    
    
    UIView *payView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 60, SCREEN_WIDTH , 60)];
    payView.backgroundColor = BACKGROUND_COLOR;
    
    selectAllBtn = [[SelectRoundBtn alloc] initWithCenter:CGPointMake(GapToLeft/2, payView.frame.size.height/2)];
    selectAllBtn.backgroundColor = [UIColor grayColor];
    [selectAllBtn addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [payView addSubview:selectAllBtn];
    
    actionBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3*2, 0, SCREEN_WIDTH/3, payView.frame.size.height)];
    actionBtn.backgroundColor = YellowBlock;
    [actionBtn setTitle:@"结算" forState:UIControlStateNormal];
    [actionBtn addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [payView addSubview:actionBtn];
    
    priceLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 5,
                                                                  (SCREEN_WIDTH - 60 -SCREEN_WIDTH/3-10),
                                                                  payView.frame.size.height/2-5)];
    priceLab.textAlignment = NSTextAlignmentRight;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:NSStringFromFormat(@"结算:¥%.02f",self.moneySum)];
    [str addAttribute:NSForegroundColorAttributeName value:YellowBlock range:NSMakeRange(3,str.length-3)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,3)];
    priceLab.attributedText = str;
    priceLab.font = [UIFont systemFontOfSize:14];
    [payView addSubview:priceLab];
    
    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(priceLab.frame.origin.x, payView.frame.size.height/2,
                                                                priceLab.frame.size.width, payView.frame.size.height/2-5)];
    tipLab.text = @"不含运费";
    tipLab.font = [UIFont systemFontOfSize:14];
    tipLab.textColor = [UIColor whiteColor];
    tipLab.textAlignment = NSTextAlignmentRight;
    [payView addSubview:tipLab];

    [self.view addSubview:payView];
    [self.view bringSubviewToFront:payView];
    
    [self getShoppingCartList];
}

#pragma mark - self data


-(NSMutableArray *)goodsArr
{
    if(_goodsArr ==nil)
    {
        _goodsArr = [NSMutableArray array];
    }
    
    return _goodsArr;
}

-(NSMutableArray*)selectArr
{
    if(_selectArr == nil)
    {
        _selectArr = [NSMutableArray array];
    }
    
    return _selectArr;
}

-(void)setMoneySum:(CGFloat)moneySum
{
    _moneySum = moneySum;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:NSStringFromFormat(@"结算:¥%.02f",_moneySum)];
    [str addAttribute:NSForegroundColorAttributeName value:YellowBlock range:NSMakeRange(3,str.length-3)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,3)];
    priceLab.attributedText = str;
    

}

#pragma mark - self data source

-(void)delCartGoods
{
    
    if(self.selectArr.count == 0)
        return;
    
    NSString *delIds = self.selectArr[0];
    for (int i=1; i<self.selectArr.count; i++) {
        delIds = ZY_NSStringFromFormat(@"%@&%@",delIds,self.selectArr[i]);
    }
    
    [self delCartGoodsAction:delIds];
}

-(void)delCartGoodsAction:(NSString *)delIds
{
    [SVProgressHUD showWithStatus:@"删除中"];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"delCartGoodsCallBack:"];
    [dataProvider delShopCartGoods:[Toolkit getUserID] andIdList:delIds];
}

-(void)delCartGoodsCallBack:(id)dict
{
    DLog(@"%@",dict);
    if([dict[@"code"] intValue] == 200)
    {
        [SVProgressHUD dismiss];

        [self getShoppingCartList];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:dict[@"data"] maskType:SVProgressHUDMaskTypeBlack];
    }

}

-(void)getShoppingCartList
{
    self.moneySum = 0;
    [self.goodsArr removeAllObjects];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getShoppingCartListCallBack:"];
    [dataProvider getShoppingCartList:[Toolkit getUserID] andstartRowIndex:NSStringFromFormat(@"%u",pageNo*pageSize) andmaximumRows:NSStringFromFormat(@"%u",pageSize)];
}

-(void)getShoppingCartListCallBack:(id)dict
{
    DLog(@"%@",dict);
    if([dict[@"code"] intValue] == 200)
    {
        [SVProgressHUD dismiss];
        
//        [self.goodsArr addObjectsFromArray:dict[@"data"]];
        
        for (int i = 0; i<[dict[@"data"] count]; i++) {
            CartModel *tempModel = [[CartModel alloc] init];
            [tempModel setValuesForKeysWithDictionary:dict[@"data"][i]];
            [self.goodsArr addObject:tempModel];
            
            self.moneySum += [tempModel.Number intValue] * [tempModel.ProductPriceTotalPrice floatValue];
            
        }
        
        [_mainTableView reloadData];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:dict[@"data"] maskType:SVProgressHUDMaskTypeBlack];
    }
}


#pragma mark - click actions

-(void)actionBtnClick:(UIButton *)sender
{
    if([sender.titleLabel.text isEqualToString:@"删除"])
    {
        [self delCartGoods];
    }
}

-(void)clickRightButton:(UIButton *)sender
{
    [self.selectArr removeAllObjects];
    selectAllBtn.selected = NO;
    if([_lblRight.text isEqualToString:@"编辑"])
    {
        _lblRight.text = @"完成";
        [actionBtn setTitle:@"删除" forState:UIControlStateNormal];
        EditMode = YES;
    }
    else if([_lblRight.text isEqualToString:@"完成"])
    {
        _lblRight.text = @"编辑";
        [actionBtn setTitle:@"结算" forState:UIControlStateNormal];
        EditMode = NO;
    }
    [_mainTableView reloadData];
}


-(void)plusBtnClick:(UIButton*)sender
{
    UILabel *tempLab = numLabArr[sender.tag-1];
    NSInteger num = [tempLab.text intValue];
    num++;
    tempLab.text = [NSString stringWithFormat:@"%ld",(long)num];
    
    
    CartModel *tempModel = self.goodsArr[sender.tag - 1];
    tempModel.Number = NSStringFromFormat(@"%ld",(long)num);
    
    self.moneySum +=[tempModel.ProductPriceTotalPrice floatValue];
    
}
-(void)delBtnClick:(UIButton*)sender
{
    UILabel *tempLab = numLabArr[sender.tag-1];
    NSInteger num = [tempLab.text intValue];
    if(num>1)
    {
        num--;
        tempLab.text = [NSString stringWithFormat:@"%ld",(long)num];
        CartModel *tempModel = self.goodsArr[sender.tag - 1];
        tempModel.Number = NSStringFromFormat(@"%ld",(long)num);
        self.moneySum -=[tempModel.ProductPriceTotalPrice floatValue];
    }
    else
    {
//        [Dialog simpleToast:@"客官，您还买不买了"];
        [SVProgressHUD showInfoWithStatus:@"客官，你还买不买了"];
    }
    
}


-(void)selectAllBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
   
    [self.selectArr removeAllObjects];
    
    if(sender.selected == YES)
    {
        for(int i=0 ;i < self.goodsArr.count ;i++)
        {
            CartModel *tempModel = self.goodsArr[i];
            [self.selectArr addObject:tempModel.Id];
        }
    
    }
    
    for (UIButton *tempBtn in cellBtnArr) {
        tempBtn.selected = sender.selected;
    }
}


-(void)roundBtnClick:(UIButton *)sender
{
    sender.selected = ! sender.selected;
    
    
    if(sender.selected == YES)
    {
        CartModel *tempModel = self.goodsArr[sender.tag-1];
        
        [self.selectArr addObject:tempModel.Id];
        
        if(self.selectArr.count >= self.goodsArr.count)
        {
            selectAllBtn.selected = YES;
        }
    }
    else
    {
        selectAllBtn.selected = NO;
        
        for (int i = 0; i <self.selectArr.count; i++) {
            CartModel *tempModel = self.goodsArr[i];
            if([tempModel.Id isEqual:self.selectArr[i]])
            {
                [self.selectArr removeObjectAtIndex:i];
            }
        }
    }
}

#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.goodsArr.count+1;
}

#pragma mark - setting for cell
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    @try {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight*3)];
        cell.backgroundColor = ItemsBaseColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        if(indexPath.row == 0)
        {
            cell.textLabel.text = @"核武者自营店";
            cell.textLabel.textColor = [UIColor whiteColor];
        }
        else
        {
            CartModel *tempDict = self.goodsArr[indexPath.row-1];
            
            UIImageView *productImgView = [[UIImageView alloc] initWithFrame:CGRectMake(GapToLeft, 10, (_cellHeight+10), (_cellHeight-10*2))];
//            productImgView.image = [UIImage imageNamed:@"KongFuStoreProduct"];
            NSString *url = NSStringFromFormat(@"%@%@",Kimg_path,tempDict.MiddleImagePath);
            [productImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"KongFuStoreProduct"]];
            [cell addSubview:productImgView];
            
            UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(5+productImgView.frame.size.width+productImgView.frame.origin.x,
                                                                         10,
                                                                          (SCREEN_WIDTH-(productImgView.frame.size.width+productImgView.frame.origin.x)), 20)];
            titleLab.text = tempDict.ProductName;
            titleLab.font = [UIFont systemFontOfSize:14];
            titleLab.textColor = [UIColor whiteColor];
            [cell addSubview:titleLab];
            
            
            
            UILabel *infoLab = [[UILabel alloc] initWithFrame:CGRectMake(titleLab.frame.origin.x,
                                                                        (titleLab.frame.origin.y+titleLab.frame.size.height),
                                                                         titleLab.frame.size.width - 100, 40)];
            
            infoLab.text = NSStringFromFormat(@"颜色:%@;尺寸:%@",tempDict.ProductColorName,tempDict.ProductSizeName);
            infoLab.font = [UIFont systemFontOfSize:12];
            infoLab.textColor = [UIColor whiteColor];
            infoLab.numberOfLines = 0;
            [cell addSubview:infoLab];
        
            
            UIButton *plusBtn = [[UIButton alloc] initWithFrame:CGRectMake(titleLab.frame.origin.x,
                                                                           (infoLab.frame.origin.y+infoLab.frame.size.height),
                                                                           20,
                                                                           20 )];
            plusBtn.tag = indexPath.row;
            [plusBtn setImage:[UIImage imageNamed:@"KongFuStoreAdd"] forState:UIControlStateNormal];
            [plusBtn addTarget:self action:@selector(plusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:plusBtn];
            
            UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake((plusBtn.frame.size.width+plusBtn.frame.origin.x+2),
                                                                        plusBtn.frame.origin.y,
                                                                        30,
                                                                        plusBtn.frame.size.height)];
           
            if(EditMode == YES)
            {
                numLab.backgroundColor = BACKGROUND_COLOR;
            }
            else
            {
                numLab.backgroundColor = ItemsBaseColor;
            }
            
            numLab.text =NSStringFromFormat(@"%@",tempDict.Number);
            numLab.textColor = [UIColor whiteColor];
            numLab.textAlignment = NSTextAlignmentCenter;
            numLab.tag = indexPath.row;
            [cell addSubview:numLab];
            
            if(numLabArr.count>indexPath.row-1)
            {
                [numLabArr replaceObjectAtIndex:(indexPath.row-1) withObject:numLab];
            }
            else
            {
                [numLabArr addObject:numLab];
            }
            
            UIButton *delBtn = [[UIButton alloc] initWithFrame:CGRectMake((numLab.frame.size.width+numLab.frame.origin.x+2),
                                                                          plusBtn.frame.origin.y,
                                                                          20,
                                                                          plusBtn.frame.size.height)];
            delBtn.tag = indexPath.row;
            [delBtn setImage:[UIImage imageNamed:@"KongFuStoreDel"] forState:UIControlStateNormal];
            [delBtn addTarget:self action:@selector(delBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:delBtn];
            
            
            UILabel *newPrice = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 20 -180),
                                                                         (titleLab.frame.origin.y+titleLab.frame.size.height),
                                                                         180,
                                                                          20)];
            newPrice.textAlignment = NSTextAlignmentRight;
            newPrice.textColor = YellowBlock;
            newPrice.font = [UIFont systemFontOfSize:14];
            
            CGFloat totalePrice =[tempDict.Number intValue] * [tempDict.ProductPriceTotalPrice floatValue];
            
            newPrice.text = NSStringFromFormat(@"¥%.02f",totalePrice);
            [cell addSubview:newPrice];
            
            
            
            UILabel *oldPrice = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 20 -180),
                                                                          (newPrice.frame.origin.y+newPrice.frame.size.height), 180, 20)];
            oldPrice.textAlignment = NSTextAlignmentRight;
            oldPrice.textColor = [UIColor grayColor];
            oldPrice.font = [UIFont systemFontOfSize:12];
            oldPrice.text = @"¥ 200.00";
            [cell addSubview:oldPrice];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(indexPath.section ==0 && indexPath.row == 0)
            {
                if(cellBtnArr == nil)
                {
                    cellBtnArr = [NSMutableArray array];
                }
                if(cellBtnArr != nil&&cellBtnArr.count >0)
                {
                    [cellBtnArr removeAllObjects];
                }
            }
            
            SelectRoundBtn *roundBtn = [[SelectRoundBtn alloc] initWithCenter:CGPointMake(15, _cellHeight/2)];
            roundBtn.backgroundColor = Separator_Color;
            [roundBtn addTarget:self action:@selector(roundBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            roundBtn.tag = indexPath.row;
            [cell addSubview:roundBtn];
            for (int i=0 ; i<self.selectArr.count; i++) {
                if ([tempDict.Id isEqual:self.selectArr[i]]) {
                    roundBtn.selected = YES;
                }
            }
            
            [cellBtnArr addObject:roundBtn];
            
           
            
            if(EditMode == YES)
            {
//                roundBtn.hidden = YES;
                plusBtn.hidden = NO;
                delBtn.hidden = NO;
            }
            else
            {
//                roundBtn.hidden = NO;
                plusBtn.hidden = YES;
                delBtn.hidden = YES;
            }
            
            
        }
        return cell;
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }

}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0)
        return 30;
    return _cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    NSLog(@"click cell section : %ld row : %ld",(long)indexPath.section,(long)indexPath.row);
    
    
    
}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor); CGContextFillRect(context, rect); //上分割线，
    
    CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1)); //下分割线
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(5, 10, 100, 10));
}


//设置划动cell是否出现del按钮，可供删除数据里进行处理

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0)
        return NO;
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"del");
 
    [self delCartGoodsAction:self.goodsArr[indexPath.row - 1].Id];
    
    
}

- (UITableViewCellEditingStyle)tableView: (UITableView *)tableView editingStyleForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  YES;
}


-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  @"删除";
}

//设置选中的行所执行的动作

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"删除？");
    
    return indexPath;
    
}

#pragma mark - setting for section
//设置section的header view

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView = [[UIView alloc] init];

    
    return tempView;
}

//设置section header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 0;
}

//设置section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
 
        return 0;
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
