//
//  PayOrderViewController.m
//  KongFuCenter
//
//  Created by Wangjc on 16/1/23.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "PayOrderViewController.h"
#import "OrderMainViewController.h"

#define WxPay   @"wx"
#define Alipay  @"alipay"
#define kUrlScheme      @"com.zykj.KongFuCenter" // 这个是你定义的 URL Scheme，支付宝、微信支付和测试模式需要。

@interface PayOrderViewController ()
{
    CGFloat totalMoney;
}

@end

@implementation PayOrderViewController
@synthesize goodsArr = _goodsArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"left"];
    
//    addressDict = [NSMutableDictionary dictionary];
    payFlag = Alipay;
    self.navtitle = @"确认订单";
    roundBtnArr = [NSMutableArray array];
    [self initViews];
    [self getDefaultAddress];
    // Do any additional setup after loading the view.
}

-(void)PaySuccessFun{
    OrderMainViewController *orderListVC = [[OrderMainViewController alloc] init];
    [orderListVC setBillType:Mode_PaySuccess];
    orderListVC.navtitle = @"订单";
    [self.navigationController pushViewController:orderListVC animated:YES];
}

-(void)PayFailFun{
    OrderMainViewController *orderListVC = [[OrderMainViewController alloc] init];
    [orderListVC setBillType:Mode_Normal];
    orderListVC.navtitle = @"订单";
    [self.navigationController pushViewController:orderListVC animated:YES];
}

-(void)initViews
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PaySuccessFun) name:@"PaySuccessFun" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PayFailFun) name:@"PayFailFun" object:nil];
    
    _cellHeight = 100;
    pageSize = 10;
    
    for(int i = 0;i<2;i++)
    {
        SelectRoundBtn *roundBtn = [[SelectRoundBtn alloc] initWithCenter:CGPointMake((SCREEN_WIDTH - 60), 50/2)];
        if (i == 0) {
            roundBtn.selected = YES;
        }
        roundBtn.backgroundColor = BACKGROUND_COLOR;
        [roundBtn addTarget:self action:@selector(roundBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        roundBtn.tag = i+1000;
        [roundBtnArr addObject:roundBtn];
    }
    
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height - 50 ) style:UITableViewStyleGrouped];
    _mainTableView.backgroundColor = BACKGROUND_COLOR;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorColor =  Separator_Color;
    //    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.tableFooterView = [[UIView alloc] init];
    //_mainTableView.scrollEnabled = NO;
    [self.view addSubview:_mainTableView];
    
    UIView *btnBackView = [[UIView alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT - 50), SCREEN_WIDTH, 50)];
    btnBackView.backgroundColor = ItemsBaseColor;
    
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH  - 100), 0, 100, btnBackView.frame.size.height)];
    btnRight.backgroundColor = YellowBlock;
    btnRight.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnBackView addSubview:btnRight];
    [btnRight addTarget:self action:@selector(payOrderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnRight setTitle:@"确认结算" forState:UIControlStateNormal];

    moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,  btnRight.frame.origin.x - 10, btnBackView.frame.size.height/2)];
    [btnBackView addSubview:moneyLab];
    moneyLab.textColor = [UIColor whiteColor];
    
    if(self.paytype == PayByJiFen)
    {
        moneyLab.text =ZY_NSStringFromFormat(@"合计 %.02f积分",totalMoney);
    }
    else
    {
        moneyLab.text =ZY_NSStringFromFormat(@"总金额：¥ %.02f",totalMoney);
    }
    moneyLab.font = [UIFont systemFontOfSize:14];
    moneyLab.textAlignment = NSTextAlignmentRight;
    
    
    tiplab = [[UILabel alloc] initWithFrame:CGRectMake(0,btnBackView.frame.size.height/2, (btnRight.frame.origin.x - 10), btnBackView.frame.size.height/2)];
    [btnBackView addSubview:tiplab];
    tiplab.textColor = [UIColor grayColor];
    if(_postage == -1)
    {
        tiplab.text = ZY_NSStringFromFormat(@"邮费（%@）",@"到付");
    }
    else if(_postage > 0)
    {
        tiplab.text = ZY_NSStringFromFormat(@"邮费（%.02f）",self.postage);
        
    }
    tiplab.font = [UIFont systemFontOfSize:14];
    tiplab.textAlignment = NSTextAlignmentRight;
    
    [self.view addSubview:btnBackView];
    DescriptionTextView = [[MyTextView alloc] init];
    DescriptionTextView.placeHolder.text = @"请输入备注";
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:) ];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    //    //注册通知,监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    //
    //    //注册通知,监听键盘消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden) name:UIKeyboardDidHideNotification object:nil];
    [self getUserInfo];
    
}



