//
//  SearchViewController.h
//  KongFuCenter
//
//  Created by Wangjc on 16/1/30.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "MJRefresh.h"
#import "BaseVideoCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "VideoDetialSecondViewController.h"

typedef enum _SearchCate
{
    StudyOnline_Search  =0,
    NewsCate_Search,
    Hottest_Search,
    Suggest_Search,
    YuanChuang_Search,
    Channel_Search,
    
    all_search = 0xffff
    
}SearchCate;



@interface SearchViewController : BaseNavigationController<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    UITextField *searchTxt;
    UITableView *_mainTableView;
    UICollectionView *mainCollectionView;
    
    
    int pageNo;
    int pageSize;
    
    CGFloat _cellTableHeight;
    
}
//@property(nonatomic) NSString *searchStr;
@property(nonatomic) SearchCate searchCate;
@property(nonatomic) NSArray *subIDs;

@end
