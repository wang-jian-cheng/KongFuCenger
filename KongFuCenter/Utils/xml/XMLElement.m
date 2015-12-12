//
//  XMLElement.m
//  CaSimDemo
//
//  Created by s on 15/3/16.
//  Copyright (c) 2015年 Sunward. All rights reserved.
//

#import "XMLElement.h"

@implementation XMLElement

-(instancetype)init{
    self = [super init];
    if (self) {
        self.text = @"";
    }
    return self;
}

-(NSMutableArray*)subElements{
    if (_subElements == nil) {
        _subElements = [NSMutableArray array];
    }
    return _subElements;
}

-(NSString*)description{
    //属性
    NSMutableString* attributesStr = [NSMutableString string];
    [self.attributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [attributesStr appendFormat:@" %@=\"%@\"",key,obj];
    }];
    
    //子元素
    NSMutableString * subElementsStr = [NSMutableString string];
    if (self.subElements.count > 0){
        [self.subElements enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSLog(@"obj%d=%@",idx,obj);
            [subElementsStr appendFormat:@"%@",obj];
        }];
    }
    
    
    NSString * des = [NSString stringWithFormat:@"<%@%@>%@%@</%@>",self.name,attributesStr,self.text,subElementsStr, self.name];
    return des;
}
@end