// 键盘弹出时
-(void)keyboardDidShow:(NSNotification *)notification
{
    
    //获取键盘高度
    NSValue *keyboardObject = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect;
    [keyboardObject getValue:&keyboardRect];
    
    
    //调整放置有textView的view的位置
    
    //设置动画
    [UIView beginAnimations:nil context:nil];
    
    //定义动画时间
    [UIView setAnimationDuration:0.5];
    //               CGRectMake(0, self.view.frame.size.height-keyboardRect.size.height-kViewHeight, 320, kViewHeight)]
    //设置view的frame，往上平移
    [_mainTableView setFrame:CGRectMake(0, Header_Height, self.view.frame.size.width,self.view.frame.size.height -Header_Height -keyboardRect.size.height)];
    
    [_mainTableView scrollToRowAtIndexPath:tempIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    
    //    _cellTextViewHeight = _mainTableView.frame.size.height - 3*_cellHeight;
    //    [_mainTableView reloadData];
    [UIView commitAnimations];
    
}

//键盘消失时
-(void)keyboardDidHidden
{
    //定义动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    //设置view的frame，往下平移
    [_mainTableView setFrame:CGRectMake(0, Header_Height, self.view.frame.size.width,self.view.frame.size.height - Header_Height)];
    //   _cellTextViewHeight = _mainTableView.frame.size.height - 3*_cellHeight;
    //   [_mainTableView reloadData];
    [UIView commitAnimations];
    
}


//设置点在某个view时部触发事件
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"-%@", NSStringFromClass([touch.view class]));
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]||[NSStringFromClass([touch.view class]) isEqualToString:@"UIButton"])
    {
        return NO;
    }
    //  NSLog(@"return YES");
    return  YES;
}


#pragma mark - self property

-(void)setPayOrderId:(NSString *)payOrderId
{
    _payOrderId = ZY_NSStringFromFormat(@"%@",payOrderId);
}

-(void)setPostage:(CGFloat)postage
{
    _postage = postage;
    
    if(_postage == -1)
    {
        tiplab.text = ZY_NSStringFromFormat(@"邮费（%@）",@"到付");
    }
    else if(_postage > 0)
    {
        tiplab.text = ZY_NSStringFromFormat(@"邮费（%.02f）",self.postage);
        
        totalMoney += self.postage;
    }
    
    
}

-(void)setGoodDicts:(NSArray *)goodDicts
{
    _goodDicts = goodDicts;
    
    NSMutableArray *tempArr = [NSMutableArray array];
    
    for (int i =0; i<_goodDicts.count; i++) {
        
        CartModel *tempModel = [[CartModel alloc] init];
        
        NSDictionary *tempdict =_goodDicts[i];
        if(_paytype == PayByOrderId){
            tempModel.MiddleImagePath = [tempdict valueForKey:@"MiddleImagePath"];
            tempModel.ProductName = [tempdict valueForKey:@"ProductName"];
            tempModel.ProductColorName = [tempdict valueForKey:@"ProductColorName"];
            tempModel.ProductSizeName = [tempdict valueForKey:@"ProductSizeName"];
            tempModel.ProductPriceTotalPrice = [tempdict valueForKey:@"DetailPrice"];
            tempModel.Number = [tempdict valueForKey:@"Number"];
        }else{
            [tempModel setValuesForKeysWithDictionary:tempdict];
        }
        [tempArr addObject:tempModel];
    }
    
    self.goodsArr = tempArr;
    if(self.paytype == PayByJiFen)
    {
        moneyLab.text = ZY_NSStringFromFormat(@"合计 %.02f积分",totalMoney);
    }
    else
    {
        moneyLab.text = ZY_NSStringFromFormat(@"总金额：¥ %.02f",totalMoney);
    }
}


