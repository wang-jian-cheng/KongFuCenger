//
//  AnnouncementViewController.h
//  KongFuCenter
//
//  Created by 鞠超 on 15/12/16.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "DataProvider.h"
#import "MJRefresh.h"
@interface AnnouncementViewController : BaseNavigationController
{
    int pageNo;
    int pageSize;
    NSMutableArray *announceArr;
    
}
@end
