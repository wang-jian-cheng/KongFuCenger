//
//  KongFuUnionViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/3.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "KongFuUnionViewController.h"
#import "JHStoryViewController.h"
#import "RecruitComment.h"
#import "MushaMatch.h"
#import "JoinTeamViewController.h"
#import "MakeMushaViewController.h"
#import "ErWeiMaViewController.h"
#import "UnionNewsViewController.h"
#import "TeamNewsViewController.h"
#import "WYNewsViewController.h"
#import "ChatListViewController.h"
#import "MyFriendViewController.h"
#import "WZLBadgeImport.h"
#import "UIView+Frame.h"

@interface KongFuUnionViewController ()
{
    //tableview参数
    CGFloat _cellHeight;
    UITableView *_mainTableView;
    UIButton *noReadNumTxt;
    NSUserDefaults *userDefault;
}
@end

@implementation KongFuUnionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _cellHeight = SCREEN_HEIGHT / 12;
    [self setBarTitle:@"功夫圈"];
    [self addLeftButton:@"wdwy"];
    [self addRightButton:@"chat_icon"];
    userDefault = [NSUserDefaults standardUserDefaults];
    _imgLeft.frame = CGRectMake(_btnLeft.frame.origin.x + 10, (NavigationBar_HEIGHT - 25) / 2 + StatusBar_HEIGHT, 25, 25);
    _imgRight.frame = CGRectMake(_btnRight.frame.origin.x + 25, (NavigationBar_HEIGHT - 25) / 2 + StatusBar_HEIGHT, 25, 25);
    [self initViews];
}

-(void)initViews
{
    int noReadNum = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
    if (noReadNum != 0 && noReadNum != -1) {
        [self initNoReadMessageView:noReadNum];
    }
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height - TabBar_HEIGHT)];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.backgroundColor = BACKGROUND_COLOR;
    _mainTableView.separatorColor =  Separator_Color;
    _mainTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_mainTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMessageNum) name:@"updateMessageNum" object:nil];
}

-(void)initNoReadMessageView:(int)noReadNum{
    if (noReadNum > 99) {
        noReadNumTxt = [[UIButton alloc] initWithFrame:CGRectMake(_btnRight.frame.size.width - 22, 0, 24, 24)];
    }else{
        noReadNumTxt = [[UIButton alloc] initWithFrame:CGRectMake(_btnRight.frame.size.width - 20, 0, 21, 21)];
    }
    noReadNumTxt.backgroundColor = [UIColor redColor];
    noReadNumTxt.userInteractionEnabled = NO;
    [noReadNumTxt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    noReadNumTxt.titleLabel.font = [UIFont systemFontOfSize:11];
    [noReadNumTxt setTitle:noReadNum > 99?@"99+":[NSString stringWithFormat:@"%d",noReadNum] forState:UIControlStateNormal];
    noReadNumTxt.layer.cornerRadius = noReadNumTxt.frame.size.width / 2;
    noReadNumTxt.layer.masksToBounds = YES;
    [_btnRight addSubview:noReadNumTxt];
    
    DLog(@"%@",noReadNumTxt.titleLabel.text);
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showTabBar];
    
    [self updateMessageNum];
    
    [self initNoReadMessageNum];
    
    [self SelectNoReadMatch];
}

-(void)initNoReadMessageNum{
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getNoReadMessageInfo:"];
    [dataProvider GetNoReadCommentNumByUserId:get_sp(@"id")];
}

-(void)getNoReadMessageInfo:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        [userDefault setValue:[NSString stringWithFormat:@"%@%@",Url,dict[@"data"]] forKey:@"endReadUserPhoto"];
        [userDefault setValue:dict[@"count"] forKey:@"noReadMessageNum"];
        [_mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(void)updateMessageNum{
    int noReadNum = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
    if (noReadNum != 0 && noReadNum != -1) {
        [self initNoReadMessageView:noReadNum];
    }else{
        for (id view in _btnRight.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                [view removeFromSuperview];
            }
        }
    }
}

-(void)SelectNoReadMatch{
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"selectNoReadMatchNumCallBack:"];
    [dataProvider SelectNoReadMatch:get_sp(@"id")];
}

-(void)selectNoReadMatchNumCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        [userDefault setValue:dict[@"count"] forKey:@"NoReadMatchNum"];
        [_mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(void)clickLeftButton:(UIButton *)sender{
    MyFriendViewController *myFriendVC = [[MyFriendViewController alloc] init];
    [self.navigationController pushViewController:myFriendVC animated:YES];
}

-(void)clickRightButton:(UIButton *)sender{
    ChatListViewController *chatListVC = [[ChatListViewController alloc] init];
    [self.navigationController pushViewController:chatListVC animated:YES];
}

#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

//指定每个分区中有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 3;
    }else if(section == 1){
        return 2;
    }else if(section == 2){
        return 3;
    }else{
        return 1;
    }
}

