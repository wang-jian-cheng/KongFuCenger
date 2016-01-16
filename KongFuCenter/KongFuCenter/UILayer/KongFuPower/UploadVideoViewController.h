//
//  UploadVideoViewController.h
//  KongFuCenter
//
//  Created by 于金祥 on 15/12/19.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "BaseNavigationController.h"

@interface UploadVideoViewController : BaseNavigationController

@property (nonatomic,strong) NSURL * VideoFilePath;
@property (nonatomic,strong)NSString * uploadType;

@end
