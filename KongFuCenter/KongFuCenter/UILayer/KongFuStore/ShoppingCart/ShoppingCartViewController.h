//
//  ShoppinCartViewController.h
//  KongFuCenter
//
//  Created by Wangjc on 16/1/20.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "SelectRoundBtn.h"

@interface ShoppingCartViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
{
    CGFloat _cellHeight;
    UITableView *_mainTableView;
    NSMutableArray *cellBtnArr;
    NSMutableArray *delArr;
    NSMutableArray *numLabArr;
    
    
    
    unsigned int pageNo;
    unsigned int pageSize;
}
@end
