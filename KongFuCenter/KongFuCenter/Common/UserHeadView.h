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

-(id)initWithFrame:(CGRect)frame andImgName:(NSString *)name;
-(id)initWithFrame:(CGRect)frame andImgName:(NSString *)name andNav:(UINavigationController *)navCtl;
-(void)makeSelfRound;
@end
