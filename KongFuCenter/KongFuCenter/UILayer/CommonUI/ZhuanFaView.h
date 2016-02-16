//
//  ZhuanFaView.h
//  KongFuCenter
//
//  Created by Wangjc on 16/2/16.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZhuanFaDelegate <NSObject>

-(void)ZhuanFaSureBtnClick:(NSString *)content;

@end

@interface ZhuanFaView : UIView<UITextViewDelegate>
{

    
}

@property(nonatomic)UIImage *mainImg;
@property(nonatomic)NSString *title;
@property(nonatomic)NSString *content;
@property(nonatomic)NSString *tip;
@property(nonatomic)id<ZhuanFaDelegate>delegate;
@property(nonatomic) UIImageView *mainImgView;
- (void)show;

- (instancetype)initWithTip:(NSString *)tip andTitle:(NSString *)title andContent:(NSString *)content andMainImg:(UIImage *)mainImg;
@end
