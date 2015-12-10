//
//  ChoosePlanTypeViewController.h
//  KongFuCenter
//
//  Created by 王建成 on 15/12/10.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"

@protocol   ChoosePlanTypeDelegate<NSObject>

-(void)outView:(NSString *)planType;

@end

@interface ChoosePlanTypeViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic)id<ChoosePlanTypeDelegate> delegate;
@end
