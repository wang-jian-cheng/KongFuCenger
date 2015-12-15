//
//  ChatViewController.m
//  KongFuCenter
//
//  Created by Rain on 15/12/15.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "ChatContentViewController.h"

@interface ChatContentViewController (){
    UIView *topView;
}

@end

@implementation ChatContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

-(void)initView{
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavigationBar_HEIGHT + StatusBar_HEIGHT)];
    topView.backgroundColor = navi_bar_bg_color;
    [self.view addSubview:topView];
    
    UILabel *mTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, StatusBar_HEIGHT + (NavigationBar_HEIGHT - 21) / 2, SCREEN_WIDTH, 21)];
    mTitle.textAlignment = NSTextAlignmentCenter;
    mTitle.textColor = [UIColor whiteColor];
    mTitle.text = @"会话";
    [topView addSubview:mTitle];
    
    UIButton *leftTitle = [[UIButton alloc] initWithFrame:CGRectMake(14, StatusBar_HEIGHT + (NavigationBar_HEIGHT - 20) / 2, 20, 20)];
    [leftTitle setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [leftTitle addTarget:self action:@selector(clickLeftBtn) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:leftTitle];
}

-(void)viewWillAppear:(BOOL)animated{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

#pragma mark - 自定义方法
-(void)clickLeftBtn{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
