//
//  SimpleMessageCell.h
//  rongyun
//
//  Created by 王明辉 on 16/1/20.
//  Copyright © 2016年 王明辉. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

#import "SimpleMessage.h"

@protocol ClickImgDelegate <NSObject>

- (void)clickImgEvent:(NSString *) videoUrl;

@end

@interface SimpleMessageCell : RCMessageCell

/**
 * 消息显示Label
 */
@property(strong, nonatomic) UILabel *textLabel;

@property(strong,nonatomic)UIImageView * bgimage;


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

@property (nonatomic,assign) id<ClickImgDelegate> customDelegate;
@end
