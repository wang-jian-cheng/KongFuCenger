//
//  CartModel.m
//  KongFuCenter
//
//  Created by Wangjc on 16/2/1.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "CartModel.h"

@implementation CartModel

-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if(self)
    {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+(instancetype)CartModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

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

-(void)setProductPriceId:(NSString *)ProductPriceId
{
    _ProductPriceId = ZY_NSStringFromFormat(@"%@",ProductPriceId);
}

@end
