//
//  TeamNewsViewController.m
//  KongFuCenter
//
//  Created by Rain on 15/12/12.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "TeamNewsViewController.h"
#import "YMTableViewCell.h"
#import "ContantHead.h"
#import "YMShowImageView.h"
#import "YMTextData.h"
#import "YMReplyInputView.h"
#import "WFReplyBody.h"
#import "WFMessageBody.h"
#import "WFPopView.h"
#import "WFActionSheet.h"
#import "Member-ViewController.h"
#import "IntroduceViewController.h"
#import "AnnouncementViewController.h"
#import "TeamManagerViewController.h"


#define TeamNewsKey @"TeamNews"


#define dataCount 10
#define kLocationToBottom 20
#define kAdmin get_sp(@"NicName")//@"小虎-tiger"

#define sendNews  (2015+1)
#define smallVideo  (2015+2)

@interface TeamNewsViewController ()<UITableViewDataSource,UITableViewDelegate,cellDelegate,InputDelegate,UIActionSheetDelegate>
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
    
    NSInteger actionIndex;
    
    NSMutableDictionary *commentDict;//根据评论内容获取id的字典
    
    NSMutableArray *cacheArr;
    NSMutableArray *commentArr;//根据评论位置保存和获取id
    NSString *delCommmentId;
    NSString *commentSection;
    
    
}

@property (nonatomic,strong) WFPopView *operationView;
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;

@end

@implementation TeamNewsViewController



- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
    NSString *str = kAdmin;
    
    NSLog(@"%@",str);
    userDefault = [NSUserDefaults standardUserDefaults];
    [self setBarTitle:@"战队动态"];
    [self addLeftButton:@"left"];
    
    if(self.teamId==nil || [self.teamId isEqualToString:get_sp(@"TeamId")])
    {
            [self addRightButton:@"moreNoword"];
    }
    pageSize = 5;
    wyArray = [NSMutableArray array];
    commentArr = [NSMutableArray array];
    _tableDataSource = [[NSMutableArray alloc] init];
    _contentDataSource = [[NSMutableArray alloc] init];
    cacheArr = [NSMutableArray array];
    _replyIndex = -1;//代表是直接评论

    [self initTableview];
    
    
//
//    
//    NSLog(@"read-plist:%@",[Toolkit ReadPlist:NewsCaChePlist ForKey:TeamNewsKey]);
    
    
}
- (void) initTableview{
    
    mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    mainTable.backgroundColor = [UIColor clearColor];
    // mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTable.delegate = self;
    mainTable.dataSource = self;
    mainTable.tableFooterView = [[UIView alloc] init];
    
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    mainTable.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageNo=0;
        [wyArray removeAllObjects];
        if(_tableDataSource != nil && _tableDataSource.count > 0)
            [_tableDataSource removeAllObjects];
        
        if(cacheArr != nil && cacheArr.count > 0)
            [cacheArr removeAllObjects];
        
        [mainTable.mj_footer setState:MJRefreshStateIdle];
        [weakSelf getTeamNews];
        // 结束刷新
        
    }];
    
    
    // 上拉刷新
//    mainTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        
//        [weakSelf FooterRefresh];
//        [mainTable.mj_footer endRefreshing];
//    }];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(FooterRefresh)];
    
    // 禁止自动加载
    footer.automaticallyRefresh = NO;
    
    // 设置footer
    mainTable.mj_footer = footer;
    
  //  mainTable.mj_footer.automaticallyRefresh = NO;
    
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




-(void)viewWillAppear:(BOOL)animated{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];

    
    NSArray *cacheData = [Toolkit ReadPlist:NewsCaChePlist ForKey:TeamNewsKey];
    DLog(@"%@",cacheData);
    if(cacheData != nil||cacheData.count>0 )
    {
        if(wyArray !=nil)
        {
            [wyArray removeAllObjects];
            [wyArray addObjectsFromArray:cacheData];
        }
        else
        {
            wyArray = [NSMutableArray array];
            [wyArray addObjectsFromArray:cacheData];
        }
        
        
        
        if(cacheArr !=nil)
        {
            [cacheArr removeAllObjects];
            [cacheArr addObjectsFromArray:cacheData];
        }
        else
        {
            cacheArr = [NSMutableArray array];
            [cacheArr addObjectsFromArray:cacheData];
        }
        
        
        [self configData:cacheData];
        [self loadTextData];
        
        pageNo = (int)cacheData.count/5;
    }
    else
    {
        [mainTable.mj_header beginRefreshing];
    }
}

