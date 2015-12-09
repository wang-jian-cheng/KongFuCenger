//
//  SelectRoundBtn.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/9.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "SelectRoundBtn.h"

@implementation SelectRoundBtn


-(id)initWithCenter:(CGPoint)point
{
    self = [super init];
    if(self)
    {
        self.frame = CGRectMake(0, 0, 20, 20);
        self.center = point;
        [self makeSelfRound];
        [self setImage:[UIImage imageNamed:@"selectRound"] forState:UIControlStateSelected];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}



-(void)makeSelfRound
{
    self.layer.cornerRadius = self.frame.size.width * 0.5;
    self.layer.borderWidth = 0.1;
    self.layer.masksToBounds = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
