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

@interface ChatListViewController ()<RCIMUserInfoDataSource>{
    UIView *topView;
    NSUserDefaults *userDefault;
}

@end

@implementation ChatListViewController

- (void)viewDidLoad {
    
    //重写显示相关的接口，必须先调用super，否则会屏蔽SDK默认的处理
    [super viewDidLoad];
    
    userDefault = [NSUserDefaults standardUserDefaults];
    
    //设置要显示的会话类型
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_GROUP)]];
    
    //聚合会话类型
    [self setCollectionConversationType:@[@(ConversationType_GROUP)]];
    
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    
    [self initView];
    
}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    ChatContentViewController *conversationVC = [[ChatContentViewController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.userName = model.conversationTitle;
    conversationVC.displayUserNameInCell = NO;
    [self.navigationController pushViewController:conversationVC animated:YES];
}

-(void)initView{
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
    
    UIButton *rightTitle = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 90, StatusBar_HEIGHT + (NavigationBar_HEIGHT - 20) / 2, 40, 20)];
    [rightTitle setTitle:@"单聊" forState:UIControlStateNormal];
    rightTitle.tag = 0;
    [rightTitle addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:rightTitle];
    
    UIButton *rightTitleGroup = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, StatusBar_HEIGHT + (NavigationBar_HEIGHT - 20) / 2, 40, 20)];
    [rightTitleGroup setTitle:@"群组" forState:UIControlStateNormal];
    rightTitleGroup.tag = 1;
    [rightTitleGroup addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:rightTitleGroup];
    
    UITableView *listTableView = self.conversationListTableView;
    listTableView.frame = CGRectMake(0, NavigationBar_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_HEIGHT);
    listTableView.tableFooterView = [[UIView alloc] init];
    //listTableView.backgroundColor = [UIColor grayColor];
    
    [self.emptyConversationView removeFromSuperview];
}

-(void)viewDidAppear:(BOOL)animated{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

-(void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    RCUserInfo *user = [[RCUserInfo alloc]init];
    user.userId = userId;
    user.name = @"1233";
    user.portraitUri = @"http://img.zcool.cn/community/033d26a5618cb9732f8755701e1a308.jpg@250w_188h_1c_1e_2o";
    
    return completion(user);
}

#pragma mark - 自定义方法
-(void)clickLeftBtn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickRightBtn:(UIButton *)btn{
    if (btn.tag == 0) {
        //新建一个聊天会话View Controller对象
        ChatContentViewController *chat = [[ChatContentViewController alloc]init];
        //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众账号等
        chat.conversationType = ConversationType_PRIVATE;
        //设置会话的目标会话ID。（单聊、客服、公众账号服务为对方的ID，讨论组、群聊、聊天室为会话的ID）
        chat.targetId = @"23";
        chat.userName = @"nihao";
        //设置聊天会话界面要显示的标题
        chat.title = @"想显示的会话标题";
        //显示聊天会话界面
        [self.navigationController pushViewController:chat animated:YES];
    }else{
        //新建一个聊天会话View Controller对象
        ChatContentViewController *chat = [[ChatContentViewController alloc]init];
        //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众账号等
        chat.conversationType = ConversationType_GROUP;
        //设置会话的目标会话ID。（单聊、客服、公众账号服务为对方的ID，讨论组、群聊、聊天室为会话的ID）
        chat.targetId = @"2";
        //设置聊天会话界面要显示的标题
        chat.title = @"想显示的会话标题";
        //显示聊天会话界面
        [self.navigationController pushViewController:chat animated:YES];
    }
}

@end
