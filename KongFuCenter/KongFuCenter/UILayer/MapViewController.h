//
//  MapViewController.h
//  KongFuCenter
//
//  Created by Wangjc on 16/1/7.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import <MapKit/MapKit.h>
@interface MapViewController : BaseNavigationController
@property(nonatomic) CLLocationDegrees lat;
@property(nonatomic) CLLocationDegrees lng;
@property(nonatomic) NSString *addr;
@property(nonatomic) NSString *Title;
@end
