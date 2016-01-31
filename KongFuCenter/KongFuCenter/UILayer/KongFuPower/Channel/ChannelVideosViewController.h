//
//  ChannelVideosViewController.h
//  KongFuCenter
//
//  Created by 王建成 on 15/12/10.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UserHeadView.h"
#import "SearchViewController.h"
//#import "VideoDetailViewController.h"
@interface ChannelVideosViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView *mainCollectionView;
    VideoShowLayoutType layoutType;
}
@property (nonatomic ,strong)NSString * cateid;

@end
