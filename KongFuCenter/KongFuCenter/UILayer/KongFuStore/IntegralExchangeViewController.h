//
//  IntegralExchangeViewController.h
//  KongFuCenter
//
//  Created by Rain on 16/1/23.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "DataProvider.h"
#import "MJRefresh.h"
@interface IntegralExchangeViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
{
    NSUInteger pageNo;
    NSUInteger pageSize;
    
    
    UILabel *userName;
    UILabel *mIntegral;
    UIImageView *photoIv;
}
@end
