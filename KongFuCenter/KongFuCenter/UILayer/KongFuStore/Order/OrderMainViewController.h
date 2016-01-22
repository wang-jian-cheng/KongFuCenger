//
//  OrderMainViewController.h
//  KongFuCenter
//
//  Created by Wangjc on 16/1/21.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "MJRefresh.h"

@interface OrderMainViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
{
    int pageNo;
    int pageSize;
}
@end
