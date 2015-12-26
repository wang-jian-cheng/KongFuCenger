//
//  ceshiViewController.m
//  KongFuCenter
//
//  Created by Rain on 15/12/25.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "ceshiViewController.h"
#import "MoviePlayer.h"

@interface ceshiViewController ()

@end

@implementation ceshiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MoviePlayer *view = [[MoviePlayer alloc] initWithFrame:CGRectMake(10,64,SCREEN_WIDTH - 20, 100) URL:[NSURL URLWithString:@"http://baobab.cdn.wandoujia.com/14468618701471.mp4"]];
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
