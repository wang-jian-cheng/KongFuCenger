//
//  PictureShowView.h
//  HiHome
//
//  Created by 王建成 on 15/11/12.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PictureShowViewDelegate <NSObject>

-(void)didClickDelPicBtn:(NSInteger)index;

@end

@interface PictureShowView : UIScrollView<UIGestureRecognizerDelegate>
{

    CGPoint beginPoint;
}
@property(assign,nonatomic)NSString *ImgUrl;
@property(assign,nonatomic)NSInteger picIndex;
//@property(nonatomic) id<PictureShowViewDelegate> delegate;


    //移植于VIPhoto
//@property (nonatomic, strong) UIView *containerView;
//@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic) BOOL rotating;
@property (nonatomic) CGSize minSize;

- (instancetype)initWithTitle:(NSString *)title showImg:(UIImage *)showImg;
- (void)show;
- (void)dismiss;
@end
