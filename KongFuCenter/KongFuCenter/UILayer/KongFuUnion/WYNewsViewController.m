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

#define dataCount 10
#define kLocationToBottom 20
#define kAdmin @"小虎-tiger"

#define sendNews  (2015+1)
#define smallVideo  (2015+2)

@interface WYNewsViewController ()<UITableViewDataSource,UITableViewDelegate,cellDelegate,InputDelegate,UIActionSheetDelegate>
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

@implementation WYNewsViewController


#pragma mark - 数据源
- (void)configData{
    
    _tableDataSource = [[NSMutableArray alloc] init];
    _contentDataSource = [[NSMutableArray alloc] init];
    _replyIndex = -1;//代表是直接评论
    
    
    WFReplyBody *body1 = [[WFReplyBody alloc] init];
    body1.replyUser = kAdmin;
    body1.repliedUser = @"红领巾";
    body1.replyInfo = kContentText1;
    
    
    WFReplyBody *body2 = [[WFReplyBody alloc] init];
    body2.replyUser = @"迪恩";
    body2.repliedUser = @"";
    body2.replyInfo = kContentText2;
    
    
    WFReplyBody *body3 = [[WFReplyBody alloc] init];
    body3.replyUser = @"山姆";
    body3.repliedUser = @"";
    body3.replyInfo = kContentText3;
    
    
    WFReplyBody *body4 = [[WFReplyBody alloc] init];
    body4.replyUser = @"雷锋";
    body4.repliedUser = @"简森·阿克斯";
    body4.replyInfo = kContentText4;
    
    
    WFReplyBody *body5 = [[WFReplyBody alloc] init];
    body5.replyUser = kAdmin;
    body5.repliedUser = @"";
    body5.replyInfo = kContentText5;
    
    
    WFReplyBody *body6 = [[WFReplyBody alloc] init];
    body6.replyUser = @"红领巾";
    body6.repliedUser = @"";
    body6.replyInfo = kContentText6;
    
    
    WFMessageBody *messBody1 = [[WFMessageBody alloc] init];
    messBody1.posterContent = kShuoshuoText1;
    messBody1.posterPostImage = @[@"yewenback@2x.png",@"yewenback@2x.png",@"yewenback@2x.png"];
    messBody1.posterReplies = [NSMutableArray arrayWithObjects:body1,body2,body4, nil];
    messBody1.posterImgstr = @"mao.jpg";
    messBody1.posterName = @"迪恩·温彻斯特";
    messBody1.posterIntro = @"";
    messBody1.posterFavour = [NSMutableArray arrayWithObjects:@"路人甲",@"希尔瓦娜斯",kAdmin,@"鹿盔", nil];
    messBody1.isFavour = YES;
    
    WFMessageBody *messBody2 = [[WFMessageBody alloc] init];
    messBody2.posterContent = kShuoshuoText1;
    messBody2.posterPostImage = @[];
    messBody2.posterReplies = [NSMutableArray arrayWithObjects:body1,body2,body4, nil];
    messBody2.posterImgstr = @"mao.jpg";
    messBody2.posterName = @"山姆·温彻斯特";
    messBody2.posterIntro = @"";
    messBody2.posterFavour = [NSMutableArray arrayWithObjects:@"塞纳留斯",@"希尔瓦娜斯",@"鹿盔", nil];
    messBody2.isFavour = NO;
    
    
    WFMessageBody *messBody3 = [[WFMessageBody alloc] init];
    messBody3.posterContent = kShuoshuoText3;
    messBody3.posterPostImage = @[@"yewenback.png",@"yewenback.png",@"yewenback.png",@"yewenback.png",@"yewenback.png",@"yewenback.png"];
    messBody3.posterReplies = [NSMutableArray arrayWithObjects:body1,body2,body4,body6,body5,body4, nil];
    messBody3.posterImgstr = @"mao.jpg";
    messBody3.posterName = @"伊利丹怒风";
    messBody3.posterIntro = @"";
    messBody3.posterFavour = [NSMutableArray arrayWithObjects:@"路人甲",kAdmin,@"希尔瓦娜斯",@"鹿盔",@"黑手", nil];
    messBody3.isFavour = YES;
    
    WFMessageBody *messBody4 = [[WFMessageBody alloc] init];
    messBody4.posterContent = kShuoshuoText4;
    messBody4.posterPostImage = @[@"yewenback.png",@"yewenback.png",@"yewenback.png",@"yewenback.png"];
    messBody4.posterReplies = [NSMutableArray arrayWithObjects:body1, nil];
    messBody4.posterImgstr = @"mao.jpg";
    messBody4.posterName = @"基尔加丹";
    messBody4.posterIntro = @"";
    messBody4.posterFavour = [NSMutableArray arrayWithObjects:@"路人甲",nil];
    messBody4.isFavour = NO;
    
    WFMessageBody *messBody5 = [[WFMessageBody alloc] init];
    messBody5.posterContent = kShuoshuoText5;
    messBody5.posterPostImage = @[@"yewenback.png",@"yewenback.png",@"yewenback.png",@"yewenback.png"];
    messBody5.posterReplies = [NSMutableArray arrayWithObjects:body2,body4,body5, nil];
    messBody5.posterImgstr = @"mao.jpg";
    messBody5.posterName = @"阿克蒙德";
    messBody5.posterIntro = @"";
    messBody5.posterFavour = [NSMutableArray arrayWithObjects:@"希尔瓦娜斯",@"格鲁尔",@"魔兽世界5区石锤人类联盟女圣骑丨阿诺丨",@"钢铁女武神",@"魔兽世界5区石锤人类联盟女盗贼chaotics",@"克苏恩",@"克尔苏加德",@"钢铁议会", nil];
    messBody5.isFavour = NO;
    
    WFMessageBody *messBody6 = [[WFMessageBody alloc] init];
    messBody6.posterContent = kShuoshuoText5;
    messBody6.posterPostImage = @[@"yewenback.png",@"yewenback.png",@"yewenback.png",@"yewenback.png"];
    messBody6.posterReplies = [NSMutableArray arrayWithObjects:body2,body4,body5,body4,body6, nil];
    messBody6.posterImgstr = @"mao.jpg";
    messBody6.posterName = @"红领巾";
    messBody6.posterIntro = @"";
    messBody6.posterFavour = [NSMutableArray arrayWithObjects:@"爆裂熔炉",@"希尔瓦娜斯",@"阿尔萨斯",@"死亡之翼",@"玛里苟斯", nil];
    messBody6.isFavour = NO;
    
    
    [_contentDataSource addObject:messBody1];
    [_contentDataSource addObject:messBody2];
    [_contentDataSource addObject:messBody3];
    [_contentDataSource addObject:messBody4];
    [_contentDataSource addObject:messBody5];
    [_contentDataSource addObject:messBody6];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    [self setBarTitle:@"战队动态"];
    [self addLeftButton:@"left"];
    [self addRightButton:@"moreNoword@2x"];
    
    [self configData];
    
    [self initTableview];
    
    [self loadTextData];
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
    cell.replyBtn.appendIndexPath = indexPath;
    [cell.replyBtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.delegate = self;
    [cell setYMViewWith:[_tableDataSource objectAtIndex:indexPath.row]];
    cell.userNameLbl.frame = CGRectMake(20 + TableHeader + 20, (TableHeader - TableHeader / 2) / 2, screenWidth - 120, TableHeader/2);
    
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
    
    UIImageView *headBackgroundIv = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,headView.frame.size.height)];
    headBackgroundIv.image = [UIImage imageNamed:@"head_bg"];
    [headView addSubview:headBackgroundIv];
    
    UIView *headImgView = [[UIView alloc] initWithFrame:CGRectMake(0, headView.frame.size.height - 50 - 10, SCREEN_WIDTH, 60)];
    UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake(20 , 0, 50, 50)];
    headImg.image = [UIImage imageNamed:@"headImg"];
    [headImgView addSubview:headImg];
    UILabel *name_lbl = [[UILabel alloc] initWithFrame:CGRectMake(headImg.frame.origin.x + headImg.frame.size.width+ 2, headImg.frame.origin.y + 2, 100, 21)];
    name_lbl.textColor = [UIColor whiteColor];
    name_lbl.text = @"成龙";
    name_lbl.font = [UIFont systemFontOfSize:13];
    [headImgView addSubview:name_lbl];
    UILabel *id_lbl = [[UILabel alloc] initWithFrame:CGRectMake(headImg.frame.origin.x + headImg.frame.size.width+ 2, name_lbl.frame.origin.y + name_lbl.frame.size.height / 2 +10, 100, 21)];
    id_lbl.textColor = [UIColor whiteColor];
    id_lbl.text = @"ID:123456789";
    id_lbl.font = [UIFont systemFontOfSize:13];
    [headImgView addSubview:id_lbl];
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
        [m.posterReplies addObject:body];
        ymData.messageBody = m;
        
    }else{
        
        ymData = (YMTextData *)[_tableDataSource objectAtIndex:inputTag];
        WFMessageBody *m = ymData.messageBody;
        
        WFReplyBody *body = [[WFReplyBody alloc] init];
        body.replyUser = kAdmin;
        body.repliedUser = [(WFReplyBody *)[m.posterReplies objectAtIndex:_replyIndex] replyUser];
        body.replyInfo = replyText;
        
        [m.posterReplies addObject:body];
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
