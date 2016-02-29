//
//  VipViewController.h
//  KongFuCenter
//
//  Created by 王建成 on 15/12/9.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "PayForVipViewController.h"
@interface VipViewController : BaseNavigationController
{
    NSString *ServerTime;
    NSString *overTime;
}
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UILabel *vipExplainLab;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *taocan1;
@property (weak, nonatomic) IBOutlet UILabel *taocan2;
@property (weak, nonatomic) IBOutlet UILabel *taocan3;
@property (weak, nonatomic) IBOutlet UILabel *taocan4;

@end
