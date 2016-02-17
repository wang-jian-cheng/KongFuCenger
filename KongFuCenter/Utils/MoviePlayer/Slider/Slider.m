
//
//  Slider.m
//  ProgressSlider
//
//  Created by lanou on 15/11/9.
//  Copyright © 2015年 RockyFung. All rights reserved.
//

#import "Slider.h"
@interface Slider ()

@property (nonatomic, strong) UIView *cacheView;

@end


@implementation Slider
// 定义属性
{
    CGFloat centerX; // 用于保存centerX的位置
}


- (void)dealloc
{
    // 代理滞空
    _delegate = nil;
    // 移除kvo
    [self.thumbView removeObserver:self forKeyPath:@"frame"];
    [self.slider removeObserver:self forKeyPath:@"value"];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 继承于UIView而不继承于UISlider的原因是，UISlider内部添加的任何View都处于滑轨线的下面，所以继承于view，把创建的view添加到整个slider的上面
        // 一定要是self.bounds; self.frame可能会造成视图偏差；
        _slider = [[UISlider alloc]initWithFrame:self.bounds];
        // 设置slider的图片，给一个空图片
        [_slider setThumbImage:[UIImage imageNamed:@"nil"] forState:UIControlStateNormal];
        // 添加滑块方法
        [_slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_slider];
        
        _slider.minimumTrackTintColor=[UIColor orangeColor];
        // 给centerX初始值
        centerX = 0;
        
        
        // 缓冲条在slider上面，滑块的下面
        self.cacheView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 2)];
        // 用户交互关闭
        self.cacheView.userInteractionEnabled = NO;
        [self addSubview:_cacheView];
        
        
        
        // 添加kvo，如果用户改变frame的大小，就对center修改
        [self.thumbView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
        
        
        // 创建滑块视图
        self.thumbView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        self.thumbView.backgroundColor = [UIColor whiteColor];
        self.thumbView.center = CGPointMake(0, frame.size.height / 2);
        // 把用户交互关闭，防止响应者链断开，造成slider不可滑动
        self.thumbView.userInteractionEnabled = NO;
        self.thumbView.layer.cornerRadius = 10;
        [self addSubview:_thumbView];
        
        // 放到滑块上面
//        [self insertSubview:_cacheView aboveSubview:_thumbView];
        
        // 添加轻拍手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
       
        
        // 添加kvo，观察slider的value值，然后对滑块的位置做修改
        [self.slider addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return self;
}

#pragma mark - kvo执行方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        self.thumbView.center = CGPointMake(centerX, self.frame.size.height / 2);
    }
    else if ([keyPath isEqualToString:@"value"]){
        // 修改滑块位置
        CGFloat progress = self.slider.value / (self.slider.maximumValue - self.slider.minimumValue);
        self.thumbView.center = CGPointMake(self.frame.size.width * progress, self.frame.size.height / 2);
    }
    
}

#pragma mark - 轻拍手势方法
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    // 获取tap手势的位置
    CGPoint touch = [tap locationInView:self];
    // 返回判断（解决bug：在滑轨外面点，滑块会跑出去）
    if (touch.x < 0) {
        touch.x = 0;
    }
    else if (touch.x > self.frame.size.width)
    {
        touch.x = self.frame.size.width;
    }
    // 点哪，滑块就跳到哪里
    self.thumbView.center = CGPointMake(touch.x, self.frame.size.height / 2);
    
    
    
    // 求出这个点所在百分比
    CGFloat progress = touch.x / self.frame.size.width;
    // 根据百分比计算出value的值
    CGFloat value = (_slider.maximumValue - _slider.minimumValue) * progress;
    self.slider.value = value;
    
    // 传递参数
    if ([_delegate respondsToSelector:@selector(touchView:)]) {
        [_delegate touchView:value];
    }
    
}


#pragma mark - 滑块的值改变触发的方法
- (void)sliderAction:(UISlider *)slider
{
    // 求出value所在的百分比
    CGFloat progress = slider.value / (slider.maximumValue - slider.minimumValue);
    // 求出thumbView的X点
    CGFloat thumbViewX = self.frame.size.width * progress;
    self.thumbView.center = CGPointMake(thumbViewX, self.frame.size.height / 2);
    // 保存centerX的值
    centerX = self.thumbView.center.x;
//    NSLog(@"%f",slider.value);
}


#pragma mark - 更换视图执行的方法
- (void)setThumbView:(UIView *)thumbView
{
    // 移除老视图的观察者
    [_thumbView removeObserver:self forKeyPath:@"frame"];
    // 移除之前的视图
    [_thumbView removeFromSuperview];
    // 添加新视图
    [self addSubview:thumbView];
    // 指针重新赋值
    _thumbView = thumbView;
    // 添加一个新观察者
    [_thumbView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    // 让它走一次kvo的方法
    _thumbView.frame = thumbView.frame;
}

#pragma mark - 外部更改frame，内部子视图也要修改
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.slider.frame = self.bounds;
}


#pragma mark - 重写cache方法
- (void)setCache:(CGFloat)cache
{
    if (cache < self.slider.minimumValue) {
        cache = self.slider.minimumValue;
    }
    else if (cache > self.slider.maximumValue){
        cache = self.slider.maximumValue;
    }
    // 求出百分比
    CGFloat progress = cache / (self.slider.maximumValue - self.slider.minimumValue);
    // 对cacheView的frame进行赋值
    CGFloat thumbX = self.thumbView.frame.origin.x; // 滑块的x值
    self.cacheView.frame = CGRectMake(thumbX, (self.frame.size.height - 2) / 2, progress * self.frame.size.width - thumbX, 2);

}

#pragma mark - 更改缓冲条的背景颜色
- (void)setCacheColor:(UIColor *)cacheColor
{
    self.cacheView.backgroundColor = cacheColor;
}




















@end
