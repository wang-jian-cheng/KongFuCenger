//
//  MushaMatchDetailViewController.h
//  KongFuCenter
//
//  Created by 王建成 on 15/12/12.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "ApplyForMatchViewController.h"
#import "PlayerForMatchViewController.h"

typedef enum _mushaMatchDetailMode
{
    Mode_Musha,
    Mode_Team
}MushaMatchDetailMode;

@interface MushaMatchDetailViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property(nonatomic,strong) NSString *matchId;
@property(nonatomic) BOOL isApply;
@property(nonatomic) MushaMatchDetailMode mushaMatchDetailMode;

@end
