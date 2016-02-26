//
//  WYNewsViewController.m
//  KongFuCenter
//
//  Created by Rain on 15/12/12.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "MyNewsViewController.h"
#import "YMTableViewCell.h"
#import "ContantHead.h"
#import "YMShowImageView.h"
#import "YMTextData.h"
#import "YMReplyInputView.h"
#import "WFReplyBody.h"
#import "WFMessageBody.h"
#import "WFPopView.h"
#import "WFActionSheet.h"
#import "PlayVideoViewController.h"
#import "MJRefresh.h"
#import "UserHeadView.h"
#import "CommentListViewController.h"
#import "OneShuoshuoViewController.h"
#import "PlayVideoView.h"

#define dataCount 10
#define kLocationToBottom 20
//#define kAdmin @"小虎-tiger"

#define sendNews  (2015+1)
#define smallVideo  (2015+2)

@interface MyNewsViewController ()<UITableViewDataSource,UITableViewDelegate,cellDelegate,InputDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    
    UserHeadView *headImg;
    
    NSMutableArray *_imageDataSource;
    
    NSMutableArray *_contentDataSource;//模拟接口给的数据
    
    NSMutableArray *_tableDataSource;//tableview数据源
    
    NSMutableArray *_shuoshuoDatasSource;//说说数据源
    
    UITableView *mainTable;
    
    UIView *popView;
    
    YMReplyInputView *replyView ;
    
    NSInteger _replyIndex;
    
    UIView *moreSettingBackView;
    
    
    //通用
    NSUserDefaults *userDefault;
    DataProvider *dataProvider;
    
    //数据
    int selectRow;
    NSString *kAdmin;
    BOOL isComment;
    int curpage;//页数
    int sumpage;
    
    
    NSString *userPhotoPath;
    NSString *_userName;
    
    NSString *delDTId;
}

@property (nonatomic,strong) WFPopView *operationView;
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;

@end

@implementation MyNewsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    //[self setBarTitle:@"个人动态"];
    [self addLeftButton:@"left"];
    if([self.UserID isEqualToString:[Toolkit getUserID]])
    {
        [self addRightbuttontitle:@"评论回复"];
    }
    userDefault = [NSUserDefaults standardUserDefaults];
    dataProvider = [[DataProvider alloc] init];
    _tableDataSource = [[NSMutableArray alloc] init];
    _contentDataSource = [[NSMutableArray alloc] init];
    _replyIndex = -1;//代表是直接评论
    kAdmin = [userDefault valueForKey:@"NicName"];
    
    //[self configData];
    [self getUserInfoById];
    [self initTableview];
    //[self loadTextData];
    
    //[self initData];
}

-(void)getUserInfoById{
    DataProvider *dataUserInfo = [[DataProvider alloc] init];
    [dataUserInfo setDelegateObject:self setBackFunctionName:@"getUserInfoCallBack:"];
    [dataUserInfo getUserInfo:_UserID];
}

-(void)getUserInfoCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        NSLog(@"%@",dict);
        userPhotoPath = [Toolkit judgeIsNull:[dict[@"data"] valueForKey:@"PhotoPath"]];
        _userName = [Toolkit judgeIsNull:[dict[@"data"] valueForKey:@"NicName"]];
        if (name_lbl && headImg) {
            name_lbl.text = _userName;
            NSString *url = [NSString stringWithFormat:@"%@%@",Url,userPhotoPath];
            [headImg.headImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"me"]];
        }
    }
}

-(void)setUserID:(NSString *)UserID
{
    _UserID = [NSString stringWithFormat:@"%@",UserID];
}

-(void)TeamTopRefresh{
    curpage = 0;
    [SVProgressHUD showWithStatus:@"加载中..."];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getMyNewsCallBack:"];
    //[dataProvider GetDongtaiPageByFriends:self.UserID andstartRowIndex:@"0" andmaximumRows:@"10"];
    [dataProvider SelectDongtaiByFriendId:self.UserID andstartRowIndex:@"0" andmaximumRows:@"5"];
}

