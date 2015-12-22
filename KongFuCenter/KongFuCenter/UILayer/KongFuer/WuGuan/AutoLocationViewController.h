//
//  AutoLocationViewController.h
//  BuerShopping
//
//  Created by 于金祥 on 15/7/7.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
#import "MJRefresh.h"


@protocol AutoLocationDelegate  <NSObject>

-(void)outCitySetting:(NSString *)City andID:(NSString *)cityId;

@end

@interface AutoLocationViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic)id<AutoLocationDelegate> delegate;
@end
