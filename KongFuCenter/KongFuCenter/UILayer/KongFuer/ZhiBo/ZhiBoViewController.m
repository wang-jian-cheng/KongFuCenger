//
//  ZhiBoViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/9.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "ZhiBoViewController.h"

@interface ZhiBoViewController (){
    NSDictionary *videoLiveDict;
    UITableView *mTableView;
    BOOL OrientationFlag;
    CGAffineTransform t;
}
@end

@implementation ZhiBoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"left"];
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    t = self.view.transform;
    videoLiveDict = [[NSDictionary alloc] init];
    
    
    webView = [[UIWebView alloc] init];
    [self initData];
    
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    //    [[UIApplication sharedApplication] setStatusBarStyle:];
}

- (void)deviceOrientationDidChange: (NSNotification *)notification
{
//    if (self.view.frame.size.width > self.view.frame.size.height) {
//        OrientationFlag = YES;
//    }
//    else
//    {
//        OrientationFlag = NO;
//    }
    
    DLog(@"%ld",(long)self.interfaceOrientation);
    
    
    mTableView.frame = CGRectMake(mTableView.frame.origin.x, mTableView.frame.origin.y,self.view.frame.size.width  , self.view.frame.size.height - 64);
    DLog(@"%@",NSStringFromCGRect(mTableView.frame));
    [mTableView reloadData];
    
    [self relayoutHeadView];
}


//重写这两个方法，设置成UIInterfaceOrientationMaskAll 和return yes则支持转屏
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;//只支持Portrait方向的旋转
}

-(BOOL)shouldAutorotate
{
    return YES;
}

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

-(void)relayoutHeadView
{
    _topView.frame = CGRectMake(0, 0, self.view.frame.size.width, 64);
    _lblTitle.center = CGPointMake(self.view.frame.size.width/2, 64/2);
}

-(void)initViews
{
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    mTableView.backgroundColor = BACKGROUND_COLOR;
    mTableView.delegate  = self;
    mTableView.dataSource = self;
    mTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:mTableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    cell.backgroundColor = ItemsBaseColor;
    
    if (indexPath.section == 0) {
        webView.frame = CGRectMake(0, 0, self.view.frame.size.width,200);
        webView.scalesPageToFit = YES;
        webView.backgroundColor = ItemsBaseColor;
        webView.scrollView.bounces = NO;
//        [self.view addSubview:webView];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@zhibo.aspx?id=%@",Url,_videoLiveID]];
        NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
        [webView loadRequest:request];
        [cell addSubview:webView];
    }else if(indexPath.section == 1){
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
        
        [Toolkit drawLine:self.view.frame.size.width/2 +20 andSY:0 andEX:self.view.frame.size.width/2-18 andEY:45 andLW:1 andColor:Separator_Color andView:cell];
        
        UILabel *endTimeStr = [[UILabel alloc] initWithFrame:CGRectMake(16 + self.view.frame.size.width / 2, 2, 120, 21)];
        endTimeStr.textColor = [UIColor whiteColor];
        endTimeStr.font = [UIFont systemFontOfSize:14];
        endTimeStr.text = @"直播结束时间:";
        [cell addSubview:endTimeStr];
        
        UILabel *endTime = [[UILabel alloc] initWithFrame:CGRectMake(10 + self.view.frame.size.width / 2, endTimeStr.frame.origin.y + endTimeStr.frame.size.height + 2, 140, 21)];
        endTime.textColor = YellowBlock;
        endTime.font = [UIFont systemFontOfSize:13];
        endTime.text = [Toolkit judgeIsNull:[videoLiveDict valueForKey:@"TimeEnd"]];
        [cell addSubview:endTime];
    }else{
        UILabel *contentTitle = [[UILabel alloc] initWithFrame:CGRectMake(14, 10, 100, 21)];
        contentTitle.textColor = [UIColor whiteColor];
        contentTitle.font = [UIFont systemFontOfSize:18];
        contentTitle.text = @"内容介绍:";
        [cell addSubview:contentTitle];
        
        NSString *mContentStr = [NSString stringWithFormat:@"%@%@",@"        ",[Toolkit judgeIsNull:[videoLiveDict valueForKey:@"Content"]]];
        CGFloat contentHeight = [Toolkit heightWithString:mContentStr fontSize:14 width:self.view.frame.size.width-64]+15;
        UITextView *contentTv = [[UITextView alloc] initWithFrame:CGRectMake(14, contentTitle.frame.origin.y + contentTitle.frame.size.height, self.view.frame.size.width - 28, contentHeight)];
        contentTv.editable = NO;
        contentTv.scrollEnabled = NO;
        contentTv.font = [UIFont systemFontOfSize:14];
        contentTv.backgroundColor = ItemsBaseColor;
        contentTv.textColor = [UIColor whiteColor];
        contentTv.text = mContentStr;
        [cell addSubview:contentTv];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 200;
    }else if (indexPath.section == 1){
        return 45;
    }else{
        NSString *mContentStr = [NSString stringWithFormat:@"%@%@",@"        ",[Toolkit judgeIsNull:[videoLiveDict valueForKey:@"Content"]]];
        CGFloat contentHeight = [Toolkit heightWithString:mContentStr fontSize:14 width:self.view.frame.size.width-64]+15;
        return 10 + 21 + 5 + contentHeight + 10;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