-(void)setGoodsArr:(NSMutableArray<CartModel *> *)goodsArr
{
    
    if(_goodsArr == nil)
    {
        _goodsArr = [NSMutableArray array];
    }
    [_goodsArr addObjectsFromArray:goodsArr];
    totalMoney = 0;
    
    for (CartModel *tempModel in goodsArr) {
        totalMoney += ([tempModel.ProductPriceTotalPrice floatValue] * [tempModel.Number floatValue]);
    }
    
    moneyLab.text = ZY_NSStringFromFormat(@"总金额：¥ %.02f",totalMoney);
}



-(NSMutableArray<CartModel *>*)goodsArr
{
    
    if(_goodsArr == nil)
    {
        _goodsArr = [NSMutableArray array];
    }
    return _goodsArr;
}

#pragma mark - self data source




-(void)getUserInfo
{
    [SVProgressHUD showWithStatus:@"刷新中" maskType:SVProgressHUDMaskTypeBlack];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"getUserInfoCallBack:"];
    [dataprovider getUserInfo:[Toolkit getUserID]];
    
}


-(void)getUserInfoCallBack:(id)dict
{
    [SVProgressHUD dismiss];
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try {
            NSDictionary *tempDict = dict[@"data"];
            
            jiFenTotal = [[NSString stringWithFormat:@"%@",tempDict[@"Credit"]] integerValue];
            
            [_mainTableView reloadData];

        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"data"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        
    }
}


-(void)payByJifen
{
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"payJifenCallBack:"];
    [dataProvider payByjiFen:[Toolkit getUserID] andProductId:self.goodsArr[0].Id andNum:@"1" andDeliveryId:addressDict[@"Id"] andDescription:DescriptionTextView.text];
    
}

-(void)payJifenCallBack:(id)dict
{
    DLog(@"%@",dict);
    if([dict[@"code"] intValue] == 200)
    {
//        self.payOrderId = dict[@"data"][@"id"];
//        [self getCharge:self.payOrderId];
        [SVProgressHUD showSuccessWithStatus:@"兑换成功"];
        NSUserDefaults *mUserDefault = [NSUserDefaults standardUserDefaults];
        [mUserDefault setValue:@"1" forKey:@"IntegralExchangeFlag"];
        //[self.navigationController popViewControllerAnimated:YES];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:ZY_NSStringFromFormat(@"%@",dict[@"data"]) maskType:SVProgressHUDMaskTypeBlack];
    }
}


-(void)payImmediately
{
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"payImmediatelyCallBack:"];
    [dataProvider BuyNow:self.goodsArr[0].Id
                  andnum:self.goodsArr[0].Number
              andpriceId:self.goodsArr[0].ProductPriceId
               anduserId:[Toolkit getUserID]
                andprice:self.goodsArr[0].ProductPriceTotalPrice
           anddeliveryId:addressDict[@"Id"]
     anddescription:DescriptionTextView.text];
}

-(void)payImmediatelyCallBack:(id)dict
{
    DLog(@"%@",dict);
    if([dict[@"code"] intValue] == 200)
    {
        self.payOrderId = dict[@"data"][@"id"];
        [self getCharge:self.payOrderId];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:ZY_NSStringFromFormat(@"%@",dict[@"data"]) maskType:SVProgressHUDMaskTypeBlack];
    }
}

