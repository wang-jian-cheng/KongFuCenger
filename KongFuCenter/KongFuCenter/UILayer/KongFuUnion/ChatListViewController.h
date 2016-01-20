//
//  ChatListViewController.h
//  KongFuCenter
//
//  Created by Rain on 15/12/15.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>

@interface ChatListViewController : RCConversationListViewController

@property(nonatomic,strong) NSString *loadFlag;

@end
