//
//  DeltaView.m
//  KongFuCenter
//
//  Created by Wangjc on 16/2/27.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "DeltaView.h"


@interface DeltaView ()
{
    CGPoint _point1;
    CGPoint _point2;
    CGPoint _point3;
}
@end
@implementation DeltaView

-(instancetype)initWithPoint:(CGPoint)point andHeight:(CGFloat)height
{
    self = [super init];
    if(self)
    {
        _point1 = point;
        _point2 = CGPointMake(_point1.x - fabs(height) , _point1.y+height);
        _point3 = CGPointMake(_point1.x + fabs(height) , _point1.y+height);
    }
        
    return self;
}

-(void)drawRect:(CGRect)rect

{
    //设置背景颜色
    
    [[UIColor clearColor]set];
    
    UIRectFill([self bounds]);
    
    //拿到当前视图准备好的画板
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //利用path进行绘制三角形
    
    CGContextBeginPath(context);//标记
    
    CGContextMoveToPoint(context,_point1.x, _point1.y);//设置起点
    
    CGContextAddLineToPoint(context,_point2.x, _point2.y);
    
    CGContextAddLineToPoint(context,_point3.x, _point3.y);
    
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    
    [BACKGROUND_COLOR setFill]; //设置填充色
    
    [BACKGROUND_COLOR setStroke]; //设置边框颜色
    
    CGContextDrawPath(context, kCGPathFillStroke);//绘制路径path
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
