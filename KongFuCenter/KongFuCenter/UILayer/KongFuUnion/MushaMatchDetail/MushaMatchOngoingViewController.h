//
//  MushaMatchOngoingViewController.h
//  KongFuCenter
//
//  Created by 王建成 on 15/12/12.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UserHeadView.h"
#import "VideoDetailForMatchViewController.h"

typedef enum _mushaMatchOngoingMode
{
    Mode_OnGoing,
    Mode_Ranking
}MushaMatchOngoingMode;

@interface MushaMatchOngoingViewController : BaseNavigationController<UICollectionViewDataSource,UICollectionViewDelegate,UISearchBarDelegate>

@property(nonatomic,strong) NSString *matchId;
@property(nonatomic) MushaMatchOngoingMode mushaMatchOngoingMode;

@end
