//
//  UITableViewCell+EditMode.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/5.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "UITableViewCell+EditMode.h"


@implementation UITableViewCell (EditMode)

-(void)setCellEditMode:(BOOL)enableEditMode andGapSize:(CGFloat)gapSize
{
    CGRect tempRect;
    
    if(enableEditMode == NO)
    {
        tempRect = self.contentView.frame;
        tempRect.origin.x = 0;
        self.contentView.frame = tempRect;
    }
    else
    {
        NSArray *subViews;
        
        subViews = self.contentView.subviews;
        
        for(UIView *tempView in subViews)
        {
//            tempRect = tempView.frame;
//            tempRect.origin.x += gapSize;
            tempView.frame = CGRectMake(gapSize, 0, 100, 100);
        }
        
        
      //  self.contentView.backgroundColor = [UIColor greenColor];
        UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 10, 15, 15)];
        selectBtn.center  = CGPointMake(gapSize/2, self.frame.size.height/2);
        selectBtn.backgroundColor = [UIColor redColor];
        
        [self addSubview:selectBtn];
        
    }
}

@end