-(void)getCharge:(NSString *)BillId
{
    
    if(!([payFlag isEqualToString:WxPay] || [payFlag isEqualToString:Alipay]))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付方式错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getChargeCallBack:"];
    [dataProvider getChargeForShopping:[Toolkit getUserID] andChannel:payFlag andAmount:ZY_NSStringFromFormat(@"%.0f",[[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",totalMoney]] floatValue] * 100) andDescription:@"购买商品" andFlg:@"1"/*0：充值会员 1：购买商品*/ andBillId:BillId];
}//[[NSDecimalNumber decimalNumberWithString:@"3.45"]floatValue] ;

-(void)getChargeCallBack:(id)dict
{
    [SVProgressHUD dismiss];
    DLog(@"%@",dict);
    @try {
        
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSString* charge = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"str_data:%@",charge);
        
        //            NSString* charge = [[NSString alloc] initWithData:    data encoding:NSUTF8StringEncoding];
        //            NSLog(@"charge = %@", charge);
        
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [Pingpp createPayment:charge viewController:self appURLScheme:kUrlScheme withCompletion:^(NSString *result, PingppError *error) {
                               NSLog(@"completion block: %@", result);
                               if ([result isEqualToString:@"success"]) {
                                   NSLog(@"PingppError is nil");
                                   // 支付成功
                                   OrderMainViewController *orderListVC = [[OrderMainViewController alloc] init];
                                   [orderListVC setBillType:Mode_PaySuccess];
                                   [self.navigationController pushViewController:orderListVC animated:YES];
                               } else {
                                   NSLog(@"PingppError: code=%lu msg=%@", (unsigned  long)error.code, [error getMsg]);
                                   // 支付失败或取消
                                   OrderMainViewController *orderListVC = [[OrderMainViewController alloc] init];
                                   [orderListVC setBillType:Mode_Normal];
                                   [self.navigationController pushViewController:orderListVC animated:YES];
                               }
                               [SVProgressHUD showInfoWithStatus:result];
                           }];
                       });
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }

}

-(void)goShoppingCartPayOrder
{
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"goShoppingCartPayOrderCallBack:"];
    
    if(self.goodsArr.count == 0)
    {
        [SVProgressHUD showInfoWithStatus:@"没有商品可供支付"];
        
        return;
    }
    NSString *payIds = self.goodsArr[0].Id;
    for (int i=1; i<self.goodsArr.count; i++) {
        payIds = ZY_NSStringFromFormat(@"%@&%@",payIds,self.goodsArr[i].Id);
    }
    
    [dataProvider buyInShoppingCart:[Toolkit getUserID] andDeliveryId:addressDict[@"Id"] andDescription:DescriptionTextView.text andBasketDeatilIdList:payIds];
}

-(void)goShoppingCartPayOrderCallBack:(id)dict
{
    DLog(@"%@",dict);
    if([dict[@"code"] intValue] == 200)
    {
        self.payOrderId = dict[@"data"][@"id"];
        [self getCharge:self.payOrderId];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:ZY_NSStringFromFormat(@"%@",dict[@"data"]) maskType:SVProgressHUDMaskTypeBlack];
    }

}

-(void)goPay{
    [self getCharge:_payOrderId];
}

-(void)getDefaultAddress
{
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getDefaultAddressCallBack:"];
    [dataProvider getDefaultAddress:[Toolkit getUserID]];
}
-(void)getDefaultAddressCallBack:(id)dict
{
    DLog(@"%@",dict);
    if([dict[@"code"] intValue] == 200)
    {
        NSDictionary *tempDict = dict[@"data"];
        @try {
            addressDict = [[NSMutableDictionary alloc] initWithDictionary:dict[@"data"]];
            
            [addressDict setValue:[NSString stringWithFormat:@"%@%@",[[Toolkit judgeIsNull:[tempDict valueForKey:@"Area"]] stringByReplacingOccurrencesOfString:@"/" withString:@""],[Toolkit judgeIsNull:[tempDict valueForKey:@"Address"]]] forKey:@"TotaleAddress"];
            [_mainTableView reloadData];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:ZY_NSStringFromFormat(@"%@",dict[@"data"]) maskType:SVProgressHUDMaskTypeBlack];
    }
}

#pragma mark - click action

-(void)tapViewAction:(id)sender
{
    [self.view endEditing:YES];
}