-(void)getMyNewsCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        if(_contentDataSource != nil || _contentDataSource.count>0){
            [_contentDataSource removeAllObjects];
        }
        
        if(_tableDataSource != nil || _tableDataSource.count>0){
            [_tableDataSource removeAllObjects];
        }
        DLog(@"%@",dict);
        sumpage = [dict[@"recordcount"] intValue];
        for(NSDictionary *itemDict in dict[@"data"]){
            WFMessageBody *messBody = [[WFMessageBody alloc] init];
            NSString *isRepeat = [Toolkit judgeIsNull:[itemDict valueForKey:@"IsRepeat"]];
            if ([isRepeat isEqual:@"1"]) {
                messBody.posterContent =  ZY_NSStringFromFormat(@"%@\n//转发:%@",[Toolkit judgeIsNull:[itemDict valueForKey:@"Description"]],[Toolkit judgeIsNull:[itemDict valueForKey:@"Content"]]);
            }else{
                messBody.posterContent = [itemDict valueForKey:@"Content"];
            }
            NSArray *picArray =[itemDict valueForKey:@"PicList"];
            NSMutableArray *imgArray = [[NSMutableArray alloc] init];
            for (int i = 0; i < picArray.count; i++) {
                [imgArray addObject:[NSString stringWithFormat:@"%@%@",Url,[picArray[i] valueForKey:@"ImagePath"]]];
            }
            messBody.posterPostImage = imgArray;
            NSArray *ComArray =[itemDict valueForKey:@"ComList"];
            if (ComArray.count == 0) {
                WFReplyBody *body = [[WFReplyBody alloc] init];
                body.replyUser = @"";
                body.repliedUser = @"";
                body.replyInfo = @"";
                messBody.posterReplies = [[NSMutableArray alloc] init];
            }else{
                NSMutableArray *commentArray = [[NSMutableArray alloc] init];;
                for (int i = 0; i < ComArray.count; i++) {
                    WFReplyBody *body = [[WFReplyBody alloc] init];
                    body.cID = [ComArray[i] valueForKey:@"Id"];
                    body.replyUser = [ComArray[i] valueForKey:@"NicName"];
                    body.repliedUser = [[NSString stringWithFormat:@"%@",[ComArray[i] valueForKey:@"ParentId"]] isEqual:@"0"]?@"":[ComArray[i] valueForKey:@"CommentedNicName"];
                    body.replyInfo = [ComArray[i] valueForKey:@"Content"];
                    [commentArray addObject:body];
                }
                messBody.posterReplies = commentArray;
            }
            NSString *PhotoPath = [itemDict valueForKey:@"PhotoPath"];
            //userPhotoPath = PhotoPath;
            NSString *url = [NSString stringWithFormat:@"%@%@",Url,PhotoPath];
            
            messBody.mID = [itemDict valueForKey:@"Id"];
            messBody.userID = [itemDict valueForKey:@"UserId"];
            messBody.posterImgstr = url;//@"mao.jpg";
            messBody.posterName = [itemDict valueForKey:@"NicName"];
            messBody.isRepeat = [Toolkit judgeIsNull:[itemDict valueForKey:@"IsRepeat"]];
            //_userName =messBody.posterName;
            //name_lbl.text = _userName;
            messBody.posterIntro = @"";
            messBody.posterFavour = [[NSMutableArray alloc] init];//[NSMutableArray arrayWithObjects:@"路人甲",@"希尔瓦娜斯",kAdmin,@"鹿盔", nil];
            messBody.isFavour = [[NSString stringWithFormat:@"%@",[itemDict valueForKey:@"IsLike"]] isEqual:@"0"]?NO:YES;
            messBody.zanNum = [[itemDict valueForKey:@"LikeNum"] intValue];
            
            messBody.sendTime = [NSString stringWithFormat:@"%@",[itemDict valueForKey:@"PublishTime"]];
            
            NSMutableArray *videoArray = [[NSMutableArray alloc] init];
            [videoArray addObject:[NSString stringWithFormat:@"%@%@",Url,[itemDict valueForKey:@"ImagePath"]]];
            [videoArray addObject:[itemDict valueForKey:@"VideoPath"]];
            [videoArray addObject:[itemDict valueForKey:@"VideoDuration"]];
            messBody.posterPostVideo = videoArray;
            
            [_contentDataSource addObject:messBody];
        }
        
        //[self initTableview];
        
        if (_contentDataSource.count == 0) {
            [self dataEmptyTip];
        }
        
        [self loadTextData];
        
        [mainTable reloadData];
        
        [SVProgressHUD dismiss];
        
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

//-(void)clickRightButton:(UIButton *)sender
//{
//    if(moreSettingBackView.hidden == YES)
//    {
//        moreSettingBackView.hidden = NO;
//        [self positionShowView:moreSettingBackView];
//    }
//    else
//    {
//        
//        [self positionDismissView:moreSettingBackView];
//    }
//}

#pragma mark -加载数据
- (void)loadTextData{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray * ymDataArray =[[NSMutableArray alloc]init];
        
        for (int i = 0 ; i < _contentDataSource.count; i ++) {
            
            WFMessageBody *messBody = [_contentDataSource objectAtIndex:i];
            
            YMTextData *ymData = [[YMTextData alloc] init ];
            ymData.messageBody = messBody;
            
            [ymDataArray addObject:ymData];
            
        }
        [self calculateHeight:ymDataArray];
        
    });
}



#pragma mark - 计算高度
- (void)calculateHeight:(NSMutableArray *)dataArray{
    
    
    NSDate* tmpStartData = [NSDate date];
    
    for (YMTextData *ymData in dataArray) {
        
        ymData.shuoshuoHeight = [ymData calculateShuoshuoHeightWithWidth:self.view.frame.size.width withUnFoldState:NO];//折叠
        
        ymData.unFoldShuoHeight = [ymData calculateShuoshuoHeightWithWidth:self.view.frame.size.width withUnFoldState:YES];//展开
        
        ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
        
        ymData.favourHeight = [ymData calculateFavourHeightWithWidth:self.view.frame.size.width];
        
        [_tableDataSource addObject:ymData];
        
    }
    
    
    double deltaTime = [[NSDate date] timeIntervalSinceDate:tmpStartData];
    NSLog(@"cost time = %f", deltaTime);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [mainTable reloadData];
        
    });
    
    
}

