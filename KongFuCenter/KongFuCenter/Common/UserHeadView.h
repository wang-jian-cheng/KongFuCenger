//
//  UserHeadView.h
//  KongFuCenter
//
//  Created by 王建成 on 15/12/7.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonInfoViewController.h"
@interface UserHeadView : UIView
{
    UINavigationController *tempNav;
}
@property(nonatomic) BOOL enableRespondClick;
//不会跳转
-(id)initWithFrame:(CGRect)frame andImgName:(NSString *)name;
//会跳转至个人资料页
-(id)initWithFrame:(CGRect)frame andImgName:(NSString *)name andNav:(UINavigationController *)navCtl;
//头像设置成圆形
-(void)makeSelfRound;
@end
