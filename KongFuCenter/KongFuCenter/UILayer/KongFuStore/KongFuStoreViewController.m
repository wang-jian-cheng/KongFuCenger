//
//  KongFuStoreViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/7.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "KongFuStoreViewController.h"
#import "ShopTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface KongFuStoreViewController (){
    UITableView *mTableView;
}

@end

@implementation KongFuStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化参数
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self setBarTitle:@"功夫库"];
    
    //初始化View
    [self initViews];
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showTabBar];
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
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }else{
        return 1 + 6;
    }
}

#pragma mark setting for section

#pragma mark setting for cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        cell.backgroundColor = ItemsBaseColor;
        UIImageView *mIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1700)];
        [mIv sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"head_bg"]];
        [cell addSubview:mIv];
        return cell;
    }else{
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
            cell.backgroundColor = ItemsBaseColor;
            UILabel *mLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, 80, cell.frame.size.height)];
            mLabel.textAlignment = NSTextAlignmentCenter;
            mLabel.textColor = [UIColor whiteColor];
            mLabel.text = @"推荐商品";
            [cell addSubview:mLabel];
            return cell;
        }else{
            NSString *CellIdentifier = @"ShopCellIdentifier";
            ShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ShopTableViewCell" owner:self options:nil] objectAtIndex:0];
                cell.backgroundColor = ItemsBaseColor;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [cell.mImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"me"]];
            cell.mName.text = @"男士哑铃一对10公斤";
            cell.mPrice.text = [NSString stringWithFormat:@"¥20.00"];
            NSString *oldPriceStr = @"¥30.00";
            cell.mOldPrice.text = oldPriceStr;
            CGSize size = [oldPriceStr sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]}];
            UIView *delLine = [[UIView alloc] initWithFrame:CGRectMake(0, (cell.mOldPrice.frame.size.height - 1) / 2, size.width, 1)];
            delLine.backgroundColor = [UIColor grayColor];
            [cell.mOldPrice addSubview:delLine];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 195;
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
