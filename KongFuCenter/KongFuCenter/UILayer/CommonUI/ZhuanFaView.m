//
//  ZhuanFaView.m
//  KongFuCenter
//
//  Created by Wangjc on 16/2/16.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "ZhuanFaView.h"

#define ViewHeight  240
#define ViewWidth   (300)

#define GapToLeft   20

@interface ZhuanFaView ()
{
    UILabel *tipLab;
    UILabel *titleLab;
    UILabel *contentLab;
   
    
    
    UIButton *cancelBtn;
    UIButton *sureBtn;
    
    UIView *coverView;
    UIView *showView;
}
@property(nonatomic)UITextView *contentTextView;
@property(nonatomic)UILabel *holderLab;

@end

@implementation ZhuanFaView


- (instancetype)init{
    self = [super init];
    if (self) {
        
        [self buildViews];
    }
    return self;
}

- (instancetype)initWithTip:(NSString *)tip andTitle:(NSString *)title andContent:(NSString *)content andMainImg:(UIImage *)mainImg
{
    self = [super init];
    if (self) {
        _tip = tip;
        _title = title;
        _content = content;
        _mainImg = mainImg;
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
    showView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - 50);
    showView.layer.masksToBounds = YES;
    showView.layer.cornerRadius = 5;
    showView.backgroundColor = BACKGROUND_COLOR;
    [self addSubview:showView];
    
    tipLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 0, ViewWidth - GapToLeft*2, 50)];
    tipLab.text = self.tip;
    tipLab.textColor = [UIColor whiteColor];
    tipLab.font = [UIFont boldSystemFontOfSize:16];
    
    [showView addSubview:tipLab];
    
    self.mainImgView = [[UIImageView alloc] initWithFrame:CGRectMake(GapToLeft,
                                                               (tipLab.frame.size.height + tipLab.frame.origin.y),
                                                                80, 80)];
    self.mainImgView.image = self.mainImg;
    
    [showView addSubview:self.mainImgView];
    
    titleLab = [[UILabel alloc] initWithFrame:CGRectMake(self.mainImgView.frame.size.width+self.mainImgView.frame.origin.x+10,
                                                        self.mainImgView.frame.origin.y,
                                                        ViewWidth - (self.mainImgView.frame.size.width+self.mainImgView.frame.origin.x) - GapToLeft,
                                                         self.mainImgView.frame.size.height/4)];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.text = self.title;
    titleLab.font = [UIFont systemFontOfSize:14];
    [showView addSubview:titleLab];
    
    contentLab = [[UILabel alloc] initWithFrame:CGRectMake(titleLab.frame.origin.x,
                                                          titleLab.frame.origin.y+titleLab.frame.size.height,
                                                          titleLab.frame.size.width,
                                                           self.mainImgView.frame.size.height/4*3)];
    contentLab.numberOfLines = 0;
    contentLab.font = [UIFont systemFontOfSize:14];
    contentLab.text = self.content;
    contentLab.textColor = [UIColor whiteColor];
    [showView addSubview:contentLab];
    
    
    
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
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(cancelBtn.frame.size.width, cancelBtn.frame.origin.y, 1, cancelBtn.frame.size.height)];
    lineView.backgroundColor = BACKGROUND_COLOR;
    [showView addSubview:lineView];
    
    self.contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, sureBtn.frame.origin.y - 40 -10,
                                                                        ViewWidth - 20*2,
                                                                        40)];
    
    self.contentTextView.delegate = self;
    self.contentTextView.backgroundColor = [UIColor grayColor];
    self.contentTextView.font = [UIFont systemFontOfSize:14];
    [showView addSubview:self.contentTextView];
    
    self.holderLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.contentTextView.frame.size.width,self.contentTextView.frame.size.height)];
    self.holderLab.text = @"来，讲两句！";
    self.holderLab.font = [UIFont systemFontOfSize:14];
    [self.contentTextView addSubview:self.holderLab];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:) ];
    [self addGestureRecognizer:tapGesture];
    
}

#pragma mark - self property
-(void)setTip:(NSString *)tip
{
    _tip = tip;
    
    tipLab.text = _tip;
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    titleLab.text = _title;
}

-(void)setContent:(NSString *)content
{
    _content = content;
    contentLab.text = content;
}
-(void)setMainImg:(UIImage *)mainImg
{
    _mainImg = mainImg;
    self.mainImgView.image = _mainImg;
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
        
        if([self.delegate respondsToSelector:@selector(ZhuanFaSureBtnClick:)])
        {
            [self.delegate ZhuanFaSureBtnClick:self.contentTextView.text];
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
    [UIView animateWithDuration:0.5 animations:^{
        coverView.alpha = 0.0;
        showView.alpha = 0.0;
        
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
