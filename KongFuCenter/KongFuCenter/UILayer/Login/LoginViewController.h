//
//  LoginViewController.h
//  HiHome
//
//  Created by 王建成 on 15/9/29.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
#import "DataDefine.h"
#import "UIView+XD.h"
#import "RegisterViewController.h"
#import <ShareSDK/ShareSDK.h>
#pragma mark - define frame

#define     ZY_UIPART_SCREEN_WIDTH      (self.view.frame.size.width/100)
#define     ZY_UIPART_SCREEN_HEIGHT      (self.view.frame.size.height/100)
#define     ZY_UISTART_X                ((self.view.frame.size.height/100)*5)


#pragma  mark - define tags

#define USER_TEXT_TAG       (2015 + 1)
#define PASSWORD_TEXT_TAG   (2015 + 2)

typedef struct _zyColor
{
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
}zyColor;


@interface LoginViewController : BaseNavigationController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    @private
    DataDefine *_userData;
    UIAlertView *myAlert;
}

@end
