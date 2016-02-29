//
//  PayForVipViewController.h
//  KongFuCenter
//
//  Created by 王建成 on 15/12/9.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "SelectRoundBtn.h"
#import "Pingpp.h"



@interface PayForVipViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, retain)NSString *channel;
@property(nonatomic,strong) NSArray *mMonthArray;
@property(nonatomic,strong) NSArray *mPriceArray;
@end
