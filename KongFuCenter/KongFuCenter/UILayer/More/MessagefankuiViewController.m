//
//  MessagefankuiViewController.m
//  KongFuCenter
//
//  Created by 鞠超 on 15/12/18.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "MessagefankuiViewController.h"

@interface MessagefankuiViewController ()

@property (nonatomic, strong) UITextField * text_title;

@property (nonatomic, strong) UITextView * detail;

//图片
@property (nonatomic, strong) UIImageView * image_1;
@property (nonatomic, strong) UIImageView * image_2;
@property (nonatomic, strong) UIImageView * image_3;

//照片和相机
@property (nonatomic, strong) UIButton * btn_1;
@property (nonatomic, strong) UIButton * btn_2;

@end

@implementation MessagefankuiViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self p_navigation];
    
    [self p_setupView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//隐藏tabbar
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

#pragma mark - 背景色和navigation
- (void)p_navigation
{
    self.view.backgroundColor = ItemsBaseColor;
    [self setBarTitle:@"留言反馈"];
    [self addLeftButton:@"left"];
    [self addRightbuttontitle:@"保存"];
}

- (void)clickRightButton:(UIButton *)sender
{
    NSLog(@"保存");
}

#pragma mark - 布局
- (void)p_setupView
{
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(15, NavigationBar_HEIGHT + StatusBar_HEIGHT + 20, 50, 22)];
    title.text = @"标题";
    title.textColor = Separator_Color;
    title.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:title];
    
    self.text_title = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(title.frame) + 15, CGRectGetMinY(title.frame) - 2 , 220, 25)];
    self.text_title.font = [UIFont systemFontOfSize:20];
//    self.text_title.backgroundColor = [UIColor orangeColor];
    self.text_title.textColor = [UIColor whiteColor];
    [self.view addSubview:self.text_title];
    
    UIView * view_line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(title.frame) + 10, self.view.frame.size.width, 1)];
    view_line.backgroundColor = Separator_Color;
    [self.view addSubview:view_line];
    
    UILabel * title1 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(view_line.frame) + 10, 90, 22)];
    title1.text = @"发帖内容";
    title1.textColor = Separator_Color;
//    title1.backgroundColor = [UIColor orangeColor];
    title1.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:title1];
    
    
    UIView * view_line1 = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 1)];
    view_line1.backgroundColor = Separator_Color;
    [self.view addSubview:view_line1];
    
    self.btn_1 = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.btn_1.frame = CGRectMake(15, CGRectGetMaxY(view_line1.frame) + 10, 30, 30);
    [self.btn_1 setImage:[UIImage imageNamed:@"picture@2x"] forState:(UIControlStateNormal)];
    [self.btn_1 setTintColor:Separator_Color];
    [self.view addSubview:self.btn_1];
    
    self.btn_2 = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.btn_2.frame = CGRectMake(CGRectGetMaxX(self.btn_1.frame) + 20, CGRectGetMaxY(view_line1.frame) + 10, 30, 30);
    [self.btn_2 setImage:[UIImage imageNamed:@"photo@2x"] forState:(UIControlStateNormal)];
    [self.btn_2 setTintColor:Separator_Color];
    [self.view addSubview:self.btn_2];
    
    self.image_1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMinY(view_line1.frame) - 10 - (self.view.frame.size.width - 70) / 3, (self.view.frame.size.width - 70) / 3, (self.view.frame.size.width - 70) / 3)];
//    self.image_1.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.image_1];
    
    self.image_2 = [[UIImageView alloc] initWithFrame:CGRectMake(15 + ((self.view.frame.size.width - 70) / 3 + 20), CGRectGetMinY(view_line1.frame) - 10 - (self.view.frame.size.width - 70) / 3, (self.view.frame.size.width - 70) / 3, (self.view.frame.size.width - 70) / 3)];
//    self.image_2.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.image_2];
    
    self.image_3 = [[UIImageView alloc] initWithFrame:CGRectMake(15 + 2 * ((self.view.frame.size.width - 70) / 3 + 20), CGRectGetMinY(view_line1.frame) - 10 - (self.view.frame.size.width - 70) / 3, (self.view.frame.size.width - 70) / 3, (self.view.frame.size.width - 70) / 3)];
//    self.image_3.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.image_3];
    
    
    self.detail = [[UITextView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(title1.frame) + 10, self.view.frame.size.width - 30, CGRectGetMinY(self.image_1.frame) - CGRectGetMaxY(title1.frame) - 20)];
        self.detail.backgroundColor = ItemsBaseColor;
    self.detail.font = [UIFont systemFontOfSize:19];
    self.detail.textColor = [UIColor whiteColor];
    [self.view addSubview:self.detail];
    
}

#pragma mark - btn点击事件



@end
