//
//  SimpleMessageCell.h
//  KongFuCenter
//
//  Created by Rain on 16/2/15.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>
#import <RongIMKit/RCMessageCell.h>
#import <RongIMKit/RCAttributedLabel.h>

/**
 * 文本消息Cell
 */
@interface SimpleMessageCell : RCMessageCell

/**
 * 消息显示Label
 */
@property(strong, nonatomic) RCAttributedLabel *textLabel;

/**
 * 消息背景
 */
@property(nonatomic, strong) UIImageView *bubbleBackgroundView;

/**
 * 设置消息数据模型
 *
 * @param model 消息数据模型
 */
- (void)setDataModel:(RCMessageModel *)model;
@end
