//
//  ShopListViewController.h
//  KongFuCenter
//
//  Created by Rain on 16/1/22.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"

typedef enum _shopListType{
    Mode_NormalShop,
    Mode_RecommendShop
}ShopListType;

@interface ShopListViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong) NSString *categoryId;
@property(nonatomic,strong) NSString *isRecommend;
@property(nonatomic) ShopListType shopListType;

@end
