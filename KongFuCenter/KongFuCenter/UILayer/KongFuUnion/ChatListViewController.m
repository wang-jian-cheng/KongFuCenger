//
//  ChatListViewController.m
//  KongFuCenter
//
//  Created by Rain on 15/12/15.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "ChatListViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "ChatContentViewController.h"
#import "MyFriendViewController.h"
#import "MakeMushaViewController.h"

@interface ChatListViewController (){
    UIView *topView;
    NSUserDefaults *userDefault;
    NSArray *friendArray;
    ChatContentViewController *conversationVC;
}

@end

@implementation ChatListViewController

- (void)viewDidLoad {
    
    //重写显示相关的接口，必须先调用super，否则会屏蔽SDK默认的处理
    [super viewDidLoad];
    
    userDefault = [NSUserDefaults standardUserDefaults];
    friendArray = [[NSArray alloc] init];
    
    //设置要显示的会话类型
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_GROUP)]];
    
    //设置cell的背景颜色
    self.cellBackgroundColor = [UIColor colorWithRed:0.16 green:0.16 blue:0.18 alpha:1];
    
    //聚合会话类型
    //[self setCollectionConversationType:@[@(ConversationType_GROUP)]];
    
    [self initView];
    
}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    conversationVC = [[ChatContentViewController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.userName = model.conversationTitle;
    conversationVC.mTitle = model.conversationTitle;
//    if (conversationVC.conversationType == ConversationType_PRIVATE) {
//        conversationVC.displayUserNameInCell = NO;
//    }else{
//        conversationVC.displayUserNameInCell = YES;
//    }
    
//    if ([model.conversationTitle isEqual:@"陌生人"]) {
//        [SVProgressHUD showWithStatus:@""];
//        DataProvider *dataProvider = [[DataProvider alloc] init];
//        [dataProvider setDelegateObject:self setBackFunctionName:@"getUserInfo:"];
//        [dataProvider getUserInfo:model.targetId];
//    }else{
//        [self.navigationController pushViewController:conversationVC animated:YES];
//    }
    
    [self.navigationController pushViewController:conversationVC animated:YES];
}

-(void)getUserInfo:(id)dict{
    [SVProgressHUD dismiss];
    if ([dict[@"code"] intValue] == 200) {
        NSLog(@"%@",dict);
        conversationVC.mHeadImage = [Toolkit judgeIsNull:[dict[@"data"] valueForKey:@"PhotoPath"]];
        conversationVC.mName = [Toolkit judgeIsNull:[dict[@"data"] valueForKey:@"NicName"]];
        [self.navigationController pushViewController:conversationVC animated:YES];
    }
}

- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    RCConversationCell *messageCell = (RCConversationCell*)cell;
    messageCell.conversationTitle.textColor = [UIColor whiteColor];
}

-(void)viewDidAppear:(BOOL)animated{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

#pragma mark - 自定义方法

-(void)initView{
    NSLog(@"%@",[userDefault valueForKey:@"sound"]);
    if ([userDefault valueForKey:@"sound"]) {
        [RCIM sharedRCIM].disableMessageAlertSound = [[userDefault valueForKey:@"sound"] isEqual:@"1"]?NO:YES;
    }else{
        [RCIM sharedRCIM].disableMessageAlertSound = NO;
    }
    
    if ([userDefault valueForKey:@"chat"]) {
        [RCIM sharedRCIM].disableMessageNotificaiton = [[userDefault valueForKey:@"chat"] isEqual:@"1"]?NO:YES;
    }else{
        [RCIM sharedRCIM].disableMessageNotificaiton = NO;
    }
    
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavigationBar_HEIGHT + StatusBar_HEIGHT)];
    topView.backgroundColor = navi_bar_bg_color;
    [self.view addSubview:topView];
    
    UILabel *mTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, StatusBar_HEIGHT + (NavigationBar_HEIGHT - 21) / 2, SCREEN_WIDTH, 21)];
    mTitle.textAlignment = NSTextAlignmentCenter;
    mTitle.textColor = [UIColor whiteColor];
    mTitle.text = @"会话列表";
    [topView addSubview:mTitle];
    
    UIButton *leftTitle = [[UIButton alloc] initWithFrame:CGRectMake(14, StatusBar_HEIGHT + (NavigationBar_HEIGHT - 20) / 2, 20, 20)];
    [leftTitle setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [leftTitle addTarget:self action:@selector(clickLeftBtn) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:leftTitle];
    
    UIButton *rightTitle = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30, StatusBar_HEIGHT + (NavigationBar_HEIGHT - 20) / 2, 20, 20)];
    [rightTitle setImage:[UIImage imageNamed:@"wdwy"] forState:UIControlStateNormal];
    rightTitle.tag = 0;
    [rightTitle addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:rightTitle];
    
    //UIButton *rightTitleGroup = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, StatusBar_HEIGHT + (NavigationBar_HEIGHT - 20) / 2, 40, 20)];