-(void)dataEmptyTip{
    UILabel *tipLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, SCREEN_HEIGHT - 10)];
    tipLbl.textAlignment = NSTextAlignmentCenter;
    tipLbl.textColor = [UIColor whiteColor];
    tipLbl.text = @"还没留下任何动态";
    [self.view addSubview:tipLbl];
}


- (void)backToPre{
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void) initTableview{
    
    mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    mainTable.backgroundColor = [UIColor clearColor];
    // mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTable.delegate = self;
    mainTable.dataSource = self;
    mainTable.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:mainTable];
    
    [self initHeadView];
    
    moreSettingBackView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100 -10), Header_Height, 100, 88)];
    moreSettingBackView.backgroundColor = ItemsBaseColor;
    UIButton *newBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, moreSettingBackView.frame.size.width,  moreSettingBackView.frame.size.height/2)];
    [newBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newBtn setTitle:@"发动态" forState:UIControlStateNormal];
    newBtn.tag = sendNews;
    [newBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView2 =[[UIView alloc] initWithFrame:CGRectMake(0, moreSettingBackView.frame.size.height/2, moreSettingBackView.frame.size.width - 2, 1)];
    lineView2.backgroundColor = Separator_Color;
    UIButton *delBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, moreSettingBackView.frame.size.height/2, moreSettingBackView.frame.size.width,  moreSettingBackView.frame.size.height/2)];
    [delBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [delBtn setTitle:@"小视频" forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    delBtn.tag = smallVideo;
    
    
    
    [moreSettingBackView addSubview:newBtn];
    [moreSettingBackView addSubview:delBtn];
    [moreSettingBackView addSubview:lineView2];
    
    [self.view addSubview:moreSettingBackView];
    moreSettingBackView.hidden = YES;
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    __weak typeof(UITableView *) weakTv = mainTable;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    
    mainTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf TeamTopRefresh];
        [weakTv.mj_header endRefreshing];
    }];
    
    // 马上进入刷新状态
    [mainTable.mj_header beginRefreshing];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(TeamFootRefresh)];
    // 禁止自动加载
    footer.automaticallyRefresh = NO;
    // 设置footer
    mainTable.mj_footer = footer;
    
}

-(void)TeamFootRefresh
{
    curpage++;
    if (curpage >= sumpage) {
        [mainTable.mj_footer endRefreshing];
        return;
    }
    dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"FootRefireshBackCall:"];
    [dataProvider SelectDongtaiByFriendId:self.UserID andstartRowIndex:[NSString stringWithFormat:@"%d",curpage * 5] andmaximumRows:@"5"];
}

