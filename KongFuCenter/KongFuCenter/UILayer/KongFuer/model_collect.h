//
//  model_collect.h
//  KongFuCenter
//
//  Created by 鞠超 on 15/12/23.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface model_collect : NSObject
//是否免费
@property (nonatomic, copy) NSString * IsFree;
//收藏时间
@property (nonatomic, copy) NSString * OperateTime;
//视频截图路径
@property (nonatomic, copy) NSString * ImagePath;
//视频标题（文章)
@property (nonatomic, copy) NSString * Title;
//视频描述（文章内容)
@property (nonatomic, copy) NSString * Content;
//赞数
@property (nonatomic, copy) NSString * LikeNum;
// 收藏数
@property (nonatomic, copy) NSString * FavoriteNum;
//转发数
@property (nonatomic, copy) NSString * RepeatNum;

@property (nonatomic, copy) NSString * MessageId;

@property (nonatomic, copy) NSString * UserId;

@property (nonatomic, copy) NSString * IsLike;

@end
