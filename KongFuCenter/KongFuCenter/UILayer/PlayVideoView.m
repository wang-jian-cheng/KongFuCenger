//
//  PlayVideoView.m
//  KongFuCenter
//
//  Created by Rain on 16/2/25.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "PlayVideoView.h"
#import "MoviePlayer.h"

@interface PlayVideoView()<MovieDelegate>{
    UIButton *backView;
    MoviePlayer *player;
    UIView *coverView;
}

@end

@implementation PlayVideoView

-(instancetype)init
{
    self = [super init];
    return self;
}

-(instancetype)initWithContent:(NSString *)title andVideoUrl:(NSString *)videoUrl{
    self = [super init];
    if (self) {
        _title = title;
        _videoUrl = videoUrl;
        [self initView];
    }
    return self;
}

-(void)initView{
    coverView =  [[UIView alloc]initWithFrame:[self topView].bounds];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0;
    coverView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    //[backView addTarget:self action:@selector(backViewEvent) forControlEvents:UIControlEventTouchUpInside];
    [[self topView] addSubview:coverView];
    
    backView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backView.backgroundColor = [UIColor blackColor];
    [backView addTarget:self action:@selector(backViewEvent) forControlEvents:UIControlEventTouchUpInside];
    [[self topView] addSubview:backView];

    player = [[MoviePlayer alloc] initWithFrame:CGRectMake(0,0.2 * SCREEN_HEIGHT,SCREEN_WIDTH, 0.6 * SCREEN_HEIGHT) URL:[NSURL URLWithString:_videoUrl]];
    [backView addSubview:player];
    [[self topView] addSubview:backView];
}

-(void)show{
    [UIView animateWithDuration:0.5 animations:^{
        coverView.alpha = 0.5;
    } completion:^(BOOL finished) {
        
    }];

    [[self topView] addSubview:self];
    [self showAnimation];
}

-(UIView*)topView{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    return  window.subviews[0];
}

-(void)showAnimation {
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 1.0;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.2f, 0.2f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [backView.layer addAnimation:popAnimation forKey:nil];
}

-(void)backViewEvent{
    [player stopPlayer];
    [backView removeFromSuperview];
    [self dismiss];
}

-(void)dismiss{
    [UIView animateWithDuration:0.4 animations:^{
        coverView.alpha = 0.0;
        backView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [backView removeFromSuperview];
    }];
}

-(void)MovieBig:(BOOL)isBig{
    if (isBig) {
        player.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }else{
        player.frame = CGRectMake(0, 0, 0.2 * SCREEN_WIDTH, 0.6 * SCREEN_HEIGHT);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
