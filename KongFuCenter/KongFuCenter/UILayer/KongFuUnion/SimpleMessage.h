//
//  SimpleMessage.h
//  rongyun
//
//  Created by 王明辉 on 16/1/19.
//  Copyright © 2016年 王明辉. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
#import <RongIMLib/RCMessageContentView.h>

#define RCLocalMessageTypeIdentifier @"RC:SimpleMsg"
/**
 * 文本消息类定义
 */
@interface SimpleMessage : RCMessageContent <NSCoding,RCMessageContentView>
/** 文本消息内容 */
@property(nonatomic, strong) NSString* content;

/****背景图片的url***/
@property(strong,nonatomic)NSString * imageUrl;

/******点击需呀跳转的url******/
@property(strong,nonatomic)NSString * url;


/**
 * 附加信息
 */
@property(nonatomic, strong) NSString* extra;

/**
 * 根据参数创建文本消息对象
 * @param content 文本消息内容
 */
+(instancetype)messageWithContent:(NSString *)content;

+(instancetype)messageWithContent:(NSString *)content imageUrl:(NSString*)imageUrl url:(NSString*)url;
@end
