//
//  AddressManageViewController.h
//  KongFuCenter
//
//  Created by Rain on 16/1/31.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"

typedef enum _addressManage{
    Mode_Add,
    Mode_Edit
}AddressManage;

@interface AddressManageViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic) AddressManage addressManage;
@property(nonatomic,strong) NSString *addressId;
@property(nonatomic,strong) NSString *receiveName;
@property(nonatomic,strong) NSString *phone;
@property(nonatomic,strong) NSString *areaId;
@property(nonatomic,strong) NSString *area;
@property(nonatomic,strong) NSString *address;
@property(nonatomic,strong) NSString *code;

@end
