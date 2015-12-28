//
//  AppDelegate.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/3.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "AppDelegate.h"
#import "CustomTabBarViewController.h"
#import "LoginViewController.h"
#import <RongIMKit/RongIMKit.h>
#import <SMS_SDK/SMSSDK.h>
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "FirstScrollController.h"

#define LogIn_UserID_key    @"mAccountID"
#define LogIn_UserPass_key   @"password"

@interface AppDelegate ()<RCIMUserInfoDataSource,RCIMGroupInfoDataSource>
{
    CustomTabBarViewController *_tabBarViewCol;
    LoginViewController *_loginViewCtl;
    FirstScrollController *firstCol;
    NSUserDefaults *mUserDefault;
    NSArray *friendArray;
    NSDictionary *teamDict;
    
    int connectServerIFlag;
}
@end

@implementation AppDelegate

#pragma mark - share sdk

#define SHARESDK_AppKey @"d556d5fc79dc"
#define SHARESDK_Secret @"e3e9c5157e8f547ddcc6979d49c6e61f"



-(void)ShareSdkInit
{
    [ShareSDK registerApp:SHARESDK_AppKey
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformSubTypeQZone),
                            @(SSDKPlatformSubTypeWechatTimeline),
                            @(SSDKPlatformSubTypeQQFriend),
                            @(SSDKPlatformSubTypeWechatSession),
                            @(SSDKPlatformSubTypeWechatFav)
                            ]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
                 
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                           appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxb1fb6e1f1f47c07f"
                                       appSecret:@"0b98bac8fdab547ca0351edc5f28c09c"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105020970"
                                      appKey:@"QfVL5BJzt8hpGCN9"
                                    authType:SSDKAuthTypeBoth];
                 break;
                 
                 
             default:
                 break;
         }
     }];

}

#pragma mark - Mob sms

#define MOB_SMS_AppKey  @"d5572cbfc8b7"
#define MOB_SMS_Secret  @"04e92d2c19317b1ab64cd60d5b571b28"

-(void)SMSInit
{
     [SMSSDK registerApp: MOB_SMS_AppKey withSecret:MOB_SMS_Secret];
}

-(void)ThirdFrameWorksInit
{
    [self SMSInit];
    [self ShareSdkInit];
    
    //集成融云App Key
    [[RCIM sharedRCIM] initWithAppKey:@"3argexb6r2qhe"];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    
    [self ThirdFrameWorksInit];
    [self initUI];
    
    return YES;
}

-(void) initUI
{

    /**
     设置根VC
     */
    _loginViewCtl = [[LoginViewController alloc] init];
    
    firstCol=[[FirstScrollController alloc]init];
    
    _tabBarViewCol = [[CustomTabBarViewController alloc] init];
    
    if(self.window == nil)
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds] ];
    
    [self.window makeKeyAndVisible];
    mUserDefault = [NSUserDefaults standardUserDefaults];
    NSString *mRegistAcount = [mUserDefault valueForKey:LogIn_UserID_key];
    NSString *mRegistPwd = [mUserDefault valueForKey:LogIn_UserPass_key];
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]) {
        
        self.window.rootViewController =_tabBarViewCol;
        
        
        if((mRegistAcount == nil||[mRegistAcount isEqualToString:@"" ])||(mRegistPwd == nil || [mRegistPwd isEqualToString:@"" ]))
        {
            self.window.rootViewController = _loginViewCtl;
        }
        else
        {
            self.window.rootViewController = _tabBarViewCol;
            
            [self TryLoginFun];
        }
        
        
        
    }
    else
    {
        self.window.rootViewController =firstCol;
        
        [self.window makeKeyAndVisible];
        //[self getAliPay];
        
        
        [self.window makeKeyAndVisible];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRootView1:) name:@"changeRootView1" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRootView:) name:@"changeRootView" object:nil];
    
    //集成融云App Key
    [[RCIM sharedRCIM] initWithAppKey:@"3argexb6r2qhe"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectServer) name:@"connectServer" object:nil];
}

-(void)connectServer{
    [SVProgressHUD showWithStatus:@"数据加载中"];
    NSString *token = [mUserDefault valueForKey:@"token"];
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        
        //获取好友信息
        DataProvider *dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"getFriendBackCall:"];
        [dataProvider getFriendForKeyValue:userId];
        
        //获取战队信息
        DataProvider *dataProvider1 = [[DataProvider alloc] init];
        [dataProvider1 setDelegateObject:self setBackFunctionName:@"getTeamBackCall:"];
        [dataProvider1 SelectTeam:[mUserDefault valueForKey:@"TeamId"]];
    } error:^(RCConnectErrorCode status) {
        NSLog(@"登陆的错误码为:%ld", (long)status);
        [SVProgressHUD dismiss];
        
    } tokenIncorrect:^{
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"token错误");
        [SVProgressHUD dismiss];
    }];
}

-(void)getFriendBackCall:(id)dict{
    if (connectServerIFlag == 2) {
        [SVProgressHUD dismiss];
    }else{
        connectServerIFlag++;
    }
    if ([dict[@"code"] intValue] == 200) {
        friendArray = dict[@"data"];
        [mUserDefault setValue:friendArray forKey:@"friendData"];
        [[RCIM sharedRCIM] setUserInfoDataSource:self];
    }
}

-(void)getTeamBackCall:(id)dict{
    if (connectServerIFlag == 2) {
        [SVProgressHUD dismiss];
    }else{
        connectServerIFlag++;
    }
    if ([dict[@"code"] intValue] == 200) {
        teamDict = dict[@"data"];
        [mUserDefault setValue:[teamDict valueForKey:@"ImagePath"] forKey:@"TeamImg"];
        [mUserDefault setValue:[teamDict valueForKey:@"Name"] forKey:@"TeamName"];
        [[RCIM sharedRCIM] setGroupInfoDataSource:self];
    }
}

