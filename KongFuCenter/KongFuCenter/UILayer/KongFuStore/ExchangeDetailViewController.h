//
//  ExchangeDetailViewController.h
//  KongFuCenter
//
//  Created by Rain on 16/1/23.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"

typedef enum _exchangeDetail{
    Mode_Detail,
    Mode_ImmeExchange,
    Mode_IntegralLack
}ExchangeDetail;

@interface ExchangeDetailViewController : BaseNavigationController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic) ExchangeDetail exchangeDetail;
@property(nonatomic,strong) NSString *goodsId;
@property(nonatomic,strong) NSString *billDetailId;

@end
