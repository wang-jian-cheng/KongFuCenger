//
//  OrderMainViewController.h
//  KongFuCenter
//
//  Created by Wangjc on 16/1/21.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "MJRefresh.h"
#import "OrderDetailViewController.h"
#import "PayOrderViewController.h"
#import "OrderDefine.h"

typedef enum _billType{
    Mode_Normal,
    Mode_PaySuccess
}BillType;

@interface OrderMainViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
{
    int pageNo;
    int pageSize;
    
    
    OrderType orderType;
}
@property(nonatomic) NSMutableArray *orderArr;
@property(nonatomic) BillType billType;
@end
