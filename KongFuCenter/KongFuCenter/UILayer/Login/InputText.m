//
//  InputText.m
//  HiHome
//
//  Created by 王建成 on 15/9/29.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "InputText.h"
#import "UIView+XD.h"

@implementation InputText
- (UITextField *)setupWithIcon:(NSString *)icon textY:(CGFloat)textY centerX:(CGFloat)centerX point:(NSString *)point;
{
    UITextField *textField = [[UITextField alloc] init];
    textField.width = SCREEN_WIDTH - 30;
    textField.height = 30;
    textField.centerX = centerX;
    textField.y = textY;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 29, textField.width, 0.5)];
    view.alpha = 0.5;
    view.backgroundColor = [UIColor grayColor];
    [textField addSubview:view];
    textField.placeholder = point;
    textField.font = [UIFont systemFontOfSize:16];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.clearButtonMode = UITextFieldViewModeAlways;
    UIImage *bigIcon = [UIImage imageNamed:icon];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:bigIcon];
    if (icon) {
        iconView.width = 20;
        
        iconView.frame = CGRectMake(0, 0, 20,  textField.height-3);
    }
    
    UIView *tempView = [[UIView alloc] init];
    //tempView.width = iconView.width + 5;
    tempView.frame = CGRectMake(0, 0, 20,  textField.height);
    [tempView addSubview:iconView];
    
    iconView.contentMode = UIViewContentModeLeft;
    textField.leftView = iconView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    return textField;
}
@end
