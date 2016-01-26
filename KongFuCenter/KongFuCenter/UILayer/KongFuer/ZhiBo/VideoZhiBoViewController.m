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
        NSArray *sliderArray = [[NSArray alloc] initWithObjects:@"UpLoad/Dongtai/Image/5da7e68c-51fb-415d-ab57-bf4450193a66.jpg",@"UpLoad/Dongtai/Image/28910553-2b69-4b0f-90d3-081276f4c96f.png", nil];//[mDataArray valueForKey:@"rotationAdvertList"];
        if (sliderArray.count > 0) {
            for (int i=0; i<sliderArray.count; i++) {
                UIImageView * img=[[UIImageView alloc] init];
                NSString *imgpath = sliderArray[i];//sliderArray[i][@"imgpath"]?sliderArray[i][@"imgpath"]:@"";
                NSString *url = [NSString stringWithFormat:@"%@%@",Url,imgpath];
                [img sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"store_head_bg"]];
                [images addObject:img];
            }
        }
        //创建带标题的图片轮播器
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 170) imagesGroup:images ];
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        cycleScrollView.autoScrollTimeInterval = 5;
        [cell addSubview:cycleScrollView];
        
        UILabel *mName = [[UILabel alloc] initWithFrame:CGRectMake(14, cycleScrollView.frame.origin.y + cycleScrollView.frame.size.height + (50 - 21) / 2, 220, 21)];
        mName.textColor = [UIColor whiteColor];
        mName.font = [UIFont systemFontOfSize:19];
        mName.text = @"临沂第一届国际武术大赛";
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
        startTime.text = @"2016-02-06 23:00:00";
        [cell addSubview:startTime];
        
        [Toolkit drawLine:SCREEN_WIDTH/2 +20 andSY:0 andEX:SCREEN_WIDTH/2-18 andEY:45 andLW:1 andColor:Separator_Color andView:cell];
        
        UILabel *endTimeStr = [[UILabel alloc] initWithFrame:CGRectMake(16 + SCREEN_WIDTH / 2, 2, 120, 21)];
        endTimeStr.textColor = [UIColor whiteColor];
        endTimeStr.font = [UIFont systemFontOfSize:14];
        endTimeStr.text = @"直播开始时间:";
        [cell addSubview:endTimeStr];
        
        UILabel *endTime = [[UILabel alloc] initWithFrame:CGRectMake(10 + SCREEN_WIDTH / 2, endTimeStr.frame.origin.y + endTimeStr.frame.size.height + 2, 140, 21)];
        endTime.textColor = YellowBlock;
        endTime.font = [UIFont systemFontOfSize:13];
        endTime.text = @"2016-02-08 23:00:00";
        [cell addSubview:endTime];
    }else{
        if (indexPath.row == 0) {
            UILabel *contentTitle = [[UILabel alloc] initWithFrame:CGRectMake(14, 10, 100, 21)];
            contentTitle.textColor = [UIColor whiteColor];
            contentTitle.font = [UIFont systemFontOfSize:18];
            contentTitle.text = @"内容介绍:";
            [cell addSubview:contentTitle];
            
            NSString *mContentStr = [NSString stringWithFormat:@"%@%@",@"        ",@"成家班就是五行里的“飞虎队”，勇猛果敢无所不能，成家班就是五行里的“飞虎队”，勇猛果敢无所不能，成家班就是五行里的“飞虎队”，勇猛果敢无所不能，成家班就是五行里的“飞虎队”，勇猛果敢无所不能，成家班就是五行里的“飞虎队”，勇猛果敢无所不能，成家班就是五行里的“飞虎队”，勇猛果敢无所不能。"];
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
            [viewCourseBtn setTitle:@"查看课程" forState:UIControlStateNormal];
            [viewCourseBtn addTarget:self action:@selector(viewCourseEvent) forControlEvents:UIControlEventTouchUpInside];
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
            NSString *mContentStr = [NSString stringWithFormat:@"%@%@",@"        ",@"成家班就是五行里的“飞虎队”，勇猛果敢无所不能，成家班就是五行里的“飞虎队”，勇猛果敢无所不能，成家班就是五行里的“飞虎队”，勇猛果敢无所不能，成家班就是五行里的“飞虎队”，勇猛果敢无所不能，成家班就是五行里的“飞虎队”，勇猛果敢无所不能，成家班就是五行里的“飞虎队”，勇猛果敢无所不能。"];
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