-(void)FootRefireshBackCall:(id)dict
{
    if(_contentDataSource != nil || _contentDataSource.count>0){
        [_contentDataSource removeAllObjects];
    }
    
    //    if(_tableDataSource != nil || _tableDataSource.count>0){
    //        [_tableDataSource removeAllObjects];
    //    }
    
    NSLog(@"%@",dict);
    // 结束刷新
    [mainTable.mj_footer endRefreshing];
    if ([dict[@"code"] intValue] == 200) {
        NSArray * arrayitem=[[NSArray alloc] init];
        arrayitem=dict[@"data"];
        for(NSDictionary *itemDict in dict[@"data"]){
            WFMessageBody *messBody = [[WFMessageBody alloc] init];
            NSString *isRepeat = [Toolkit judgeIsNull:[itemDict valueForKey:@"IsRepeat"]];
            if ([isRepeat isEqual:@"1"]) {
                messBody.posterContent =  ZY_NSStringFromFormat(@"%@\n//转发:%@",[Toolkit judgeIsNull:[itemDict valueForKey:@"Description"]],[Toolkit judgeIsNull:[itemDict valueForKey:@"Content"]]);
            }else{
                messBody.posterContent = [itemDict valueForKey:@"Content"];
            }
            NSArray *picArray =[itemDict valueForKey:@"PicList"];
            NSMutableArray *imgArray = [[NSMutableArray alloc] init];
            for (int i = 0; i < picArray.count; i++) {
                [imgArray addObject:[NSString stringWithFormat:@"%@%@",Url,[picArray[i] valueForKey:@"ImagePath"]]];
            }
            messBody.posterPostImage = imgArray;
            NSArray *ComArray =[itemDict valueForKey:@"ComList"];
            if (ComArray.count == 0) {
                WFReplyBody *body = [[WFReplyBody alloc] init];
                body.replyUser = @"";
                body.repliedUser = @"";
                body.replyInfo = @"";
                messBody.posterReplies = [[NSMutableArray alloc] init];
            }else{
                NSMutableArray *commentArray = [[NSMutableArray alloc] init];;
                for (int i = 0; i < ComArray.count; i++) {
                    WFReplyBody *body = [[WFReplyBody alloc] init];
                    body.replyUser = [ComArray[i] valueForKey:@"NicName"];
                    body.repliedUser = [[NSString stringWithFormat:@"%@",[ComArray[i] valueForKey:@"ParentId"]] isEqual:@"0"]?@"":[ComArray[i] valueForKey:@"CommentedNicName"];
                    body.replyInfo = [ComArray[i] valueForKey:@"Content"];
                    [commentArray addObject:body];
                }
                messBody.posterReplies = commentArray;
            }
            NSString *PhotoPath = [itemDict valueForKey:@"PhotoPath"];
            NSString *url = [NSString stringWithFormat:@"%@%@",Url,PhotoPath];
            messBody.mID = [itemDict valueForKey:@"Id"];
            messBody.userID = [itemDict valueForKey:@"UserId"];
            messBody.posterImgstr = url;//@"mao.jpg";
            messBody.posterName = [itemDict valueForKey:@"NicName"];
            messBody.isRepeat = [Toolkit judgeIsNull:[itemDict valueForKey:@"IsRepeat"]];
            messBody.posterIntro = @"";
            messBody.posterFavour = [[NSMutableArray alloc] init];//[NSMutableArray arrayWithObjects:@"路人甲",@"希尔瓦娜斯",kAdmin,@"鹿盔", nil];
            messBody.isFavour = [[NSString stringWithFormat:@"%@",[itemDict valueForKey:@"IsLike"]] isEqual:@"0"]?NO:YES;
            messBody.zanNum = [[itemDict valueForKey:@"LikeNum"] intValue];
            
            messBody.sendTime = [NSString stringWithFormat:@"%@",[itemDict valueForKey:@"PublishTime"]];
            
            NSMutableArray *videoArray = [[NSMutableArray alloc] init];
            [videoArray addObject:[NSString stringWithFormat:@"%@%@",Url,[itemDict valueForKey:@"ImagePath"]]];
            [videoArray addObject:[itemDict valueForKey:@"VideoPath"]];
            [videoArray addObject:[itemDict valueForKey:@"VideoDuration"]];
            messBody.posterPostVideo = videoArray;
            
            [_contentDataSource addObject:messBody];
        }
        
        [self loadTextData];
    }
    [mainTable reloadData];
}

-(void)btnClick:(UIButton *)sender
{
    if(sender.tag == sendNews)
    {
        
    }
    else  if(sender.tag == smallVideo)
    {
        
    }
}

#define SHOW_ANIM_KEY   @"showSettingView"
#define DISMISS_ANIM_KEY   @"dismissSettingView"
-(void)positionShowView:(UIView *)tempView
{
    CABasicAnimation *scale=[CABasicAnimation animationWithKeyPath:@"transform"];
    [scale setFromValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 0, 1.0)]];
    [scale setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake((moreSettingBackView.frame.origin.x+moreSettingBackView.frame.size.width/2), Header_Height)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake((moreSettingBackView.frame.origin.x+moreSettingBackView.frame.size.width/2),
                                                              (moreSettingBackView.frame.size.height/2 + moreSettingBackView.frame.origin.y))];
    //动画执行后保持显示状态 但是属性值不会改变 只会保持显示状态
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    
    //    animation.autoreverses = YES;//动画返回
    
    CAAnimationGroup *group=[CAAnimationGroup animation];
    [group setAnimations:[NSArray arrayWithObjects:scale,animation, nil]];
    [group setDuration:0.5];
    //    animation.repeatCount = MAXFLOAT;//重复
    //tempView.layer.delegate = self;
    group.delegate= self;
    [moreSettingBackView.layer addAnimation:group forKey:SHOW_ANIM_KEY];
}

-(void)positionDismissView:(UIView *)tempView
{
    
    
    CABasicAnimation *scale=[CABasicAnimation animationWithKeyPath:@"transform"];
    [scale setFromValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1, 1.0)]];
    [scale setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 0.0, 1.0)]];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake((moreSettingBackView.frame.origin.x+moreSettingBackView.frame.size.width/2),
                                                                (moreSettingBackView.frame.size.height/2 + moreSettingBackView.frame.origin.y))];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake((moreSettingBackView.frame.origin.x+moreSettingBackView.frame.size.width/2),
                                                              Header_Height)];
    //动画执行后保持显示状态 但是属性值不会改变 只会保持显示状态
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    
    //    animation.autoreverses = YES;//动画返回
    
    CAAnimationGroup *group=[CAAnimationGroup animation];
    [group setAnimations:[NSArray arrayWithObjects:scale,animation, nil]];
    [group setDuration:0.5];
    //    animation.repeatCount = MAXFLOAT;//重复
    group.delegate= self;
    [tempView.layer addAnimation:group forKey:DISMISS_ANIM_KEY];
    
    [self performSelector:@selector(viewSetHidden:) withObject:[NSNumber numberWithBool:YES] afterDelay:0.5 - 0.1];
}
-(void)viewSetHidden:(id)info
{
    moreSettingBackView.hidden = YES;
}