-(void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    RCUserInfo *user = [[RCUserInfo alloc]init];
    NSLog(@"%@",userId);
    user.userId = userId;
    user.name = @"匿名";
    //user.portraitUri = @"http://img.zcool.cn/community/033d26a5618cb9732f8755701e1a308.jpg@250w_188h_1c_1e_2o";
    if ([userId isEqual:[NSString stringWithFormat:@"%@",[mUserDefault valueForKey:@"id"]]]) {
        user.name = [mUserDefault valueForKey:@"NicName"];
        user.portraitUri = [NSString stringWithFormat:@"%@%@",Url,[mUserDefault valueForKey:@"PhotoPath"]];
    }else{
        for (int i = 0; i < friendArray.count; i++) {
            if([userId isEqual:[NSString stringWithFormat:@"%@",[friendArray[i] valueForKey:@"Key"]]]){
                user.name = [friendArray[i] valueForKey:@"Value"][@"NicName"];
                user.portraitUri = [NSString stringWithFormat:@"%@%@",Url,[friendArray[i] valueForKey:@"Value"][@"PhotoPath"]];
                break;
            }
        }
    }
    
    return completion(user);
}

- (void)getGroupInfoWithGroupId:(NSString *)groupId
                     completion:(void (^)(RCGroup *groupInfo))completion{
    
    RCGroup *group = [[RCGroup alloc]init];
    group.groupId = groupId;
    NSLog(@"%@",teamDict);
    group.groupName =[teamDict valueForKey:@"Name"];
    group.portraitUri = [NSString stringWithFormat:@"http://192.168.1.136:8033/%@",[teamDict valueForKey:@"ImagePath"]];
    
    return completion(group);
}

#pragma mark - 尝试登录之前保存的账号登录




-(void)TryLoginFun{
    
    
    [SVProgressHUD showWithStatus:@"登录中" maskType:SVProgressHUDMaskTypeBlack];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"loginBackcall:"];
    NSString *mRegistAcount = [mUserDefault valueForKey:LogIn_UserID_key];
    NSString *mRegistPwd = [mUserDefault valueForKey:LogIn_UserPass_key];
    
    [dataprovider login:mRegistAcount andPassWord:mRegistPwd];
}


-(void)loginBackcall:(id)dict
{
    [SVProgressHUD dismiss];
    printf("[%s] start \r\n",__FUNCTION__);
    NSLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200 ) {

        DLog(@"%@ ",dict[@"data"]);
        [mUserDefault setValue:[dict[@"data"] valueForKey:@"Id"] forKey:@"id"];
        [mUserDefault setValue:[dict[@"data"] valueForKey:@"NicName"] forKey:@"NicName"];
        [mUserDefault setValue:[dict[@"data"] valueForKey:@"Token"] forKey:@"token"];
        [mUserDefault setValue:[dict[@"data"] valueForKey:@"PhotoPath"] forKey:@"PhotoPath"];
        [mUserDefault setValue:[dict[@"data"] valueForKey:@"TeamId"] forKey:@"TeamId"];
        [mUserDefault setValue:[dict[@"data"] valueForKey:@"HomeAreaId"] forKey:@"HomeAreaId"];
        [mUserDefault setValue:[dict[@"data"] valueForKey:@"HomeCode"] forKey:@"HomeCode"];
        [mUserDefault setValue:[dict[@"data"] valueForKey:@"HomeAreaprovinceName"] forKey:@"HomeAreaprovinceName"];
        [mUserDefault setValue:[dict[@"data"] valueForKey:@"HomeAreaCityName"] forKey:@"HomeAreaCityName"];
        [mUserDefault setValue:[dict[@"data"] valueForKey:@"HomeAreaCountyName"] forKey:@"HomeAreaCountyName"];
        
        [self setNotificate];
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"data"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        
        self.window.rootViewController = _loginViewCtl;
    }
    printf("[%s] end\r\n",__FUNCTION__);
}

-(void)setNotificate{
    //重新获取好友信息
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getFriendInfo" object:nil];
    
    //获取聊天Token
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getTokenInfo" object:nil];
    
    //登陆时重新获取头像
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setHeadImg" object:nil];
    
    //获取左侧栏用户信息
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getUserInfo" object:nil];
    
    //设置显示/隐藏tabbar
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil];
    
    //连接融云服务器
    [[NSNotificationCenter defaultCenter] postNotificationName:@"connectServer" object:nil];

}

-(void)changeRootView:(id)sender
{
    NSString *viewName = [[sender userInfo]objectForKey:@"rootView"];
    
    NSLog(@"ViewName = %@",viewName);
    
    if([viewName isEqualToString:@"mainpage"])
    {
        self.window.rootViewController=_tabBarViewCol;
        
        return;
    }
    
    
    if([viewName isEqualToString:@"loginpage"])
    {
        self.window.rootViewController = [[LoginViewController alloc] init];
        return;
    }
    
    if([viewName isEqualToString:@"optionspage"])
    {
        //  self.window.rootViewController = _loginViewCtl;
        return;
    }
    
}

-(void)changeRootView1:(id)sender
{
    self.window.rootViewController = [[LoginViewController alloc] init];
    return;
}


- (void)showTabBar
{
    [_tabBarViewCol showTabBar];
}
- (void)hiddenTabBar
{
    [_tabBarViewCol hideCustomTabBar];
}
-(CustomTabBarViewController *)getTabBar
{
    return _tabBarViewCol;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
