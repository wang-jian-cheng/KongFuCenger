//
//  MushaMatchDetailGoingViewController.m
//  KongFuCenter
//
//  Created by Rain on 16/1/7.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "MushaMatchDetailGoingViewController.h"
#import "UIImageView+WebCache.h"
#import "PlayerForMatchViewController.h"
#import "VideoDetailForMatchViewController.h"
#import "MushaMatchOngoingViewController.h"

@interface MushaMatchDetailGoingViewController (){
    UITableView *mTableView;
    NSDictionary *personMatchDetalDict;
}

@end

@implementation MushaMatchDetailGoingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化参数
    self.view.backgroundColor = BACKGROUND_COLOR;
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
    [SVProgressHUD showWithStatus:@"加载中..."];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getPersonMatchDetailCallBack:"];
    [dataProvider SelectMatchDetail:_matchId];
}

-(void)getPersonMatchDetailCallBack:(id)dict{
    [SVProgressHUD dismiss];
    if ([dict[@"code"] intValue] == 200) {
        personMatchDetalDict = [[NSDictionary alloc] initWithDictionary:dict[@"data"]];
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

-(CGFloat)heightWithString:(NSString*)string fontSize:(CGFloat)fontSize width:(CGFloat)width
{
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    return  [string boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size.height + 10;
}

-(void)myVideoEvent{
    VideoDetailForMatchViewController *videoViewCtl = [[VideoDetailForMatchViewController alloc] init];
    videoViewCtl.navtitle = @"大赛个人详情";
    [self.navigationController pushViewController:videoViewCtl animated:YES];
}

-(void)myVideoTeamEvent{
    VideoDetailForMatchViewController *videoViewCtl = [[VideoDetailForMatchViewController alloc] init];
    videoViewCtl.navtitle = @"战队详情";
    [self.navigationController pushViewController:videoViewCtl animated:YES];
}

-(void)playerDetail{
    PlayerForMatchViewController *playForMatchViewCtl = [[PlayerForMatchViewController alloc] init];
    playForMatchViewCtl.navtitle = @"参赛成员";
    playForMatchViewCtl.matchId = _matchId;
    [self.navigationController pushViewController:playForMatchViewCtl animated:YES];
}

-(void)playerTeamDetail{
    PlayerForMatchViewController *playForMatchViewCtl = [[PlayerForMatchViewController alloc] init];
    playForMatchViewCtl.navtitle = @"参赛战队";
    playForMatchViewCtl.matchId = _matchId;
    [self.navigationController pushViewController:playForMatchViewCtl animated:YES];
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

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else if (section == 1){
        return 1;
    }else{
        return 2;
    }
}

#pragma mark setting for section
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    }else if (section == 2){
        return 12;
    }else{
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

#pragma mark setting for cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    cell.backgroundColor = ItemsBaseColor;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
            NSString *MatchImage = [Toolkit judgeIsNull:[personMatchDetalDict valueForKey:@"MatchImage"]];
            NSString *url = [NSString stringWithFormat:@"%@%@",Url,MatchImage];
            [headImg sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"yewenback"]];
            [cell addSubview:headImg];
        }else if (indexPath.row == 1){
            UILabel *hdxqTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 21)];
            hdxqTitle.textColor = [UIColor whiteColor];
            hdxqTitle.font = [UIFont systemFontOfSize:18];
            hdxqTitle.text = @"活动详情:";
            [cell addSubview:hdxqTitle];
            
            UITextView *hdxqContent = [[UITextView alloc] initWithFrame:CGRectMake(10, 10 + 21 + 6, SCREEN_WIDTH - 20, [self heightWithString:[Toolkit judgeIsNull:[personMatchDetalDict valueForKey:@"Introduction"]] fontSize:15 width:SCREEN_WIDTH - 20])];
            hdxqContent.editable = NO;
            hdxqContent.scrollEnabled = NO;
            hdxqContent.backgroundColor = ItemsBaseColor;
            hdxqContent.textColor = [UIColor whiteColor];
            hdxqContent.font = [UIFont systemFontOfSize:15];
            hdxqContent.text = [Toolkit judgeIsNull:[personMatchDetalDict valueForKey:@"Introduction"]];
            [cell addSubview:hdxqContent];
        }
    }else if (indexPath.section == 1){
        UILabel *matchStartDateLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 21)];
        matchStartDateLbl.textColor = [UIColor whiteColor];
        matchStartDateLbl.text = @"赛事时间:";
        [cell addSubview:matchStartDateLbl];
        UILabel *matchStartDate = [[UILabel alloc] initWithFrame:CGRectMake(20, 10 + 21 + 5, 120, 21)];
        matchStartDate.textColor = [UIColor whiteColor];
        matchStartDate.text = [[Toolkit judgeIsNull:[personMatchDetalDict valueForKey:@"MatchTimeStart"]] substringToIndex:10];
        [cell addSubview:matchStartDate];
        
        cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, 67);
        [Toolkit drawLine:SCREEN_WIDTH/2 andSY:0 andEX:SCREEN_WIDTH/2 - 20 andEY:67 andLW:1 andColor:Separator_Color andView:cell];
        
        UILabel *enrollEndDateLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 + 20, 10, 100, 21)];
        enrollEndDateLbl.textColor = [UIColor whiteColor];
        enrollEndDateLbl.text = @"报名截止:";
        [cell addSubview:enrollEndDateLbl];
        UILabel *enrollEndDate = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 + 20, 10 + 21 + 5, 100, 21)];
        enrollEndDate.textColor = [UIColor whiteColor];
        enrollEndDate.text = [[Toolkit judgeIsNull:[personMatchDetalDict valueForKey:@"EnrollTimeEnd"]] substringToIndex:10];
        [cell addSubview:enrollEndDate];
    }else{
        if (indexPath.row == 0) {
            UILabel *ssyqTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 21)];
            ssyqTitle.textColor = [UIColor whiteColor];
            ssyqTitle.font = [UIFont systemFontOfSize:18];
            ssyqTitle.text = @"赛事要求:";
            [cell addSubview:ssyqTitle];
            
            UITextView *ssyqContent = [[UITextView alloc] initWithFrame:CGRectMake(10, 10 + 21 + 6, SCREEN_WIDTH - 20, [self heightWithString:[Toolkit judgeIsNull:[personMatchDetalDict valueForKey:@"MatchRule"]] fontSize:15 width:SCREEN_WIDTH - 20])];
            ssyqContent.editable = NO;
            ssyqContent.scrollEnabled = NO;
            ssyqContent.backgroundColor = ItemsBaseColor;
            ssyqContent.textColor = [UIColor whiteColor];
            ssyqContent.font = [UIFont systemFontOfSize:15];
            ssyqContent.text = [Toolkit judgeIsNull:[personMatchDetalDict valueForKey:@"MatchRule"]];
            [cell addSubview:ssyqContent];
        }else{
            UIButton *myVideoBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 10, SCREEN_WIDTH / 2 - 10, 40)];
            myVideoBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            myVideoBtn.layer.cornerRadius = 8;
            myVideoBtn.layer.masksToBounds = YES;
            [cell addSubview:myVideoBtn];
            
            UIButton *playerDetail = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 + 5, 10, SCREEN_WIDTH / 2 - 10, 40)];
            playerDetail.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            playerDetail.backgroundColor = [UIColor whiteColor];
            [playerDetail setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            playerDetail.layer.cornerRadius = 8;
            playerDetail.layer.masksToBounds = YES;
            
            if (_mushaMatchDetailGoingMode == Mode_MushaGoing) {
                [myVideoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                myVideoBtn.backgroundColor = [UIColor whiteColor];
                [myVideoBtn setTitle:@"我的视频" forState:UIControlStateNormal];
                [myVideoBtn addTarget:self action:@selector(myVideoEvent) forControlEvents:UIControlEventTouchUpInside];
                
                [playerDetail setTitle:@"已报名选手详情" forState:UIControlStateNormal];
                [playerDetail addTarget:self action:@selector(playerDetail) forControlEvents:UIControlEventTouchUpInside];
            }else if(_mushaMatchDetailGoingMode == Mode_MushaEnd){
                [myVideoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                myVideoBtn.backgroundColor = [UIColor grayColor];
                [myVideoBtn setTitle:@"活动结束" forState:UIControlStateNormal];
                //[myVideoBtn addTarget:self action:@selector(activityEvent) forControlEvents:UIControlEventTouchUpInside];
                
                [playerDetail setTitle:@"投票结果" forState:UIControlStateNormal];
                [playerDetail addTarget:self action:@selector(voteEvent) forControlEvents:UIControlEventTouchUpInside];
            }else if(_mushaMatchDetailGoingMode == Mode_TeamOnGoing){
                [myVideoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                myVideoBtn.backgroundColor = [UIColor whiteColor];
                [myVideoBtn setTitle:@"战队视频" forState:UIControlStateNormal];
                [myVideoBtn addTarget:self action:@selector(myVideoTeamEvent) forControlEvents:UIControlEventTouchUpInside];
                
                [playerDetail setTitle:@"已报名战队详情" forState:UIControlStateNormal];
                [playerDetail addTarget:self action:@selector(playerTeamDetail) forControlEvents:UIControlEventTouchUpInside];
            }else if(_mushaMatchDetailGoingMode == Mode_TeamEnd){
                [myVideoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                myVideoBtn.backgroundColor = [UIColor grayColor];
                [myVideoBtn setTitle:@"活动结束" forState:UIControlStateNormal];
                //[myVideoBtn addTarget:self action:@selector(activityEvent) forControlEvents:UIControlEventTouchUpInside];
                
                [playerDetail setTitle:@"投票结果" forState:UIControlStateNormal];
                [playerDetail addTarget:self action:@selector(voteTeamEvent) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [cell addSubview:playerDetail];
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if (indexPath.row == 0) {
            return 200;
        }else{
            return [self heightWithString:[Toolkit judgeIsNull:[personMatchDetalDict valueForKey:@"Introduction"]] fontSize:15 width:SCREEN_WIDTH - 20] + 20 + 21 + 8;
        }
    }else if (indexPath.section == 1){
        return 67;
    }else{
        if (indexPath.row == 0) {
            return [self heightWithString:[Toolkit judgeIsNull:[personMatchDetalDict valueForKey:@"MatchRule"]] fontSize:15 width:SCREEN_WIDTH - 20] + 20 + 21 + 8;
        }else{
            return 60;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [mTableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
