//
//  IntegralExchangeRecordViewController.m
//  KongFuCenter
//
//  Created by Rain on 16/1/23.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "IntegralExchangeRecordViewController.h"
#import "IntegralExchangeRecordTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ExchangeDetailViewController.h"
#import "MJRefresh.h"

@interface IntegralExchangeRecordViewController (){
    UITableView *mTableView;
    NSMutableArray *goodsArray;
    int curpage;
    DataProvider *dataProvider;
}

@end

@implementation IntegralExchangeRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化参数
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self setBarTitle:@"兑换记录"];
    [self addLeftButton:@"left"];
    
    goodsArray = [[NSMutableArray alloc] init];
    dataProvider = [[DataProvider alloc] init];
    
    //初始化View
    [self initViews];
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
    mTableView.separatorColor = Separator_Color;
    mTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:mTableView];
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    __weak typeof(UITableView *) weakTv = mTableView;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    
    mTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        curpage = 0;
        [goodsArray removeAllObjects];
        [weakSelf initData];
        [weakTv.mj_header endRefreshing];
    }];
    
    // 马上进入刷新状态
    [mTableView.mj_header beginRefreshing];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    // 禁止自动加载
    footer.automaticallyRefresh = NO;
    // 设置footer
    mTableView.mj_footer = footer;
}

-(void)initData{
    [dataProvider setDelegateObject:self setBackFunctionName:@"getGoodsCallBack:"];
    [dataProvider SelectPageChangeBillByUserId:[NSString stringWithFormat:@"%d",curpage * 15] andmaximumRows:@"15" anduserId:get_sp(@"id") andstate:@"2" andproNum:@"1"];
}

-(void)getGoodsCallBack:(id)dict{
    // 结束刷新
    [mTableView.mj_footer endRefreshing];
    if ([dict[@"code"] intValue] == 200) {
        NSArray * arrayitem=[[NSArray alloc] init];
        arrayitem=dict[@"data"];
        for (id item in arrayitem) {
            [goodsArray addObject:item];
        }
    }
    [mTableView reloadData];
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return goodsArray.count;
}

#pragma mark setting for section
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    return view;
}

#pragma mark setting for cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"IntegralExchangeRecordCellIdentifier";
    IntegralExchangeRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"IntegralExchangeRecordTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.backgroundColor = ItemsBaseColor;
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",Url,[Toolkit judgeIsNull:[goodsArray[indexPath.row] valueForKey:@"ImagePath"]]];
    [cell.mPhotoIv sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"KongFuStoreProduct"]];
    cell.mName.text = [Toolkit judgeIsNull:[goodsArray[indexPath.row] valueForKey:@"Name"]];
    cell.mIntegral.text = [NSString stringWithFormat:@"%@积分",[Toolkit judgeIsNull:[goodsArray[indexPath.row] valueForKey:@"CreditTotal"]]];
    cell.mExchangeState.text = @"兑换成功";
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [mTableView deselectRowAtIndexPath:indexPath animated:YES];
    ExchangeDetailViewController *exchangeDetailVC = [[ExchangeDetailViewController alloc] init];
    [exchangeDetailVC setExchangeDetail:Mode_Detail];
    exchangeDetailVC.goodsId = [Toolkit judgeIsNull:[goodsArray[indexPath.row] valueForKey:@"ProductId"]];
    exchangeDetailVC.billDetailId = [Toolkit judgeIsNull:[goodsArray[indexPath.row] valueForKey:@"Id"]];
    [self.navigationController pushViewController:exchangeDetailVC animated:YES];
}

@end
