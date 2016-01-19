//
//  ChatViewController.h
//  KongFuCenter
//
//  Created by Rain on 15/12/15.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>

@interface ChatContentViewController : RCConversationViewController

@property(strong,nonatomic) NSString *mTitle;
@property(strong,nonatomic) NSString *mHeadImage;
@property(strong,nonatomic) NSString *mName;

@end
