//
//  IntegralExchangeViewController.m
//  KongFuCenter
//
//  Created by Rain on 16/1/23.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "IntegralExchangeViewController.h"
#import "IntegralExchangeTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "IntegralExchangeRecordViewController.h"
#import "ExchangeDetailViewController.h"

@interface IntegralExchangeViewController (){
    UITableView *mTableView;
    
    NSString *JiFen;
}

@property(nonatomic) NSMutableArray *goodList;

@end

@implementation IntegralExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化参数
    pageSize = 15;
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self setBarTitle:@"积分兑换"];
    [self addLeftButton:@"left"];
    
    //初始化View
    [self initViews];
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

#pragma mark 自定义方法
-(void)initViews{
    
    [self getUserInfo];
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height)];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = BACKGROUND_COLOR;
    mTableView.separatorColor = Separator_Color;
    mTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:mTableView];
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    mTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{

        [self.goodList removeAllObjects];
        
        pageNo=0;
        [mTableView.mj_footer setState:MJRefreshStateIdle];
        [weakSelf getJiFenGoodList];
        // 结束刷新
        
    }];
    [mTableView.mj_header beginRefreshing];
    
    // 上拉刷新
    mTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{

        [weakSelf getJiFenGoodList];
        [mTableView.mj_footer endRefreshing];
    }];

 
    photoIv = [[UIImageView alloc] init];
    userName = [[UILabel alloc] init];
    mIntegral = [[UILabel alloc] init];
    
}

-(void)exchangeEvent:(UIButton *)btn{
    ExchangeDetailViewController *exchangeDetailVC = [[ExchangeDetailViewController alloc] init];
    [exchangeDetailVC setExchangeDetail:Mode_ImmeExchange];
    [self.navigationController pushViewController:exchangeDetailVC animated:YES];
}

-(void)integralExchangeRecordEvent{
    IntegralExchangeRecordViewController *integralExchangeRecordVC = [[IntegralExchangeRecordViewController alloc] init];
    [self.navigationController pushViewController:integralExchangeRecordVC animated:YES];
}
#pragma mark - self interface

-(NSMutableArray *)goodList
{
    if(_goodList == nil)
    {
        _goodList = [NSMutableArray array];
    }
    
    return _goodList;
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
            
            
            NSString * url=[NSString stringWithFormat:@"%@%@",Kimg_path,tempDict[@"PhotoPath"]];
            
            [photoIv sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"headImg"]];
            mIntegral.text = [NSString stringWithFormat:@"积分：%@",tempDict[@"Credit"]];
            JiFen = [NSString stringWithFormat:@"%@",tempDict[@"Credit"]];
            userName.text = [NSString stringWithFormat:@"%@",tempDict[@"NicName"]];
//            [mTableView reloadData];
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

-(void)getJiFenGoodList
{
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getJiFenGoodListCallBack:"];
    [dataProvider SelectProductBySearch:[NSString stringWithFormat:@"%lu",(unsigned long)pageNo*pageSize]/*页数*/
                         andmaximumRows:[NSString stringWithFormat:@"%lu",(unsigned long)pageSize]/*页数x每页条数*/
                              andsearch:@""/*搜索内容*/
                          andcategoryId:@"0"/*类别ID 不按照类别搜索传0*/
                          andisPriceAsc:@"0"/*是否价格升序 0：默认 1：升序 2：降序*/
                          andisSalesAsc:@"0"/*是否销量升序 0：默认 1：升序 2：降序*/
                        andisCommentAsc:@"0"/*是否好评升序 0：默认 1：升序 2：降序*/
                            andisNewAsc:@"0"/*是否最新升序 0：默认 1：升序 2：降序*/
                            andisCredit:@"0"/*是否可以兑换 0：积分兑换 1：购买*/
                         andisRecommend:@"0"/*不推荐商品 1：推荐商品*/];
    
}


