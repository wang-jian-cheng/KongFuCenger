//
//  UnionNewsViewController.h
//  KongFuCenter
//
//  Created by Rain on 15/12/12.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UnionNewsDetailViewController.h"
#import "MJRefresh.h"
@interface UnionNewsViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
{
    int pageNo;
    int pageSize;
    
    NSString *_cateId;
}
@end
