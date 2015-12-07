//
//  StudyOnLineViewController.h
//  KongFuCenter
//
//  Created by 王建成 on 15/12/3.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "RAMCollectionViewFlemishBondLayout.h"
#import "VideoListForStudyViewController.h"

@interface StudyOnLineViewController : BaseNavigationController<UICollectionViewDelegate,UICollectionViewDataSource,RAMCollectionViewFlemishBondLayoutDelegate>
@property (nonatomic, strong) RAMCollectionViewFlemishBondLayout *collectionViewLayout;
@end
