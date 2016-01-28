//
//  IntegralExchangeViewController.m
//  KongFuCenter
//
//  Created by Rain on 16/1/23.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "IntegralExchangeViewController.h"
#import "IntegralExchangeTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "IntegralExchangeRecordViewController.h"
#import "ExchangeDetailViewController.h"

@interface IntegralExchangeViewController (){
    UITableView *mTableView;
}

@end

@implementation IntegralExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化参数
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self setBarTitle:@"积分兑换"];
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

-(void)exchangeEvent:(UIButton *)btn{
    ExchangeDetailViewController *exchangeDetailVC = [[ExchangeDetailViewController alloc] init];
    [exchangeDetailVC setExchangeDetail:Mode_ImmeExchange];
    [self.navigationController pushViewController:exchangeDetailVC animated:YES];
}

-(void)integralExchangeRecordEvent{
    IntegralExchangeRecordViewController *integralExchangeRecordVC = [[IntegralExchangeRecordViewController alloc] init];
    [self.navigationController pushViewController:integralExchangeRecordVC animated:YES];
}


#pragma mark - self data source





#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 1 + 6;
    }
}

#pragma mark setting for section
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }else{
        return 10;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    return view;
}

#pragma mark setting for cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"CellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.backgroundColor = ItemsBaseColor;
        }else{
            for (UIView *view in cell.subviews) {
                [view removeFromSuperview];
            }
        }
        
        UIImageView *photoIv = [[UIImageView alloc] initWithFrame:CGRectMake(14, (150 - 120) / 2, 120, 120)];
        [photoIv sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"me"]];
        [cell addSubview:photoIv];
        
        UILabel *mName = [[UILabel alloc] initWithFrame:CGRectMake(photoIv.frame.origin.x + photoIv.frame.size.width + 5, (150 - 85) / 2, 150, 21)];
        mName.text = @"成龙";
        mName.textColor = [UIColor whiteColor];
        [cell addSubview:mName];
        
        UILabel *mIntegral = [[UILabel alloc] initWithFrame:CGRectMake(mName.frame.origin.x, mName.frame.origin.y + mName.frame.size.height + 5, 150, 21)];
        mIntegral.text = [NSString stringWithFormat:@"积分:%@个",@"1000"];
        mIntegral.textColor = [UIColor whiteColor];
        [cell addSubview:mIntegral];
        
        UIButton *mIntegralExchangeRecord = [[UIButton alloc] initWithFrame:CGRectMake(mName.frame.origin.x, mIntegral.frame.origin.y + mIntegral.frame.size.height + 5, 120, 30)];
        mIntegralExchangeRecord.backgroundColor = [UIColor colorWithRed:0.32 green:0.33 blue:0.34 alpha:1];
        [mIntegralExchangeRecord setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [mIntegralExchangeRecord setTitle:@"积分兑换记录" forState:UIControlStateNormal];
        [mIntegralExchangeRecord addTarget:self action:@selector(integralExchangeRecordEvent) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:mIntegralExchangeRecord];
        
        return cell;
    }else{
        if (indexPath.row == 0) {
            static NSString *cellIdentifier = @"CellIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.backgroundColor = ItemsBaseColor;
            }
            cell.textLabel.text = @"积分兑换商品";
            cell.textLabel.font = [UIFont systemFontOfSize:17];
            cell.textLabel.textColor = [UIColor whiteColor];
            return cell;
        }else{
            static NSString *CellIdentifier = @"IntegralExchangeCellIdentifier";
            IntegralExchangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"IntegralExchangeTableViewCell" owner:self options:nil] objectAtIndex:0];
                cell.backgroundColor = ItemsBaseColor;
            }
            [cell.mPhotoIv sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"jhstory"]];
            cell.mName.text = @"咏春拳门票一张";
            cell.mDetail1.text = [NSString stringWithFormat:@"积分兑换:%@",@"500"];
            cell.mDetail2.text = [NSString stringWithFormat:@"剩余:%@",@"50"];
            [cell.mExchange addTarget:self action:@selector(exchangeEvent:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 150;
    }else{
        if (indexPath.row == 0) {
            return 45;
        }else{
            return 70;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [mTableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