-(void)payOrderBtnClick:(UIButton *)sender
{
    NSUserDefaults *mUserDefault = [NSUserDefaults standardUserDefaults];
    [mUserDefault setValue:@"2" forKey:@"PayType"];
    [SVProgressHUD showWithStatus:@"请稍后..."];
    
    switch (self.paytype) {
        case PayByShoppingCart:
        {
            [self goShoppingCartPayOrder];
        }
            break;
        case PayByImmediately:
        {
            [self payImmediately];
        }
            break;
        case PayByOrderId:
        {
            [self goPay];
        }
            break;
        case PayByJiFen:
        {
            [self payByJifen];
        }
            break;
        default:
            break;
    }
}

-(void)roundBtnClick:(UIButton *)sender
{
    sender.selected = YES;
    
//    PayFlag = sender.tag;
    
    if(sender.tag == 1000)
    {
        payFlag = Alipay;
    }
    else if(sender.tag == 1001)
    {
        payFlag = WxPay;
    }
    
    for(UIButton *tempBtn in roundBtnArr)
    {
        if(tempBtn != sender)
        {
            tempBtn.selected = NO;
        }
    }
}

#pragma mark - address picker delegate
- (void)getReceiveAddress:(NSMutableDictionary *)receiveAddressDict
{
    addressDict = [[NSMutableDictionary alloc] initWithDictionary:receiveAddressDict];
    [_mainTableView reloadData];
}

#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 1) {
        return self.goodsArr.count+3;
    }
    if(section == 2)
    {
        if(self.paytype == PayByJiFen)
            return 2;
        return 3;
    }
    if(section == 3)
        return 2;
    return 1;
    
}

#pragma mark - setting for cell

#define GapToLeft 20
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight)];;
    cell.backgroundColor = ItemsBaseColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    @try {

        if (indexPath.section == 0) {
            if(addressDict == nil)
            {
                UILabel *tempLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight)];
                
                tempLab.textColor = [UIColor whiteColor];
                tempLab.textAlignment = NSTextAlignmentCenter;
                tempLab.text = @"请设置收货地址";
                [cell addSubview:tempLab];
            }
            else
            {
                UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(GapToLeft, 15, cell.frame.size.height - 30 , cell.frame.size.height - 30)];
                image.image = [UIImage imageNamed:@"dingwei"];
                image.center = CGPointMake(GapToLeft+10, _cellHeight/2);
                [cell.contentView addSubview:image];
                
                UILabel *infoLab = [[UILabel alloc] initWithFrame:CGRectMake((image.frame.size.width+image.frame.origin.x)+5,
                                                                             10, SCREEN_WIDTH - (image.frame.size.width+image.frame.origin.x)-5, _cellHeight/2-10)];
                
                infoLab.textColor = [UIColor whiteColor];
                infoLab.text = [NSString  stringWithFormat:@"收货人：%@    %@",addressDict[@"ReceiverName"],addressDict[@"Phone"]];
                infoLab.font = [UIFont systemFontOfSize:14];
                [cell.contentView addSubview:infoLab];
                
                UILabel *addrLab = [[UILabel alloc] initWithFrame:CGRectMake(infoLab.frame.origin.x,
                                                                             _cellHeight/2,infoLab.frame.size.width , _cellHeight/2-10)];
                addrLab.text = [NSString stringWithFormat:@"收货地址：%@",addressDict[@"TotaleAddress"]];
                addrLab.numberOfLines = 0;
                addrLab.textColor = [UIColor whiteColor];
                addrLab.font = [UIFont systemFontOfSize:14];
                [cell.contentView addSubview:addrLab];
            }
        }
        
        
        if(indexPath.section == 1)
        {
            
            if (indexPath.row== 0) {
                cell.textLabel.text = @"核武者自营店";
                cell.textLabel.textColor = [UIColor whiteColor];
                cell.textLabel.font = [UIFont systemFontOfSize:14];
                
            }
            if(indexPath.row > 0 && indexPath.row < self.goodsArr.count+1)
            {
                CartModel *tempModel;
                if(self.paytype == PayByImmediately){
                    tempModel =_goodsArr[0];
                }else{
                    tempModel = self.goodsArr[indexPath.row - 1];
                }
                
                
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(GapToLeft, 10, _cellHeight, _cellHeight - 20)];
                NSString *url = ZY_NSStringFromFormat(@"%@%@",Kimg_path,tempModel.MiddleImagePath);
                [imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"KongFuStoreProduct"]];
                [cell addSubview:imgView];
                
                UILabel *nowPriceLab = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 10 - 80), 10, 80, 30)];
                nowPriceLab.textColor = Separator_Color;
                
                if(self.paytype == PayByJiFen)
                {
                    nowPriceLab.text = ZY_NSStringFromFormat(@"%@积分",tempModel.ProductPriceTotalPrice);
                }
                else
                {
                    nowPriceLab.text = ZY_NSStringFromFormat(@"¥%@",tempModel.ProductPriceTotalPrice);//   @"¥20.00";
                }
                nowPriceLab.textAlignment = NSTextAlignmentRight;
                nowPriceLab.font = [UIFont systemFontOfSize:14];
                [cell addSubview:nowPriceLab];
                
