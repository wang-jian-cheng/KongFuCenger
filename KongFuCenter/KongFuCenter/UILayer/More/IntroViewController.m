//
//  IntroViewController.m
//  KongFuCenter
//
//  Created by 鞠超 on 15/12/18.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "IntroViewController.h"

@interface IntroViewController ()

@property (nonatomic, strong) UIScrollView * scrollView;
//介绍
@property (nonatomic, strong) UILabel * text_introduce;
//中部图片
@property (nonatomic, strong) UIImageView * image;
//文字详情
@property (nonatomic, strong) UILabel * detail;

@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self p_navigation];
    
    [self p_scrollView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}
#pragma mark - 背景色和navigation
- (void)p_navigation
{
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self setBarTitle:@"关于@功夫"];
    [self addLeftButton:@"left"];
}

#pragma mark - scrollView
- (void)p_scrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT + StatusBar_HEIGHT + 1, self.view.frame.size.width, self.view.frame.size.height - NavigationBar_HEIGHT - StatusBar_HEIGHT - 1)];
    self.scrollView.backgroundColor = ItemsBaseColor;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    //需要先得到文字的内容判断frame
    NSString * str = @"专为武术，功夫，跆拳道等爱好者打造的一款集在线学习，视频教程，直播课堂，名师讲堂，即时通讯，互动交流，在线购物，行业资讯等服务为一体的平台！";
    CGFloat H = [str boundingRectWithSize:CGSizeMake(self.scrollView.frame.size.width - 20, 2000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:18]} context:nil].size.height;
    
    
    self.text_introduce = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20 , H)];
    self.text_introduce.textColor = [UIColor whiteColor];
    self.text_introduce.text = str;
    self.text_introduce.numberOfLines = 0;
    self.text_introduce.font = [UIFont systemFontOfSize:18];
    [self.scrollView addSubview:self.text_introduce];
    
    self.image = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.text_introduce.frame) + 10 , self.scrollView.frame.size.width, self.scrollView.frame.size.width * 0.7)];
    self.image.backgroundColor = [UIColor orangeColor];
    //    self.image.image = [UIImage imageNamed:@""];
    [self.scrollView addSubview:self.image];
    
//    
//    self.detail = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.image.frame) + 10, self.scrollView.frame.size.width - 20, H)];
//    self.detail.textColor = [UIColor whiteColor];
//    self.detail.text = str;
//    self.detail.numberOfLines = 0;
//    self.detail.font = [UIFont systemFontOfSize:18];
//    [self.scrollView addSubview:self.detail];
    
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(self.detail.frame) + 15);
    [self.view addSubview:self.scrollView];
}

@end
