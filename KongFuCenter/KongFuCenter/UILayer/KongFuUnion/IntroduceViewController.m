//
//  IntroduceViewController.m
//  KongFuCenter
//
//  Created by 鞠超 on 15/12/16.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "IntroduceViewController.h"

@interface IntroduceViewController ()

@property (nonatomic, strong) UIScrollView * scrollView;
//顶部图片
@property (nonatomic, strong) UIImageView * image;
//文字详情
@property (nonatomic, strong) UILabel * detail;
@end

@implementation IntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_navigation];
    
    [self p_scrollView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 背景色和navigation
- (void)p_navigation
{
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self setBarTitle:@"战队介绍"];
    [self addLeftButton:@"left"];
}

#pragma mark - scrollView
- (void)p_scrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT + StatusBar_HEIGHT + 10, self.view.frame.size.width, self.view.frame.size.height - NavigationBar_HEIGHT - StatusBar_HEIGHT - 10)];
    self.scrollView.backgroundColor = ItemsBaseColor;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    
    self.image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.width * 0.7)];
    self.image.backgroundColor = [UIColor orangeColor];
//    self.image.image = [UIImage imageNamed:@""];
    [self.scrollView addSubview:self.image];
    
    //需要先得到文字的内容判断frame
    NSString * str = @"SD卡人家时间爱的,撒旦了撒旦离开,老是觉得可垃,圾收到垃圾了就觉得拉斯克奖阿迪力捡垃圾绿卡数据德里克撒娇的立刻,就死了肯德基阿斯利康简单绿卡数据的绿卡数据的绿卡数据大立科技奇偶ijlasjlkasj得利,卡数据离开家阿斯利,康点击绿卡数据的绿卡数,,据领导看见爱上领导看见爱上了都结束了简单了解了开始,觉得两款手机的两款手机登陆卡数据的两款手机登陆空间,,阿斯顿离开家阿斯利康就SD卡人家时间爱的撒旦了撒旦离开 老是觉,得可垃圾收到垃圾了就觉得拉斯克奖阿迪力捡垃圾绿卡数据德里克撒娇的立刻就死了肯德基阿斯,利康简单绿卡数据的绿卡数据的绿卡数据大立科技,,奇偶ijlasjlkasj得利卡数据离开家阿斯利康点击绿卡数据的绿卡数据领导看见爱上领导看见爱上了都结束了简单了解了开始觉得两款手机的两款手机登陆卡数";
    CGFloat H = [str boundingRectWithSize:CGSizeMake(self.scrollView.frame.size.width - 20, 2000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:18]} context:nil].size.height;
    
    self.detail = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.image.frame) + 10, self.scrollView.frame.size.width - 20, H)];
    self.detail.textColor = [UIColor whiteColor];
    self.detail.text = str;
    self.detail.numberOfLines = 0;
    self.detail.font = [UIFont systemFontOfSize:18];
    [self.scrollView addSubview:self.detail];
    
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(self.detail.frame) + 10);
    [self.view addSubview:self.scrollView];
}




@end