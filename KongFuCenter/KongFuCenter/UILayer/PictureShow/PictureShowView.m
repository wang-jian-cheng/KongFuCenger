//
//  PictureShowView.m
//  HiHome
//
//  Created by 王建成 on 15/11/12.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "PictureShowView.h"

#ifndef SCREEN_WIDTH
#define SCREEN_WIDTH  ([[UIScreen mainScreen] bounds].size.width)
#endif

#define AlertHeight 300
//#define AlertWidth


@interface UIImage (VIUtil)

- (CGSize)sizeThatFits:(CGSize)size;

@end

@implementation UIImage (VIUtil)

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize imageSize = CGSizeMake(self.size.width / self.scale,
                                  self.size.height / self.scale);
    
    CGFloat widthRatio = imageSize.width / size.width;
    CGFloat heightRatio = imageSize.height / size.height;
    
    if (widthRatio > heightRatio) {
        imageSize = CGSizeMake(imageSize.width / widthRatio, imageSize.height / widthRatio);
    } else {
        imageSize = CGSizeMake(imageSize.width / heightRatio, imageSize.height / heightRatio);
    }
    
    return imageSize;
}

@end

@interface UIImageView (VIUtil)

- (CGSize)contentSize;

@end

@implementation UIImageView (VIUtil)

- (CGSize)contentSize
{
    return [self.image sizeThatFits:self.bounds.size];
}

@end





@interface PictureShowView()<UIScrollViewDelegate>
{
    NSString *_title;
    UIImage *_showImg;
    UIView *_coverView;
    UIView *_alertView;
    
    UILabel *indexLab;
    
    UIImageView *headImg;
    UIButton *delBtn ;
    NSString *_url;
    
    volatile NSUInteger showIndex;
    
    BOOL showPicNormalMode;
}
@end

@implementation PictureShowView

- (instancetype)initWithTitle:(NSString *)title
                      andImgs:(NSArray <UIImageView *>*)showImg andShowIndex:(NSUInteger)index{
    self = [super init];
    if (self) {
        _title = title;
        self.delegate = self;
        if(showImg==nil)
            return self;
        
        showIndex  = index;
        self.imgArr = showImg;
        if(showImg == nil || showImg.count ==0)
            return self;
        if(showIndex>self.imgArr.count)
            showIndex = 0;
        _showImg = self.imgArr[showIndex];
        
        
        showPicNormalMode = YES;
        [self buildViews];
    }
    return self;
}


- (instancetype)initWithTitle:(NSString *)title
                   andImgUrls:(NSArray *)showImgUrls andShowIndex:(NSUInteger)index andHolderImg:(UIImage *)holderImg{
    self = [super init];
    if (self) {
        _title = title;
        self.delegate = self;
        
        
        showIndex  = index;
        if(showImgUrls == nil || showImgUrls.count ==0)
            return self;
        self.imgUrls = showImgUrls;
        if(showIndex>self.imgUrls.count)
            showIndex = 0;
        _showImg = holderImg;
        _url = showImgUrls[showIndex];
        showPicNormalMode = YES;
        [self buildViews];
    }
    return self;
}


- (instancetype)initWithTitle:(NSString *)title
                      showImg:(UIImage *)showImg{
    self = [super init];
    if (self) {
        _title = title;
        _showImg = showImg;
    
        self.delegate = self;
        [self buildViews];
    }
    return self;
}
#if SHOW_URLIMG
- (instancetype)initWithUrl:(NSString *)url andHolderImg:(UIImage *)showImg{
    self = [super init];
    if (self) {
        _url = url;
        _showImg = showImg;
        
        self.delegate = self;
        //  _alertType = AlertType_Hint;
        [self buildViews];
        //   [self initViews];
    }
    return self;
}
#endif

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


-(void)buildViews{
    self.frame = [self screenBounds];

    _coverView = [[UIView alloc]initWithFrame:[self topView].bounds];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.alpha = 0;
    _coverView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [[self topView] addSubview:_coverView];
    
    if(_showImg != nil)
    {
        if(_showImg.size.width >= SCREEN_WIDTH)
        {
            _imgShowView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , SCREEN_WIDTH)];
        }
        else
        {
            _imgShowView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , AlertHeight)];
        }
        
        _imgShowView.contentMode = UIViewContentModeScaleAspectFit;