//**
// *  ///////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  _tableDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMTextData *ym = [_tableDataSource objectAtIndex:indexPath.row];
    BOOL unfold = ym.foldOrNot;
    NSInteger imageCount = (ym.showImageArray.count/3)+(ym.showImageArray.count%3==0?0:1);
    return TableHeader + kLocationToBottom + ym.replyHeight + (ym.showImageHeight + 30) * imageCount  + kDistance + (ym.islessLimit?0:30) + (unfold?ym.shuoshuoHeight:ym.unFoldShuoHeight) + kReplyBtnDistance + ym.favourHeight + (ym.favourHeight == 0?0:kReply_FavourDistance) + (![self isExitVideo:ym]?30:127);
}

-(BOOL)isExitVideo:(YMTextData *)ymData{
    return ymData.showVideoArray !=nil&&![ymData.showVideoArray[0] isEqual:Url]&&ymData.showVideoArray.count>0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"ILTableViewCell";
    
    YMTableViewCell *cell = (YMTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[YMTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = ItemsBaseColor;
    }
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:indexPath.row];
    WFMessageBody *m = ymData.messageBody;
    cell.stamp = indexPath.row;
    //cell.replyBtn.appendIndexPath = indexPath;
    //[cell.replyBtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.CommentBtn.tag = indexPath.row;
    [cell.CommentBtn addTarget:self action:@selector(commentEvent:) forControlEvents:UIControlEventTouchUpInside];
    cell.CommentBtnHF.tag = indexPath.row;
    [cell.CommentBtnHF addTarget:self action:@selector(commentEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *PublishTime = m.sendTime;//[wyArray[indexPath.row] valueForKey:@"PublishTime"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:PublishTime];
    
    NSString *mChatDateIFlag = [self compareDate:date];
    NSLog(@"%@",mChatDateIFlag);
    if ([mChatDateIFlag isEqual:@"今天"]) {
        [dateFormatter setDateFormat:@"HH:mm"];
        cell.commentDate.text = [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:date]];
    }else if([mChatDateIFlag isEqual:@"昨天"]){
        [dateFormatter setDateFormat:@"HH:mm"];
        cell.commentDate.text = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:date]];
    }else{
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        cell.commentDate.text = [dateFormatter stringFromDate:date];
    }
    //cell.commentDate.text = @"发布时间";//[NSString stringWithFormat:@"%d",(int)indexPath.row];
    
    cell.zanBtn.tag = indexPath.row;
    [cell.zanBtn addTarget:self action:@selector(zanEvent:) forControlEvents:UIControlEventTouchUpInside];
    if (m.isFavour == YES) {//此时该取消赞
        [cell.zanBtn setImage:[UIImage imageNamed:@"wyzan"] forState:UIControlStateNormal];
    }else{
        [cell.zanBtn setImage:[UIImage imageNamed:@"wyzan_no"] forState:UIControlStateNormal];
    }
    cell.zanNum.text = [NSString stringWithFormat:@"%d",m.zanNum];
    
    if([self isExitVideo:ymData]){
        if([m.isRepeat isEqual:@"0"]){
            UITapGestureRecognizer *clickVideoImg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickVideoImgEvent:)];
            cell.videoImg.userInteractionEnabled = YES;
            NSLog(@"%d",(int)indexPath.row);
            [cell.videoImg addGestureRecognizer:clickVideoImg];
            clickVideoImg.view.tag = indexPath.row;
        }else{
            UITapGestureRecognizer *clickVideoImg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpDetailEvent:)];
            cell.videoImg.userInteractionEnabled = YES;
            NSLog(@"%d",(int)indexPath.row);
            [cell.videoImg addGestureRecognizer:clickVideoImg];
            clickVideoImg.view.tag = indexPath.row;
        }
    }
    [cell.delIcon addTarget:self action:@selector(delMyInfoEvent:) forControlEvents:UIControlEventTouchUpInside];
    cell.delegate = self;
    [cell setYMViewWith:[_tableDataSource objectAtIndex:indexPath.row]];
    cell.userNameLbl.frame = CGRectMake(20 + TableHeader + 20, (TableHeader - TableHeader / 2) / 2, screenWidth - 120, TableHeader/2);
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OneShuoshuoViewController *oneShuoshuoVC = [[OneShuoshuoViewController alloc] init];
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:indexPath.row];
    WFMessageBody *m = ymData.messageBody;
    oneShuoshuoVC.shuoshuoID = m.mID;
    [self.navigationController pushViewController:oneShuoshuoVC animated:YES];
}

-(void)clickVideoImgEvent:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIView *views = (UIView*) tap.view;
    NSLog(@"%d",(int)views.tag);
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:views.tag];
    NSString *url = [NSString stringWithFormat:@"%@%@",Url,ymData.showVideoArray[1]];
    url = [url stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    PlayVideoView *playVideoView = [[PlayVideoView alloc] initWithContent:@"" andVideoUrl:url];
    [playVideoView show];
//    PlayVideoViewController *playVideoVC = [[PlayVideoViewController alloc] init];
//    playVideoVC.videoPath = ymData.showVideoArray[1];
//    [self.navigationController pushViewController:playVideoVC animated:YES];
}

