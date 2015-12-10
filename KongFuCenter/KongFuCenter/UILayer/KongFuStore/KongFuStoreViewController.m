//
//  KongFuStoreViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/7.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "KongFuStoreViewController.h"

@interface KongFuStoreViewController ()

@end

@implementation KongFuStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self setBarTitle:@"核装备"];
    
    
    UILabel *tipLab = [[UILabel alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    tipLab.text = @"敬请期待";
    tipLab.textColor = [UIColor whiteColor];
    tipLab.textAlignment = NSTextAlignmentCenter ;
    
    [self.view addSubview:tipLab];
    
    
    // Do any additional setup after loading the view.
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
