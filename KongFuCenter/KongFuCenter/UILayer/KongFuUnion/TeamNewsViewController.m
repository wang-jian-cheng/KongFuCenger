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

#define dataCount 10
#define kLocationToBottom 20
#define kAdmin @"小虎-tiger"

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
    
    
}

@property (nonatomic,strong) WFPopView *operationView;
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;

@end

@implementation TeamNewsViewController


#pragma mark - 数据源
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
            for (int j =0; j<comlist.count; j++) {
                WFReplyBody *body1 = [[WFReplyBody alloc] init];
                body1.replyUser = kAdmin;
                body1.repliedUser = @"红领巾";
                body1.replyInfo = kContentText1;
                [comlistFromShow addObject:body1];
            }
            
            
            WFMessageBody *messBody1 = [[WFMessageBody alloc] init];
            messBody1.posterContent = tempDict[@"Content"];
            messBody1.posterPostImage = @[@"yewenback@2x.png",@"yewenback@2x.png",@"yewenback@2x.png"];
            messBody1.posterReplies = comlistFromShow;
            
            NSString *url = [NSString stringWithFormat:@"%@%@",Kimg_path ,get_sp(@"TeamImg")];
            messBody1.posterImgstr = url;
            messBody1.posterName = get_sp(@"TeamName");
            
            messBody1.posterIntro = @"";
            messBody1.posterFavour = [NSMutableArray arrayWithObjects:@"路人甲",@"希尔瓦娜斯",kAdmin,@"鹿盔", nil];
            messBody1.isFavour = YES;
            
            
            [_contentDataSource addObject:messBody1];
            

        }
        

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    [self setBarTitle:@"战队动态"];
    [self addLeftButton:@"left"];
    [self addRightButton:@"moreNoword"];
    pageSize = 10;
  //  [self configData];
    _tableDataSource = [[NSMutableArray alloc] init];
    _contentDataSource = [[NSMutableArray alloc] init];
    _replyIndex = -1;//代表是直接评论

    [self initTableview];
    
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

#pragma mark - self data source

-(void)getTeamNews
{
    [SVProgressHUD showWithStatus:@"刷新" maskType:SVProgressHUDMaskTypeBlack];

    if(self.teamId == nil)
    {
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"getSelfTeamNewsCallBack:"];
        [dataprovider getSelfTeamNews:[Toolkit getUserID]
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
            pageNo++;
            if(_contentDataSource != nil || _contentDataSource.count>0)
                [_contentDataSource removeAllObjects];
            [self configData:dict[@"data"]];
            
            [self loadTextData];

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
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    mainTable.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageNo=0;
        [weakSelf getTeamNews];
        // 结束刷新
        [mainTable.mj_header endRefreshing];
    }];
    [mainTable.mj_header beginRefreshing];
    
    // 上拉刷新
    mainTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf FooterRefresh];
        [mainTable.mj_footer endRefreshing];
    }];
    

    
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
    return TableHeader + kLocationToBottom + ym.replyHeight + ym.showImageHeight  + kDistance + (ym.islessLimit?0:30) + (unfold?ym.shuoshuoHeight:ym.unFoldShuoHeight) + kReplyBtnDistance + ym.favourHeight + (ym.favourHeight == 0?0:kReply_FavourDistance);
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
    cell.delegate = self;
    cell.userNameLbl.frame = CGRectMake(20 + TableHeader + 20, (TableHeader - TableHeader / 2) / 2, screenWidth - 120, TableHeader/2);
    [cell setYMViewWith:[_tableDataSource objectAtIndex:indexPath.row]];
    
    return cell;
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
    headImg.image = [UIImage imageNamed:@"headImg"];
    [headImgView addSubview:headImg];
    UILabel *name_lbl = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100) / 2, headImg.frame.origin.y + headImg.frame.size.height, 100, 21)];
    name_lbl.textColor = [UIColor whiteColor];
    name_lbl.textAlignment = NSTextAlignmentCenter;
    name_lbl.text = @"成龙战队";
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
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(itemWidth * 3, iv4.frame.origin.y + iv4.frame.size.height + 1, itemWidth, 21)];
    label4.font = [UIFont systemFontOfSize:13];
    label4.textAlignment = NSTextAlignmentCenter;
    label4.textColor = [UIColor whiteColor];
    label4.text = @"战队聊天";
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
//    NSLog(@"跳转到战队成员");
    Member_ViewController * member_ViewController = [[Member_ViewController alloc] init];
    [self.navigationController pushViewController:member_ViewController animated:YES];
//    [self showViewController:member_ViewController sender:nil];
}

- (void)btn_2Action:(UIButton *)sender
{
//    NSLog(@"跳转到战队介绍");
    IntroduceViewController * introduceViewController = [[IntroduceViewController alloc] init];
    [self.navigationController pushViewController:introduceViewController animated:YES];
    //[self showViewController:introduceViewController sender:nil];
}

- (void)btn_3Action:(UIButton *)sender
{
//    NSLog(@"跳转到战队公告");
    
    AnnouncementViewController * announcementViewController = [[AnnouncementViewController alloc] init];
    [self.navigationController pushViewController:announcementViewController animated:YES];
    //[self showViewController:announcementViewController sender:nil];
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
    
    [self.operationView dismiss];
    
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
