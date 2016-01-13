//
//  VipViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/9.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "VipViewController.h"

@interface VipViewController ()
{
    UILabel *tipLab;
}
@end

@implementation VipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"left"];
    tipLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    tipLab.center = CGPointMake(SCREEN_WIDTH/2, (self.payBtn.frame.size.height+self.payBtn.frame.origin.y+10+22));
    [self.view addSubview:tipLab];
    
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
    if([get_sp(@"IsPay") intValue] == 1)
    {
        [_payBtn setTitle:@"点击续费" forState:UIControlStateNormal];
        
        
//        DataProvider *dataProvider = [[DataProvider alloc] init];
//        [dataProvider setDelegateObject:self setBackFunctionName:@"getVipTimeCallBack:"];
//        [dataProvider getVipTime:[Toolkit getUserID]];
    }
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
    if([get_sp(@"IsPay") intValue] == 1)
    {
        [_payBtn setTitle:@"点击续费" forState:UIControlStateNormal];
        
        
        DataProvider *dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"getVipTimeCallBack:"];
        [dataProvider getVipTime:[Toolkit getUserID]];
        
    }
}


-(void)getVipTimeCallBack:(id)dict
{
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try {

        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"data"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        
    }

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
