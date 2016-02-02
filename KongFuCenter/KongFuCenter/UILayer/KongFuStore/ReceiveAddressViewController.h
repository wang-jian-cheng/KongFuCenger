//
//  ReceiveAddressViewController.h
//  KongFuCenter
//
//  Created by Rain on 16/1/31.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"

@protocol ReceiveAddressDelegate <NSObject>

- (void)getReceiveAddress:(NSMutableDictionary *)receiveAddressDict;

@end

typedef enum {
    Mode_AddressManage,
    Mode_SelectAddress
}ReceiveAddressType;

@interface ReceiveAddressViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic) ReceiveAddressType receiveAddressType;
@property (nonatomic,assign) id<ReceiveAddressDelegate> delegate;

@end
