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
    Mode_MushaNoStart,
    Mode_MushaGoing,
    Mode_MushaEnd,
    Mode_TeamNoStart,
    Mode_TeamGoing,
    Mode_TeamEnd
}MushaMatchDetailMode;

@interface MushaMatchDetailViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property(nonatomic,strong) NSString *matchId;
@property(nonatomic,strong) NSString *isApply;
@property(nonatomic) MushaMatchDetailMode mushaMatchDetailMode;

@end