#if SHOW_URLIMG
        if(_url !=nil)
        {
            [_imgShowView sd_setImageWithURL:[NSURL URLWithString:_url] placeholderImage:_showImg];
        }
        else
#endif
        {
            _imgShowView.image =_showImg;
        }
      //  self.contentSize = img.size;
    }
    else
    {
        _imgShowView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , AlertHeight)];
        
    }
    
    if(self.imgUrls!=nil&&self.imgUrls.count>0)
    {
        indexLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        indexLab.textColor = [UIColor whiteColor];
        indexLab.textAlignment = NSTextAlignmentCenter;
        indexLab.text = [NSString stringWithFormat:@"%lu/%ld",(unsigned long)(showIndex+1),(unsigned long)self.imgUrls.count];
        [self addSubview:indexLab];
    }
    else if(self.imgArr!=nil&&self.imgArr.count>0)
    {
        indexLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        indexLab.textColor = [UIColor whiteColor];
        indexLab.textAlignment = NSTextAlignmentCenter;
        indexLab.text = [NSString stringWithFormat:@"%lu/%ld",(unsigned long)(showIndex+1),(unsigned long)self.imgArr.count];
        [self addSubview:indexLab];
    }
    
    _imgShowView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    _imgShowView.backgroundColor = [UIColor blackColor];
    [self addSubview:_imgShowView];
    

    delBtn =[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 44 -20, 20, 44, 44)];
    [delBtn setImage:[UIImage imageNamed:@"del"] forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
 //   [self addSubview:delBtn];

    
    [self setupGestureRecognizer];//手势
    [self setMaxMinZoomScale];//设置缩放比例
    [self setupRotationNotification];
}

//-(void)setShowIndex:(NSUInteger)showIndex
//{
//    _showIndex = showIndex;
//    
//    if () {
//
//    }
//}


- (void)setupGestureRecognizer
{
    //单击退出手势
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:)];
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
    
    
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    [tapGesture requireGestureRecognizerToFail:doubleTapGestureRecognizer];//等待多次点击失败再执行单机
    [self addGestureRecognizer:doubleTapGestureRecognizer];
    
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPressRecognizer.minimumPressDuration = 0.5; //设置最小长按时间；默认为0.5秒
    
    [tapGesture requireGestureRecognizerToFail:longPressRecognizer];
    [self addGestureRecognizer:longPressRecognizer];
    
    if((self.imgUrls !=nil && self.imgUrls.count>0 )|| (self.imgArr !=nil && self.imgArr.count>0 ))
    {
        UISwipeGestureRecognizer *SwipRight = [[UISwipeGestureRecognizer alloc] init];
        SwipRight.direction = UISwipeGestureRecognizerDirectionRight;
        [SwipRight addTarget:self action:@selector(swipRight)];
        [self addGestureRecognizer:SwipRight];
       // [pan requireGestureRecognizerToFail:tempSwipRight];
        SwipRight.delegate = self;
        
        
        UISwipeGestureRecognizer *SwipLeft = [[UISwipeGestureRecognizer alloc] init];
        SwipLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        [SwipLeft addTarget:self action:@selector(swipLeft)];
        [self addGestureRecognizer:SwipLeft];
    //    [pan requireGestureRecognizerToFail:tempSwipLeft];
        SwipLeft.delegate = self;
    }
}

