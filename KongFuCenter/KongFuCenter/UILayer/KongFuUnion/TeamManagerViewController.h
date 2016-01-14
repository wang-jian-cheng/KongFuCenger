//
//  TeamManagerViewController.h
//  KongFuCenter
//
//  Created by 于金祥 on 16/1/14.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@interface TeamManagerViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end