//    [rightTitleGroup setTitle:@"群组" forState:UIControlStateNormal];
//    rightTitleGroup.tag = 1;
//    [rightTitleGroup addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [topView addSubview:rightTitleGroup];
    
    UITableView *listTableView = self.conversationListTableView;
    listTableView.frame = CGRectMake(0, NavigationBar_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_HEIGHT);
    listTableView.tableFooterView = [[UIView alloc] init];
    listTableView.backgroundColor = BACKGROUND_COLOR;
    
    [self.emptyConversationView removeFromSuperview];
}

-(void)clickLeftBtn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickRightBtn:(UIButton *)btn{
    if (btn.tag == 0) {
        //新建一个聊天会话View Controller对象
//        ChatContentViewController *chat = [[ChatContentViewController alloc]init];
//        //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众账号等
//        chat.conversationType = ConversationType_PRIVATE;
//        //设置会话的目标会话ID。（单聊、客服、公众账号服务为对方的ID，讨论组、群聊、聊天室为会话的ID）
//        chat.targetId = [NSString stringWithFormat:@"%@",[userDefault valueForKey:@"id"]];
//        chat.userName = @"nihao";
//        //设置聊天会话界面要显示的标题
//        chat.title = @"想显示的会话标题";
//        //显示聊天会话界面
//        [self.navigationController pushViewController:chat animated:YES];
        
        //获取好友信息
        [SVProgressHUD showWithStatus:@"加载中"];
        DataProvider *dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"getFriendBackCall:"];
        [dataProvider getFriendForKeyValue:[userDefault valueForKey:@"id"]];
    }else{
//        //新建一个聊天会话View Controller对象
//        ChatContentViewController *chat = [[ChatContentViewController alloc]init];
//        //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众账号等
//        chat.conversationType = ConversationType_GROUP;
//        //设置会话的目标会话ID。（单聊、客服、公众账号服务为对方的ID，讨论组、群聊、聊天室为会话的ID）
//        chat.targetId = [NSString stringWithFormat:@"%@",[userDefault valueForKey:@"TeamId"]];
//        //设置聊天会话界面要显示的标题
//        chat.title = @"想显示的会话标题";
//        //显示聊天会话界面
//        [self.navigationController pushViewController:chat animated:YES];
    }
}

-(void)getFriendBackCall:(id)dict{
    [SVProgressHUD dismiss];
    if ([dict[@"code"] intValue] == 200) {
        friendArray = dict[@"data"];
        if (friendArray.count > 0) {
            MyFriendViewController *myFriendVC = [[MyFriendViewController alloc] init];
            [self.navigationController pushViewController:myFriendVC animated:YES];
        }else{
            MakeMushaViewController *makeMushaVC = [[MakeMushaViewController alloc] init];
            [self.navigationController pushViewController:makeMushaVC animated:YES];
        }
    }
}

@end
