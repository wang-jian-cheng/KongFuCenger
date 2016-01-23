//
//  ChannelViewController.h
//  KongFuCenter
//
//  Created by 王建成 on 15/12/10.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "RAMCollectionViewFlemishBondLayout.h"
#import "ChannelVideosViewController.h"

@protocol ChannelDelegate <NSObject>

-(void)outOfSelectChannel:(NSString *)str;
@end

@interface ChannelViewController : BaseNavigationController<UICollectionViewDelegate,UICollectionViewDataSource,RAMCollectionViewFlemishBondLayoutDelegate>
@property (nonatomic, strong) RAMCollectionViewFlemishBondLayout *collectionViewLayout;
@property (nonatomic) BOOL isVideoSelectCadagray;

@end