#pragma mark - setting for cell
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _cellHeight)];
    cell.backgroundColor = ItemsBaseColor;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self setCell:cell andImg:@"wydt" andName:@"武者动态"];
        }else if(indexPath.row == 1){
            [self setCell:cell andImg:@"zddt" andName:@"战队动态"];
        }else{
            [self setCell:cell andImg:@"lmdt" andName:@"联盟动态"];
        }
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            [self setCell:cell andImg:@"jjwz" andName:@"结交武者"];
        }else{
            [self setCell:cell andImg:@"jrzd" andName:@"加入战队"];
        }
    }else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            [self setCell:cell andImg:@"wzss" andName:@"武者大赛"];
        }else if(indexPath.row == 1){
            [self setCell:cell andImg:@"jhgs" andName:@"行业资讯"];
        }else{
            [self setCell:cell andImg:@"zphz" andName:@"招聘合作"];
        }
    }else{
        [self setCell:cell andImg:@"sys" andName:@"扫一扫"];
    }
    return cell;
    
}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            WYNewsViewController *wyNewsVC = [[WYNewsViewController alloc] init];
            [self.navigationController pushViewController:wyNewsVC animated:YES];
        }else if(indexPath.row == 1){
            
            NSString *value = get_sp(@"TeamId");
            if(value == nil || value.length == 0||[value isEqualToString:@"0"])
            {
                UIAlertView *alertView = [[UIAlertView alloc ] initWithTitle:@"未加入战队" message:@"还没有加入战队呦～～" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
                return;
            }
            
            TeamNewsViewController *teamNewsVC = [[TeamNewsViewController alloc] init];
            [self.navigationController pushViewController:teamNewsVC animated:YES];
        }else{
            UnionNewsViewController *unionNewsVC = [[UnionNewsViewController alloc] init];
            [self.navigationController pushViewController:unionNewsVC animated:YES];
        }
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            MakeMushaViewController *makeMushaVC = [[MakeMushaViewController alloc] init];
            [self.navigationController pushViewController:makeMushaVC animated:YES];
        }else if (indexPath.row == 1){
            JoinTeamViewController *joinTeamVC = [[JoinTeamViewController alloc] init];
            [self.navigationController pushViewController:joinTeamVC animated:YES];
        }
    }else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            MushaMatch *mushaMatchVC = [[MushaMatch alloc] init];
            [self.navigationController pushViewController:mushaMatchVC animated:YES];
        }else if(indexPath.row == 1){
            JHStoryViewController *jhStoryVC = [[JHStoryViewController alloc] init];
            [self.navigationController pushViewController:jhStoryVC animated:YES];
        }else if(indexPath.row == 2){
            RecruitComment *recruitCommentVC = [[RecruitComment alloc] init];
            [self.navigationController pushViewController:recruitCommentVC animated:YES];
        }
    }else if(indexPath.section == 3){
        ErWeiMaViewController * erweima=[[ErWeiMaViewController alloc] initWithNibName:@"ErWeiMaViewController" bundle:[NSBundle mainBundle]];
        
        [self.navigationController pushViewController:erweima animated:YES];
    }
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
    if(section == 0){
        return 10;
    }else{
        return 8;
    }
}

#pragma mark - 自定义方法

-(void)setCell:(UITableViewCell *)cell andImg:(NSString *)img andName:(NSString *)name{
    
    //图标
    UIImageView *img_icon;
    if (img_icon == nil) {
        img_icon = [[UIImageView alloc] initWithFrame:CGRectMake(14, 0, 20, cell.frame.size.height)];
        img_icon.contentMode = UIViewContentModeScaleAspectFit;
        img_icon.image = [UIImage imageNamed:img];
    }
    [cell addSubview:img_icon];
    
    //名称
    UILabel *lbl_name;
    if (lbl_name == nil) {
        lbl_name = [[UILabel alloc] initWithFrame:CGRectMake(img_icon.frame.origin.x + img_icon.frame.size.width + 5, 0, 100, cell.frame.size.height)];
        lbl_name.textColor = [UIColor whiteColor];
        lbl_name.font = [UIFont systemFontOfSize:18];
    }
    lbl_name.text = name;
    
    if ([name isEqual:@"武者动态"]) {
        NSLog(@"%@",[userDefault valueForKey:@"noReadMessageNum"]);
        [lbl_name showBadgeWithStyle:WBadgeStyleNumber value:[[userDefault valueForKey:@"noReadMessageNum"] intValue] animationType:WBadgeAnimTypeNone];
        lbl_name.badge.x = lbl_name.badge.x - 20;
        lbl_name.badge.y = 8;
    }
    
    if ([name isEqual:@"武者大赛"]) {
        [lbl_name showBadgeWithStyle:WBadgeStyleNumber value:[[userDefault valueForKey:@"NoReadMatchNum"] intValue] animationType:WBadgeAnimTypeNone];
        lbl_name.badge.x = lbl_name.badge.x - 20;
        lbl_name.badge.y = 8;
    }
    
    [cell addSubview:lbl_name];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

@end
