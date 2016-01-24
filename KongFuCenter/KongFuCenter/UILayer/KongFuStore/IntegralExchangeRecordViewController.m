//
//  IntegralExchangeRecordViewController.m
//  KongFuCenter
//
//  Created by Rain on 16/1/23.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "IntegralExchangeRecordViewController.h"
#import "IntegralExchangeRecordTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ExchangeDetailViewController.h"

@interface IntegralExchangeRecordViewController (){
    UITableView *mTableView;
}

@end

@implementation IntegralExchangeRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化参数
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self setBarTitle:@"兑换记录"];
    [self addLeftButton:@"left"];
    
    //初始化View
    [self initViews];
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

#pragma mark 自定义方法
-(void)initViews{
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height)];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = BACKGROUND_COLOR;
    mTableView.separatorColor = Separator_Color;
    mTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:mTableView];
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

#pragma mark setting for section
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    return view;
}

#pragma mark setting for cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"IntegralExchangeRecordCellIdentifier";
    IntegralExchangeRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"IntegralExchangeRecordTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.backgroundColor = ItemsBaseColor;
    }
    [cell.mPhotoIv sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"KongFuStoreProduct"]];
    cell.mName.text = @"男士哑铃一对10公斤";
    cell.mIntegral.text = [NSString stringWithFormat:@"%@积分",@"1500"];
    cell.mExchangeState.text = @"兑换成功";
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [mTableView deselectRowAtIndexPath:indexPath animated:YES];
    ExchangeDetailViewController *exchangeDetailVC = [[ExchangeDetailViewController alloc] init];
    [exchangeDetailVC setExchangeDetail:Mode_Detail];
    [self.navigationController pushViewController:exchangeDetailVC animated:YES];
}

@end
