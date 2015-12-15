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

#define LogIn_UserID_key    @"mAccountID"
#define LogIn_UserPass_key   @"password"

@interface AppDelegate ()
{
    CustomTabBarViewController *_tabBarViewCol;
    LoginViewController *_loginViewCtl;
    NSUserDefaults *mUserDefault;
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
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self ThirdFrameWorksInit];
    [self initUI];
    
    return YES;
}

-(void) initUI
{

    
    _tabBarViewCol = [[CustomTabBarViewController alloc] init];
    _loginViewCtl = [[LoginViewController alloc] init];
    if(self.window == nil)
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds] ];
    
    [self.window makeKeyAndVisible];
    mUserDefault = [NSUserDefaults standardUserDefaults];
    NSString *mRegistAcount = [mUserDefault valueForKey:LogIn_UserID_key];
    NSString *mRegistPwd = [mUserDefault valueForKey:LogIn_UserPass_key];
    
    if((mRegistAcount == nil||[mRegistAcount isEqualToString:@"" ])||(mRegistPwd == nil || [mRegistPwd isEqualToString:@"" ]))
    {
         self.window.rootViewController = _loginViewCtl;
    }
    else
    {
        self.window.rootViewController = _tabBarViewCol;
        
        [self TryLoginFun];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRootView:) name:@"changeRootView" object:nil];
    
    
    
    //集成融云App Key
    [[RCIM sharedRCIM] initWithAppKey:@"3argexb6r2qhe"];
    
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
        [mUserDefault setValue:[dict valueForKey:@"Id"] forKey:@"id"];
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