-(void)clickRightButton:(UIButton *)sender
{
//    if(moreSettingBackView.hidden == YES)
//    {
//        moreSettingBackView.hidden = NO;
//        [self positionShowView:moreSettingBackView];
//    }
//    else
//    {
//        [self positionDismissView:moreSettingBackView];
//    }
    TeamManagerViewController * teamManagerVC=[[TeamManagerViewController alloc] initWithNibName:@"TeamManagerViewController" bundle:[NSBundle mainBundle]];
    
    [self.navigationController pushViewController:teamManagerVC animated:YES];
}

#pragma mark - self data source

- (void)configData:(NSArray *)dongtaiArr
{
    
    if(dongtaiArr== nil || dongtaiArr.count == 0)
        return;
    
    @try {
        for (int i = 0; i< dongtaiArr.count; i++) {
            
            NSDictionary *tempDict = dongtaiArr[i];
            NSMutableArray *comlist = [NSMutableArray array];
            [comlist addObjectsFromArray:tempDict[@"ComList"]];
            NSMutableArray *comlistFromShow = [NSMutableArray array];
            NSMutableArray *comListFroDel = [NSMutableArray array];
            [comListFroDel addObject:@"zhanwei"];//加一个占位让每个动态都有数据和index对应
            for (int j =0; j<comlist.count; j++) {
                
                NSDictionary *tempDict = comlist[j];
                WFReplyBody *body1 = [[WFReplyBody alloc] init];
                body1.replyUser = tempDict[@"NicName"];
                
                body1.repliedUser =[[NSString stringWithFormat:@"%@",[tempDict valueForKey:@"ParentId"]] isEqual:@"0"]?@"":[tempDict valueForKey:@"CommentedNicName"];
                //                if(![tempDict[@"CommentedNicName"] isEqualToString:@""])
                //                {
                //                    body1.repliedUser = tempDict[@"CommentedNicName"];
                //                }
                body1.replyInfo = tempDict[@"Content"];
                body1.replyDict = [[NSDictionary alloc] initWithDictionary:tempDict];
                [comlistFromShow addObject:body1];
                [comListFroDel addObject:tempDict[@"Id"]];
                
                
                
                
                //                NSDictionary *tempCommentDict = @{@"CommenterId":tempDict[@"CommenterId"],/*评论人id*/
                //                                                  @"MessageId":tempDict[@"MessageId"],/*动态id*/
                //                                                  @"commentId":tempDict[@"Id"]/*评论id*/};
                //                [commentDict setObject:tempCommentDict forKey:tempDict[@"Content"]];
            }
            
            
            [commentArr addObject:comListFroDel];//添加每个动态的评论
            
            
            WFMessageBody *messBody1 = [[WFMessageBody alloc] init];
            messBody1.posterContent = tempDict[@"Content"];
            
            NSMutableArray *picList = [NSMutableArray array];
            [picList addObjectsFromArray:tempDict[@"PicList"]];
            NSMutableArray *picPath = [NSMutableArray array];
            
            for (int j = 0; j<picList.count; j++) {
                [picPath addObject:[NSString stringWithFormat:@"%@%@",Kimg_path,picList[j][@"ImagePath"]]];
            }
            
            messBody1.posterPostImage = picPath;
            messBody1.posterReplies = comlistFromShow;
            NSString *url;
            if(self.teamImg!=nil)
            {
                url = [NSString stringWithFormat:@"%@%@",Kimg_path ,self.teamImg];
            }
            else
            {
                url = [NSString stringWithFormat:@"%@%@",Kimg_path ,get_sp(@"TeamImg")];
            }
            messBody1.posterImgstr = url;
            if(self.teamName)
            {
                messBody1.posterName = self.teamName;
            }
            else
            {
                messBody1.posterName = get_sp(@"TeamName");
            }
            messBody1.posterIntro = @"";
            messBody1.posterFavour = [[NSMutableArray alloc] init];//[NSMutableArray arrayWithObjects:@"路人甲",@"希尔瓦娜斯",kAdmin,@"鹿盔", nil];
            
            
            messBody1.isFavour = [tempDict[@"IsLike"] integerValue];
            messBody1.zanNum = [[tempDict valueForKey:@"LikeNum"] intValue];
            
            
            NSMutableArray *videoArray = [[NSMutableArray alloc] init];
            [videoArray addObject:[NSString stringWithFormat:@"%@%@",Url,[tempDict valueForKey:@"ImagePath"]]];
            [videoArray addObject:[tempDict valueForKey:@"VideoPath"]];
            [videoArray addObject:[tempDict valueForKey:@"VideoDuration"]];
            messBody1.posterPostVideo = videoArray;
            
            [_contentDataSource addObject:messBody1];
            
            
        }
        
        
        
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

-(void)getTeamNews
{
//    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];

    if(self.teamId == nil)
    {
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"getSelfTeamNewsCallBack:"];
        [dataprovider getSelfTeamNews:[Toolkit getUserID]
                     andStartRowIndex:[NSString stringWithFormat:@"%d",pageNo*pageSize]
                       andMaximumRows:[NSString stringWithFormat:@"%d",pageSize]];
    }
    else
    {
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"getSelfTeamNewsCallBack:"];
        [dataprovider getOtherTeamNews:self.teamId
                      andStartRowIndex:[NSString stringWithFormat:@"%d",pageNo*pageSize]
                       andMaximumRows:[NSString stringWithFormat:@"%d",pageSize]];
    }
}