-(void)swipRight
{
    if(showIndex == 0||showPicNormalMode == NO)
        return;
    
    showIndex -- ;
    if(self.imgUrls !=nil && self.imgUrls.count > 0)
    {
        
        _url = self.imgUrls[showIndex];
        [_imgShowView sd_setImageWithURL:[NSURL URLWithString:_url] placeholderImage:_showImg];
        indexLab.text = [NSString stringWithFormat:@"%lu/%ld",(unsigned long)(showIndex+1),(unsigned long)self.imgUrls.count];
    }
    if(self.imgArr!=nil && self.imgArr.count > 0)
    {
        _showImg = self.imgArr[showIndex];
        _imgShowView.image = _showImg;
        indexLab.text = [NSString stringWithFormat:@"%lu/%ld",(unsigned long)(showIndex+1),(unsigned long)self.imgArr.count];
    }
    
    
}
-(void)swipLeft
{
    if(showIndex == self.imgUrls.count -1||showPicNormalMode == NO)
        return;
    if(showIndex == self.imgArr.count -1||showPicNormalMode == NO)
        return;
    
    showIndex ++ ;
    if(self.imgUrls !=nil && self.imgUrls.count > 0)
    {
        
        _url = self.imgUrls[showIndex];
        [_imgShowView sd_setImageWithURL:[NSURL URLWithString:_url] placeholderImage:_showImg];
        indexLab.text = [NSString stringWithFormat:@"%lu/%ld",(unsigned long)(showIndex+1),(unsigned long)self.imgUrls.count];
    }
    if(self.imgArr!=nil && self.imgArr.count > 0)
    {
        _showImg = self.imgArr[showIndex];
        _imgShowView.image = _showImg;
        indexLab.text = [NSString stringWithFormat:@"%lu/%ld",(unsigned long)(showIndex+1),(unsigned long)self.imgArr.count];
    }
}
-(void)handleLongPress:(UILongPressGestureRecognizer *)sender
{
    
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        
        NSLog(@"Long press");
        
        if([self.mydelegate respondsToSelector:@selector(longPressCallBack)])
        {
            [self.mydelegate longPressCallBack];
        }
        //add your code here   
        
        
    }   
    
    
}
-(void)btnClickAction:(UIButton *)sender
{
    if([self.mydelegate respondsToSelector:@selector(didClickDelPicBtn)])
    {
        [self.mydelegate didClickDelPicBtn];
    }

}


-(void)tapViewAction:(UIPanGestureRecognizer *)recognizer
{
    CGFloat tapX;
    CGFloat tapY;
    tapX = [recognizer locationInView:self].x;
    tapY = [recognizer locationInView:self].y;
    
    NSLog(@"tapX = %lf ,tapY = %lf",tapX,tapY);
    
    if(!(
        (_imgShowView.frame.origin.x < tapX && _imgShowView.frame.origin.x + _imgShowView.frame.size.width>tapX)
       &&(_imgShowView.frame.origin.y < tapY && _imgShowView.frame.origin.y + _imgShowView.frame.size.height>tapY)
         )
       )//点击范围在图片之外才触发消失事件
    {
        [self dismiss];
    }
}
-(void)setImgUrl:(NSString *)ImgUrl
{
    _ImgUrl = ImgUrl;
    
 //   [_imgShowView sd_setImageWithURL:[NSURL URLWithString:self.ImgUrl] placeholderImage:[UIImage imageNamed:@"me"]];

}
- (CGFloat)heightWithString:(NSString*)string fontSize:(CGFloat)fontSize width:(CGFloat)width
{
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    return  [string boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size.height;
}

#pragma mark - add item

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [self reLayout];
}



#pragma mark - Handle device orientation changes
// Handle device orientation changes
- (void)deviceOrientationDidChange: (NSNotification *)notification
{
    //    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    self.frame = [self screenBounds];
    //NSLog(@"self.frame%@",NSStringFromCGRect(self.frame));
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         //  [self reLayout];
                     }
                     completion:nil
     ];
    
    
}

-(void)reLayout{
    //   CGFloat plus;
    
    
    [self setNeedsDisplay];
    [self setNeedsLayout];
}
#pragma mark - 图片拖动 可以添加拖动时代理方法
- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    // Retrieve the touch point

    beginPoint = [[touches anyObject] locationInView:_imgShowView]; //记录第一个点，以便计算移动距离
    
//    if ([self._delegate respondsToSelector: @selector(animalViewTouchesBegan)]) //设置代理类，
//        //在图像移动的时候，可以做一些处理
//        [self._delegate animalViewTouchesBegan];
}
- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    // Move relative to the original touch point
    // 计算移动距离，并更新图像的frame
    if(showPicNormalMode == YES)
    {
//        图片原始比例禁止拖动
        return;
    }
    
    CGPoint pt = [[touches anyObject] locationInView:_imgShowView];
    CGRect frame = [_imgShowView frame];
    frame.origin.x += pt.x - beginPoint.x;
    frame.origin.y += pt.y - beginPoint.y;
    [_imgShowView setFrame:frame];
//    if ([self._delegate respondsToSelector: @selector(animalViewTouchesMoved)])
//        [self._delegate animalViewTouchesMoved];
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    if ([self._delegate respondsToSelector: @selector(animalViewTouchesEnded)])
//        [self._delegate animalViewTouchesEnded];
}


#pragma mark - notice page  show

-(UIView*)topView{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    return  window.subviews[0];
}


