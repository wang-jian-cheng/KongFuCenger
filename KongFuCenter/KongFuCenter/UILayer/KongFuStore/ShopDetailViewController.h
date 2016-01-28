//
//  ShopDetailViewController.h
//  KongFuCenter
//
//  Created by Rain on 16/1/20.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"

@interface ShopDetailViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) NSString *goodsId;

@end
