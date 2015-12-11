//
//  DIYButton.h
//  Eyes
//
//  Created by lanou on 15/11/5.
//  Copyright © 2015年 RockyFung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DIYButton : UIButton

// 添加readonly使外界只能改变它的属性，不能替换
@property (nonatomic, strong, readonly) UILabel *textLabel;

@property (nonatomic, strong, readonly) UIImageView *iconImageView;
// 点击button改变图片
@property (nonatomic, strong, readonly) UIImageView *selectIconImageView;

@end
