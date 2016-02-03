//
//  VideoZhiBoList.m
//  KongFuCenter
//
//  Created by Rain on 16/1/26.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "VideoZhiBoList.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "VideoZhiBoViewController.h"
#import "MushaMatchCell.h"

#define cellIdentifier @"CellIdentifier"

@interface VideoZhiBoList (){
    UITableView *mTableView;
    int curpage;
    NSArray *videoLiveArray;
    CGFloat mCellHeight;
}

@end

@implementation VideoZhiBoList

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"left"];
    [self setBarTitle:@"直播列表"];
    mCellHeight = SCREEN_HEIGHT / 7;
    [self initCollectionView];
}

-(void)initCollectionView
{
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
        [mTableView.mj_footer setState:MJRefreshStateIdle];
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
    videoLiveArray = [[NSArray alloc] init];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getVideoLiveCallBack:"];
    [dataProvider SelectVideoLiveList:get_sp(@"id") andstartRowIndex:@"0" andmaximumRows:@"10"];
}

-(void)getVideoLiveCallBack:(id)dict{
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue] == 200) {
        NSLog(@"%@",dict);
        videoLiveArray = [[NSArray alloc] initWithArray:dict[@"data"]];
        [mTableView reloadData];
    }
}

-(void)TeamFootRefresh{
    curpage++;
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getVideoLiveFootCallBack:"];
    [dataProvider SelectVideoLiveList:get_sp(@"id") andstartRowIndex:[NSString stringWithFormat:@"%d",curpage * 10] andmaximumRows:@"10"];
}

-(void)getVideoLiveFootCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        // 结束刷新
        [mTableView.mj_footer endRefreshing];
        NSMutableArray *itemarray=[[NSMutableArray alloc] initWithArray:videoLiveArray];
        if ([dict[@"code"] intValue] == 200) {
            NSArray * arrayitem=[[NSArray alloc] init];
            arrayitem=dict[@"data"];
            for (id item in arrayitem) {
                [itemarray addObject:item];
            }
            videoLiveArray=[[NSArray alloc] initWithArray:itemarray];
        }
        [mTableView reloadData];
    }
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
            return @"直播中";
        }else{
            return @"已结束";
        }
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return videoLiveArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"MushaMatchCellIdentifier";
    MushaMatchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MushaMatchCell" owner:self options:nil] objectAtIndex:0];
        cell.backgroundColor = ItemsBaseColor;
    }
    @try {
        
        NSLog(@"%@",videoLiveArray);
        NSString *ImagePath = [Toolkit judgeIsNull:[videoLiveArray[indexPath.row] valueForKey:@"ImagePath"]];
        NSString *url = [NSString stringWithFormat:@"%@%@",Url,ImagePath];
        [cell.mImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"jhstory"]];
        cell.mName.frame = CGRectMake(cell.mName.frame.origin.x, cell.mName.frame.origin.y,20, 21);
        cell.mName.text = [Toolkit judgeIsNull:[videoLiveArray[indexPath.row] valueForKey:@"Title"]];//@"永春拳公益巡回演出";
        //cell.mDetail.text = [Toolkit judgeIsNull:[videoLiveArray[indexPath.row] valueForKey:@"Content"]];//@"咏春拳是最快的制敌拳法,公益巡回演出,让大家更好的理解咏春拳";
        NSString *startDate = [Toolkit judgeIsNull:[videoLiveArray[indexPath.row] valueForKey:@"TimeStart"]];
        NSString *year = [startDate substringToIndex:4];
        NSString *month = [startDate substringWithRange:NSMakeRange(5, 2)];
        NSString *day = [startDate substringWithRange:NSMakeRange(8, 2)];
        //cell.mDate.text = [NSString stringWithFormat:@"%@月%@日",month,day];
        cell.mDate.frame = CGRectMake(cell.mDate.frame.origin.x, cell.mDate.frame.origin.y, 0, 21);
        cell.mDate.hidden = YES;
        NSString *endDate = [Toolkit judgeIsNull:[videoLiveArray[indexPath.row] valueForKey:@"TimeEnd"]];
        NSString *yearend = [endDate substringToIndex:4];
        NSString *monthend = [endDate substringWithRange:NSMakeRange(5, 2)];
        NSString *dayend = [endDate substringWithRange:NSMakeRange(8, 2)];
        NSString *resultState = [self matchState:startDate andEndDate:endDate];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.mState.frame.size.width, cell.mState.frame.size.height)];
        if ([resultState isEqual:@"未开始"]) {
            cell.mEndDate.text = [Toolkit judgeIsNull:[videoLiveArray[indexPath.row] valueForKey:@"Content"]];;//[NSString stringWithFormat:@"开始时间:%@年%@月%@日",year,month,day];
            cell.mDetail.text = [NSString stringWithFormat:@"开始时间:%@",startDate];
            imageView.image = [UIImage imageNamed:@"weikaishi"];
            cell.tag = 0;
        }else if([resultState isEqual:@"直播中"]){
            cell.mEndDate.text = [Toolkit judgeIsNull:[videoLiveArray[indexPath.row] valueForKey:@"Content"]];;//[NSString stringWithFormat:@"结束时间:%@年%@月%@日",yearend,monthend,dayend];
            cell.mDetail.text = [NSString stringWithFormat:@"结束时间:%@",endDate];
            imageView.image = [UIImage imageNamed:@"jinxingzhong"];
            cell.tag = 1;
        }else{
            cell.mEndDate.text = [Toolkit judgeIsNull:[videoLiveArray[indexPath.row] valueForKey:@"Content"]];;//[NSString stringWithFormat:@"结束时间:%@年%@月%@日",yearend,monthend,dayend];
            cell.mDetail.text = [NSString stringWithFormat:@"结束时间:%@",endDate];
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
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return mCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VideoZhiBoViewController *videoZhiBoVC = [[VideoZhiBoViewController alloc] init];
    videoZhiBoVC.videoLiveID = [Toolkit judgeIsNull:[videoLiveArray[indexPath.row] valueForKey:@"Id"]];
    MushaMatchCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *mState = cell.mState.titleLabel.text;
    if ([mState isEqual:@"未开始"]) {
        [videoZhiBoVC setVideoZhiBoState:Mode_NoStart];
    }else if([mState isEqual:@"直播中"]){
       [videoZhiBoVC setVideoZhiBoState:Mode_Playing];
    }else{
        [videoZhiBoVC setVideoZhiBoState:Mode_End];
    }
    [self.navigationController pushViewController:videoZhiBoVC animated:YES];
}

@end
