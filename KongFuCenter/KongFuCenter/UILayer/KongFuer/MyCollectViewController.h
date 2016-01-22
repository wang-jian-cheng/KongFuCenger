//
//  MyCollectViewController.h
//  KongFuCenter
//
//  Created by 王建成 on 15/12/4.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "MyCollectTableViewCell.h"
#import "BaseVideoCollectionViewCell.h"
#import "UITableViewCell+EditMode.h"
#import "VideoDetailViewController.h"
#import "UnionNewsDetailViewController.h"
#import "MJRefresh.h"
#import "VideoDetialSecondViewController.h"
typedef enum _cateMode
{
    CollectionViewMode,
    TableViewMode
}CateMode;

@interface MyCollectViewController : BaseNavigationController<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    BOOL EditMode;
    int pageNo;
    int pageSize;
    
    int pageVideoNo;
    int pageVideoSize;
    
    NSInteger delcount;
    
    CateMode mode;
    
    NSString *videoId;
}
@end