- (void)showAnimation {
//    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//    popAnimation.duration = 0.4;
//    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
//                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
//                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
//                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
//    
//    
//    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
//    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
//                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
//                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//    [_imgShowView.layer addAnimation:popAnimation forKey:nil];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    //没有设置fromValue说明当前状态作为初始值
    //宽度(width)变为原来的2倍，高度(height)变为原来的1.5倍
    animation.fromValue =[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1)];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    
    //动画执行后保持显示状态 但是属性值不会改变 只会保持显示状态
 //   animation.fillMode = kCAFillModeForwards;
  //  animation.removedOnCompletion = NO;
    
    
    [_imgShowView.layer addAnimation:animation forKey:nil];
    
}
-(void)dismissAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    //没有设置fromValue说明当前状态作为初始值
    //宽度(width)变为原来的2倍，高度(height)变为原来的1.5倍
    animation.toValue =[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1)];
    animation.fromValue= [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    
    //动画执行后保持显示状态 但是属性值不会改变 只会保持显示状态
  //  animation.fillMode = kCAFillModeForwards;
  //  animation.removedOnCompletion = NO;
    
    
    [_imgShowView.layer addAnimation:animation forKey:nil];
    
}



- (void)show {
    [UIView animateWithDuration:0.5 animations:^{
        _coverView.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
    }];
    
    [[self topView] addSubview:self];
    [self showAnimation];
}

- (void)dismiss {
    [self dismissAnimation];
    [self hideAnimation];
}


- (void)hideAnimation{
    [UIView animateWithDuration:0.4 animations:^{
        _coverView.alpha = 0.0;
        _imgShowView.alpha = 0.0;
        delBtn.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    
}



#pragma mark - 移植于viphoto


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.rotating) {
        self.rotating = NO;
        
        // update container view frame
        CGSize containerSize = _imgShowView.frame.size;
        BOOL containerSmallerThanSelf = (containerSize.width < CGRectGetWidth(self.bounds)) && (containerSize.height < CGRectGetHeight(self.bounds));
        
        CGSize imageSize = [_imgShowView.image sizeThatFits:self.bounds.size];
        CGFloat minZoomScale = imageSize.width / self.minSize.width;
        self.minimumZoomScale = minZoomScale;
        if (containerSmallerThanSelf || self.zoomScale == self.minimumZoomScale) { // 宽度或高度 都小于 self 的宽度和高度
            self.zoomScale = minZoomScale;
        }
        
        // Center container view
        [self centerContent];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setup

- (void)setupRotationNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
   // return self.containerView;
    return _imgShowView;
    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self centerContent];
}

#pragma mark - GestureRecognizer

- (void)tapHandler:(UITapGestureRecognizer *)recognizer
{
    if (self.zoomScale > self.minimumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
        showPicNormalMode = YES;
    } else if (self.zoomScale < self.maximumZoomScale) {
        CGPoint location = [recognizer locationInView:recognizer.view];
        CGRect zoomToRect = CGRectMake(0, 0, 50, 50);
        zoomToRect.origin = CGPointMake(location.x - CGRectGetWidth(zoomToRect)/2, location.y - CGRectGetHeight(zoomToRect)/2);
        [self zoomToRect:zoomToRect animated:YES];
        showPicNormalMode = NO;
    }
}

#pragma mark - Notification

- (void)orientationChanged:(NSNotification *)notification
{
    self.rotating = YES;
}

#pragma mark - Helper

- (void)setMaxMinZoomScale
{
    CGSize imageSize = _imgShowView.image.size;
    CGSize imagePresentationSize = _imgShowView.contentSize;
    CGFloat maxScale = MAX(imageSize.height / imagePresentationSize.height, imageSize.width / imagePresentationSize.width);
    self.maximumZoomScale = MAX(1, maxScale); // Should not less than 1
    self.minimumZoomScale = 1.0;
}

- (void)centerContent
{
    
    showPicNormalMode = NO;
    CGRect frame = _imgShowView.frame;
    
    CGFloat top = 0, left = 0;
    if (self.contentSize.width < self.bounds.size.width) {
        left = (self.bounds.size.width - self.contentSize.width) * 0.5f;
    }
    if (self.contentSize.height < self.bounds.size.height) {
        top = (self.bounds.size.height - self.contentSize.height) * 0.5f;
    }
    
    top -= frame.origin.y;
    left -= frame.origin.x;
    
    self.contentInset = UIEdgeInsetsMake(top, left, top, left);
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end



