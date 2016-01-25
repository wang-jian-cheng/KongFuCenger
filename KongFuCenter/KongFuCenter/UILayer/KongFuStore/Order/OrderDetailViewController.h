//
//  OrderDetailViewController.h
//  KongFuCenter
//
//  Created by Wangjc on 16/1/22.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "PayOrderViewController.h"
#import "CommentOrderViewController.h"
typedef enum _orderMode{
    orderNeedPay,
    orderNeedSend,
    orderNeedReceive,
    orderFinish
}OrderMode;

@interface OrderDetailViewController : BaseNavigationController<UITableViewDelegate,UITableViewDataSource>
{
    int pageNo;
    int pageSize;
    
    NSArray *cateArr;
    NSMutableArray *btnArr;
    CGFloat _cellHeight;
    UITableView *_mainTableView;
    
}

@property(nonatomic)OrderMode orderMode;
@end
