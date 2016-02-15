//
//  ExchangeDetailViewController.m
//  KongFuCenter
//
//  Created by Rain on 16/1/23.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "ExchangeDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "PayOrderViewController.h"

@interface ExchangeDetailViewController (){
    UITableView *mTableView;
    NSDictionary *exchangeDetailArray;
}

@end

@implementation ExchangeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化参数
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self setBarTitle:@"兑换详情"];
    [self addLeftButton:@"left"];
    
    exchangeDetailArray = [[NSDictionary alloc] init];
    
    //初始化View
    [self initViews];
    
    //获取数据
    [self initData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

#pragma mark 自定义方法
-(void)initViews{
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height)];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = BACKGROUND_COLOR;
    mTableView.separatorColor = BACKGROUND_COLOR;
    mTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:mTableView];
}

-(void)initData{
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getChangeDetailCallBack:"];
    [dataProvider ChangeDetail:_goodsId anduserId:get_sp(@"id") andbillDetailId:_billDetailId];
}

-(void)getChangeDetailCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        exchangeDetailArray = dict[@"data"];
        [mTableView reloadData];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"data"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alertView show];
    }
}

-(void)btnEvent:(UIButton *)btn{
    switch (btn.tag) {
        case 1:{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://m.kuaidi100.com/index_all.html?type=%@&postid=%@",_liveryType,_liveryNo]]];
        }
            break;
        case 2:{
            PayOrderViewController *payOrderVC = [[PayOrderViewController alloc] init];
            payOrderVC.navtitle = @"确认订单";
            payOrderVC.paytype = PayByJiFen;
            CartModel *tempModel = [[CartModel alloc] init];
            tempModel.Id = _goodsId;
            tempModel.ProductName = [Toolkit judgeIsNull:[exchangeDetailArray valueForKey:@"Name"]];
            tempModel.ProductPriceTotalPrice = [Toolkit judgeIsNull:[exchangeDetailArray valueForKey:@"CreditTotal"]];
            tempModel.Number = @"1";
            NSMutableArray *goodsArray = [[NSMutableArray alloc] init];
            [goodsArray addObject:tempModel];
            payOrderVC.goodsArr = goodsArray;
            [self.navigationController pushViewController:payOrderVC animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 2;
    }else{
        return 1;
    }
}

#pragma mark setting for section
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 5;
    }else{
        if (_exchangeDetail == Mode_Detail) {
            return 5;
        }
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    return view;
}

#pragma mark setting for cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = ItemsBaseColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        for (UIView *view in cell.subviews) {
            if((indexPath.section == 1 && indexPath.row == 0) || indexPath.section == 0){
                if([view isKindOfClass:[UILabel class]]){
                    [view removeFromSuperview];
                }
            }else{
                [view removeFromSuperview];
            }
        }
    }
    if (indexPath.section == 0) {
        NSLog(@"%@",exchangeDetailArray);
        UIImageView *mHeadBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 170)];
        [mHeadBg sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"store_head_bg"]];
        [cell addSubview:mHeadBg];
        
        NSString *contentStr = [Toolkit judgeIsNull:[exchangeDetailArray valueForKey:@"Name"]];//@"玩悦计划2015小黄人卑鄙的我扭蛋神偷奶爸小摆件套装大眼萌热销";
        CGFloat height = [Toolkit heightWithString:contentStr fontSize:17 width:SCREEN_WIDTH - 28] + 20;
        UITextView *mContentTv = [[UITextView alloc] initWithFrame:CGRectMake(14, 170 + 5, SCREEN_WIDTH - 28, height)];
        mContentTv.textColor = [UIColor whiteColor];
        mContentTv.backgroundColor = ItemsBaseColor;
        mContentTv.editable = NO;
        mContentTv.scrollEnabled = NO;
        mContentTv.font = [UIFont systemFontOfSize:17];
        mContentTv.text = contentStr;
        [cell addSubview:mContentTv];
        
        UILabel *mIntegralLbl = [[UILabel alloc] initWithFrame:CGRectMake(14, mContentTv.frame.origin.y + mContentTv.frame.size.height + 5, 150, 21)];
        mIntegralLbl.textColor = YellowBlock;
        mIntegralLbl.text = [NSString  stringWithFormat:@"%@积分",[Toolkit judgeIsNull:[exchangeDetailArray valueForKey:@"CreditTotal"]]];
        [cell addSubview:mIntegralLbl];
        
        UILabel *mExchangeNum = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 3, mContentTv.frame.origin.y + mContentTv.frame.size.height + 5, 150, 21)];
        mExchangeNum.textColor = [UIColor colorWithRed:0.45 green:0.45 blue:0.45 alpha:1];
        mExchangeNum.font = [UIFont systemFontOfSize:14];
        mExchangeNum.text = [NSString  stringWithFormat:@"%@人兑换",[Toolkit judgeIsNull:[exchangeDetailArray valueForKey:@"CreditNum"]]];
        [cell addSubview:mExchangeNum];
        
        UILabel *mRemainNum = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH / 3) * 2, mContentTv.frame.origin.y + mContentTv.frame.size.height + 5, 150, 21)];
        mRemainNum.textColor = [UIColor colorWithRed:0.45 green:0.45 blue:0.45 alpha:1];
        mRemainNum.font = [UIFont systemFontOfSize:14];
        mRemainNum.text = [NSString  stringWithFormat:@"剩余%@件",[Toolkit judgeIsNull:[exchangeDetailArray valueForKey:@"StockNum"]]];
        [cell addSubview:mRemainNum];
    }else if (indexPath.section == 1){
        if(indexPath.row == 0){
            UILabel *contentTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(14, (cell.frame.size.height - 21) / 2, 150, 21)];
            contentTitleLbl.textColor = [UIColor whiteColor];
            contentTitleLbl.text = @"商品兑换介绍";
            [cell addSubview:contentTitleLbl];
        }else{
            NSString *contentStr1 = [Toolkit judgeIsNull:[exchangeDetailArray valueForKey:@"Content"]];//@"2015小黄人电影在海外已经上映,这群小黄人这次真正成了主角,我们依然热爱这群萌萌贱贱的物种本系列为小摆件,款式和套系众多,有2015新款的,也有2013经典款的";
            CGFloat height = [Toolkit heightWithString:contentStr1 fontSize:14 width:SCREEN_WIDTH - 28] + 20;
            UITextView *mContentTv = [[UITextView alloc] initWithFrame:CGRectMake(14, 5, SCREEN_WIDTH - 28, height)];
            mContentTv.textColor = [UIColor colorWithRed:0.45 green:0.45 blue:0.45 alpha:1];
            mContentTv.backgroundColor = ItemsBaseColor;
            mContentTv.editable = NO;
            mContentTv.scrollEnabled = NO;
            mContentTv.font = [UIFont systemFontOfSize:14];
            mContentTv.text = contentStr1;
            [cell addSubview:mContentTv];
            
//            UILabel *notes = [[UILabel alloc] initWithFrame:CGRectMake(14, mContentTv.frame.origin.y + height + 10, SCREEN_WIDTH - 28, 21)];
//            notes.textColor = [UIColor whiteColor];
//            notes.text = @"兑换注意事项:";
//            [cell addSubview:notes];
//            
//            NSString *contentStr2 = @"1、兑换时间有效期至2016-01-02\n2、兑换后积分自动被扣除\n3、兑换后请到网店去兑换领取";
//            CGFloat height2 = [Toolkit heightWithString:contentStr2 fontSize:14 width:SCREEN_WIDTH - 28] + 20;
//            UITextView *mNotesTv = [[UITextView alloc] initWithFrame:CGRectMake(14, notes.frame.origin.y + notes.frame.size.height + 5, SCREEN_WIDTH - 28, height2)];
//            mNotesTv.textColor = [UIColor colorWithRed:0.45 green:0.45 blue:0.45 alpha:1];
//            mNotesTv.backgroundColor = ItemsBaseColor;
//            mNotesTv.editable = NO;
//            mNotesTv.scrollEnabled = NO;
//            mNotesTv.font = [UIFont systemFontOfSize:14];
//            mNotesTv.text = contentStr2;
//            [cell addSubview:mNotesTv];
        }
    }else{
        UILabel *mExchangeDate = [[UILabel alloc] initWithFrame:CGRectMake(14, 10, SCREEN_WIDTH - 28, 21)];
        mExchangeDate.textColor = [UIColor colorWithRed:0.45 green:0.45 blue:0.45 alpha:1];
        mExchangeDate.text = [NSString stringWithFormat:@"兑换时间:%@",[Toolkit judgeIsNull:[exchangeDetailArray valueForKey:@"OperateTime"]]];
        
        UIButton *mViewLogistics = [[UIButton alloc] initWithFrame:CGRectMake(20, mExchangeDate.frame.origin.y + mExchangeDate.frame.size.height + 10, SCREEN_WIDTH - 40, 45)];
        [mViewLogistics addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
        if (_exchangeDetail == Mode_Detail) {
            [cell addSubview:mExchangeDate];
            mViewLogistics.backgroundColor = YellowBlock;
            [mViewLogistics setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            mViewLogistics.tag = 1;
            [mViewLogistics setTitle:@"查看物流" forState:UIControlStateNormal];
        }else if (_exchangeDetail == Mode_ImmeExchange){
            mViewLogistics.backgroundColor = YellowBlock;
            [mViewLogistics setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            mViewLogistics.tag = 2;
            [mViewLogistics setTitle:@"立即兑换" forState:UIControlStateNormal];
        }else if(_exchangeDetail == Mode_IntegralLack){
            mViewLogistics.backgroundColor = [UIColor colorWithRed:0.24 green:0.24 blue:0.25 alpha:1];
            [mViewLogistics setTitleColor:[UIColor colorWithRed:0.45 green:0.45 blue:0.45 alpha:1] forState:UIControlStateNormal];
            mViewLogistics.tag = 3;
            [mViewLogistics setTitle:@"积分不足" forState:UIControlStateNormal];
        }
        [cell addSubview:mViewLogistics];
    }
    
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
        [cell setPreservesSuperviewLayoutMargins:false];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        NSString *contentStr = [Toolkit judgeIsNull:[exchangeDetailArray valueForKey:@"Name"]];
        CGFloat height = [Toolkit heightWithString:contentStr fontSize:17 width:SCREEN_WIDTH - 28] + 20;
        return 170 + 5 + height + 30;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            return 45;
        }else{
            NSString *contentStr = [Toolkit judgeIsNull:[exchangeDetailArray valueForKey:@"Content"]];
            CGFloat height = [Toolkit heightWithString:contentStr fontSize:14 width:SCREEN_WIDTH - 28] + 20;
            //NSString *contentStr2 = @"玩悦计划2015小黄人卑鄙的我扭蛋神偷奶爸小摆件套装大眼萌热销";
            //CGFloat height2 = [Toolkit heightWithString:contentStr2 fontSize:14 width:SCREEN_WIDTH - 28] + 20;
            return height + 5 + 21 + 5;
        }
    }else{
        return 120;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [mTableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
