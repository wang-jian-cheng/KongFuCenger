//
//  GoodsCommentViewController.h
//  KongFuCenter
//
//  Created by Wangjc on 16/2/16.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "MJRefresh.h"
#import "UserHeadView.h"
@interface GoodsCommentViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic)NSString *goodId;
@end
