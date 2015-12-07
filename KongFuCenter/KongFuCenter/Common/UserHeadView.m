//
//  UserHeadView.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/7.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "UserHeadView.h"

@implementation UserHeadView


-(id)initWithFrame:(CGRect)frame andImgName:(NSString *)name
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIButton *headBtn = [[UIButton alloc] initWithFrame:frame];
        [headBtn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
        [self addSubview:headBtn];
        
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