//                UILabel *oldPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(nowPriceLab.frame.origin.x,
//                                                                                 (nowPriceLab.frame.origin.y+nowPriceLab.frame.size.height),
//                                                                                 nowPriceLab.frame.size.width, 20)];
//                oldPriceLab.textColor = Separator_Color;
//                oldPriceLab.text = @"¥20.00";
//                oldPriceLab.textAlignment = NSTextAlignmentRight;
//                oldPriceLab.font = [UIFont systemFontOfSize:12];
//                [cell addSubview:oldPriceLab];
                
                UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(nowPriceLab.frame.origin.x,
                                                                            (nowPriceLab.frame.origin.y+nowPriceLab.frame.size.height + 5),
                                                                            nowPriceLab.frame.size.width, 20)];
                numLab.textColor = Separator_Color;
                numLab.text = ZY_NSStringFromFormat(@"x%@",tempModel.Number);
                numLab.textAlignment = NSTextAlignmentRight;
                numLab.font = [UIFont systemFontOfSize:12];
                [cell addSubview:numLab];
                
                UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake((imgView.frame.origin.x + imgView.frame.size.width)+5,
                                                                              10, SCREEN_WIDTH - imgView.frame.origin.x - imgView.frame.size.width - nowPriceLab.frame.size.width, 30)];
                titleLab.text = tempModel.ProductName;
                titleLab.textColor = [UIColor whiteColor];
                titleLab.font = [UIFont systemFontOfSize:14];
                [cell addSubview:titleLab];
                
                UILabel *specLbl = [[UILabel alloc] initWithFrame:CGRectMake(titleLab.frame.origin.x, titleLab.frame.origin.y + titleLab.frame.size.height + 5, SCREEN_WIDTH - imgView.frame.origin.x - imgView.frame.size.width - 30, 21)];
                specLbl.text = [NSString stringWithFormat:@"规格:%@/%@",tempModel.ProductColorName,tempModel.ProductSizeName];
                specLbl.textColor = Separator_Color;
                specLbl.font = [UIFont systemFontOfSize:14];
                [cell addSubview:specLbl];
            }
            else if(indexPath.row == self.goodsArr.count+1)
            {
//                cell.textLabel.textColor = [UIColor whiteColor];
//                cell.textLabel.text = @"邮费";
//                cell.textLabel.font = [UIFont systemFontOfSize:15];
                
                UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH -160-20), 0, 160, 50)];
                
                if(self.postage == -1)
                {
                    tipLab.text = ZY_NSStringFromFormat(@"邮费:(%@)",@"到付");
                }
                else
                {
                    tipLab.text = ZY_NSStringFromFormat(@"邮费:(%.02f)",self.postage);
                }
                
                tipLab.font = [UIFont systemFontOfSize:15];
                tipLab.textColor = [UIColor whiteColor];
                tipLab.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:tipLab];
            }
            else if(indexPath.row == self.goodsArr.count+2)
            {
                cell.textLabel.textColor = [UIColor whiteColor];
                cell.textLabel.text = ZY_NSStringFromFormat(@"共%d件商品",(int)self.goodsArr.count);
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                
                UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 160-20), 0, 160, 50)];
                if(self.paytype == PayByJiFen)
                {
                    tipLab.text = ZY_NSStringFromFormat(@"合计:%.02f积分",totalMoney);
                }
                else
                {
                    tipLab.text = ZY_NSStringFromFormat(@"合计:¥%.02f",totalMoney);
                }
                tipLab.font = [UIFont systemFontOfSize:15];
                tipLab.textColor = [UIColor orangeColor];
                tipLab.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:tipLab];
            }
        }
        
        if(indexPath.section == 2)
        {
            if(self.paytype == PayByJiFen)
            {
                if(indexPath.row == 0)
                {
                    cell.textLabel.text = @"积分支付";
                    cell.textLabel.textColor = [UIColor whiteColor];
                    cell.textLabel.font = [UIFont systemFontOfSize:16];
                }
                else if(indexPath.row == 1)
                {
                    cell.textLabel.text = @"当前积分";
                    cell.textLabel.textColor = [UIColor whiteColor];
                    cell.textLabel.font = [UIFont systemFontOfSize:16];
                    
                    UILabel *jifenLab = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 160-20), 0, 160, 50)];
                    jifenLab.text = ZY_NSStringFromFormat(@"%lu积分",(unsigned long)jiFenTotal);
                    jifenLab.textColor = [UIColor whiteColor];
                    jifenLab.textAlignment = NSTextAlignmentRight;
                    jifenLab.font = [UIFont systemFontOfSize:14];
                    [cell addSubview:jifenLab];
                    
                }
            }
            else
            {
            
                if(indexPath.row == 0)
                {
                    cell.textLabel.text = @"支付方式";
                    cell.textLabel.textColor = [UIColor whiteColor];
                    cell.textLabel.font = [UIFont systemFontOfSize:16];
                }
                else if(indexPath.row == 1)
                {
                    cell.imageView.image = [UIImage imageNamed:@"zhifubao"];
                    cell.textLabel.text = @"支付宝支付";
                    cell.textLabel.textColor = [UIColor whiteColor];
                    cell.textLabel.font = [UIFont systemFontOfSize:14];
                    
                    [cell addSubview:roundBtnArr[indexPath.row - 1]];
                }
                else if(indexPath.row == 2)
                {
                    cell.imageView.image = [UIImage imageNamed:@"weixin"];
                    cell.textLabel.text = @"微信支付";
                    cell.textLabel.textColor = [UIColor whiteColor];
                    cell.textLabel.font = [UIFont systemFontOfSize:14];
                    
                    [cell addSubview:roundBtnArr[indexPath.row - 1]];
                }

            }
        }
        
        if(indexPath.section == 3)
        {
            if(indexPath.row==0)
            {
                cell.textLabel.text = @"备注";
                cell.textLabel.textColor = [UIColor whiteColor];
                cell.textLabel.font = [UIFont systemFontOfSize:14];
            }
            else
            {
                tempIndexPath = indexPath;
                DescriptionTextView.frame = CGRectMake(20, 10,SCREEN_WIDTH- 40 , 50 *2-20);
                DescriptionTextView.backgroundColor = BACKGROUND_COLOR;
                DescriptionTextView.textColor = [UIColor whiteColor];
                DescriptionTextView.font = [UIFont systemFontOfSize:14];
                [cell.contentView addSubview:DescriptionTextView];
            }
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
    
    if(indexPath.section == 1)
    {
        if(indexPath.row == 0||indexPath.row == (self.goodsArr.count+1)||indexPath.row == (self.goodsArr.count +2))
        {
            return 50;
        }
    }
    if(indexPath.section == 2)
        return 50;
    
    if(indexPath.section == 3)
    {
        if(indexPath.row == 0)
            return 50;
        else if(indexPath.row == 1)
        {
            return 50*2;
        }
    }
    
    return _cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    NSLog(@"click cell section : %ld row : %ld",(long)indexPath.section,(long)indexPath.row);
    
    
    if(indexPath.section == 0)
    {
        ReceiveAddressViewController *receiveAddressViewCtl = [[ReceiveAddressViewController alloc] init];
        receiveAddressViewCtl.receiveAddressType = Mode_SelectAddress;
        receiveAddressViewCtl.delegate = self;
        [self.navigationController pushViewController:receiveAddressViewCtl animated:YES];
    }
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
