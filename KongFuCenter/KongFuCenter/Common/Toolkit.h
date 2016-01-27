//
//  Toolkit.h
//  Blinq
//
//  Created by Sugar on 13-8-27.
//  Copyright (c) 2013年 Sugar Hou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>


@interface Toolkit : NSObject


+ (BOOL)isEnglishSysLanguage;
+ (BOOL)isSystemIOS7;
+(BOOL)isSystemIOS8;
+ (NSString *)base64EncodedStringFrom:(NSData *)data;

/**
 *根据nsstring 和 view的宽度计算高度
 */
+(CGFloat)heightWithString:(NSString*)string fontSize:(CGFloat)fontSize width:(CGFloat)width;
//返回rgba色值
+(NSMutableArray *)getColorRGBA:(UIColor *) color;
//添加划线api
+(UIImageView *)drawLine:(CGFloat)startX andSY:(CGFloat)startY andEX:(CGFloat)endX andEY:(CGFloat)endY andLW:(CGFloat)lineWidth andColor:(UIColor *)color andView:(UIView *)tempView;
//获取userId
+(NSString *)getUserID;
+(BOOL)isVip;
+(NSString *)judgeIsNull:(NSString *)str;
//显示顶部菊花
+(UIActivityIndicatorView*)showJuHua;



#pragma mark Plist
+(id)ReadPlist:(NSString*)FileName ForKey:(NSString *)key;
+(void)writePlist:(NSString*)FileName andContent:(id)content andKey:(NSString *)key;
+(void)delPlist:(NSString *)plist;
#pragma mark - camera

+ (BOOL) isCameraAvailable;
+ (BOOL) isRearCameraAvailable;
+ (BOOL) isFrontCameraAvailable;
+ (BOOL) doesCameraSupportTakingPhotos;
+ (BOOL) isPhotoLibraryAvailable;
+ (BOOL) canUserPickVideosFromPhotoLibrary;
+ (BOOL) canUserPickPhotosFromPhotoLibrary;
+ (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType;

@end
