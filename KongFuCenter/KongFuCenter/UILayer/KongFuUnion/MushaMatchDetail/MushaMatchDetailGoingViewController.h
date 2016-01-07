//
//  MushaMatchDetailGoingViewController.h
//  KongFuCenter
//
//  Created by Rain on 16/1/7.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"

typedef enum _mushaMatchDetailGoingMode
{
    Mode_Going,
    Mode_End
}MushaMatchDetailGoingMode;

@interface MushaMatchDetailGoingViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) NSString *matchId;
@property(nonatomic) MushaMatchDetailGoingMode mushaMatchDetailGoingMode;

@end
