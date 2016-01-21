//
//  VideoDetialSecondViewController.h
//  KongFuCenter
//
//  Created by 于金祥 on 16/1/14.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "CustomButton.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKInterfaceAdapter/ISSContainer.h>
#import "VipViewController.h"
#import "JvbaoView.h"

@interface VideoDetialSecondViewController : BaseNavigationController<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,JvbaoDelegate,UIAlertViewDelegate>
{
    CGFloat _keyHeight;
    NSIndexPath *tempIndexPath;
    UITextView *commentTextView;
    CGFloat commentWidth;
    
    CustomButton *SupportBtn;
    CustomButton *collectBtn ;
    
    BOOL shouldPay;
}

@property(nonatomic,strong) NSString * videoID;


@end
