//
//  VideoZhiBoViewController.m
//  KongFuCenter
//
//  Created by Rain on 16/1/26.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "VideoZhiBoViewController.h"
#import "UIImageView+WebCache.h"
#import "SDCycleScrollView.h"
#import "ZhiBoViewController.h"

@interface VideoZhiBoViewController (){
    UITableView *mTableView;
    NSDictionary *videoLiveDict;
}

@end

@implementation VideoZhiBoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化参数
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self setBarTitle:@"视频直播"];
    [self addLeftButton:@"left"];
    
    //初始化View
    [self initData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

#pragma mark 自定义方法
-(void)initData{
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getVideoZhiInfoCallBack:"];
    [dataProvider SelectVideoLive:get_sp(@"id") andvideoLiveId:_videoLiveID];
}

-(void)getVideoZhiInfoCallBack:(id)dict{
    [SVProgressHUD dismiss];
    if ([dict[@"code"] intValue] == 200) {
        videoLiveDict = [[NSDictionary alloc] initWithDictionary:dict[@"data"]];
        [self initViews];
    }
}

-(void)initViews{
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height)];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = BACKGROUND_COLOR;
    mTableView.separatorColor = Separator_Color;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:mTableView];
}

-(void)viewCourseEvent{
    ZhiBoViewController *zhiboViewCtl = [[ZhiBoViewController alloc] init];
    zhiboViewCtl.navtitle = @"视频直播";
    [self.navigationController pushViewController:zhiboViewCtl animated:YES];
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return 2;
    }else{
        return 1;
    }
}

