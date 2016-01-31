//
//  RecommendGoodsViewController.m
//  KongFuCenter
//
//  Created by Rain on 16/1/23.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "RecommendGoodsViewController.h"
#import "ShopTableViewCell.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "ShopDetailViewController.h"

@interface RecommendGoodsViewController (){
    UITableView *mTableView;
    DataProvider *dataProvider;
    NSArray *recommendGoodsArray;
    int curpage;
}

@end

@implementation RecommendGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化参数
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self setBarTitle:@"推荐商品"];
    [self addLeftButton:@"left"];
    
    dataProvider = [[DataProvider alloc] init];
    recommendGoodsArray = [[NSArray alloc] init];
    
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
        [weakSelf initData];
        [weakTv.mj_header endRefreshing];
    }];
    
    // 马上进入刷新状态
    [mTableView.mj_header beginRefreshing];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(TeamFootRefresh)];
    // 禁止自动加载
    footer.automaticallyRefresh = NO;
    // 设置footer
    mTableView.mj_footer = footer;
}

-(void)initData{
    curpage = 0;
    [dataProvider setDelegateObject:self setBackFunctionName:@"recommendGoodsCallBack:"];
    [dataProvider SelectProductBySearch:@"0" andmaximumRows:@"15" andsearch:@"" andcategoryId:@"0" andisPriceAsc:@"0" andisSalesAsc:@"0" andisCommentAsc:@"0" andisNewAsc:@"0" andisCredit:@"0" andisRecommend:@"1"];
}

-(void)recommendGoodsCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        recommendGoodsArray = dict[@"data"];
        [mTableView reloadData];
    }
}

-(void)TeamFootRefresh{
    curpage++;
    [dataProvider setDelegateObject:self setBackFunctionName:@"recommendGoodsFootCallBack:"];
    [dataProvider SelectProductBySearch:[NSString stringWithFormat:@"%d",curpage * 15] andmaximumRows:@"15" andsearch:@"" andcategoryId:@"0" andisPriceAsc:@"0" andisSalesAsc:@"0" andisCommentAsc:@"0" andisNewAsc:@"0" andisCredit:@"0" andisRecommend:@"1"];
}

-(void)recommendGoodsFootCallBack:(id)dict{
    // 结束刷新
    [mTableView.mj_footer endRefreshing];
    NSMutableArray *itemarray=[[NSMutableArray alloc] initWithArray:recommendGoodsArray];
    if ([dict[@"code"] intValue] == 200) {
        NSArray * arrayitem=[[NSArray alloc] init];
        arrayitem=dict[@"data"];
        for (id item in arrayitem) {
            [itemarray addObject:item];
        }
        recommendGoodsArray=[[NSArray alloc] initWithArray:itemarray];
    }
    [mTableView reloadData];
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return recommendGoodsArray.count;
}

#pragma mark setting for section

#pragma mark setting for cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ShopCellIdentifier";
    ShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ShopTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.backgroundColor = ItemsBaseColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",Url,[Toolkit judgeIsNull:[recommendGoodsArray[indexPath.row] valueForKey:@"ImagePath"]]];
    [cell.mImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"KongFuStoreProduct"]];
    cell.mName.text = [Toolkit judgeIsNull:[recommendGoodsArray[indexPath.row] valueForKey:@"Name"]];
    cell.mPrice.text = [NSString stringWithFormat:@"¥%@",[Toolkit judgeIsNull:[recommendGoodsArray[indexPath.row] valueForKey:@"Price"]]];
    cell.watchNum.text = [NSString stringWithFormat:@"%@人",[Toolkit judgeIsNull:[recommendGoodsArray[indexPath.row] valueForKey:@"VisitNum"]]];
    cell.salesNum.text = [NSString stringWithFormat:@"销量:%@",[Toolkit judgeIsNull:[recommendGoodsArray[indexPath.row] valueForKey:@"SaleNum"]]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [mTableView deselectRowAtIndexPath:indexPath animated:YES];
    ShopDetailViewController *shopDetailVC = [[ShopDetailViewController alloc] init];
    shopDetailVC.goodsId = [recommendGoodsArray[indexPath.row] valueForKey:@"Id"];
    [self.navigationController pushViewController:shopDetailVC animated:YES];
}

@end
