//
//  VImVideoViewController.h
//  KongFuCenter
//
//  Created by 于金祥 on 16/1/6.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vitamio.h"
#import "PlayerControllerDelegate.h"

@interface VImVideoViewController : UIViewController<VMediaPlayerDelegate>
@property (nonatomic, assign) id<PlayerControllerDelegate> delegate;

@end
