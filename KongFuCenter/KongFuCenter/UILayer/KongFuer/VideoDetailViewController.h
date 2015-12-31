//
//  VideoDetailViewController.h
//  KongFuCenter
//
//  Created by 王建成 on 15/12/7.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "CustomButton.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKInterfaceAdapter/ISSContainer.h>

typedef enum _DetailMode
{
    StudyOnline = 0,
    NormalVideo
}VideoDetailMode;


@interface VideoDetailViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
{
    CGFloat _keyHeight;
    NSIndexPath *tempIndexPath;
}

@property(nonatomic,strong) NSString * videoID;

@property(nonatomic)VideoDetailMode detailMode;
@end