-(void)jumpDetailEvent:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIView *views = (UIView*) tap.view;
    NSLog(@"%d",(int)views.tag);
    OneShuoshuoViewController *oneShuoshuoVC = [[OneShuoshuoViewController alloc] init];
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:views.tag];
    WFMessageBody *m = ymData.messageBody;
    oneShuoshuoVC.shuoshuoID = m.mID;
    [self.navigationController pushViewController:oneShuoshuoVC animated:YES];
}

-(void)delMyInfoEvent:(UIButton *)btn{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认删除动态?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    delDTId = [NSString stringWithFormat:@"%d",(int)btn.tag];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [SVProgressHUD showWithStatus:@"删除中..."];
        [dataProvider setDelegateObject:self setBackFunctionName:@"delMyInfoCallBack:"];
        [dataProvider delePlan:delDTId];
    }
}

-(void)delMyInfoCallBack:(id)dict{
    [SVProgressHUD dismiss];
    if ([dict[@"code"] intValue] == 200) {
        [SVProgressHUD showSuccessWithStatus:@"删除成功~"];
        [mainTable.mj_header beginRefreshing];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"删除失败~"];
    }
}

-(NSString *)compareDate:(NSDate *)date{
    
    NSDate * today = [NSDate date];
    NSDate * yesterday = [NSDate dateWithTimeIntervalSinceNow:-86400];
    NSDate * refDate = date;
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * refDateString = [[refDate description] substringToIndex:10];
    
    if ([refDateString isEqualToString:todayString])
    {
        return @"今天";
    } else if ([refDateString isEqualToString:yesterdayString])
    {
        return @"昨天";
    }
    else
    {
        return [self formatDate:date];
    }
}

-(NSString *)formatDate:(NSDate *)date{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //[formatter setDateFormat:@"MM-dd    HH:mm"];
    NSString* str = [formatter stringFromDate:date];
    return str;
    
}

-(void)zanEvent:(UIButton *)sender{
    NSLog(@"%d",(int)sender.tag);
    selectRow = (int)sender.tag;
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:selectRow];
    WFMessageBody *m = ymData.messageBody;
    if (m.isFavour == YES) {//此时该取消赞
        dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"zanCallBack:"];
        [dataProvider voicedelete:m.mID andUserId:[Toolkit getUserID] andFlg:@"2"];
    }else{
        dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"zanCallBack:"];
        [dataProvider voiceAction:m.mID andUserId:[Toolkit getUserID] andFlg:@"2" andDescription:nil];
    }
}

-(void)zanCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:selectRow];
        WFMessageBody *m = ymData.messageBody;
        if (m.isFavour == YES) {//此时该取消赞
            m.isFavour = NO;
            m.zanNum--;
        }else{
            m.isFavour = YES;
            m.zanNum++;
        }
        ymData.messageBody = m;
        //清空属性数组。否则会重复添加
        [ymData.attributedDataFavour removeAllObjects];
        ymData.favourHeight = [ymData calculateFavourHeightWithWidth:self.view.frame.size.width];
        [_tableDataSource replaceObjectAtIndex:selectRow withObject:ymData];
        [mainTable reloadData];
    }
}

-(void)commentEvent:(UIButton *)sender{
    isComment = YES;
    selectRow = (int)sender.tag;
    replyView = [[YMReplyInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, screenWidth,44) andAboveView:self.view];
    replyView.delegate = self;
    replyView.replyTag = sender.tag;//_selectedIndexPath.row;
    [self.view addSubview:replyView];
}

-(void)sendButton:(id)sender{
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:selectRow];
    WFMessageBody *m = ymData.messageBody;
    if (isComment) {
        dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"mainCommentCallBack:"];
        [dataProvider MessageComment:m.mID anduserid:[Toolkit getUserID] andcomment:((UITextView *)sender).text];
    }else{
        dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"mainCommentCallBack:"];
        WFReplyBody *b = [m.posterReplies objectAtIndex:_replyIndex];
        [dataProvider CommentComment:b.cID anduserid:[Toolkit getUserID] andcomment:((UITextView *)sender).text];
    }
}

-(void)mainCommentCallBack:(id)dict{
    NSLog(@"%@",dict);
    if ([dict[@"code"] intValue] == 200) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateComment" object:nil];
        [replyView updateComment];
    }
}

-(void)clickPhotoEvent:(NSString *)userId{
    if ([userId isEqual:[NSString stringWithFormat:@"%@",get_sp(@"id")]]) {
        PersonInfoViewController *personInfoVC = [[PersonInfoViewController alloc] init];
        personInfoVC.navtitle = @"个人资料";
        [self.navigationController pushViewController:personInfoVC animated:YES];
    }else{
        FriendInfoViewController *friendInfoVC = [[FriendInfoViewController alloc] init];
        friendInfoVC.navtitle = @"好友资料";
        friendInfoVC.userID = userId;
        [self.navigationController pushViewController:friendInfoVC animated:YES];
    }
}

