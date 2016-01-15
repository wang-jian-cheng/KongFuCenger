//
//  MushaMatch.m
//  KongFuCenter
//
//  Created by Rain on 15/12/8.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "MushaMatch.h"
#import "MushaMatchCell.h"
#import "MJRefresh.h"
#import "MushaMatchDetailGoingViewController.h"

typedef enum _MatchMode
{
    WuZheMode =0,
    ZhanDuiMode
   
    
}MatchMode;

@interface MushaMatch (){
    //tableview
    UITableView *mTableView;
    CGFloat mCellHeight;
    
    //data
    NSMutableArray *menuArray;
    int curpage;
    NSArray *matchArray;
    
    //view
    UIImageView *menuImgView;
    
    
    MatchMode matchMode;
}

@end

@implementation MushaMatch

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化参数
    mCellHeight = SCREEN_HEIGHT / 7;
    [self setBarTitle:@"武者大赛"];
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self addLeftButton:@"left"];
    
    //初始化数据
    [self initDatas];
    
    //初始化View
    [self initViews];
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

#pragma mark 自定义方法
-(void)initDatas{
    menuArray = [[NSMutableArray alloc] init];
    [menuArray addObjectsFromArray:@[@"武者赛事",@"战队赛事"]];
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
        
        [btnMenu setTitle:menuArray[i] forState:UIControlStateNormal];
        btnMenu.titleLabel.font = [UIFont systemFontOfSize:16];
        [btnMenu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnMenu setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        btnMenu.tag = i;
        [btnMenu addTarget:self action:@selector(clickBtnMenuEvent:) forControlEvents:UIControlEventTouchUpInside];
        [menuView addSubview:btnMenu];
    }
    [self.view addSubview:menuView];
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height + 46, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height - 46)];
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

-(void)TeamTopRefresh{
    curpage = 0;
    matchArray = [[NSArray alloc] init];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"TopRefireshCallBack:"];
    if (matchMode == WuZheMode) {
        [dataProvider SelectMatchPageByPerson:@"0" andmaximumRows:@"10"];
    }else{
        [dataProvider SelectMatchPageByTeam:@"0" andmaximumRows:@"10"];
    }
}

-(void)TopRefireshCallBack:(id)dict{
    [SVProgressHUD dismiss];
    if ([dict[@"code"] intValue] == 200) {
        matchArray = [[NSArray alloc] initWithArray:dict[@"data"]];
        [mTableView reloadData];
    }
}

-(void)TeamFootRefresh{
    curpage++;
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"FootRefireshBackCall:"];
    if (matchMode == WuZheMode) {
        [dataProvider SelectMatchPageByPerson:[NSString stringWithFormat:@"%d",curpage * 10] andmaximumRows:@"10"];
    }else{
        [dataProvider SelectMatchPageByTeam:[NSString stringWithFormat:@"%d",curpage * 10] andmaximumRows:@"10"];
    }
}

-(void)FootRefireshBackCall:(id)dict
{
    
    NSLog(@"上拉刷新");
    // 结束刷新
    [mTableView.mj_footer endRefreshing];
    NSMutableArray *itemarray=[[NSMutableArray alloc] initWithArray:matchArray];
    if ([dict[@"code"] intValue] == 200) {
        NSArray * arrayitem=[[NSArray alloc] init];
        arrayitem=dict[@"data"];
        for (id item in arrayitem) {
            [itemarray addObject:item];
        }
        matchArray=[[NSArray alloc] initWithArray:itemarray];
    }
    [mTableView reloadData];
}

-(void)clickBtnMenuEvent:(UIButton *)btnMenu{
    for (UIView *view in btnMenu.superview.subviews) {
        ((UIButton *)view).selected = NO;
    }
    menuImgView.frame = CGRectMake((btnMenu.frame.size.width - 15) / 2, btnMenu.frame.size.height - 14, 15, 10);
    [btnMenu addSubview:menuImgView];
    btnMenu.selected = YES;
    
    
    if(btnMenu.tag == 1)
    {

        
        matchMode = ZhanDuiMode;
    }
    else
    {
        matchMode = WuZheMode;
    }
    NSLog(@"%d",(int)btnMenu.tag);
    [mTableView.mj_header beginRefreshing];
}