-(void)FooterRefresh
{
    [self getTeamNews];
}



-(void)getSelfTeamNewsCallBack:(id)dict
{
    
    [SVProgressHUD dismiss];
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try {
            [wyArray addObjectsFromArray:dict[@"data"]];
            [cacheArr addObjectsFromArray:dict[@"data"]];
            
            
            [Toolkit writePlist:NewsCaChePlist andContent:cacheArr andKey:TeamNewsKey];
            pageNo++;
            if(_contentDataSource != nil || _contentDataSource.count>0)
                [_contentDataSource removeAllObjects];
            [self configData:dict[@"data"]];
            
            
            if(_contentDataSource.count == 0 || _contentDataSource==nil)
            {
                
                label = [[UILabel alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height)];
                [self.view addSubview:label];
                label.backgroundColor = BACKGROUND_COLOR;
                label.text = @"队长很懒，什么都没有留下～～";
                label.font = [UIFont systemFontOfSize:16];
                label.numberOfLines = 0;
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [UIColor whiteColor];
                
                label.hidden = NO;
            }
            else
            {
                label.hidden = YES;
            }
            
            
            if(_contentDataSource.count >= [dict[@"recordcount"] intValue])
            {
                [mainTable.mj_footer setState:MJRefreshStateNoMoreData];
            }
            [self loadTextData];

            
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            [mainTable.mj_header endRefreshing];
            [mainTable.mj_footer endRefreshing];
            [mainTable reloadData];
        }
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"data"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        [mainTable.mj_footer endRefreshing];
        
    }
}

#pragma mark -加载数据
- (void)loadTextData{
    //dispatch_async
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  _tableDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMTextData *ym = [_tableDataSource objectAtIndex:indexPath.row];
    BOOL unfold = ym.foldOrNot;
    return TableHeader + kLocationToBottom + ym.replyHeight + ym.showImageHeight  + kDistance + (ym.islessLimit?0:30) + (unfold?ym.shuoshuoHeight:ym.unFoldShuoHeight) + kReplyBtnDistance + ym.favourHeight + (ym.favourHeight == 0?0:kReply_FavourDistance) + (![self isExitVideo:ym]?30:127);
    
    
}


