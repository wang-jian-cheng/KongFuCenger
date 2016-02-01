//
//  CartModel.m
//  KongFuCenter
//
//  Created by Wangjc on 16/2/1.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "CartModel.h"

@implementation CartModel

-(void)setId:(NSString *)Id
{
    _Id = NSStringFromFormat(@"%@",Id);
}

-(void)setNumber:(NSString *)Number
{
    _Number = NSStringFromFormat(@"%@",Number);
}

-(void)setProductPriceTotalPrice:(NSString *)ProductPriceTotalPrice
{
    _ProductPriceTotalPrice = NSStringFromFormat(@"%@",ProductPriceTotalPrice);
}

@end
