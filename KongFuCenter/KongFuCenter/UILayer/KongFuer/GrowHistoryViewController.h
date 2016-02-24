//
//  GrowHistoryViewController.h
//  KongFuCenter
//
//  Created by 王建成 on 15/12/5.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UITableViewCell+EditMode.h"
#import "SelectRoundBtn.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "VideoDetialSecondViewController.h"
@interface GrowHistoryViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
{
    int pageNo;
    int pageSize;
    NSMutableArray *delArr;
    NSInteger deleCount;
}

@property(nonatomic,strong) NSString *userId;

@end
