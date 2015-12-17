//
//  IntroduceViewController.m
//  KongFuCenter
//
//  Created by 鞠超 on 15/12/16.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "IntroduceViewController.h"

@interface IntroduceViewController ()

@end

@implementation IntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_navigation];

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

@end
