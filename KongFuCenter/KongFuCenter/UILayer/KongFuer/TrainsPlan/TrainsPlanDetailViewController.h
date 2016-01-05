//
//  TrainsPlanDetailViewController.h
//  KongFuCenter
//
//  Created by Wangjc on 15/12/24.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UIImageView+WebCache.h"
#import "PictureShowView.h"
#import "NewPlanViewController.h"
#ifndef _CELL
#define _CELL @ "acell"
#endif


@interface TrainsPlanDetailViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,PictureShowViewDelegate,UIActionSheetDelegate>
{
    NSMutableArray *picArr;
    
    
    NSInteger _cellCount;
    NSInteger _cellHeight;
    NSInteger _cellTextViewHeight;//包含textview的cell的高度
    UITableView *_mainTableView;
    UITextField *_titleField;//标题
    UITextView *_textView;
    CGFloat _keyHeight;
    

}
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic) NSDictionary *planInfo;
@end
