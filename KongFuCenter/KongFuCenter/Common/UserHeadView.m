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
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _headImgView.image = [UIImage imageNamed:name];
        [headBtn addSubview:_headImgView];
        _enableRespondClick = YES;
        tempNav = navCtl;
        [self addSubview:headBtn];
        
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame andImg:(UIImage *)img andNav:(UINavigationController *)navCtl
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIButton *headBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        //[headBtn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
        [headBtn addTarget:self action:@selector(UserHeadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _headImgView.image = img;
        [headBtn addSubview:_headImgView];
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
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _headImgView.image = [UIImage imageNamed:name];
        [headBtn addSubview:_headImgView];
        _enableRespondClick = YES;
        [self addSubview:headBtn];
        
    }
    return self;
}


-(id)initWithFrame:(CGRect)frame andImg:(UIImage *)img
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIButton *headBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        //[headBtn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
        [headBtn addTarget:self action:@selector(UserHeadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _headImgView.image = img;
        [headBtn addSubview:_headImgView];
        _enableRespondClick = YES;
        [self addSubview:headBtn];
        
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame andurl:(NSString *)url
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIButton *headBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        //[headBtn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
        [headBtn addTarget:self action:@selector(UserHeadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"me"]];
        [headBtn addSubview:_headImgView];
        _enableRespondClick = YES;
        [self addSubview:headBtn];
        
    }
    return self;
}


-(void)CheckIsFriend:(NSString *)userId
{
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"isFriendCallBack:"];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [dataProvider IsWuyou:[userDefault valueForKey:@"id"] andfriendid:userId];
}

-(void)isFriendCallBack:(id)dict{
    NSLog(@"%@",dict);
    if ([dict[@"code"] intValue] == 200) {
        if([dict[@"data"] intValue] == 1)//好友
        {
            FriendInfoViewController *friendInfoViewCtl = [[FriendInfoViewController alloc] init];
            friendInfoViewCtl.navtitle = @"好友资料";
            friendInfoViewCtl.userID = self.userId;
            if(tempNav!=nil)
                [tempNav pushViewController:friendInfoViewCtl animated:YES];
        }
        else//陌生人
        {
            
            StrangerInfoViewController *strangerInfoViewCtl = [[StrangerInfoViewController alloc] init];
            strangerInfoViewCtl.navtitle = @"好友资料";
            strangerInfoViewCtl.userID = self.userId;
            if(tempNav!=nil)
                [tempNav pushViewController:strangerInfoViewCtl animated:YES];
        }
    }
}

-(void)UserHeadBtnClick:(UIButton *)sender
{
    DLog(@"Click Btn");
    
    if(self.enableRespondClick == YES)
    {
        if(self.userId == nil || [self.userId isEqual:[Toolkit getUserID]])//自己
        {
            PersonInfoViewController *personInfoViewCtl = [[PersonInfoViewController alloc] init];
            personInfoViewCtl.navtitle = @"个人资料";
            
            if(tempNav!=nil)
               [tempNav pushViewController:personInfoViewCtl animated:YES];
        }
        else
        {
            [self CheckIsFriend:self.userId];
        }
    }
    
    if([self.delegate respondsToSelector:@selector(userHeadViewClick)])
    {
        [self.delegate userHeadViewClick];
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
