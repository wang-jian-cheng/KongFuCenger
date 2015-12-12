//
//  XMLElement.h
//  CaSimDemo
//
//  Created by s on 15/3/16.
//  Copyright (c) 2015年 Sunward. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLElement : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * text;
@property (nonatomic, strong) NSDictionary * attributes;
@property (nonatomic, strong) NSMutableArray * subElements;
@property (nonatomic, strong) XMLElement * parent;

-(NSString*)description;

@end
