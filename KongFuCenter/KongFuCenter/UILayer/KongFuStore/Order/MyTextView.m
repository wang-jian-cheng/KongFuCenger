//
//  MyTextView.m
//  KongFuCenter
//
//  Created by Wangjc on 16/1/25.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "MyTextView.h"

@implementation MyTextView

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.delegate = self;
        [self addSubview:self.placeHolder];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.delegate = self;
        [self addSubview:self.placeHolder];
    }
    return self;
}

#pragma mark - delegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if([self.mydelegate respondsToSelector:@selector(myTextViewDidBeginEditing:)])
    {
        [self.mydelegate myTextViewDidBeginEditing:self];
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    if(textView.text.length == 0)
    {
        self.placeHolder.hidden = NO;
    }
    else
    {
        self.placeHolder.hidden = YES;
    }
    
    
    
    if([self.mydelegate respondsToSelector:@selector(myTextViewDidChange:)])
    {
        [self.mydelegate myTextViewDidChange:self];
    }
}

-(void)setFrame:(CGRect)frame
{
    super.frame = frame;
    _placeHolder.frame =CGRectMake(5, 0, frame.size.width-5, 30);
    
}




-(UILabel *)placeHolder
{
    if(_placeHolder==nil)
    {
        _placeHolder = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.frame.size.width-5, 30)];
    }
    
    return _placeHolder;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
