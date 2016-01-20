//
//  PictureShowView.h
//  HiHome
//
//  Created by 王建成 on 15/11/12.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SHOW_URLIMG 1

#if SHOW_URLIMG
#import "UIImageView+WebCache.h"
#endif
@protocol PictureShowViewDelegate <NSObject>
//点击删除键回调
-(void)didClickDelPicBtn;
//长按手势回调
-(void)longPressCallBack;
@end

@interface PictureShowView : UIScrollView<UIGestureRecognizerDelegate>
{

    CGPoint beginPoint;
}
@property(assign,nonatomic)NSString *ImgUrl;
@property(assign,nonatomic)NSInteger picIndex;
@property(nonatomic) id<PictureShowViewDelegate> mydelegate;


    //移植于VIPhoto
//@property (nonatomic, strong) UIView *containerView;
//@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic) BOOL rotating;
@property (nonatomic) CGSize minSize;
@property (nonatomic) UIImageView *imgShowView;
@property (nonatomic) NSUInteger showIndex;
@property (nonatomic) NSArray *imgArr;
@property (nonatomic) NSArray *imgUrls;
#if SHOW_URLIMG
- (instancetype)initWithUrl:(NSString *)url andHolderImg:(UIImage *)showImg;
#endif
- (instancetype)initWithTitle:(NSString *)title showImg:(UIImage *)showImg;
//显示多张图片
- (instancetype)initWithTitle:(NSString *)title
                   andImgUrls:(NSArray *)showImgUrls andShowIndex:(NSUInteger)index andHolderImg:(UIImage *)holderImg;
- (instancetype)initWithTitle:(NSString *)title
                      andImgs:(NSArray <UIImageView *>*)showImg andShowIndex:(NSUInteger)index;
- (void)show;
- (void)dismiss;
- (instancetype)initWithTitle:(NSString *)title
                 andImgsOrUrl:(NSArray *)showImg andShowIndex:(NSUInteger)index;

@end
