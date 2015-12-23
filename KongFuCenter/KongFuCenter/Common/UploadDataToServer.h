//
//  UploadDataToServer.h
//  KongFuCenter
//
//  Created by Wangjc on 15/12/23.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UploadDataToServerDelegate <NSObject>
//全部图片都传完
-(void)uploadImgsAllFinishDelegate:(NSArray *)imgPath;
//每传完一张
-(void)uploadImgsOneFinishDelegate:(NSDictionary *)dict andImgIndex:(NSInteger)ImgIndex;

@end

@interface UploadDataToServer : NSObject
@property(nonatomic) id<UploadDataToServerDelegate> delegate;
/*
 *  上传多张图片
 *
 *  @param ImgArr 图片base64数据数组
 */
-(void)uploadImg:(NSArray *)ImgArr;
@end

