//
//  KongFuPowerViewController.h
//  KongFuCenter
//
//  Created by 王建成 on 15/12/3.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UserHeadView.h"
#import "ChannelViewController.h"
#import "SearchViewController.h"
//#import "VideoDetailViewController.h"
@interface KongFuPowerViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    UIView *moreSettingBackView;
    UICollectionView *mainCollectionView;
    VideoShowLayoutType layoutType;
}
@end
