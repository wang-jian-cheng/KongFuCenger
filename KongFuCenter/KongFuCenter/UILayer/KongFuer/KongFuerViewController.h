//
//  KongFuerViewController.h
//  KongFuCenter
//
//  Created by 王建成 on 15/12/3.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "StudyOnLineViewController.h"
#import "WuGuanViewController.h"
#import "MyCollectViewController.h"
#import "GrowHistoryViewController.h"
#import "UserHeadView.h"
#import "JiFenViewController.h"
#import "MyDreamViewController.h"
#import "ZhiBo/ZhiBoViewController.h"
#import "VipViewController.h"
#import "TrainsPlanViewController.h"

#import "DataProvider.h"
@interface KongFuerViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
    UIImageView *weatherImg;
    UILabel *locationLab;
    UILabel *temp;
    UILabel *lhTempt;
    UILabel *outNote;
    UILabel *airNUm;
    UILabel *airQuality;
    
    CLLocationManager *locationManager;
    NSArray *mHomeInfo;
    
    UIApplication *application;
    
}
@end
