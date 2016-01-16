//
//  MushaMatchDetailViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/12.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "MushaMatchDetailViewController.h"
#import "ApplyForMatchViewController.h"
#import "VideoDetailForMatchViewController.h"
#import "MushaMatchOngoingViewController.h"
#import "MapViewController.h"

#define cancelApply  (2015+1)
#define changeWorks  (2015+2)

@interface MushaMatchDetailViewController ()
{
#pragma mark - pram for tableView
    NSInteger _sectionNum;
    CGFloat _cellHeight;
    UITableView *_mainTableView;
    NSDictionary *personMatchDetalDict;
    UIView *moreSettingBackView;
    ApplyForMatchViewController *applyForMatchViewCtl;
}
@end
#define GapToLeft   20

@implementation MushaMatchDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self addLeftButton:@"left"];
    [self initData];
}

-(void)initData{
    [SVProgressHUD showWithStatus:@"加载中..."];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getPersonMatchDetailCallBack:"];
    [dataProvider SelectMatchDetail:_matchId anduserId:get_sp(@"id")];
}

-(void)getPersonMatchDetailCallBack:(id)dict{
    [SVProgressHUD dismiss];
    NSLog(@"%@",dict);
    if ([dict[@"code"] intValue] == 200) {
        personMatchDetalDict = [[NSDictionary alloc] initWithDictionary:dict[@"data"]];
        [self initViews];
    }
}

-(void)initViews
{
    _cellHeight = SCREEN_HEIGHT/12;
    _sectionNum = 5;
    
    _isApply = [Toolkit judgeIsNull:[personMatchDetalDict valueForKey:@"IsJoin"]];
    if ([_isApply isEqual:@"1"]) {
        [self addRightButton:@"plus"];
    }
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height )];
    _mainTableView.backgroundColor = BACKGROUND_COLOR;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorColor =  Separator_Color;
    _mainTableView.tableFooterView = [[UIView alloc] init];
    //_mainTableView.scrollEnabled = NO;
    
    _mainTableView.contentSize = CGSizeMake(SCREEN_HEIGHT, _sectionNum*(_cellHeight + 20));
    [self.view addSubview:_mainTableView];
    
    moreSettingBackView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100 -10), Header_Height, 100, 88)];
    moreSettingBackView.backgroundColor = ItemsBaseColor;
    UIButton *newBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, moreSettingBackView.frame.size.width,  moreSettingBackView.frame.size.height/2)];
    [newBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newBtn setTitle:@"取消报名" forState:UIControlStateNormal];
    newBtn.tag = cancelApply;
    [newBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView2 =[[UIView alloc] initWithFrame:CGRectMake(0, moreSettingBackView.frame.size.height/2, moreSettingBackView.frame.size.width - 2, 1)];
    lineView2.backgroundColor = Separator_Color;
    UIButton *delBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, moreSettingBackView.frame.size.height/2, moreSettingBackView.frame.size.width,  moreSettingBackView.frame.size.height/2)];
    [delBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [delBtn setTitle:@"修改作品" forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    delBtn.tag = changeWorks;
    
    
    [moreSettingBackView addSubview:newBtn];
    [moreSettingBackView addSubview:delBtn];
    [moreSettingBackView addSubview:lineView2];
    
    [self.view addSubview:moreSettingBackView];
    moreSettingBackView.hidden = YES;
}

-(void)btnClick:(UIButton *)sender
{
    if(sender.tag == cancelApply)
    {
        [self positionDismissView:moreSettingBackView];
        
        [SVProgressHUD showWithStatus:@""];
        DataProvider *dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"cancelApplyCallBack:"];
        [dataProvider CancleJoinMatch:_matchId anduserid:get_sp(@"id")];
    }
    else  if(sender.tag == changeWorks)
    {
        [self positionDismissView:moreSettingBackView];
        ApplyForMatchViewController *applyForMatchVC = [[ApplyForMatchViewController alloc] init];
        [applyForMatchVC setApplyForMatchMode:Mode_Update];
        applyForMatchVC.matchId = _matchId;
        applyForMatchVC.navtitle = @"修改作品";
        [self.navigationController pushViewController:applyForMatchVC animated:YES];
    }
}

