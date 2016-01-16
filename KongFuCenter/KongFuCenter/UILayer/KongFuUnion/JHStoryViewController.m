//
//  JHStoryViewController.m
//  KongFuCenter
//
//  Created by Rain on 15/12/4.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "JHStoryViewController.h"
#import "JHStoryTableViewCell.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"

@interface JHStoryViewController (){
    UITableView *mTableView;
    CGFloat mCellHeight;
    int curpage;
    int selectMenuIndex;
    NSArray *menuArray;
    UIImageView *menuImgView;
    NSArray *jhStoryArray;
}

@end

@implementation JHStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化参数
    self.view.backgroundColor = BACKGROUND_COLOR;
    mCellHeight = SCREEN_HEIGHT / 6;
    [self setBarTitle:@"江湖故事"];
    [self addLeftButton:@"left"];
    
    selectMenuIndex = 0;
    
    //初始化View
    [self initData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

#pragma mark 自定义方法

-(void)initData{
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"GetCateForJianghuCallBack:"];
    [dataProvider GetCateForJianghu];
}

-(void)GetCateForJianghuCallBack:(id)dict{
    menuArray = [[NSArray alloc] initWithArray:dict[@"data"]];
    //初始化View
    [self initViews];
}

-(void)initViews{
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, 44)];
    menuImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btnFlag"]];
    menuImgView.contentMode = UIViewContentModeScaleAspectFit;
    menuView.backgroundColor = ItemsBaseColor;
    CGFloat everyMenuWidth = SCREEN_WIDTH / menuArray.count;
    for (int i = 0; i < menuArray.count; i++) {
        UIButton *btnMenu = [[UIButton alloc] initWithFrame:CGRectMake(i * everyMenuWidth, 0, everyMenuWidth , menuView.frame.size.height)];
        if (i == 0) {
            btnMenu.selected = YES;
            menuImgView.frame = CGRectMake((btnMenu.frame.size.width - 15) / 2, btnMenu.frame.size.height - 14, 15, 10);
            [btnMenu addSubview:menuImgView];
        }
        
        [btnMenu setTitle:[menuArray[i] valueForKey:@"Name"] forState:UIControlStateNormal];
        btnMenu.titleLabel.font = [UIFont systemFontOfSize:16];
        [btnMenu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnMenu setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        btnMenu.tag = i;
        [btnMenu addTarget:self action:@selector(clickBtnMenuEvent:) forControlEvents:UIControlEventTouchUpInside];
        [menuView addSubview:btnMenu];
    }
    [self.view addSubview:menuView];
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height + 44, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height - 44)];
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
        [weakSelf TeamTopRefresh];
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

-(void)clickBtnMenuEvent:(UIButton *)btnMenu{
    for (UIView *view in btnMenu.superview.subviews) {
        ((UIButton *)view).selected = NO;
    }
    menuImgView.frame = CGRectMake((btnMenu.frame.size.width - 15) / 2, btnMenu.frame.size.height - 14, 15, 10);
    [btnMenu addSubview:menuImgView];
    btnMenu.selected = YES;
    
    NSLog(@"%d",(int)btnMenu.tag);
    selectMenuIndex = (int)btnMenu.tag;
    [self TeamTopRefresh];
}

-(void)TeamTopRefresh{
    curpage = 0;
    jhStoryArray = [[NSArray alloc] init];
    [mTableView.mj_footer setState:MJRefreshStateIdle];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"TopRefireshCallBack:"];
    [dataProvider GetJianghuListByPage:@"0" andUserId:[Toolkit getUserID] andmaximumRows:@"10" andcategoryid:[menuArray[selectMenuIndex] valueForKey:@"Id"]];
}

-(void)TopRefireshCallBack:(id)dict{
    [SVProgressHUD dismiss];
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue] == 200) {
        jhStoryArray = [[NSArray alloc] initWithArray:dict[@"data"]];
        if(jhStoryArray.count >= [dict[@"recordcount"] intValue])
        {
            [mTableView.mj_footer setState:MJRefreshStateNoMoreData];
        }
        [mTableView reloadData];
    }
}

