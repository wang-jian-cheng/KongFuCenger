//
//  AutoLocationViewController.h
//  BuerShopping
//
//  Created by 于金祥 on 15/7/7.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "ChineseInclude.h"
#import "PinYinForObjc.h"

@protocol AutoLocationDelegate  <NSObject>

-(void)outCitySetting:(NSString *)City andID:(NSString *)cityId;

@end

@interface AutoLocationViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIGestureRecognizerDelegate>
{
    UITableView * tableview;
}
@property (nonatomic)id<AutoLocationDelegate> delegate;
@end
