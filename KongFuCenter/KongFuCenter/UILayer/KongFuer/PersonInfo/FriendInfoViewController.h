//
//  FriendInfoViewController.h
//  KongFuCenter
//
//  Created by 王建成 on 15/12/14.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UserHeadView.h"
#import "ChatSetViewController.h"
#import "MyNewsViewController.h"
#import "TeamNewsViewController.h"
@interface FriendInfoViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic) NSString *userID;

@end
