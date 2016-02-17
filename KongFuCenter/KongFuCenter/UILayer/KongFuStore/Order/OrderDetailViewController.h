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
#import "OrderDefine.h"
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
    
    NSArray *proList;
    
    CGFloat totalMoney;
    NSDictionary *addressDict;
    
}

@property(nonatomic)OrderMode orderMode;
@property (nonatomic,strong) NSDictionary * OrderDict;

@end
