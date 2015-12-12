//
//  PlayerForMatchViewController.h
//  KongFuCenter
//
//  Created by 王建成 on 15/12/12.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UserHeadView.h"
@interface PlayerForMatchViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
{
    UISearchBar *_searchBar;
    UISearchDisplayController *_searchDisplayController;
}
@end
