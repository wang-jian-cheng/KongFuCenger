//
//  WYNewsViewController.m
//  KongFuCenter
//
//  Created by Rain on 15/12/12.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "WYNewsViewController.h"
#import "YMTableViewCell.h"
#import "ContantHead.h"
#import "YMShowImageView.h"
#import "YMTextData.h"
#import "YMReplyInputView.h"
#import "WFReplyBody.h"
#import "WFMessageBody.h"
#import "WFPopView.h"
#import "WFActionSheet.h"
#import "MyNewsViewController.h"
#import "SendNewsViewController.h"
#import "WechatShortVideoController.h"
#import "SendVideoViewController.h"
#import "ceshiViewController.h"

#define dataCount 10
#define kLocationToBottom 20
//#define kAdmin @"小虎-tiger"

#define sendNews  (2015+1)
#define smallVideo  (2015+2)

@interface WYNewsViewController ()<UITableViewDataSource,UITableViewDelegate,cellDelegate,InputDelegate,UIActionSheetDelegate,WechatShortVideoDelegate>
{
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
    NSArray *wyArray;
    int selectRow;
    NSString *kAdmin;
    BOOL isComment;
    
}

@property (nonatomic,strong) WFPopView *operationView;
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;

@end

@implementation WYNewsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    [self setBarTitle:@"武友动态"];
    [self addLeftButton:@"left"];
    [self addRightButton:@"moreNoword"];
    
    userDefault = [NSUserDefaults standardUserDefaults];
    dataProvider = [[DataProvider alloc] init];
    _tableDataSource = [[NSMutableArray alloc] init];
    _contentDataSource = [[NSMutableArray alloc] init];
    wyArray = [[NSArray alloc] init];
    _replyIndex = -1;//代表是直接评论
    kAdmin = [userDefault valueForKey:@"NicName"];
    
    //[self configData];
    //[self initTableview];
    //[self loadTextData];
    
    [self initData];
}

-(void)initData{
    [SVProgressHUD showWithStatus:@"加载中"];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getWYNewsCallBack:"];
    [dataProvider GetDongtaiPageByFriends:[userDefault valueForKey:@"id"] andstartRowIndex:@"0" andmaximumRows:@"10"];
}

-(void)getWYNewsCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        DLog(@"%@",dict);
        wyArray = dict[@"data"];
        for(NSDictionary *itemDict in dict[@"data"]){
            WFMessageBody *messBody = [[WFMessageBody alloc] init];
            messBody.posterContent = [itemDict valueForKey:@"Content"];
            NSArray *picArray =[itemDict valueForKey:@"PicList"];
            NSMutableArray *imgArray = [[NSMutableArray alloc] init];
            for (int i = 0; i < picArray.count; i++) {
                //[imgArray addObject:[NSString stringWithFormat:@"%@%@",Url,[picArray[i] valueForKey:@"ImagePath"]]];
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
            messBody.posterImgstr = url;//@"mao.jpg";
            messBody.posterName = [itemDict valueForKey:@"NicName"];
            messBody.posterIntro = @"";
            messBody.posterFavour = [[NSMutableArray alloc] init];//[NSMutableArray arrayWithObjects:@"路人甲",@"希尔瓦娜斯",kAdmin,@"鹿盔", nil];
            messBody.isFavour = [[NSString stringWithFormat:@"%@",[itemDict valueForKey:@"IsLike"]] isEqual:@"0"]?NO:YES;
            messBody.zanNum = [[itemDict valueForKey:@"LikeNum"] intValue];
            
            NSMutableArray *videoArray = [[NSMutableArray alloc] init];
            [videoArray addObject:[itemDict valueForKey:@"VideoDuration"]];
            [videoArray addObject:[itemDict valueForKey:@"VideoPath"]];
            messBody.posterPostVideo = videoArray;
            
            [_contentDataSource addObject:messBody];
        }
        
        [self initTableview];
        
        [self loadTextData];
        
        [SVProgressHUD dismiss];
        
    }
}

