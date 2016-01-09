//
//  ChatSetViewController.h
//  KongFuCenter
//
//  Created by Wangjc on 16/1/9.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UserHeadView.h"
#import "ChatContentViewController.h"
#import "MyNewsViewController.h"
@interface ChatSetViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic) NSString *userID;
@end