#pragma mark setting for section
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1 || section == 2) {
        return 3;
    }else{
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
    }else{
        for (UIView *view in cell.subviews) {
            [view removeFromSuperview];
        }
    }
    if (indexPath.section == 0) {
        NSMutableArray *images = [[NSMutableArray alloc] init];
        NSArray *sliderArray = [[NSArray alloc] initWithArray:[videoLiveDict valueForKey:@"ImageList"]];
        if (sliderArray.count > 0) {
            for (int i=0; i<sliderArray.count; i++) {
                UIImageView * img=[[UIImageView alloc] init];
                NSString *url = [NSString stringWithFormat:@"%@%@",Url,[Toolkit judgeIsNull:[sliderArray[i] valueForKey:@"ImagePath"]]];
                [img sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"store_head_bg"]];
                [images addObject:img];
            }
        }
        //创建带标题的图片轮播器
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 170) imagesGroup:images ];
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        cycleScrollView.autoScrollTimeInterval = 5;
        [cell addSubview:cycleScrollView];
        
        UILabel *mName = [[UILabel alloc] initWithFrame:CGRectMake(14, cycleScrollView.frame.origin.y + cycleScrollView.frame.size.height + (50 - 21) / 2, 250, 21)];
        mName.textColor = [UIColor whiteColor];
        mName.font = [UIFont systemFontOfSize:18];
        mName.text = [Toolkit judgeIsNull:[videoLiveDict valueForKey:@"Title"]];
        [cell addSubview:mName];
    }else if (indexPath.section == 1){
        UILabel *startTimeStr = [[UILabel alloc] initWithFrame:CGRectMake(14, 2, 120, 21)];
        startTimeStr.textColor = [UIColor whiteColor];
        startTimeStr.font = [UIFont systemFontOfSize:14];
        startTimeStr.text = @"直播开始时间:";
        [cell addSubview:startTimeStr];
        
        UILabel *startTime = [[UILabel alloc] initWithFrame:CGRectMake(10, startTimeStr.frame.origin.y + startTimeStr.frame.size.height + 2, 140, 21)];
        startTime.font = [UIFont systemFontOfSize:13];
        startTime.textColor = YellowBlock;
        startTime.text = [Toolkit judgeIsNull:[videoLiveDict valueForKey:@"TimeStart"]];
        [cell addSubview:startTime];
        
        [Toolkit drawLine:SCREEN_WIDTH/2 +20 andSY:0 andEX:SCREEN_WIDTH/2-18 andEY:45 andLW:1 andColor:Separator_Color andView:cell];
        
        UILabel *endTimeStr = [[UILabel alloc] initWithFrame:CGRectMake(16 + SCREEN_WIDTH / 2, 2, 120, 21)];
        endTimeStr.textColor = [UIColor whiteColor];
        endTimeStr.font = [UIFont systemFontOfSize:14];
        endTimeStr.text = @"直播结束时间:";
        [cell addSubview:endTimeStr];
        
        UILabel *endTime = [[UILabel alloc] initWithFrame:CGRectMake(10 + SCREEN_WIDTH / 2, endTimeStr.frame.origin.y + endTimeStr.frame.size.height + 2, 140, 21)];
        endTime.textColor = YellowBlock;
        endTime.font = [UIFont systemFontOfSize:13];
        endTime.text = [Toolkit judgeIsNull:[videoLiveDict valueForKey:@"TimeEnd"]];
        [cell addSubview:endTime];
    }else{
        if (indexPath.row == 0) {
            UILabel *contentTitle = [[UILabel alloc] initWithFrame:CGRectMake(14, 10, 100, 21)];
            contentTitle.textColor = [UIColor whiteColor];
            contentTitle.font = [UIFont systemFontOfSize:18];
            contentTitle.text = @"内容介绍:";
            [cell addSubview:contentTitle];
            
            NSString *mContentStr = [NSString stringWithFormat:@"%@%@",@"        ",[Toolkit judgeIsNull:[videoLiveDict valueForKey:@"Content"]]];
            CGFloat contentHeight = [Toolkit heightWithString:mContentStr fontSize:14 width:SCREEN_WIDTH-64]+5;
            UITextView *contentTv = [[UITextView alloc] initWithFrame:CGRectMake(14, contentTitle.frame.origin.y + contentTitle.frame.size.height, SCREEN_WIDTH - 28, contentHeight)];
            contentTv.editable = NO;
            contentTv.scrollEnabled = NO;
            contentTv.font = [UIFont systemFontOfSize:14];
            contentTv.backgroundColor = ItemsBaseColor;
            contentTv.textColor = [UIColor whiteColor];
            contentTv.text = mContentStr;
            [cell addSubview:contentTv];
        }else{
            cell.backgroundColor = BACKGROUND_COLOR;
            UIButton *viewCourseBtn = [[UIButton alloc] initWithFrame:CGRectMake(14, 10, SCREEN_WIDTH - 28, 45)];
            viewCourseBtn.backgroundColor = ItemsBaseColor;
            [viewCourseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            if(_videoZhiBoState == Mode_NoStart){
                [viewCourseBtn setTitle:@"直播未开始" forState:UIControlStateNormal];
            }else if (_videoZhiBoState == Mode_Playing){
                [viewCourseBtn setTitle:@"正在直播" forState:UIControlStateNormal];
                [viewCourseBtn addTarget:self action:@selector(viewCourseEvent) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [viewCourseBtn setTitle:@"直播已结束" forState:UIControlStateNormal];
            }
            viewCourseBtn.layer.masksToBounds = YES;
            viewCourseBtn.layer.cornerRadius = 8;
            [cell addSubview:viewCourseBtn];
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 170 + 50;
    }else if (indexPath.section == 1){
        return 45;
    }else{
        if (indexPath.row == 0) {
            NSString *mContentStr = [NSString stringWithFormat:@"%@%@",@"        ",[Toolkit judgeIsNull:[videoLiveDict valueForKey:@"Content"]]];
            CGFloat contentHeight = [Toolkit heightWithString:mContentStr fontSize:14 width:SCREEN_WIDTH-64]+5;
            return 10 + 21 + 5 + contentHeight + 10;
        }else{
            return 65;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [mTableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
