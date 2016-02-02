//
//  XHPicView.h
//  PictureScanView
//
//  Created by xhliang on 15/12/30.
//  Copyright © 2015年 xhliang. All rights reserved.
//

#import <UIKit/UIKit.h>
//需要WebImage头文件
#import "SDWebImageManager.h"

#import "UIImageView+WebCache.h"

@class XHPicView;

typedef void(^XHPicBlock)(NSString *event);

@interface XHPicView : UIView

@property (nonatomic,copy) XHPicBlock eventBlock;

-(instancetype)initWithFrame:(CGRect)frame withImgs:(NSArray *)imgs withImgUrl:(NSArray *)imgUrls;

@end


@class PicCell;

typedef void(^HiddenBlcok)(NSString *gest);

@interface PicCell : UICollectionViewCell

@property (nonatomic,copy) HiddenBlcok myBlock;

-(void)createUIWithImage:(UIImage *)image ImgUrl:(NSString *)imageUrl;

@end