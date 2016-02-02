//
//  ShoppinCartViewController.h
//  KongFuCenter
//
//  Created by Wangjc on 16/1/20.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "SelectRoundBtn.h"
#import "UIImageView+WebCache.h"
#import "CartModel.h"
#import "PayOrderViewController.h"

@interface ShoppingCartViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
{
    CGFloat _cellHeight;
    UITableView *_mainTableView;
    NSMutableArray *cellBtnArr;
    
    NSMutableArray *numLabArr;
    
    unsigned int pageNo;
    unsigned int pageSize;
    UILabel * priceLab ;
    
    BOOL EditMode;
    
    SelectRoundBtn *selectAllBtn;
    UIButton *actionBtn;
    
    NSUInteger updateNum;
}
@property(nonatomic) CGFloat moneySum;

@end