-(void)getJiFenGoodListCallBack:(id)dict
{
    [SVProgressHUD dismiss];
    [mTableView.mj_header endRefreshing];
    [mTableView.mj_footer endRefreshing];
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try {
            [self.goodList addObjectsFromArray:dict[@"data"]];
            
            if(self.goodList.count >= [dict[@"recordcount"] intValue] )
            {
                [mTableView.mj_footer setState:MJRefreshStateNoMoreData];
            }
            
            [mTableView reloadData];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:[dict[@"data"] substringToIndex:4] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        
    }
}


#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 1 + self.goodList.count;
    }
}

#pragma mark setting for section
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }else{
        return 10;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    return view;
}

#pragma mark setting for cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"CellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.backgroundColor = ItemsBaseColor;
        }else{
            for (UIView *view in cell.subviews) {
                [view removeFromSuperview];
            }
        }
        
        photoIv.frame =  CGRectMake(14, (150 - 120) / 2, 120, 120);
        [photoIv sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"me"]];
        [cell addSubview:photoIv];
        
        photoIv.layer.cornerRadius = photoIv.frame.size.width * 0.5;
        photoIv.layer.borderWidth = 0.1;
        photoIv.layer.masksToBounds = YES;
        
        userName.frame =  CGRectMake(photoIv.frame.origin.x + photoIv.frame.size.width + 10, (150 - 85) / 2, 150, 21);
//        userName.text = @"成龙";
        userName.textColor = [UIColor whiteColor];
        
        
        
        [cell addSubview:userName];
        
        mIntegral.frame = CGRectMake(userName.frame.origin.x, userName.frame.origin.y + userName.frame.size.height + 5, 150, 21);
        mIntegral.text = [NSString stringWithFormat:@"积分:%@个",JiFen];
        mIntegral.textColor = [UIColor whiteColor];
        [cell addSubview:mIntegral];
        
        UIButton *mIntegralExchangeRecord = [[UIButton alloc] initWithFrame:CGRectMake(userName.frame.origin.x, mIntegral.frame.origin.y + mIntegral.frame.size.height + 5, 120, 30)];
        mIntegralExchangeRecord.backgroundColor = [UIColor colorWithRed:0.32 green:0.33 blue:0.34 alpha:1];
        [mIntegralExchangeRecord setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [mIntegralExchangeRecord setTitle:@"积分兑换记录" forState:UIControlStateNormal];
        [mIntegralExchangeRecord addTarget:self action:@selector(integralExchangeRecordEvent) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:mIntegralExchangeRecord];
        
        return cell;
    }
    else
    {
    
        if (indexPath.row == 0) {
            static NSString *cellIdentifier = @"CellIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.backgroundColor = ItemsBaseColor;
            }
            cell.textLabel.text = @"积分兑换商品";
            cell.textLabel.font = [UIFont systemFontOfSize:17];
            cell.textLabel.textColor = [UIColor whiteColor];
            return cell;
        }else{
            
            static NSString *CellIdentifier = @"IntegralExchangeCellIdentifier";
            IntegralExchangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"IntegralExchangeTableViewCell" owner:self options:nil] objectAtIndex:0];
                cell.backgroundColor = ItemsBaseColor;
            }
            
            @try {
                
                NSDictionary *tempDict = self.goodList[indexPath.row -1];
                
                
                [cell.mPhotoIv sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"me"]];
                cell.mName.text = tempDict[@"Name"];
                cell.mDetail1.text = [NSString stringWithFormat:@"%@",tempDict[@"CreditTotal"]];//[NSString stringWithFormat:@"积分兑换:%@",@"500"];
                cell.mDetail2.text = [NSString stringWithFormat:@"剩余:%@",JiFen];
                [cell.mExchange addTarget:self action:@selector(exchangeEvent:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                return cell;
            }
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 150;
    }else{
        if (indexPath.row == 0) {
            return 45;
        }else{
            return 70;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [mTableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
