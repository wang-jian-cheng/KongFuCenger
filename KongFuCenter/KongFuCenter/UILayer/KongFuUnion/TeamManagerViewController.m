//
//  TeamManagerViewController.m
//  KongFuCenter
//
//  Created by 于金祥 on 16/1/14.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "TeamManagerViewController.h"

@interface TeamManagerViewController ()

@end

@implementation TeamManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarTitle:@"战队管理"];
    [self addLeftButton:@"left"];
    self.view.backgroundColor = ItemsBaseColor;
    
    _mainTableView.delegate=self;
    _mainTableView.dataSource=self;
    _mainTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _mainTableView.backgroundColor = BACKGROUND_COLOR;
    _mainTableView.separatorColor = Separator_Color;
}



#pragma mark uitableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 10;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    cell.textLabel.text=@"退出战队";
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.backgroundColor=ItemsBaseColor;
    
    UIImageView *rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right"]];
    rightView.frame = CGRectMake((SCREEN_WIDTH - 20 -20), 0, 15, 15);
    rightView.center = CGPointMake((SCREEN_WIDTH - 15 -10), 22);
    rightView.contentMode = UIViewContentModeScaleAspectFit;
    [cell addSubview:rightView];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        DataProvider *dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"quitTeamCallBack:"];
        [dataProvider quitTeam:[Toolkit getUserID] andTeamID:get_sp(@"TeamId")];
    }
}
-(void)quitTeamCallBack:(id)dict
{
    if ([dict[@"code"] intValue] == 200) {
        [SVProgressHUD showSuccessWithStatus:@"退出战队成功" maskType:SVProgressHUDMaskTypeBlack];
        remove_sp(@"TeamId");
        remove_sp(@"TeamImg");
        remove_sp(@"TeamName");
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else{
        
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"data"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        
    }
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
