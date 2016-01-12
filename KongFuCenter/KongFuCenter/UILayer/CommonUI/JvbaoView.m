//
//  JvbaoView.m
//  KongFuCenter
//
//  Created by Wangjc on 16/1/12.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "JvbaoView.h"

#define ViewHeight  200
#define ViewWidth   (SCREEN_WIDTH - 40)

@implementation JvbaoView

- (instancetype)init{
    self = [super init];
    if (self) {
        
        [self buildViews];
    }
    return self;
}

-(void)buildViews
{
    self.frame = [self screenBounds];
    coverView =  [[UIView alloc]initWithFrame:[self topView].bounds];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0;
    coverView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [[self topView] addSubview:coverView];
    
    showView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
    showView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    showView.layer.masksToBounds = YES;
    showView.backgroundColor = BACKGROUND_COLOR;
    [self addSubview:showView];
    
    
    titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, showView.frame.size.width, 45)];
    titleLab.text = @"举报事由";
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [showView addSubview:titleLab];
    
    
    cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, ViewHeight-44, ViewWidth/2, 44)];
    cancelBtn.tag = 1000 + 1;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.backgroundColor = ItemsBaseColor;
    [cancelBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [showView addSubview:cancelBtn];
    
    
    sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(ViewWidth/2, ViewHeight-44, ViewWidth/2, 44)];
    sureBtn.tag = 1000 + 2;
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    sureBtn.backgroundColor = ItemsBaseColor;
    [sureBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [showView addSubview:sureBtn];
    
    self.contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 45,
                                                                        ViewWidth - 20*2,
                                                                        ViewHeight - sureBtn.frame.size.height - titleLab.frame.size.height - 10)];
    
    self.contentTextView.delegate = self;
    self.contentTextView.backgroundColor = [UIColor grayColor];
    [showView addSubview:self.contentTextView];
    
    self.holderLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.contentTextView.frame.size.width, 30)];
    self.holderLab.text = @"请输入举报内容";
    [self.contentTextView addSubview:self.holderLab];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:) ];
    [self addGestureRecognizer:tapGesture];

}

-(void)tapViewAction:(id)sender
{
    [self endEditing:YES];
}

- (CGRect)screenBounds
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    // On iOS7, screen width and height doesn't automatically follow orientation
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
            CGFloat tmp = screenWidth;
            screenWidth = screenHeight;
            screenHeight = tmp;
        }
    }
    
    return CGRectMake(0, 0, screenWidth, screenHeight);
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.holderLab.hidden = YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
//    self.holderLab.hidden = YES;
    
    return YES;
}

-(void)clickAction:(UIButton *)sender
{
    if(sender == sureBtn)
    {
        sureBtn.backgroundColor = YellowBlock;
        cancelBtn.backgroundColor = ItemsBaseColor;
        
        if([self.delegate respondsToSelector:@selector(JvbaoSureBtnClick:)])
        {
            [self.delegate JvbaoSureBtnClick:self.contentTextView.text];
        }
        
    }
    else if(sender == cancelBtn)
    {
        cancelBtn.backgroundColor = YellowBlock;
        sureBtn.backgroundColor = ItemsBaseColor;
    }
    
    [self dismiss];
}

-(UIView*)topView{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    return  window.subviews[0];
}

- (void)show {
    [UIView animateWithDuration:0.5 animations:^{
        coverView.alpha = 0.5;
        
    } completion:^(BOOL finished) {
        
    }];
    
    [[self topView] addSubview:self];
    [self showAnimation];
}

- (void)dismiss {
    [self hideAnimation];
    [self endEditing:YES];
}

- (void)showAnimation {
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [showView.layer addAnimation:popAnimation forKey:nil];
}

- (void)hideAnimation{
    [UIView animateWithDuration:0.4 animations:^{
        coverView.alpha = 0.0;
        coverView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
