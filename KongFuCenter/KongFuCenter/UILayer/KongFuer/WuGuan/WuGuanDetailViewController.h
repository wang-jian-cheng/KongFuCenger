//
//  WuGuanDetailViewController.h
//  KongFuCenter
//
//  Created by 王建成 on 15/12/7.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "CustomButton.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKInterfaceAdapter/ISSContainer.h>
#import "PictureShowView.h"
#import "MapViewController.h"
#define _CELL @ "acell"

@interface WuGuanDetailViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSDictionary *wuGuanDetailDict;
    NSMutableArray *showPicArr;
    NSMutableArray *imgUrls;
    
    CLLocationDegrees lat;
    CLLocationDegrees lng;
    
    UILabel *numLab;
    
}
@property (nonatomic, retain,readonly) UICollectionView *collectionView;
@property(nonatomic)NSString *wuGuanId;
@end
