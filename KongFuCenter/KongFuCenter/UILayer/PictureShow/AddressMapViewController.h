//
//  AddressMapViewController.h
//  HiHome
//
//  Created by Rain on 15/10/29.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import "BaseNavigationController.h"

@interface AddressMapViewController : BaseNavigationController


@property (strong,nonatomic) NSString *mLag;
@property (strong,nonatomic) NSString *mLong;
@property (strong,nonatomic) NSString *mAddress;

@end
