//
//  UserHeadView.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/7.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "UserHeadView.h"

@implementation UserHeadView

-(id)initWithFrame:(CGRect)frame andImgName:(NSString *)name andNav:(UINavigationController *)navCtl
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIButton *headBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        //[headBtn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
        [headBtn addTarget:self action:@selector(UserHeadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        headImgView.image = [UIImage imageNamed:name];
        [headBtn addSubview:headImgView];
        _enableRespondClick = YES;
        tempNav = navCtl;
        [self addSubview:headBtn];
        
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame andImgName:(NSString *)name
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIButton *headBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        //[headBtn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
        [headBtn addTarget:self action:@selector(UserHeadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        headImgView.image = [UIImage imageNamed:name];
        [headBtn addSubview:headImgView];
        _enableRespondClick = YES;
        [self addSubview:headBtn];
        
    }
    return self;
}


-(BOOL)CheckIsFriend:(NSString *)userId
{

    return NO;
}

-(void)UserHeadBtnClick:(UIButton *)sender
{
    DLog(@"Click Btn");
    
    if(self.enableRespondClick == YES)
    {
        if(self.userId == nil || [self.userId isEqualToString:[Toolkit getUserID]])//自己
        {
            PersonInfoViewController *personInfoViewCtl = [[PersonInfoViewController alloc] init];
            personInfoViewCtl.navtitle = @"个人资料";
            
            if(tempNav!=nil)
               [tempNav pushViewController:personInfoViewCtl animated:YES];
        }
        else
        {
            if([self CheckIsFriend:self.userId] == YES)//好友
            {
                FriendInfoViewController *friendInfoViewCtl = [[FriendInfoViewController alloc] init];
                friendInfoViewCtl.navtitle = @"好友资料";
                if(tempNav!=nil)
                    [tempNav pushViewController:friendInfoViewCtl animated:YES];
            }
            else//陌生人
            {

                StrangerInfoViewController *strangerInfoViewCtl = [[StrangerInfoViewController alloc] init];
                strangerInfoViewCtl.navtitle = @"好友资料";
                if(tempNav!=nil)
                    [tempNav pushViewController:strangerInfoViewCtl animated:YES];
            }
        }
        
        
    }
}


-(void)makeSelfRound
{
    self.layer.cornerRadius = self.frame.size.width * 0.5;
    self.layer.borderWidth = 0.1;
    self.layer.masksToBounds = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