-(void)TeamFootRefresh{
    curpage++;
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"FootRefireshBackCall:"];
    [dataProvider GetJianghuListByPage:[NSString stringWithFormat:@"%d",curpage * 10] andUserId:[Toolkit getUserID]  andmaximumRows:@"10" andcategoryid:[menuArray[selectMenuIndex] valueForKey:@"Id"]];
}

-(void)FootRefireshBackCall:(id)dict
{
    DLog(@"%@",dict);
    NSLog(@"上拉刷新");
    // 结束刷新
    [mTableView.mj_footer endRefreshing];
    NSMutableArray *itemarray=[[NSMutableArray alloc] initWithArray:jhStoryArray];
    if ([dict[@"code"] intValue] == 200) {
        NSArray * arrayitem=[[NSArray alloc] init];
        arrayitem=dict[@"data"];
        for (id item in arrayitem) {
            [itemarray addObject:item];
        }
        jhStoryArray=[[NSArray alloc] initWithArray:itemarray];
        
        
        if(jhStoryArray.count >= [dict[@"recordcount"] intValue])
        {
            [mTableView.mj_footer setState:MJRefreshStateNoMoreData];
        }
        
    }
    [mTableView reloadData];
}

-(NSString *)judgeIsNull:(NSString *)str{
    str = [NSString stringWithFormat:@"%@",str];
    if([str isEqual:@""] || [str isEqual:[NSNull null]]){
        return @"";
    }
    return str;
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return jhStoryArray.count;
}

#pragma mark setting for section
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 2;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BACKGROUND_COLOR;
    return view;
}

#pragma mark setting for cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"JHStoryCellIdentifier";
    JHStoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JHStoryTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.backgroundColor = ItemsBaseColor;
    }
    NSString *ImagePath = [self judgeIsNull:[jhStoryArray[indexPath.row] valueForKey:@"ImagePath"]];
    NSString *url = [NSString stringWithFormat:@"%@%@",Url,ImagePath];
    [cell.mImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"jhstory"]];
    cell.mName.text = [self judgeIsNull:[jhStoryArray[indexPath.row] valueForKey:@"Title"]];//@"咏春拳公益巡回演出";
    cell.mDetail.text = [self judgeIsNull:[jhStoryArray[indexPath.row] valueForKey:@"Content"]];//@"咏春拳是最快的制敌拳法,公益巡回演出,让大家更好的理解咏春拳";
    NSString *PublishTime = [self judgeIsNull:[jhStoryArray[indexPath.row] valueForKey:@"PublishTime"]];
    NSString *month = [PublishTime substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [PublishTime substringWithRange:NSMakeRange(8, 2)];
    cell.mDate.text = [NSString stringWithFormat:@"%@月%@日",month,day];
    cell.mReadNum.text = [self judgeIsNull:[jhStoryArray[indexPath.row] valueForKey:@"LikeNum"]];
    cell.mCollectionNum.text = [self judgeIsNull:[jhStoryArray[indexPath.row] valueForKey:@"FavoriteNum"]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return mCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [mTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UnionNewsDetailViewController *unionNewsViewCtl = [[UnionNewsDetailViewController alloc] init];
    unionNewsViewCtl.webId =[ NSString stringWithFormat:@"%@",jhStoryArray[indexPath.row][@"Id"]];
    unionNewsViewCtl.navtitle = jhStoryArray[indexPath.row][@"Title"];
    unionNewsViewCtl.collectNum = [ NSString stringWithFormat:@"%@",jhStoryArray[indexPath.row][@"FavoriteNum"]];
    unionNewsViewCtl.isFavorite = [ NSString stringWithFormat:@"%@",jhStoryArray[indexPath.row][@"IsFavorite"]];
    [self.navigationController pushViewController:unionNewsViewCtl animated:YES];
}

@end
