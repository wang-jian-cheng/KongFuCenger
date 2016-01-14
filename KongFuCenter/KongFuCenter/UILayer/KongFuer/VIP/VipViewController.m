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
    tipLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    tipLab.textAlignment = NSTextAlignmentCenter;
    tipLab.textColor = [UIColor whiteColor];
    tipLab.center = CGPointMake(SCREEN_WIDTH/2, (SCREEN_HEIGHT-22-70));
    tipLab.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:tipLab];
    
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
            if([dict[@"data"][@"IsPay"] intValue] == 0)
            {
                [_payBtn setTitle:@"成为会员" forState:UIControlStateNormal];
                set_sp(@"IsPay", @"0");
            }
            else
            {
                set_sp(@"IsPay", @"1");
                overTime = dict[@"data"][@"OverTime"];
                ServerTime= dict[@"data"][@"ServerTime"];
                
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *overdate = [formatter dateFromString:overTime];
                NSDate *ServerTimeDate = [formatter dateFromString:ServerTime];
                
                NSTimeInterval over = [overdate timeIntervalSince1970];
                NSTimeInterval server = [ServerTimeDate timeIntervalSince1970];
                
                if(server > over)
                {
                    set_sp(@"IsPay", @"0");
                    DataProvider *dataProvider = [[DataProvider alloc] init];
                    [dataProvider setDelegateObject:self setBackFunctionName:@"closeVipCallBack:"];
                    [dataProvider closeVip:[Toolkit getUserID]];
                    return;
                }
                
                
//                [dict[@""] substringToIndex:10];
                tipLab.text = [NSString stringWithFormat:@"到期时间:%@",dict[@"data"][@"OverTime"] ];
                [self.view bringSubviewToFront:tipLab];
                
                
            }
                
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

-(void)closeVipCallBack:(id)dict
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
