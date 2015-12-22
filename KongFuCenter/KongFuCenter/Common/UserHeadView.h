//
//  UserHeadView.h
//  KongFuCenter
//
//  Created by 王建成 on 15/12/7.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonInfoViewController.h"
#import "FriendInfoViewController.h"
#import "StrangerInfoViewController.h"

@protocol UserHeadViewDelegate <NSObject>

-(void)userHeadViewClick;

@end

@interface UserHeadView : UIView
{
    UINavigationController *tempNav;
}
@property(nonatomic)id<UserHeadViewDelegate> delegate;
//
@property(nonatomic)UIImageView *headImgView;
//可以用于设置关闭点击进入资料页
@property(nonatomic) BOOL enableRespondClick;
//不设置userID（等于0）显示自己的资料，设置显示好友的资料
@property(nonatomic) NSString *userId;
//@property(nonatomic)UIButton *headBtn;
//不会跳转
-(id)initWithFrame:(CGRect)frame andImgName:(NSString *)name;
-(id)initWithFrame:(CGRect)frame andImg:(UIImage *)img;
//会跳转至个人资料页
-(id)initWithFrame:(CGRect)frame andImgName:(NSString *)name andNav:(UINavigationController *)navCtl;
-(id)initWithFrame:(CGRect)frame andImg:(UIImage *)img andNav:(UINavigationController *)navCtl;
//头像设置成圆形
-(void)makeSelfRound;
@end
