//
//  AnnouncementViewController.m
//  KongFuCenter
//
//  Created by 鞠超 on 15/12/16.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "AnnouncementViewController.h"
#import "AnnouncementTableViewCell.h"
@interface AnnouncementViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation AnnouncementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    pageSize = 12;
    // Do any additional setup after loading the view.
    announceArr = [NSMutableArray array];
    [self p_navigation];
    
    [self p_setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - self data source 
-(void)FooterRefresh
{
    [self getTeamAnnounce];
}

-(void) getTeamAnnounce
{
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getTeamAnnounceCallBack:"];
    [dataProvider getTeamAnnouncement:get_sp(TEAM_ID)
                     andStartRowIndex:[NSString stringWithFormat:@"%d",pageNo*pageSize]
                       andMaximumRows:[NSString stringWithFormat:@"%d",pageSize]];
}

-(void)getTeamAnnounceCallBack:(id)dict
{
    DLog(@"%@",dict);
    [SVProgressHUD dismiss];
    if ([dict[@"code"] intValue] == 200) {
        @try {
            pageNo ++;
            [announceArr addObjectsFromArray:dict[@"data"]];
            [self.tableView reloadData];
            
            if(announceArr.count >= [dict[@"recordcount"] intValue])
            {
                [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
            }
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

#pragma mark - 背景色和navigation
- (void)p_navigation
{
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self setBarTitle:@"战队公告"];
    [self addLeftButton:@"left"];
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - tableView
- (void)p_setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT + StatusBar_HEIGHT + 10, self.view.frame.size.width, self.view.frame.size.height - NavigationBar_HEIGHT - StatusBar_HEIGHT - 10) style:(UITableViewStylePlain)];
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 30, 0, 0);
    self.tableView.separatorColor = Separator_Color;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    self.tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageNo=0;
        [announceArr removeAllObjects];
        if(self.tableView.mj_footer != nil)
        {
            [self.tableView.mj_footer setState:MJRefreshStateIdle];
        }
        [weakSelf getTeamAnnounce];
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
    [self.tableView.mj_header beginRefreshing];
    
//     上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    
            [weakSelf FooterRefresh];
            [self.tableView.mj_footer endRefreshing];
        }];
    
    [self.tableView registerClass:[AnnouncementTableViewCell class] forCellReuseIdentifier:@"cell_Announcement"];
    
}

#pragma mark - tableView代理方法
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return announceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnnouncementTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell_Announcement" forIndexPath:indexPath];
    
    cell.backgroundColor = ItemsBaseColor;
    
    @try {
        if(announceArr==nil || announceArr.count == 0|| announceArr.count - 1 < indexPath.row)
            return cell;
        
        cell.name.text = announceArr[indexPath.row][@"Title"];
        cell.date.text = [announceArr[indexPath.row][@"PublishTime"] substringToIndex:10];
        NSRange tempRange;
        tempRange.length = 5;
        tempRange.location = 11;
        cell.time.text = [announceArr[indexPath.row][@"PublishTime"] substringWithRange:tempRange];
        cell.detail.text = announceArr[indexPath.row][@"Content"];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
        return cell;
    }
    
    
   
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AnnounceDetailViewController *announceDetailViewCtl = [[AnnounceDetailViewController alloc] init];
    announceDetailViewCtl.navtitle = announceArr[indexPath.row][@"Title"];
    announceDetailViewCtl.announceDetailDict = announceArr[indexPath.row];
    [self.navigationController pushViewController:announceDetailViewCtl animated:NO];
}

@end
