//
//  InputText.h
//  HiHome
//
//  Created by 王建成 on 15/9/29.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface InputText : NSObject
/**
 *  输入框创建方法
 *
 *  @param icon  输入框图标
 *  @param centerX 输入框中点x值
 *  @param textY 输入框y值
 *  @param point 输入框提示文字
 */

- (UITextField *)setupWithIcon:(NSString *)icon textY:(CGFloat)textY centerX:(CGFloat)centerX point:(NSString *)point;
@end


