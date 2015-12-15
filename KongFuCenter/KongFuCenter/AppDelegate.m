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

@interface AppDelegate ()
{
    CustomTabBarViewController *_tabBarViewCol;
    LoginViewController *_loginViewCtl;
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
                 [appInfo SSDKSetupWeChatByAppId:@"wx4868b35061f87885"
                                       appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
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
    
    self.window.rootViewController = _loginViewCtl;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRootView:) name:@"changeRootView" object:nil];
    
    
    
    //集成融云App Key
    [[RCIM sharedRCIM] initWithAppKey:@"3argexb6r2qhe"];
    
    return YES;
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
