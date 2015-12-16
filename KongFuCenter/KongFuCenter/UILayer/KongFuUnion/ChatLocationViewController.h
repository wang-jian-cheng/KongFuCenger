//
//  ChatLocationViewController.h
//  HiHome
//
//  Created by 于金祥 on 15/10/30.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>
#import "Toolkit.h"

@interface ChatLocationViewController : RCLocationPickerViewController
{
    UIView *_topView;//导航背景图
    UILabel *_lblTitle;//导航标题
    UIButton *_btnLeft;
    UIButton *_btnRight;
    UIImageView *_imgLeft;
    UIImageView *_imgRight;
    UILabel *_lblLeft;
    UILabel *_lblRight;
    
    NSInteger _orginY;
}

@end