-(BOOL)isExitVideo:(YMTextData *)ymData{
    return ymData.showVideoArray !=nil&&![ymData.showVideoArray[1] isEqual:@""]&&ymData.showVideoArray.count>0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"ILTableViewCell";
    
    YMTableViewCell *cell = (YMTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[YMTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = ItemsBaseColor;
    }
    
    @try {
        
        @try {
            
            cell.CommentBtn.tag = indexPath.row;
            [cell.CommentBtn addTarget:self action:@selector(commentEvent:) forControlEvents:UIControlEventTouchUpInside];
            cell.CommentBtnHF.tag = indexPath.row;
            [cell.CommentBtnHF addTarget:self action:@selector(commentEvent:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.zanBtn.tag = indexPath.row;
            [cell.zanBtn addTarget:self action:@selector(zanEvent:) forControlEvents:UIControlEventTouchUpInside];
            YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:indexPath.row];
            WFMessageBody *m = ymData.messageBody;
            if (m.isFavour == YES) {//此时该取消赞
                [cell.zanBtn setImage:[UIImage imageNamed:@"wyzan"] forState:UIControlStateNormal];
            }else{
                [cell.zanBtn setImage:[UIImage imageNamed:@"wyzan_no"] forState:UIControlStateNormal];
            }
            cell.zanNum.text = [NSString stringWithFormat:@"%d",m.zanNum];//[NSString stringWithFormat:@"%@",[wyArray[indexPath.row] valueForKey
            
            
            cell.stamp = indexPath.row;
            //cell.replyBtn.appendIndexPath = indexPath;
            //[cell.replyBtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.delegate = self;
            cell.userNameLbl.frame = CGRectMake(20 + TableHeader + 20, (TableHeader - TableHeader / 2) / 2, screenWidth - 120, TableHeader/2);
            [cell setYMViewWith:[_tableDataSource objectAtIndex:indexPath.row]];
            
            
            if( ymData.showVideoArray !=nil&&![ymData.showVideoArray[0] isEqual:Url]&&ymData.showVideoArray.count>0){
                UITapGestureRecognizer *clickVideoImg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickVideoImgEvent:)];
                cell.videoImg.userInteractionEnabled = YES;
                NSLog(@"%d",(int)indexPath.row);
                [cell.videoImg addGestureRecognizer:clickVideoImg];
                clickVideoImg.view.tag = indexPath.row;
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        

    }
    @catch (NSException *exception) {
        
    }
    @finally {
         return cell;
    }
    
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if(self.teamId!=nil)
    {
        if(get_sp(@"TeamId")==nil || ![self.teamId isEqualToString:get_sp(@"TeamId")])
        {
            return 120;
        }
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    headView.backgroundColor = BACKGROUND_COLOR;
    
    if(self.teamId!=nil)
    {
        if(get_sp(@"TeamId")==nil || ![self.teamId isEqualToString:get_sp(@"TeamId")])
        {
            
            UIButton *joinBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 20, SCREEN_WIDTH - 30*2, 50)];
            [joinBtn setTitle:@"加入战队" forState:UIControlStateNormal];
            joinBtn.backgroundColor = YellowBlock;
            [joinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [joinBtn addTarget:self action:@selector(joinTeamBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [headView addSubview:joinBtn];
            
            UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                        (joinBtn.frame.origin.y+joinBtn.frame.size.height)+5,
                                                                        SCREEN_WIDTH, 30)];
            tipLab.text = @"每人仅限加入一个战队";
            tipLab.textAlignment = NSTextAlignmentCenter;
            tipLab.textColor = [UIColor whiteColor];
            [headView addSubview:tipLab];
            
         //   mainTable.tableHeaderView = headView;
        }
    }
    
    return headView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OneShuoshuoViewController *oneShuoshuoVC = [[OneShuoshuoViewController alloc] init];
    oneShuoshuoVC.shuoshuoID = [wyArray[indexPath.row] valueForKey:@"Id"];
    if(self.teamName!=nil)
    {
        oneShuoshuoVC.teamName = self.teamName;
    }
    else
    {
        oneShuoshuoVC.teamName = get_sp(@"TeamName");
    }
    if(self.teamImg!=nil)
    {
        oneShuoshuoVC.teamImg = self.teamImg;
    }
    else
    {
        oneShuoshuoVC.teamImg = get_sp(@"TeamImg");
    }
    [self.navigationController pushViewController:oneShuoshuoVC animated:YES];
}

-(void)joinTeamBtnClick:(UIButton *)sender
{
    
    if(get_sp(@"TeamId")!=nil && [get_sp(@"TeamId") isEqualToString:@"0"]!=YES){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您已经有战队,请先退出~" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"joinTeamCallBack:"];
    [dataProvider JoinTeam:[Toolkit getUserID] andTeamId:self.teamId andName:self.teamName];
}


-(void)joinTeamCallBack:(id)dict
{
    DLog(@"%@",dict);
    
    if ([dict[@"code"] intValue] == 200) {

        [SVProgressHUD showSuccessWithStatus:@"加入战队成功~"];
        [userDefault setValue:self.teamId forKey:@"TeamId"];
        [userDefault setValue:self.teamImg forKey:@"TeamImg"];
        [userDefault setValue:self.teamName forKey:@"TeamName"];
        [mainTable.mj_header beginRefreshing];
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"data"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }
}
//播放视频
-(void)clickVideoImgEvent:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIView *views = (UIView*) tap.view;
    NSLog(@"%d",(int)views.tag);
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:views.tag];
    PlayVideoViewController *playVideoVC = [[PlayVideoViewController alloc] init];
    playVideoVC.videoPath = ymData.showVideoArray[1];
    [self.navigationController pushViewController:playVideoVC animated:YES];
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
    
    UIImageView *headBackgroundIv = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,headView.frame.size.height - 40)];
    headBackgroundIv.image = [UIImage imageNamed:@"head_bg"];
    [headView addSubview:headBackgroundIv];
    
    UIView *headImgView = [[UIView alloc] initWithFrame:CGRectMake(0, (headView.frame.size.height - 85) / 2, SCREEN_WIDTH, headView.frame.size.height / 2)];
    UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 40) / 2 , 0, 40, 40)];
    NSString *url ;
    if (self.teamImg !=nil) {
        url = [NSString stringWithFormat:@"%@%@",Kimg_path ,self.teamImg];
    }
    else{
        url = [NSString stringWithFormat:@"%@%@",Kimg_path,get_sp(@"TeamImg")];
    }
    [headImg sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"headImg"]];
    
    headImg.layer.cornerRadius = headImg.frame.size.width * 0.5;
    headImg.layer.borderWidth = 0.1;
    headImg.layer.masksToBounds = YES;
    
    [headImgView addSubview:headImg];
    UILabel *name_lbl = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100) / 2, headImg.frame.origin.y + headImg.frame.size.height, 100, 21)];
    name_lbl.textColor = [UIColor whiteColor];
    name_lbl.textAlignment = NSTextAlignmentCenter;
    if(self.teamName != nil)
    {
        name_lbl.text = self.teamName;
    }
    else
    {
        name_lbl.text = get_sp(@"TeamName");
    }
    name_lbl.font = [UIFont systemFontOfSize:13];
    [headImgView addSubview:name_lbl];
    UILabel *address_lbl = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100) / 2, name_lbl.frame.origin.y + name_lbl.frame.size.height - 5, 100, 21)];
    address_lbl.textColor = [UIColor whiteColor];
    address_lbl.textAlignment = NSTextAlignmentCenter;
    address_lbl.text = @"山东∙临沂";
    address_lbl.font = [UIFont systemFontOfSize:13];
    [headImgView addSubview:address_lbl];
    [headView addSubview:headImgView];
    
    NSLog(@"%f",headImgView.frame.origin.y);
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, headImgView.frame.origin.y + headImgView.frame.size.height, SCREEN_WIDTH, 40)];
    menuView.backgroundColor = ItemsBaseColor;
    CGFloat itemWidth = SCREEN_WIDTH / 4;
    
    UIImageView *iv1 = [[UIImageView alloc] initWithFrame:CGRectMake((itemWidth - 15) / 2, 5, 15, 15)];
    iv1.image = [UIImage imageNamed:@"zdcy"];
    [menuView addSubview:iv1];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, iv1.frame.origin.y + iv1.frame.size.height + 1, itemWidth, 21)];
    label1.font = [UIFont systemFontOfSize:13];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [UIColor whiteColor];
    label1.text = @"战队成员";
    [menuView addSubview:label1];
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(itemWidth, 2, 1, menuView.frame.size.height - 4)];
    line1.backgroundColor = [UIColor colorWithRed:0.23 green:0.23 blue:0.25 alpha:1];
    [menuView addSubview:line1];
    
    //btn_1(战队成员)
    UIButton * btn_1 = [UIButton buttonWithType:(UIButtonTypeSystem)];
    btn_1.frame = CGRectMake(0, 0, itemWidth, 40);
