//
//  ChineseString.h
//  YUChineseSorting
//
//  Created by yuzhx on 15/4/19.
//  Copyright (c) 2015年 BruceYu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "pinyin.h"

@interface ChineseString : NSObject
@property(retain,nonatomic)NSString *string;
@property(retain,nonatomic)NSString *pinYin;
@property(retain,nonatomic)NSString *friendID;
@property(retain,nonatomic)NSString *photoImg;
@property(retain,nonatomic)NSString *level;

//-----  返回tableview右方indexArray
+(NSMutableArray*)IndexArray:(NSArray*)stringArr;

//-----  返回联系人
+(NSMutableArray*)LetterSortArray:(NSArray*)stringArr;

//-----  返回tableview右方indexArray
+(NSMutableArray*)mIndexArray:(NSArray*)stringArr;

//-----  返回联系人
+(NSMutableArray*)mLetterSortArray:(NSArray*)stringArr;

///----------------------
//返回一组字母排序数组(中英混排)
+(NSMutableArray*)SortArray:(NSArray*)stringArr;

@end