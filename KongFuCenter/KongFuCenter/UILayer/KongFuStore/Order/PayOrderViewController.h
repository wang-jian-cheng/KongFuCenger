//
//  PayOrderViewController.h
//  KongFuCenter
//
//  Created by Wangjc on 16/1/23.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "SelectRoundBtn.h"
#import "OrderDefine.h"
#import "CartModel.h"
#import "UIImageView+WebCache.h"
#import "ReceiveAddressViewController.h"

@interface PayOrderViewController : BaseNavigationController<UITableViewDelegate,UITableViewDataSource,ReceiveAddressDelegate>
{
    int pageNo;
    int pageSize;
    
    NSArray *cateArr;
    NSMutableArray *btnArr;
    CGFloat _cellHeight;
    UITableView *_mainTableView;
    NSMutableArray *roundBtnArr;
    
    UILabel *tiplab;
    UILabel *moneyLab;
    
    NSMutableDictionary *addressDict;
}

@property(nonatomic) NSMutableArray<CartModel *>* goodsArr;
@property(nonatomic) NSArray *goodDicts;
@property(nonatomic) CGFloat postage;
@end