-(void)cancelApplyCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        [SVProgressHUD showSuccessWithStatus:@"取消报名成功~"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)clickRightButton:(UIButton *)sender{
    if ([_isApply isEqual:@"1"]) {
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

-(void)viewDidAppear:(BOOL)animated{
    if (applyForMatchViewCtl) {
        [self initData];
    }
}

#pragma mark - Click actions
-(void)actionBtnClick:(UIButton*)sender
{
    if([sender.titleLabel.text isEqualToString:@"我要报名"])
    {
        applyForMatchViewCtl = [[ApplyForMatchViewController alloc] init];
        [applyForMatchViewCtl setApplyForMatchMode:Mode_Add];
        applyForMatchViewCtl.navtitle = @"武者大赛报名";
        applyForMatchViewCtl.matchId = _matchId;
        [self.navigationController pushViewController:applyForMatchViewCtl animated:YES];
    }else if([sender.titleLabel.text isEqualToString:@"查看报名选手"])
    {
        PlayerForMatchViewController *playForMatchViewCtl = [[PlayerForMatchViewController alloc] init];
        [playForMatchViewCtl setPlayerForMatchMode:Mode_MushaPlayer];
        playForMatchViewCtl.navtitle = @"参赛成员";
        playForMatchViewCtl.matchId = _matchId;
        [self.navigationController pushViewController:playForMatchViewCtl animated:YES];
    }else if([sender.titleLabel.text isEqualToString:@"查看报名战队"])
    {
        PlayerForMatchViewController *playForMatchViewCtl = [[PlayerForMatchViewController alloc] init];
        [playForMatchViewCtl setPlayerForMatchMode:Mode_TeamPlayer];
        playForMatchViewCtl.navtitle = @"参赛成员";
        playForMatchViewCtl.matchId = _matchId;
        [self.navigationController pushViewController:playForMatchViewCtl animated:YES];
    }else if([sender.titleLabel.text isEqualToString:@"我的视频"])
    {
        VideoDetailForMatchViewController *videoViewCtl = [[VideoDetailForMatchViewController alloc] init];
        videoViewCtl.matchId = _matchId;
        videoViewCtl.matchUserId = [Toolkit getUserID];
        videoViewCtl.navtitle = @"大赛个人详情";
        [self.navigationController pushViewController:videoViewCtl animated:YES];
    }else if([sender.titleLabel.text isEqualToString:@"战队视频"])
    {
        VideoDetailForMatchViewController *videoViewCtl = [[VideoDetailForMatchViewController alloc] init];
        videoViewCtl.matchId = _matchId;
        videoViewCtl.matchTeamId = get_sp(@"TeamId");
        videoViewCtl.navtitle = @"战队详情";
        [self.navigationController pushViewController:videoViewCtl animated:YES];
    }
}

-(void)voteEvent{
    MushaMatchOngoingViewController *mushaMatchOngoingViewCtl =[[MushaMatchOngoingViewController alloc] init];
    [mushaMatchOngoingViewCtl setMushaMatchOngoingMode:Mode_MushaRanking];
    mushaMatchOngoingViewCtl.navtitle = @"投票排名";
    mushaMatchOngoingViewCtl.matchId = _matchId;
    [self.navigationController pushViewController:mushaMatchOngoingViewCtl animated:YES];
}

-(void)voteTeamEvent{
    MushaMatchOngoingViewController *mushaMatchOngoingViewCtl =[[MushaMatchOngoingViewController alloc] init];
    [mushaMatchOngoingViewCtl setMushaMatchOngoingMode:Mode_TeamRanking];
    mushaMatchOngoingViewCtl.navtitle = @"投票排名";
    mushaMatchOngoingViewCtl.matchId = _matchId;
    [self.navigationController pushViewController:mushaMatchOngoingViewCtl animated:YES];
}

-(void)connectPhoneClick:(UIButton *)btn{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认拨打电话?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.delegate = self;
    alertView.tag = 100;
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *phoneStr = [NSString stringWithFormat:@"tel://%@",[Toolkit judgeIsNull:[personMatchDetalDict valueForKey:@"Phone"]]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
    }
}

-(void)dingweiEvent{
    NSLog(@"%@",personMatchDetalDict);
    MapViewController *mapVC = [[MapViewController alloc] init];
    mapVC.navtitle = @"大赛位置";
    mapVC.lat = 0;//118.35571299999999;
    mapVC.lng = 0;//35.121513;
    mapVC.Title = @"title";
    mapVC.addr = @"address";
    [self.navigationController pushViewController:mapVC animated:YES];
}

#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _sectionNum;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}

#pragma mark - setting for cell
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight)];
    cell.backgroundColor = ItemsBaseColor;
    switch (indexPath.section) {
        case 0:
        {
            NSLog(@"%@",personMatchDetalDict);
            NSString *MatchPath = [Toolkit judgeIsNull:[personMatchDetalDict valueForKey:@"MatchImage"]];
            NSString *url = [NSString stringWithFormat:@"%@%@",Url,MatchPath];
            UIImageView *mainImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight*4)];
            [mainImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"yewenback"]]; //[UIImage imageNamed:@"yewenback"];
            [cell addSubview:mainImgView];
            
            UILabel *titlelab = [[UILabel alloc ]initWithFrame:CGRectMake(GapToLeft, mainImgView.frame.size.height+5, SCREEN_WIDTH-GapToLeft, _cellHeight/2-5)];
            titlelab.text = [Toolkit judgeIsNull:[personMatchDetalDict valueForKey:@"Name"]];//@"临沂第一届国际武术大赛";
            titlelab.textColor = [UIColor whiteColor];
            titlelab.font = [UIFont systemFontOfSize:14];
            [cell addSubview:titlelab];
            
            UIButton *placeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 30, _cellHeight/2-5)];
            [placeBtn setImage:[UIImage imageNamed:@"dingwei"] forState:UIControlStateNormal];
            UIView *backView = [[UIView alloc] initWithFrame:placeBtn.frame];
            
            UITextField *placeLab = [[UITextField alloc] initWithFrame:CGRectMake(GapToLeft,(titlelab.frame.size.height+titlelab.frame.origin.y) + 5 , SCREEN_WIDTH-GapToLeft, _cellHeight/2-5)];
            placeLab.leftView =backView;
            placeLab.leftViewMode = UITextFieldViewModeAlways;
            placeLab.text = [Toolkit judgeIsNull:[personMatchDetalDict valueForKey:@"MatchAddress"]];//@"临沂市兰山区沂蒙路和上海路交汇处朗润大厦18楼";
            placeLab.textColor = [UIColor whiteColor];
            placeLab.font = [UIFont systemFontOfSize:14];
            
            placeLab.enabled = NO;
            [placeLab addSubview:placeBtn];
            [cell addSubview:placeLab];
            
            UIButton *placeEventBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, (titlelab.frame.size.height+titlelab.frame.origin.y) + 5, SCREEN_WIDTH, (_cellHeight/2-5) * 2)];
            [placeEventBtn addTarget:self action:@selector(dingweiEvent) forControlEvents:UIControlEventTouchUpInside];\
            [cell addSubview:placeEventBtn];
        }
            break;
        case 1:
        {
            UILabel *titlelab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 0, SCREEN_WIDTH, _cellHeight/2)];
            titlelab.text = @"活动详情：";
            titlelab.textColor = [UIColor whiteColor];
            titlelab.font = [UIFont systemFontOfSize:16];
            [cell addSubview:titlelab];
            
            NSString *str = [Toolkit judgeIsNull:[personMatchDetalDict valueForKey:@"Introduction"]];
            
            CGFloat height = [Toolkit heightWithString:str fontSize:14 width:(SCREEN_WIDTH-GapToLeft)]+10;
            height = height > (_cellHeight*3 -  (titlelab.frame.size.height+titlelab.frame.origin.y))?(_cellHeight*3 -  (titlelab.frame.size.height+titlelab.frame.origin.y)):height;
            UITextView *contentView = [[UITextView alloc] initWithFrame:CGRectMake(GapToLeft, (titlelab.frame.size.height+titlelab.frame.origin.y), SCREEN_WIDTH-GapToLeft, height)];
            contentView.editable = NO;
            contentView.scrollEnabled = NO;
            contentView.textColor = [UIColor whiteColor];
            contentView.font = [UIFont systemFontOfSize:14];
            contentView.text = str;
            contentView.backgroundColor = ItemsBaseColor;
            [cell addSubview:contentView];
        }
            break;
        case 2:
        {
            UILabel *sendTimetip = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, (SCREEN_WIDTH-60)/2 -20, _cellHeight/2)];
            sendTimetip.text = @"公布时间:";
            sendTimetip.textColor = [UIColor whiteColor];
            sendTimetip.font = [UIFont systemFontOfSize:14];
            [cell addSubview:sendTimetip];
            
            UILabel *sendTime = [[UILabel alloc] initWithFrame:CGRectMake(30, _cellHeight/2, (SCREEN_WIDTH-60)/2-20, _cellHeight/2)];
            sendTime.text = [[Toolkit judgeIsNull:[personMatchDetalDict valueForKey:@"EnrollTimeStart"]] substringToIndex:10];
            sendTime.textColor = YellowBlock;
            sendTime.font = [UIFont systemFontOfSize:14];
            [cell addSubview:sendTime];
            
            [Toolkit drawLine:SCREEN_WIDTH/2 +20 andSY:0 andEX:SCREEN_WIDTH/2-20 andEY:_cellHeight andLW:1 andColor:Separator_Color andView:cell];
            
            UILabel *startTimetip = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 +23, 0, (SCREEN_WIDTH-60)/2 , _cellHeight/2)];
            startTimetip.text = @"开始时间:";
            startTimetip.textColor = [UIColor whiteColor];
            startTimetip.font = [UIFont systemFontOfSize:14];
            [cell addSubview:startTimetip];
            
            UILabel *startTime = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 +23, _cellHeight/2, (SCREEN_WIDTH-60)/2, _cellHeight/2)];
            startTime.text = [[Toolkit judgeIsNull:[personMatchDetalDict valueForKey:@"MatchTimeStart"]] substringToIndex:10];;
            startTime.textColor = YellowBlock;
            startTime.font = [UIFont systemFontOfSize:14];
            [cell addSubview:startTime];
            
        }
            break;
        case 3:
        {
            UILabel *endTimetip = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, (SCREEN_WIDTH-60)/2-20, _cellHeight/2)];
            endTimetip.text = @"结束时间:";
            endTimetip.textColor = [UIColor whiteColor];
            endTimetip.font = [UIFont systemFontOfSize:14];
            [cell addSubview:endTimetip];
            
            UILabel *endTime = [[UILabel alloc] initWithFrame:CGRectMake(30, _cellHeight/2, (SCREEN_WIDTH-60)/2-20, _cellHeight/2)];
            endTime.text = [[Toolkit judgeIsNull:[personMatchDetalDict valueForKey:@"MatchTimeEnd"]] substringToIndex:10];
            endTime.textColor = YellowBlock;
            endTime.font = [UIFont systemFontOfSize:14];
            [cell addSubview:endTime];
            
            [Toolkit drawLine:SCREEN_WIDTH/2 -20 andSY:0 andEX:SCREEN_WIDTH/2+20 andEY:_cellHeight andLW:1 andColor:Separator_Color andView:cell];
            
            UILabel *deadlineTimetip = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 +20+3, 0, (SCREEN_WIDTH-60)/2, _cellHeight/2)];
            deadlineTimetip.text = @"报名截止:";
            deadlineTimetip.textColor = [UIColor whiteColor];
            deadlineTimetip.font = [UIFont systemFontOfSize:14];
            [cell addSubview:deadlineTimetip];
            
            UILabel *deadlineTime = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 +20+3, _cellHeight/2, (SCREEN_WIDTH-60)/2, _cellHeight/2)];
            deadlineTime.text = [[Toolkit judgeIsNull:[personMatchDetalDict valueForKey:@"EnrollTimeEnd"]] substringToIndex:10];
            deadlineTime.textColor = YellowBlock;
            deadlineTime.font = [UIFont systemFontOfSize:14];
            [cell addSubview:deadlineTime];
        }
            break;
        case 4:
        {
            UILabel *titlelab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 0, SCREEN_WIDTH-GapToLeft, _cellHeight/2)];
            titlelab.text = @"赛事要求：";
            titlelab.textColor = [UIColor whiteColor];
            titlelab.font = [UIFont systemFontOfSize:16];
            [cell addSubview:titlelab];
            
            NSString *str = [Toolkit judgeIsNull:[personMatchDetalDict valueForKey:@"MatchRule"]];//@"让全球玩家通过形神兼备的武功招式、手脑并用的立体激斗，领略到一个融视、听、感为一体的武侠江湖，让所有参与者在精彩的世界电竞盛会中感受武侠和武术文化的独特魅力，最终将武侠这一独特的东方文化发扬、传播至全球";
            
            CGFloat height = [Toolkit heightWithString:str fontSize:14 width:SCREEN_WIDTH-GapToLeft]+10;
            height = height > (_cellHeight*3 -  (titlelab.frame.size.height+titlelab.frame.origin.y - _cellHeight))?(_cellHeight*3 -  (titlelab.frame.size.height+titlelab.frame.origin.y)- _cellHeight):height;
            UITextView *contentView = [[UITextView alloc] initWithFrame:CGRectMake(GapToLeft, (titlelab.frame.size.height+titlelab.frame.origin.y), SCREEN_WIDTH-GapToLeft, height)];
            contentView.editable = NO;
            contentView.scrollEnabled = NO;
            contentView.textColor = [UIColor whiteColor];
            contentView.font = [UIFont systemFontOfSize:14];
            contentView.text = str;
            contentView.backgroundColor = ItemsBaseColor;
            [cell addSubview:contentView];
            if (_mushaMatchDetailMode == Mode_MushaNoStart) {
                UIButton *actionBtn =[[UIButton alloc] initWithFrame:CGRectMake(GapToLeft, (contentView.frame.size.height + contentView.frame.origin.y + 10), (SCREEN_WIDTH -GapToLeft*2 -50)/2, _cellHeight )];
                actionBtn.backgroundColor = BACKGROUND_COLOR;
                [actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                if ([_isApply isEqual:@"1"]) {
                    [actionBtn setTitle:@"我的视频" forState:UIControlStateNormal];
                    [actionBtn addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    [actionBtn setTitle:@"我要报名" forState:UIControlStateNormal];
                    [actionBtn addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                }
                actionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [cell addSubview:actionBtn];
                
                
                UIButton *checkBtn =[[UIButton alloc] initWithFrame:CGRectMake((actionBtn.frame.size.width+actionBtn.frame.origin.x +50), (contentView.frame.size.height + contentView.frame.origin.y + 10), (SCREEN_WIDTH -GapToLeft*2 -50)/2, _cellHeight)];
                checkBtn.backgroundColor = BACKGROUND_COLOR;
                [checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [checkBtn setTitle:@"查看报名选手" forState:UIControlStateNormal];
                [checkBtn addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                checkBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [cell addSubview:checkBtn];
            }else if (_mushaMatchDetailMode == Mode_MushaGoing) {
                UIButton *actionBtn =[[UIButton alloc] initWithFrame:CGRectMake(GapToLeft, (contentView.frame.size.height + contentView.frame.origin.y + 10), (SCREEN_WIDTH -GapToLeft*2 -50)/2, _cellHeight )];
                actionBtn.backgroundColor = BACKGROUND_COLOR;
                [actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [actionBtn setTitle:@"我的视频" forState:UIControlStateNormal];
                [actionBtn addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                actionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [cell addSubview:actionBtn];
                
                
                UIButton *checkBtn =[[UIButton alloc] initWithFrame:CGRectMake((actionBtn.frame.size.width+actionBtn.frame.origin.x +50), (contentView.frame.size.height + contentView.frame.origin.y + 10), (SCREEN_WIDTH -GapToLeft*2 -50)/2, _cellHeight)];
                checkBtn.backgroundColor = BACKGROUND_COLOR;
                [checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [checkBtn setTitle:@"查看报名选手" forState:UIControlStateNormal];
                [checkBtn addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                checkBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [cell addSubview:checkBtn];
            }
            else if (_mushaMatchDetailMode == Mode_MushaEnd){
                UIButton *actionBtn =[[UIButton alloc] initWithFrame:CGRectMake(GapToLeft, (contentView.frame.size.height + contentView.frame.origin.y + 10), (SCREEN_WIDTH -GapToLeft*2 -50)/2, _cellHeight )];
                actionBtn.backgroundColor = [UIColor colorWithRed:0.24 green:0.24 blue:0.25 alpha:1];
                [actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [actionBtn setTitle:@"活动结束" forState:UIControlStateNormal];
                actionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [cell addSubview:actionBtn];
                
                
                UIButton *checkBtn =[[UIButton alloc] initWithFrame:CGRectMake((actionBtn.frame.size.width+actionBtn.frame.origin.x +50), (contentView.frame.size.height + contentView.frame.origin.y + 10), (SCREEN_WIDTH -GapToLeft*2 -50)/2, _cellHeight)];
                checkBtn.backgroundColor = [UIColor colorWithRed:0.51 green:0.51 blue:0.51 alpha:1];
                [checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [checkBtn setTitle:@"投票排名" forState:UIControlStateNormal];
                [checkBtn addTarget:self action:@selector(voteEvent) forControlEvents:UIControlEventTouchUpInside];
                checkBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [cell addSubview:checkBtn];
            }
            else if(_mushaMatchDetailMode == Mode_TeamNoStart){
                UIButton *connectPhone = [[UIButton alloc] initWithFrame:CGRectMake(GapToLeft, (contentView.frame.size.height + contentView.frame.origin.y + 10), SCREEN_WIDTH -GapToLeft*2, _cellHeight)];
                connectPhone.backgroundColor = BACKGROUND_COLOR;
                [connectPhone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [connectPhone setTitle:@"联系电话" forState:UIControlStateNormal];
                connectPhone.titleLabel.font = [UIFont systemFontOfSize:14];
                [connectPhone addTarget:self action:@selector(connectPhoneClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:connectPhone];
            }else if (_mushaMatchDetailMode == Mode_TeamGoing) {
                UIButton *actionBtn =[[UIButton alloc] initWithFrame:CGRectMake(GapToLeft, (contentView.frame.size.height + contentView.frame.origin.y + 10), (SCREEN_WIDTH -GapToLeft*2 -50)/2, _cellHeight )];
                actionBtn.backgroundColor = BACKGROUND_COLOR;
                [actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [actionBtn setTitle:@"战队视频" forState:UIControlStateNormal];
                [actionBtn addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                actionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [cell addSubview:actionBtn];
                
                UIButton *checkBtn =[[UIButton alloc] initWithFrame:CGRectMake((actionBtn.frame.size.width+actionBtn.frame.origin.x +50), (contentView.frame.size.height + contentView.frame.origin.y + 10), (SCREEN_WIDTH -GapToLeft*2 -50)/2, _cellHeight)];
                checkBtn.backgroundColor = BACKGROUND_COLOR;
                [checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [checkBtn setTitle:@"查看报名战队" forState:UIControlStateNormal];
                [checkBtn addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                checkBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [cell addSubview:checkBtn];
            }else if (_mushaMatchDetailMode == Mode_TeamEnd){
                UIButton *actionBtn =[[UIButton alloc] initWithFrame:CGRectMake(GapToLeft, (contentView.frame.size.height + contentView.frame.origin.y + 10), (SCREEN_WIDTH -GapToLeft*2 -50)/2, _cellHeight )];
                actionBtn.backgroundColor = [UIColor colorWithRed:0.24 green:0.24 blue:0.25 alpha:1];
                [actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [actionBtn setTitle:@"活动结束" forState:UIControlStateNormal];
                actionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [cell addSubview:actionBtn];
                
                
                UIButton *checkBtn =[[UIButton alloc] initWithFrame:CGRectMake((actionBtn.frame.size.width+actionBtn.frame.origin.x +50), (contentView.frame.size.height + contentView.frame.origin.y + 10), (SCREEN_WIDTH -GapToLeft*2 -50)/2, _cellHeight)];
                checkBtn.backgroundColor = [UIColor colorWithRed:0.51 green:0.51 blue:0.51 alpha:1];
                [checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [checkBtn setTitle:@"投票排名" forState:UIControlStateNormal];
                [checkBtn addTarget:self action:@selector(voteTeamEvent) forControlEvents:UIControlEventTouchUpInside];
                checkBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [cell addSubview:checkBtn];
            }
        }
            break;
        default:
            break;
    }
    return cell;
    
}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            return _cellHeight*5 + 10;
            break;
        case 1:{
            NSString *str = [Toolkit judgeIsNull:[personMatchDetalDict valueForKey:@"Introduction"]];//@"让全球玩家通过形神兼备的武功招式、手脑并用的立体激斗，领略到一个融视、听、感为一体的武侠江湖，让所有参与者在精彩的世界电竞盛会中感受武侠和武术文化的独特魅力，最终将武侠这一独特的东方文化发扬、传播至全球";
            
            CGFloat height = [Toolkit heightWithString:str fontSize:14 width:SCREEN_WIDTH-GapToLeft]+10;
            return height + _cellHeight/2 + 10;
        }
            break;
        case 2:
            return _cellHeight;
            break;
        case 3:
            return _cellHeight;
            break;
        case 4:{
            NSString *str = [Toolkit judgeIsNull:[personMatchDetalDict valueForKey:@"MatchRule"]];//@"让全球玩家通过形神兼备的武功招式、手脑并用的立体激斗，领略到一个融视、听、感为一体的武侠江湖，让所有参与者在精彩的世界电竞盛会中感受武侠和武术文化的独特魅力，最终将武侠这一独特的东方文化发扬、传播至全球";
            
            CGFloat height = [Toolkit heightWithString:str fontSize:14 width:SCREEN_WIDTH-GapToLeft]+10;
            return height + _cellHeight/2 + 10 + _cellHeight + 10;
        }
            break;
        default:
            break;
    }
    
    return _cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    NSLog(@"click cell section : %ld row : %ld",(long)indexPath.section,(long)indexPath.row);
    

    
}


//设置划动cell是否出现del按钮，可供删除数据里进行处理

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

- (UITableViewCellEditingStyle)tableView: (UITableView *)tableView editingStyleForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  YES;
}


-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  @"删除";
}

//设置选中的行所执行的动作

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return indexPath;
    
}

#pragma mark - setting for section
//设置section的header view

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView = [[UIView alloc] init];
    return tempView;
}

//设置section header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

//设置section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
    
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