//    btn_1.backgroundColor = [UIColor orangeColor];
    [menuView addSubview:btn_1];
    [btn_1 addTarget:self action:@selector(btn_1Action:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIImageView *iv2 = [[UIImageView alloc] initWithFrame:CGRectMake(itemWidth + (itemWidth - 15) / 2, 5, 15, 15)];
    iv2.image = [UIImage imageNamed:@"zdjs"];
    [menuView addSubview:iv2];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(itemWidth, iv2.frame.origin.y + iv2.frame.size.height + 1, itemWidth, 21)];
    label2.font = [UIFont systemFontOfSize:13];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = [UIColor whiteColor];
    label2.text = @"战队介绍";
    [menuView addSubview:label2];
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(itemWidth * 2, 2, 1, menuView.frame.size.height - 4)];
    line2.backgroundColor = [UIColor colorWithRed:0.23 green:0.23 blue:0.25 alpha:1];
    [menuView addSubview:line2];
    
    //btn_2(战队介绍)
    UIButton * btn_2 = [UIButton buttonWithType:(UIButtonTypeSystem)];
    btn_2.frame = CGRectMake(itemWidth , 0, itemWidth, 40);
//    btn_2.backgroundColor = [UIColor orangeColor];
    [menuView addSubview:btn_2];
    [btn_2 addTarget:self action:@selector(btn_2Action:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIImageView *iv3 = [[UIImageView alloc] initWithFrame:CGRectMake(itemWidth * 2 + (itemWidth - 15) / 2, 5, 15, 15)];
    iv3.image = [UIImage imageNamed:@"zdgg"];
    [menuView addSubview:iv3];
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(itemWidth * 2, iv3.frame.origin.y + iv3.frame.size.height + 1, itemWidth, 21)];
    label3.font = [UIFont systemFontOfSize:13];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.textColor = [UIColor whiteColor];
    label3.text = @"战队公告";
    [menuView addSubview:label3];
    UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(itemWidth * 3, 2, 1, menuView.frame.size.height - 4)];
    line3.backgroundColor = [UIColor colorWithRed:0.23 green:0.23 blue:0.25 alpha:1];
    [menuView addSubview:line3];
    
    //btn_3(战队公告)
    UIButton * btn_3 = [UIButton buttonWithType:(UIButtonTypeSystem)];
    btn_3.frame = CGRectMake(itemWidth * 2, 0, itemWidth, 40);
