//
//  AppDelegate.h
//  KongFuCenter
//
//  Created by 王建成 on 15/12/3.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataProvider.h"
#import "SVProgressHUD.h"
#import "Pingpp.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)showTabBar;
- (void)hiddenTabBar;
@end