////////////////////////////////////////////////////////////////////

#pragma mark - 按钮动画

- (void)replyAction:(YMButton *)sender{
    
    CGRect rectInTableView = [mainTable rectForRowAtIndexPath:sender.appendIndexPath];
    CGFloat origin_Y = rectInTableView.origin.y + sender.frame.origin.y;
    CGRect targetRect = CGRectMake(CGRectGetMinX(sender.frame), origin_Y, CGRectGetWidth(sender.bounds), CGRectGetHeight(sender.bounds));
    if (self.operationView.shouldShowed) {
        [self.operationView dismiss];
        return;
    }
    _selectedIndexPath = sender.appendIndexPath;
    YMTextData *ym = [_tableDataSource objectAtIndex:_selectedIndexPath.row];
    [self.operationView showAtView:mainTable rect:targetRect isFavour:ym.hasFavour];
}

#pragma mark - initHeadView
-(void)initHeadView{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 160)];
    headView.backgroundColor = [UIColor colorWithRed:0.24 green:0.24 blue:0.25 alpha:1];
    mainTable.tableHeaderView = headView;
    
    UIImageView *headBackgroundIv = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,headView.frame.size.height)];
    headBackgroundIv.image = [UIImage imageNamed:@"head_bg"];
    [headView addSubview:headBackgroundIv];
    
    UIView *headImgView = [[UIView alloc] initWithFrame:CGRectMake(0, headView.frame.size.height - 50 - 10, SCREEN_WIDTH, 60)];
    NSString *photoPath =userPhotoPath;
    NSString *url = [NSString stringWithFormat:@"%@%@",Url,photoPath];
    headImg = [[UserHeadView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60 , 0, 50, 50) andUrl:url andNav:self.navigationController];
    headImg.userId = _UserID;
    [headImgView addSubview:headImg];
    name_lbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - headImg.frame.size.width - 10 - 120 - 5, (headImg.frame.size.height - 21) / 2, 120, 21)];
    name_lbl.textColor = [UIColor whiteColor];
    name_lbl.textAlignment = NSTextAlignmentRight;
    name_lbl.text = _userName;//[userDefault valueForKey:@"NicName"];//@"成龙";
    name_lbl.font = [UIFont systemFontOfSize:15];
    [headImgView addSubview:name_lbl];
    //    UILabel *id_lbl = [[UILabel alloc] initWithFrame:CGRectMake(headImg.frame.origin.x + headImg.frame.size.width+ 2, name_lbl.frame.origin.y + name_lbl.frame.size.height / 2 +10, 100, 21)];
    //    id_lbl.textColor = [UIColor whiteColor];
    //    id_lbl.text = @"ID:123456789";
    //    id_lbl.font = [UIFont systemFontOfSize:13];
    //    [headImgView addSubview:id_lbl];
    [headView addSubview:headImgView];
    
}

- (WFPopView *)operationView {
    if (!_operationView) {
        _operationView = [WFPopView initailzerWFOperationView];
        WS(ws);
        _operationView.didSelectedOperationCompletion = ^(WFOperationType operationType) {
            switch (operationType) {
                case WFOperationTypeLike:
                    
                    [ws addLike];
                    break;
                case WFOperationTypeReply:
                    [ws replyMessage: nil];
                    break;
                default:
                    break;
            }
        };
    }
    return _operationView;
}

#pragma mark - 赞
- (void)addLike{
    
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:_selectedIndexPath.row];
    WFMessageBody *m = ymData.messageBody;
    if (m.isFavour == YES) {//此时该取消赞
        [m.posterFavour removeObject:kAdmin];
        m.isFavour = NO;
    }else{
        [m.posterFavour addObject:kAdmin];
        m.isFavour = YES;
    }
    ymData.messageBody = m;
    
    
    //清空属性数组。否则会重复添加
    
    [ymData.attributedDataFavour removeAllObjects];
    
    
    ymData.favourHeight = [ymData calculateFavourHeightWithWidth:self.view.frame.size.width];
    [_tableDataSource replaceObjectAtIndex:_selectedIndexPath.row withObject:ymData];
    
    [mainTable reloadData];
    
}


#pragma mark - 真の评论
- (void)replyMessage:(YMButton *)sender{
    
    if (replyView) {
        return;
    }
    replyView = [[YMReplyInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, screenWidth,44) andAboveView:self.view];
    replyView.delegate = self;
    replyView.replyTag = _selectedIndexPath.row;
    [self.view addSubview:replyView];
    
}


#pragma mark -移除评论按钮
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.operationView dismiss];
    
}


#pragma mark -cellDelegate
- (void)changeFoldState:(YMTextData *)ymD onCellRow:(NSInteger)cellStamp{
    
    [_tableDataSource replaceObjectAtIndex:cellStamp withObject:ymD];
    [mainTable reloadData];
    
}

