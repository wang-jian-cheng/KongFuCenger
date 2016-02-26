//
//  MoviePlayer.h
//  MoviePlayer
//
//  Created by lanou on 15/11/6.
//  Copyright © 2015年 RockyFung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DIYButton.h"

// 枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, PanDirection){
    PanDirectionHorizontalMoved,
    PanDirectionVerticalMoved
};

@interface MoviePlayer : UIView<UIGestureRecognizerDelegate>

@property (nonatomic, strong, readonly) DIYButton *back; // 返回按钮

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSTimer *timer; // 定时器
// 初始化方法
- (instancetype)initWithFrame:(CGRect)frame URL:(NSURL *)url;
//关闭播放
-(void)stopPlayer;

@end
