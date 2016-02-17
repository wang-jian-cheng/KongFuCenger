//
//  QupaiSDK.h
//  QupaiSDK
//
//  Created by lyle on 13-12-19.
//  Copyright (c) 2013年 lyle. All rights reserved.
//

@protocol QupaiSDKDelegate;

// VideoInfo Key
extern NSString * const QPVideoInfoDuration;  // 视频时长 (s)
extern NSString * const QPVideoInfoLength;    // 视频大小 (byte)
extern NSString * const QPVideoInfoBitRate;   // 码率（bps）
extern NSString * const QPVideoInfoSize;      // 分辨率 (pixel*pixel)

@interface QupaiSDK : NSObject

@property (nonatomic, weak) id<QupaiSDKDelegate> delegte;
/* 生成视频信息，只读 */
@property (nonatomic, strong, readonly) NSDictionary *videoInfo;

/* 首帧图图片质量:压缩质量 0-1 */
@property (nonatomic, assign) CGFloat  thumbnailCompressionQuality;
/*要不要合成，默认合成，回调有视频地址和缩略图地址，如果不合成，则返回packName*/
@property (nonatomic, assign) BOOL combine;
/* 语言本地化配置文件url */
@property (nonatomic, strong) NSURL *localizableFileUrl;
/* 是否显示拍摄时长 */
@property (nonatomic, assign) BOOL progressIndicatorEnabled;
/* 是否显示拍摄引导 */
@property (nonatomic, assign) BOOL recordGuideEnabled;
/* 是否开启闪光灯切换 */
@property (nonatomic, assign) BOOL flashSwitchEnabled;
/* 是否开启美颜切换 */
@property (nonatomic, assign) BOOL beautySwitchEnabled;
/* 美颜度 0-1 */
@property (nonatomic, assign) CGFloat beautyDegree;
/* 主题颜色 */
@property (nonatomic, strong) UIColor *tintColor;
/* 底部操作面板高度。默认120，小于85将导致面板显示不全，过大将导致覆盖。
   顶部操作面板高度44，进度条高度4，可以根据屏幕高度调节bottomPanelHeight使底部面板居中。
 */
@property (nonatomic, assign) CGFloat bottomPanelHeight;

+ (instancetype)shared;

/**
 * @param appKey    应用App Key
 * @param appSecret 应用App Secret
 * @param space     申请的授权空间名，命名规则：字母（区别大小写）+数字+特殊字符(短横线"-"，下划线"_"，点".")，长度限制在3-32之间
                    授权成功后，视频将上传到对应文件夹。建议为每个用户分配一个空间。
 */
- (void)registerAppWithKey:(NSString *)appKey
                    secret:(NSString *)appSecret
                     space:(NSString *)space
                   success:(void(^)(NSString *accessToken))success
                   failure:(void(^)(NSError *error))failure;

/**
 * @param mimDuration 允许拍摄的最小时长，时长越大，产生的视频文件越大。
 * @param maxDuration 允许拍摄的最大时长，时长越大，产生的视频文件越大。
 * @param bitRate     视频码率，建议800*1000-5000*1000,码率越大，视频越清析，视频文件也会越大。
                      参考：8秒的视频以2000*1000的码率压缩，文件大小1.5M-2M。请开发者根据自己的业务场景设置时长和码率。
 * @param videoSize   视频分辨率。
 */
- (UIViewController *)createRecordViewControllerWithMinDuration:(CGFloat)minDuration
                                                    maxDuration:(CGFloat)maxDuration
                                                        bitRate:(CGFloat)bitRate
                                                      videoSize:(CGSize)videoSize;
/**
 * 创建录制页面，需要以 UINavigationController 为父容器
 */
- (UIViewController *)createRecordViewController;

/**
 * 合成视频
 * @param packName 代理方法qupaiSDK:packName:中返回的packName。
 */
- (void)combinePackName:(NSString *)packName completionBlock:(void(^)(NSString *videoPath, NSError *error))block;

@end

@protocol QupaiSDKDelegate <NSObject>

/**
 * 录制取消
 */
- (void)qupaiSDKCancel:(QupaiSDK *)sdk;

/**
 * 录制完成
 * @param videoPath      视频的存储路径
 * @param thumbnailPath  视频首帧图的存储路径
 */
- (void)qupaiSDK:(QupaiSDK *)sdk compeleteVideoPath:(NSString *)videoPath thumbnailPath:(NSString *)thumbnailPath;

/**
 * 录制完成
 * @param packName 待合成的packName
 */
- (void)qupaiSDK:(QupaiSDK *)sdk packName:(NSString *)packName;
@end