#pragma mark - 图片点击事件回调
- (void)showImageViewWithImageViews:(NSArray *)imageViews byClickWhich:(NSInteger)clickTag{
    
    UIView *maskview = [[UIView alloc] initWithFrame:self.view.bounds];
    maskview.backgroundColor = [UIColor blackColor];
    [self.view addSubview:maskview];
    
    YMShowImageView *ymImageV = [[YMShowImageView alloc] initWithFrame:self.view.bounds byClick:clickTag appendArray:imageViews];
    [ymImageV show:maskview didFinish:^(){
        
        [UIView animateWithDuration:0.5f animations:^{
            
            ymImageV.alpha = 0.0f;
            maskview.alpha = 0.0f;
            
        } completion:^(BOOL finished) {
            
            [ymImageV removeFromSuperview];
            [maskview removeFromSuperview];
        }];
        
    }];
    
}

#pragma mark - 长按评论整块区域的回调
- (void)longClickRichText:(NSInteger)index replyIndex:(NSInteger)replyIndex{
    
    [self.operationView dismiss];
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:index];
    WFReplyBody *b = [ymData.messageBody.posterReplies objectAtIndex:replyIndex];
    
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = b.replyInfo;
    
}

#pragma mark - 点评论整块区域的回调
- (void)clickRichText:(NSInteger)index replyIndex:(NSInteger)replyIndex{
    isComment = NO;
    [self.operationView dismiss];
    
    selectRow = (int)index;
    _replyIndex = replyIndex;
    
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:index];
    WFReplyBody *b = [ymData.messageBody.posterReplies objectAtIndex:replyIndex];
    if ([b.replyUser isEqualToString:kAdmin]) {
        WFActionSheet *actionSheet = [[WFActionSheet alloc] initWithTitle:@"删除评论？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
        actionSheet.actionIndex = index;
        [actionSheet showInView:self.view];
        
        
        
    }else{
        //回复
        if (replyView) {
            return;
        }
        
        replyView = [[YMReplyInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, screenWidth,44) andAboveView:self.view];
        replyView.delegate = self;
        replyView.lblPlaceholder.text = [NSString stringWithFormat:@"回复%@:",b.replyUser];
        replyView.replyTag = index;
        [self.view addSubview:replyView];
    }
}

#pragma mark - 评论说说回调
- (void)YMReplyInputWithReply:(NSString *)replyText appendTag:(NSInteger)inputTag{
    
    YMTextData *ymData = nil;
    if (_replyIndex == -1) {
        
        WFReplyBody *body = [[WFReplyBody alloc] init];
        body.replyUser = kAdmin;
        body.repliedUser = @"";
        body.replyInfo = replyText;
        
        ymData = (YMTextData *)[_tableDataSource objectAtIndex:inputTag];
        WFMessageBody *m = ymData.messageBody;
        //[m.posterReplies addObject:body];
        [m.posterReplies insertObject:body atIndex:m.posterReplies.count == 0?0:m.posterReplies.count];
        ymData.messageBody = m;
        
    }else{
        
        ymData = (YMTextData *)[_tableDataSource objectAtIndex:inputTag];
        WFMessageBody *m = ymData.messageBody;
        
        WFReplyBody *body = [[WFReplyBody alloc] init];
        body.replyUser = kAdmin;
        body.repliedUser = [(WFReplyBody *)[m.posterReplies objectAtIndex:_replyIndex] replyUser];
        body.replyInfo = replyText;
        
        //[m.posterReplies addObject:body];
        [m.posterReplies insertObject:body atIndex:_replyIndex + 1];
        ymData.messageBody = m;
        
    }
    
    
    
    //清空属性数组。否则会重复添加
    [ymData.completionReplySource removeAllObjects];
    [ymData.attributedDataReply removeAllObjects];
    
    
    ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
    [_tableDataSource replaceObjectAtIndex:inputTag withObject:ymData];
    
    [mainTable reloadData];
    
}

- (void)destorySelf{
    
    //  NSLog(@"dealloc reply");
    [replyView removeFromSuperview];
    replyView = nil;
    _replyIndex = -1;
    
}

- (void)actionSheet:(WFActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //delete
        YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:actionSheet.actionIndex];
        WFMessageBody *m = ymData.messageBody;
        [m.posterReplies removeObjectAtIndex:_replyIndex];
        ymData.messageBody = m;
        [ymData.completionReplySource removeAllObjects];
        [ymData.attributedDataReply removeAllObjects];
        
        
        ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
        [_tableDataSource replaceObjectAtIndex:actionSheet.actionIndex withObject:ymData];
        
        [mainTable reloadData];
        
    }else{
        
    }
    _replyIndex = -1;
}

-(void)clickRightButton:(UIButton *)sender{
    CommentListViewController *commentListVC = [[CommentListViewController alloc] init];
    [self.navigationController pushViewController:commentListVC animated:YES];
}

- (void)dealloc{
    
    NSLog(@"销毁");
    
}

@end