-(NSString *)matchState:(NSString *)startDate andEndDate:(NSString *)endDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *now = [dateFormatter stringFromDate:[NSDate date]];
    NSComparisonResult result = [now compare:startDate];
    if (result == -1) {
        return @"未开始";
    }else{
        result = [now compare:endDate];
        if (result == -1) {
            return @"进行中";
        }else{
            return @"已结束";
        }
    }
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return matchArray.count;
}

#pragma mark setting for section

#pragma mark setting for cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"MushaMatchCellIdentifier";
    MushaMatchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MushaMatchCell" owner:self options:nil] objectAtIndex:0];
        cell.backgroundColor = ItemsBaseColor;
    }
    @try {
        
        NSLog(@"%@",matchArray);
        NSString *ImagePath = [Toolkit judgeIsNull:[matchArray[indexPath.row] valueForKey:@"MatchImage"]];
        NSString *url = [NSString stringWithFormat:@"%@%@",Url,ImagePath];
        [cell.mImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"jhstory"]];
        cell.mName.text = [Toolkit judgeIsNull:[matchArray[indexPath.row] valueForKey:@"Name"]];//@"永春拳公益巡回演出";
        cell.mDetail.text = [Toolkit judgeIsNull:[matchArray[indexPath.row] valueForKey:@"Introduction"]];//@"咏春拳是最快的制敌拳法,公益巡回演出,让大家更好的理解咏春拳";
        NSString *startDate = [Toolkit judgeIsNull:[matchArray[indexPath.row] valueForKey:@"MatchTimeStart"]];
        NSString *year = [startDate substringToIndex:4];
        NSString *month = [startDate substringWithRange:NSMakeRange(5, 2)];
        NSString *day = [startDate substringWithRange:NSMakeRange(8, 2)];
        cell.mDate.text = [NSString stringWithFormat:@"%@月%@日",month,day];
        NSString *endDate = [Toolkit judgeIsNull:[matchArray[indexPath.row] valueForKey:@"MatchTimeEnd"]];
        NSString *yearend = [endDate substringToIndex:4];
        NSString *monthend = [endDate substringWithRange:NSMakeRange(5, 2)];
        NSString *dayend = [endDate substringWithRange:NSMakeRange(8, 2)];
        NSString *resultState = [self matchState:startDate andEndDate:endDate];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.mState.frame.size.width, cell.mState.frame.size.height)];
        if ([resultState isEqual:@"未开始"]) {
            cell.mEndDate.text = [NSString stringWithFormat:@"开始时间:%@年%@月%@日",year,month,day];
            imageView.image = [UIImage imageNamed:@"weikaishi"];
            cell.tag = 0;
        }else if([resultState isEqual:@"进行中"]){
            cell.mEndDate.text = [NSString stringWithFormat:@"结束时间:%@年%@月%@日",yearend,monthend,dayend];
            imageView.image = [UIImage imageNamed:@"jinxingzhong"];
            cell.tag = 1;
        }else{
            cell.mEndDate.text = [NSString stringWithFormat:@"结束时间:%@年%@月%@日",yearend,monthend,dayend];
            imageView.image = [UIImage imageNamed:@"yijieshu"];
            cell.tag = 2;
        }
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [cell.mState addSubview:imageView];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
//    
//    
//    [cell.mState setTitle:@"未开始" forState:UIControlStateNormal];
//    [cell.mState setTitleColor:[UIColor colorWithRed:0.94 green:0.61 blue:0 alpha:1] forState:UIControlStateNormal];
//    cell.mState.layer.cornerRadius = 5;
//    cell.mState.layer.borderWidth = 1;
//    cell.mState.layer.borderColor = [UIColor colorWithRed:0.94 green:0.61 blue:0 alpha:1].CGColor;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return mCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [mTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    int matchState = (int)cell.tag;
    if(matchMode == WuZheMode)
    {
        if (matchState == 0) {//未开始
            MushaMatchDetailViewController *mushaMatchDetailViewCtl = [[MushaMatchDetailViewController alloc] init];
            [mushaMatchDetailViewCtl setMushaMatchDetailMode:Mode_Musha];
            mushaMatchDetailViewCtl.navtitle  = [Toolkit judgeIsNull:[matchArray[indexPath.row] valueForKey:@"Name"]];
            mushaMatchDetailViewCtl.matchId = [Toolkit judgeIsNull:[matchArray[indexPath.row] valueForKey:@"Id"]];
            [self.navigationController pushViewController:mushaMatchDetailViewCtl animated:YES];
        }else if(matchState == 1){//进行中
            MushaMatchOngoingViewController *mushaMatchOngoingViewCtl =[[MushaMatchOngoingViewController alloc] init];
            [mushaMatchOngoingViewCtl setMushaMatchOngoingMode:Mode_MushaOnGoing];
            mushaMatchOngoingViewCtl.navtitle = [Toolkit judgeIsNull:[matchArray[indexPath.row] valueForKey:@"Name"]];
            mushaMatchOngoingViewCtl.matchId = [Toolkit judgeIsNull:[matchArray[indexPath.row] valueForKey:@"Id"]];
            [self.navigationController pushViewController:mushaMatchOngoingViewCtl animated:YES];
        }else{//已结束
            MushaMatchDetailGoingViewController *mushaMatchDetailGoingVC = [[MushaMatchDetailGoingViewController alloc] init];
            [mushaMatchDetailGoingVC setMushaMatchDetailGoingMode:Mode_MushaEnd];
            mushaMatchDetailGoingVC.matchId = [Toolkit judgeIsNull:[matchArray[indexPath.row] valueForKey:@"Id"]];
            mushaMatchDetailGoingVC.navtitle = [Toolkit judgeIsNull:[matchArray[indexPath.row] valueForKey:@"Name"]];
            [self.navigationController pushViewController:mushaMatchDetailGoingVC animated:YES];
        }
    }
    else if(matchMode == ZhanDuiMode)
    {
        if(matchState == 0)
        {
            MushaMatchDetailViewController *mushaMatchDetailViewCtl = [[MushaMatchDetailViewController alloc] init];
            [mushaMatchDetailViewCtl setMushaMatchDetailMode:Mode_Team];
            mushaMatchDetailViewCtl.navtitle  = @"战队大赛详情";
            mushaMatchDetailViewCtl.matchId = [Toolkit judgeIsNull:[matchArray[indexPath.row] valueForKey:@"Id"]];
            [self.navigationController pushViewController:mushaMatchDetailViewCtl animated:YES];
        }
        else if(matchState == 1)
        {
            MushaMatchOngoingViewController *mushaMatchOngoingViewCtl =[[MushaMatchOngoingViewController alloc] init];
            [mushaMatchOngoingViewCtl setMushaMatchOngoingMode:Mode_TeamOnGoing];
            mushaMatchOngoingViewCtl.matchId = [Toolkit judgeIsNull:[matchArray[indexPath.row] valueForKey:@"Id"]];
            mushaMatchOngoingViewCtl.navtitle = [Toolkit judgeIsNull:[matchArray[indexPath.row] valueForKey:@"Name"]];
            [self.navigationController pushViewController:mushaMatchOngoingViewCtl animated:YES];
        }
        else
        {
            MushaMatchDetailGoingViewController *mushaMatchDetailGoingVC = [[MushaMatchDetailGoingViewController alloc] init];
            [mushaMatchDetailGoingVC setMushaMatchDetailGoingMode:Mode_TeamEnd];
            mushaMatchDetailGoingVC.navtitle = @"战队大赛详情";
            mushaMatchDetailGoingVC.matchId = [Toolkit judgeIsNull:[matchArray[indexPath.row] valueForKey:@"Id"]];
            [self.navigationController pushViewController:mushaMatchDetailGoingVC animated:YES];
        }
    }
}

@end
