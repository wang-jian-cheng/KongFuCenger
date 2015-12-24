//
//  WuGuanViewController.h
//  KongFuCenter
//
//  Created by 王建成 on 15/12/4.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "WuGuan/WuGuanDetailViewController.h"
#import "AutoLocationViewController.h"
#import "DataProvider.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
@interface WuGuanViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate,AutoLocationDelegate>

@end
