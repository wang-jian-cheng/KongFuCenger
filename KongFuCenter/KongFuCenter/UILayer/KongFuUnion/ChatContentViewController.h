//
//  ChatViewController.h
//  KongFuCenter
//
//  Created by Rain on 15/12/15.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>

typedef enum _chatPageType
{
    Mode_Chat,
    Mode_History
}ChatPageType;

@interface ChatContentViewController : RCConversationViewController

@property(strong,nonatomic) NSString *mTitle;
@property(strong,nonatomic) NSString *mHeadImage;
@property(strong,nonatomic) NSString *mName;
@property(nonatomic) ChatPageType chatPageType;

@end
