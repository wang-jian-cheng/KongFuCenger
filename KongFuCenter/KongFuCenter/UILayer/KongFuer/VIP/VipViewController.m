//
//  VipViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/9.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "VipViewController.h"

@interface VipViewController ()

@end

@implementation VipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"left"];
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    [self initViews];
    // Do any additional setup after loading the view from its nib.
}

-(void)initViews
{
    _backView.backgroundColor = ItemsBaseColor;
    _payBtn.backgroundColor = YellowBlock;
    
    _vipExplainLab.backgroundColor = ItemsBaseColor;
    _vipExplainLab.textColor = [UIColor whiteColor];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}
- (IBAction)goPayPageClick:(id)sender {
    
    PayForVipViewController *payPage = [[PayForVipViewController alloc] init];
    
    payPage.navtitle = @"会员付费";
    [self.navigationController pushViewController:payPage animated:YES];
    
    
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
