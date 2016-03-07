//
//  CartModel.h
//  KongFuCenter
//
//  Created by Wangjc on 16/2/1.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartModel : NSObject
@property(nonatomic) NSString *Id;
@property(nonatomic) NSString *MiddleImagePath;
@property(nonatomic) NSString *Number;
@property(nonatomic) NSString *ProductColorName;
@property(nonatomic) NSString *ProductId;
@property(nonatomic) NSString *ProductName;
@property(nonatomic) NSString *ProductPriceId;
@property(nonatomic) NSString *ProductPriceTotalPrice;
@property(nonatomic) NSString *ProductSizeName;
@property(nonatomic) NSString *StockNum;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)CartModelWithDict:(NSDictionary *)dict;
@end
