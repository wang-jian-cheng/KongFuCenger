//
//  IntegralExchangeViewController.h
//  KongFuCenter
//
//  Created by Rain on 16/1/23.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "DataProvider.h"
@interface IntegralExchangeViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
{
    NSUInteger pageNo;
    NSUInteger pageSize;
}
@end
