//
//  MyNewsViewController.h
//  KongFuCenter
//
//  Created by Rain on 15/12/25.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"

@interface MyNewsViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic)NSString *UserID;
@end
