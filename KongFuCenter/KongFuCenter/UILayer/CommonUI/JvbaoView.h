//
//  JvbaoView.h
//  KongFuCenter
//
//  Created by Wangjc on 16/1/12.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JvbaoDelegate <NSObject>

-(void)JvbaoSureBtnClick:(NSString *)content;

@end


@interface JvbaoView : UIView<UITextViewDelegate>
{
    UILabel *titleLab ;
    UIButton *cancelBtn;
    UIButton *sureBtn;
    
    UIView *coverView;
    UIView *showView;
    
}
@property(nonatomic)UITextView *contentTextView;
@property(nonatomic)UILabel *holderLab;
@property(nonatomic) id<JvbaoDelegate>delegate;

- (void)show ;
@end
