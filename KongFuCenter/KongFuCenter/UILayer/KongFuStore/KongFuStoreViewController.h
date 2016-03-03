//
//  KongFuStoreViewController.h
//  KongFuCenter
//
//  Created by 王建成 on 15/12/7.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "ShoppingCart/ShoppingCartViewController.h"
#import "OrderMainViewController.h"
#import "SDCycleScrollView.h"

@interface KongFuStoreViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>
{
    SDCycleScrollView *cycleScrollView;
}
@end
