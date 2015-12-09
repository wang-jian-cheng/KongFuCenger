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

@interface TrainsPlanViewController : BaseNavigationController<UITableViewDelegate,UITableViewDataSource>
{
    UIView *moreSettingBackView;
}
@end
