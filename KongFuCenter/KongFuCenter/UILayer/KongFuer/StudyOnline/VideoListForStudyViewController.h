//
//  VideoListForStudyViewController.h
//  KongFuCenter
//
//  Created by 王建成 on 15/12/7.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "SearchViewController.h"

@interface VideoListForStudyViewController : BaseNavigationController
{
    NSString *ServerTime;
    NSString *overTime;
}
@property (nonatomic,strong) NSString *categoryid;

@end
