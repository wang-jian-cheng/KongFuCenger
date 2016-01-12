//
//  TrainsPlanViewController.h
//  KongFuCenter
//
//  Created by 王建成 on 15/12/9.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "SelectRoundBtn.h"
#import "NewPlanViewController.h"
#import "MJRefresh.h"
#import "TrainsPlanDetailViewController.h"

#define WeekPlan    51
#define MonthPlan   50
#define SeasonPlan  49
#define YearPlan    48

@interface TrainsPlanViewController : BaseNavigationController<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    UIView *moreSettingBackView;
    
    int pageNo;
    int pageSize;
    
    NSMutableArray *planArr;
}
@end