//    btn_3.backgroundColor = [UIColor orangeColor];
    [menuView addSubview:btn_3];
    [btn_3 addTarget:self action:@selector(btn_3Action:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIImageView *iv4 = [[UIImageView alloc] initWithFrame:CGRectMake(itemWidth * 3 + (itemWidth - 15) / 2, 5, 15, 15)];
    iv4.image = [UIImage imageNamed:@"zdlt"];
    [menuView addSubview:iv4];
    UIButton *label4 = [[UIButton alloc] initWithFrame:CGRectMake(itemWidth * 3, iv4.frame.origin.y + iv4.frame.size.height + 1, itemWidth, 21)];
    [label4 addTarget:self action:@selector(chatBtkClick:) forControlEvents:UIControlEventTouchUpInside];
    [label4 setTitle:@"战队聊天" forState:UIControlStateNormal];
    label4.titleLabel.font = [UIFont systemFontOfSize:13];
//    label4.font = [UIFont systemFontOfSize:13];
//    label4.textAlignment = NSTextAlignmentCenter;
//    label4.textColor = [UIColor whiteColor];
//    label4.text = @"战队聊天";
    [menuView addSubview:label4];
    
    [headView addSubview:menuView];
    
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

#pragma mark - 战队信息的点击事件
- (void)btn_1Action:(UIButton *)sender
{
    if(self.teamId!=nil)
    {
        if(![self.teamId isEqualToString:get_sp(@"TeamId")])
        {
            UIAlertView *alertView = [[UIAlertView alloc ] initWithTitle:@"提示" message:@"您不是该战队成员" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return;
        }
    }
//    NSLog(@"跳转到战队成员");
    Member_ViewController * member_ViewController = [[Member_ViewController alloc] init];
    [self.navigationController pushViewController:member_ViewController animated:YES];
//    [self showViewController:member_ViewController sender:nil];
}

- (void)btn_2Action:(UIButton *)sender
{
    if(self.teamId!=nil)
    {
        if(![self.teamId isEqualToString:get_sp(@"TeamId")])
        {
            UIAlertView *alertView = [[UIAlertView alloc ] initWithTitle:@"提示" message:@"您不是该战队成员" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return;
        }
    }
//    NSLog(@"跳转到战队介绍");
    IntroduceViewController * introduceViewController = [[IntroduceViewController alloc] init];
    if(self.teamId==nil)
    {
        introduceViewController.teamId = get_sp(@"TeamId");
    }
    else
    {
        introduceViewController.teamId = self.teamId;
    }
    [self.navigationController pushViewController:introduceViewController animated:YES];
    //[self showViewController:introduceViewController sender:nil];
}

- (void)btn_3Action:(UIButton *)sender
{
//    NSLog(@"跳转到战队公告");
    if(self.teamId!=nil)
    {
        if(![self.teamId isEqualToString:get_sp(@"TeamId")])
        {
            UIAlertView *alertView = [[UIAlertView alloc ] initWithTitle:@"提示" message:@"您不是该战队成员" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return;
        }
    }
    AnnouncementViewController * announcementViewController = [[AnnouncementViewController alloc] init];
    [self.navigationController pushViewController:announcementViewController animated:YES];
    //[self showViewController:announcementViewController sender:nil];
}
-(void)chatBtkClick:(UIButton *)sender
{
    if(self.teamId!=nil)
    {
        if(![self.teamId isEqualToString:get_sp(@"TeamId")])
        {
            UIAlertView *alertView = [[UIAlertView alloc ] initWithTitle:@"提示" message:@"您不是该战队成员" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return;
        }
    }
    
    //新建一个聊天会话View Controller对象
    ChatContentViewController *chat = [[ChatContentViewController alloc]init];
    //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众账号等
    chat.conversationType = ConversationType_GROUP;
    //设置会话的目标会话ID。（单聊、客服、公众账号服务为对方的ID，讨论组、群聊、聊天室为会话的ID）
    if(self.teamId==nil)
    {
        chat.targetId = [NSString stringWithFormat:@"%@",get_sp(@"TeamId")];
    }
    else{
        chat.targetId = self.teamId;
    }
    //设置聊天会话界面要显示的标题
    chat.title = @"想显示的会话标题";
    
    if(self.teamName != nil)
    {
        chat.mTitle = self.teamName;
    }
    else
    {
        chat.mTitle = get_sp(@"TeamName");
    }
    //显示聊天会话界面
    [self.navigationController pushViewController:chat animated:YES];
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


-(void)zanEvent:(UIButton *)sender{
    NSLog(@"%d",(int)sender.tag);
    selectRow = (int)sender.tag;
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:selectRow];
    WFMessageBody *m = ymData.messageBody;
    
    [SVProgressHUD showWithStatus:@"提交更改" maskType:SVProgressHUDMaskTypeBlack];
    
    if (m.isFavour == YES) {//此时该取消赞
        actionType = cancelZan;
        DataProvider *dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"zanCallBack:"];
        [dataProvider voicedelete:[wyArray[sender.tag] valueForKey:@"Id"] andUserId:[Toolkit getUserID] andFlg:@"2"];
        
    }else{
        actionType = setZan;
        DataProvider *dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"zanCallBack:"];
        [dataProvider voiceAction:[wyArray[sender.tag] valueForKey:@"Id"] andUserId:[Toolkit getUserID] andFlg:@"2" andDescription:nil];
    }
}
-(void)zanCallBack:(id)dict{
    
    DLog(@"%@",dict);
    
    if ([dict[@"code"] intValue] == 200) {
        if(actionType == setZan)
        {
            [SVProgressHUD showSuccessWithStatus:@"赞＋1"];
        }
        else if(actionType == cancelZan)
        {
            [SVProgressHUD showSuccessWithStatus:@"取消成功"];
        }
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
    else
    {
        [SVProgressHUD dismiss];
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"data"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }
}


#pragma mark - 评论

-(void)commentEvent:(UIButton *)sender{
    isComment = YES;
    selectRow = (int)sender.tag;
    replyView = [[YMReplyInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, screenWidth,44) andAboveView:self.view];
    replyView.delegate = self;
    replyView.replyTag = sender.tag;//_selectedIndexPath.row;
    commentSection = [NSString  stringWithFormat:@"%ld",sender.tag];
    [self.view addSubview:replyView];
}


-(void)sendButton:(id)sender
{
    
    @try {
        if (isComment) {
            DataProvider *dataProvider = [[DataProvider alloc] init];
            [dataProvider setDelegateObject:self setBackFunctionName:@"mainCommentCallBack:"];
            [dataProvider MessageComment:[wyArray[selectRow] valueForKey:@"Id"]
                               anduserid:[Toolkit getUserID]
                              andcomment:((UITextView *)sender).text];
        }else{
            DataProvider *dataProvider = [[DataProvider alloc] init];
            [dataProvider setDelegateObject:self setBackFunctionName:@"mainCommentCallBack:"];
            [dataProvider CommentComment:[[wyArray[selectRow] valueForKey:@"ComList"][_replyIndex] valueForKey:@"Id"]
                               anduserid:[Toolkit getUserID]
                              andcomment:((UITextView *)sender).text];
            
        }
    }
    @catch (NSException *exception) {
    
    }
    @finally {
        
    }


}

-(void)mainCommentCallBack:(id)dict{
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue] == 200) {
        
//        dispatch_queue_t defaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        dispatch_async(defaultQueue, ^{
//                    });
//        
     //   [[NSNotificationCenter defaultCenter] postNotificationName:@"updateComment" object:nil userInfo:nil];
        [replyView updateComment];
        NSMutableArray *tempArr = commentArr[[commentSection intValue]];
        [tempArr insertObject:dict[@"insertid"] atIndex:1];
        
        //  dict[@"insertid"];
    //    [mainTable.mj_header beginRefreshing];
    }
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
    
    [self.operationView dismiss];
    
    _replyIndex = replyIndex;
    
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:index];
    WFReplyBody *b = [ymData.messageBody.posterReplies objectAtIndex:replyIndex];
    if ([b.replyUser isEqualToString:kAdmin]) {
        WFActionSheet *actionSheet = [[WFActionSheet alloc] initWithTitle:@"删除评论？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
        actionSheet.actionIndex = index;
        [actionSheet showInView:self.view];
        @try {
            delCommmentId =[NSString stringWithFormat:@"%@", commentArr[index][replyIndex+1]];
        }
        
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
        
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
        actionIndex = actionSheet.actionIndex;
        @try {
            //YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:actionSheet.actionIndex];
           // WFMessageBody *m = ymData.messageBody;
            [SVProgressHUD showWithStatus:@"删除中" maskType:SVProgressHUDMaskTypeBlack];
            DataProvider *dataProvider = [[DataProvider alloc] init];
            [dataProvider setDelegateObject:self setBackFunctionName:@"delCommentCallBack:"];
            
           // WFReplyBody *tempReply = m.posterReplies[_replyIndex];
            if(delCommmentId ==nil||delCommmentId.length ==0)
            {
                [SVProgressHUD dismiss];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"删除失败" message:@"请重新进入页面重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
                return;
            }
            [dataProvider delComment:delCommmentId];


        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
        //delete
    }else{
        
    }
    
}

-(void)delCommentCallBack:(id)dict
{
    DLog(@"%@",dict);
    [SVProgressHUD dismiss];
    if ([dict[@"code"] intValue] == 200) {
        @try {
            YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:actionIndex];
            WFMessageBody *m = ymData.messageBody;
            
            [m.posterReplies removeObjectAtIndex:_replyIndex];
            ymData.messageBody = m;
            [ymData.completionReplySource removeAllObjects];
            [ymData.attributedDataReply removeAllObjects];
            
            
            ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
            [_tableDataSource replaceObjectAtIndex:actionIndex withObject:ymData];
            

        }
        @catch (NSException *exception) {
            
        }
        @finally {
            [mainTable reloadData];
            _replyIndex = -1;

        }
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"删除失败" message:dict[@"data"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }

}


- (void)dealloc{
    
    NSLog(@"销毁");
    
}

@end