- (void)finishWechatShortVideoCapture:(NSURL *)filePath {
    NSLog(@"filePath is %@", filePath);
    SendVideoViewController *sendVideoVC = [[SendVideoViewController alloc] init];
    sendVideoVC.VideoFilePath=filePath;
    [self.navigationController pushViewController:sendVideoVC animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

-(void)clickRightButton:(UIButton *)sender
{
    if(moreSettingBackView.hidden == YES)
    {
        moreSettingBackView.hidden = NO;
        [self positionShowView:moreSettingBackView];
    }
    else
    {
        
        [self positionDismissView:moreSettingBackView];
    }
}

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




- (void)backToPre{
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void) initTableview{
    
    mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    mainTable.backgroundColor = [UIColor clearColor];
    // mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTable.delegate = self;
    mainTable.dataSource = self;
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
    
}

-(void)btnClick:(UIButton *)sender
{
    if(sender.tag == sendNews)
    {
        //SendNewsViewController *sendNewsVC = [[SendNewsViewController alloc] init];
        //[self.navigationController pushViewController:sendNewsVC animated:YES];
        
        ceshiViewController *ceshiVC = [[ceshiViewController alloc] init];
        [self.navigationController pushViewController:ceshiVC animated:YES];
    }
    else  if(sender.tag == smallVideo)
    {
        WechatShortVideoController *wechatShortVideoController = [[WechatShortVideoController alloc] init];
        
        wechatShortVideoController.delegate = self;
        
        [self presentViewController:wechatShortVideoController animated:YES completion:^{}];
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
    return TableHeader + kLocationToBottom + ym.replyHeight + ym.showImageHeight  + kDistance + (ym.islessLimit?0:30) + (unfold?ym.shuoshuoHeight:ym.unFoldShuoHeight) + kReplyBtnDistance + ym.favourHeight + (ym.favourHeight == 0?0:kReply_FavourDistance) + ([ym.showVideoArray[0] isEqual:@""]?0:80);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"ILTableViewCell";
    
    YMTableViewCell *cell = (YMTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[YMTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = ItemsBaseColor;
    }
    cell.stamp = indexPath.row;
    //cell.replyBtn.appendIndexPath = indexPath;
    //[cell.replyBtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.CommentBtn.tag = indexPath.row;
    [cell.CommentBtn addTarget:self action:@selector(commentEvent:) forControlEvents:UIControlEventTouchUpInside];
    cell.CommentBtnHF.tag = indexPath.row;
    [cell.CommentBtnHF addTarget:self action:@selector(commentEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *PublishTime = [wyArray[indexPath.row] valueForKey:@"PublishTime"];
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
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:indexPath.row];
    WFMessageBody *m = ymData.messageBody;
    if (m.isFavour == YES) {//此时该取消赞
        [cell.zanBtn setImage:[UIImage imageNamed:@"wyzan"] forState:UIControlStateNormal];
    }else{
        [cell.zanBtn setImage:[UIImage imageNamed:@"wyzan_no"] forState:UIControlStateNormal];
    }
    cell.zanNum.text = [NSString stringWithFormat:@"%d",m.zanNum];//[NSString stringWithFormat:@"%@",[wyArray[indexPath.row] valueForKey:@"LikeNum"]];
    cell.delegate = self;
    [cell setYMViewWith:[_tableDataSource objectAtIndex:indexPath.row]];
    cell.userNameLbl.frame = CGRectMake(20 + TableHeader + 20, (TableHeader - TableHeader / 2) / 2, screenWidth - 120, TableHeader/2);
    
    return cell;
}

-(void)tapPhotoImg{
    MyNewsViewController *myNewsVC = [[MyNewsViewController alloc] init];
    [self.navigationController pushViewController:myNewsVC animated:YES];
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
        [dataProvider voicedelete:[wyArray[sender.tag] valueForKey:@"Id"] andUserId:[userDefault valueForKey:@"id"] andFlg:@"2"];
    }else{
        dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"zanCallBack:"];
        [dataProvider voiceAction:[wyArray[sender.tag] valueForKey:@"Id"] andUserId:[userDefault valueForKey:@"id"] andFlg:@"2"];
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
    if (isComment) {
        dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"mainCommentCallBack:"];
        [dataProvider MessageComment:[wyArray[selectRow] valueForKey:@"Id"] anduserid:[userDefault valueForKey:@"id"] andcomment:((UITextView *)sender).text];
    }else{
        dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"mainCommentCallBack:"];
        [dataProvider CommentComment:[[wyArray[selectRow] valueForKey:@"ComList"][_replyIndex] valueForKey:@"Id"] anduserid:[userDefault valueForKey:@"id"] andcomment:((UITextView *)sender).text];

    }
}

-(void)mainCommentCallBack:(id)dict{
    NSLog(@"%@",dict);
    if ([dict[@"code"] intValue] == 200) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateComment" object:nil];//ios7 多次调用会导致崩溃
    [replyView updateComment];
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
    UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60 , 0, 50, 50)];
    NSString *photoPath = [userDefault valueForKey:@"PhotoPath"];
    NSString *url = [NSString stringWithFormat:@"%@%@",Url,photoPath];
    headImg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPhotoImg)];
    [headImg setUserInteractionEnabled:YES];
    [headImg addGestureRecognizer:tapGesture];
    
    [headImgView addSubview:headImg];
    UILabel *name_lbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - headImg.frame.size.width - 10 - 120 - 5, (headImg.frame.size.height - 21) / 2, 120, 21)];
    name_lbl.textColor = [UIColor whiteColor];
    name_lbl.textAlignment = NSTextAlignmentRight;
    name_lbl.text = [userDefault valueForKey:@"NicName"];//@"成龙";
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
        [m.posterReplies insertObject:body atIndex:0];
        ymData.messageBody = m;
        
    }else{
        
        ymData = (YMTextData *)[_tableDataSource objectAtIndex:inputTag];
        WFMessageBody *m = ymData.messageBody;
        
        WFReplyBody *body = [[WFReplyBody alloc] init];
        body.replyUser = kAdmin;
        body.repliedUser = [(WFReplyBody *)[m.posterReplies objectAtIndex:_replyIndex] replyUser];
        body.replyInfo = replyText;
        
        //[m.posterReplies addObject:body];
        [m.posterReplies insertObject:body atIndex:0];
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

- (void)dealloc{
    
    NSLog(@"销毁");
    
}

@end
