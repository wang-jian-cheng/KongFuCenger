//
//  ShopDetailViewController.m
//  KongFuCenter
//
//  Created by Rain on 16/1/20.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "ShopDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "UserHeadView.h"

@interface ShopDetailViewController (){
    UITableView *mTableView;
}

@end

@implementation ShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化参数
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self setBarTitle:@"商品详情"];
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
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height - 50)];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = BACKGROUND_COLOR;
    mTableView.separatorColor = Separator_Color;
    mTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:mTableView];
    
    UIView *mFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
    
    UIButton *collectionBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    collectionBtn.backgroundColor = [UIColor colorWithRed:0.16 green:0.16 blue:0.18 alpha:1];
    UIImageView *collectionIv = [[UIImageView alloc] initWithFrame:CGRectMake((50 - 25) / 2, 2, 25, 25)];
    collectionIv.image = [UIImage imageNamed:@"store_nocollection"];
    [collectionBtn addSubview:collectionIv];
    UILabel *collectionLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, collectionIv.frame.origin.y + collectionIv.frame.size.height + 2, 50, 21)];
    collectionLbl.font = [UIFont systemFontOfSize:14];
    collectionLbl.textColor = [UIColor whiteColor];
    collectionLbl.textAlignment = NSTextAlignmentCenter;
    collectionLbl.text = @"收藏";
    [collectionBtn addSubview:collectionLbl];
    [mFooterView addSubview:collectionBtn];
    
    UIButton *joinShoppingCar = [[UIButton alloc] initWithFrame:CGRectMake(50, 0, (SCREEN_WIDTH - 50) / 2, 50)];
    [joinShoppingCar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [joinShoppingCar setTitle:@"加入购物车" forState:UIControlStateNormal];
    [mFooterView addSubview:joinShoppingCar];
    
    UIButton *immediatelyBuyBtn = [[UIButton alloc] initWithFrame:CGRectMake(50 + (SCREEN_WIDTH - 50) / 2, 0, (SCREEN_WIDTH - 50) / 2, 50)];
    immediatelyBuyBtn.backgroundColor = YellowBlock;
    [immediatelyBuyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [immediatelyBuyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [mFooterView addSubview:immediatelyBuyBtn];
    
    [self.view addSubview:mFooterView];
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 2;
    }else if (section == 1){
        return 1;
    }else{
        return 1 + 2;
    }
}

#pragma mark setting for section
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1 || section == 2) {
        return 4;
    }else{
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    return view;
}

#pragma mark setting for cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.backgroundColor = ItemsBaseColor;
        }
        if (indexPath.row == 0) {
            UIImageView *mIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 170)];
            [mIv sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"store_head_bg"]];
            [cell addSubview:mIv];
            
            UILabel *mName = [[UILabel alloc] initWithFrame:CGRectMake(14, mIv.frame.origin.y + mIv.frame.size.height + (45 - 21) / 2, 150, 21)];
            mName.textColor = [UIColor whiteColor];
            mName.text = @"瑜伽球大号一个";
            [cell addSubview:mName];
        }else{
            NSString *priceStr = [NSString stringWithFormat:@"¥%@",@"20.00"];
            CGSize priceSize = [priceStr sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17.0f]}];
            UILabel *priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(14, 5, priceSize.width, 21)];
            priceLbl.textColor = YellowBlock;
            priceLbl.text = priceStr;
            [cell addSubview:priceLbl];
            
            NSString *oldPriceStr = [NSString stringWithFormat:@"¥%@",@"20.00"];
            CGSize oldPriceSize = [oldPriceStr sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]}];
            UILabel *oldPriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(priceLbl.frame.origin.x + priceLbl.frame.size.width + 10, 5, oldPriceSize.width, 21)];
            oldPriceLbl.textColor = [UIColor colorWithRed:0.45 green:0.45 blue:0.45 alpha:1];
            oldPriceLbl.font = [UIFont systemFontOfSize:14];
            oldPriceLbl.text = oldPriceStr;
            [cell addSubview:oldPriceLbl];
            UIView *delLineView = [[UIView alloc] initWithFrame:CGRectMake(0, (oldPriceLbl.frame.size.height - 1) / 2, oldPriceSize.width, 1)];
            delLineView.backgroundColor = [UIColor grayColor];
            [oldPriceLbl addSubview:delLineView];
            
            UILabel *byLbl = [[UILabel alloc] initWithFrame:CGRectMake(14, priceLbl.frame.origin.y + priceLbl.frame.size.height + 5, SCREEN_WIDTH / 3, 21)];
            byLbl.font = [UIFont systemFontOfSize:15];
            byLbl.textColor = [UIColor colorWithRed:0.45 green:0.45 blue:0.45 alpha:1];
            byLbl.text = @"包邮";
            [cell addSubview:byLbl];
            
            UILabel *browseNum = [[UILabel alloc] initWithFrame:CGRectMake(byLbl.frame.origin.x + byLbl.frame.size.width, priceLbl.frame.origin.y + priceLbl.frame.size.height + 5, SCREEN_WIDTH / 3, 21)];
            browseNum.font = [UIFont systemFontOfSize:15];
            browseNum.textColor = [UIColor colorWithRed:0.45 green:0.45 blue:0.45 alpha:1];
            browseNum.text = [NSString stringWithFormat:@"浏览量:%@",@"1000"];
            [cell addSubview:browseNum];
            
            UILabel *Sales = [[UILabel alloc] initWithFrame:CGRectMake(browseNum.frame.origin.x + browseNum.frame.size.width, priceLbl.frame.origin.y + priceLbl.frame.size.height + 5, SCREEN_WIDTH / 3, 21)];
            Sales.font = [UIFont systemFontOfSize:15];
            Sales.textColor = [UIColor colorWithRed:0.45 green:0.45 blue:0.45 alpha:1];
            Sales.text = [NSString stringWithFormat:@"销量:%@",@"1000"];
            [cell addSubview:Sales];
        }
        return cell;
    }else if (indexPath.section == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.backgroundColor = ItemsBaseColor;
        }
        UILabel *mSpecLbl = [[UILabel alloc] initWithFrame:CGRectMake(14, (45 - 21) / 2, 150, 21)];
        mSpecLbl.textColor = [UIColor whiteColor];
        mSpecLbl.text = @"请选择规格";
        [cell addSubview:mSpecLbl];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }else{
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.backgroundColor = ItemsBaseColor;
            }
            UILabel *userCommentTitle = [[UILabel alloc] initWithFrame:CGRectMake(14, (45 - 21) / 2, 150, 21)];
            userCommentTitle.font = [UIFont systemFontOfSize:16];
            userCommentTitle.textColor = [UIColor whiteColor];
            userCommentTitle.text = @"用户评价";
            [cell addSubview:userCommentTitle];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 65, 5, 1, 35)];
            lineView.backgroundColor = [UIColor colorWithRed:0.25 green:0.26 blue:0.27 alpha:1];
            [cell addSubview:lineView];
            
            UILabel *userCommentNum = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, (45 - 21) / 2, 60, 21)];
            userCommentNum.font = [UIFont systemFontOfSize:14];
            userCommentNum.textColor = [UIColor whiteColor];
            userCommentNum.text = [NSString stringWithFormat:@"共%@条",@"100"];
            [cell addSubview:userCommentNum];
            
            return cell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.backgroundColor = ItemsBaseColor;
            }
            UserHeadView *userHeadView = [[UserHeadView alloc] initWithFrame:CGRectMake(14, 5, 40, 40) andUrl:nil andNav:self.navigationController];
            [userHeadView makeSelfRound];
            [cell addSubview:userHeadView];
            
            UILabel *mName = [[UILabel alloc] initWithFrame:CGRectMake(userHeadView.frame.origin.x + userHeadView.frame.size.width + 5, 5 + (40 - 21) / 2, 150, 21)];
            mName.font = [UIFont systemFontOfSize:15];
            mName.textColor = [UIColor whiteColor];
            mName.text = @"路人甲";
            [cell addSubview:mName];
            
            NSString *mContentStr = @"东西不错，用着很好，很喜欢.东西不错，用着很好，很喜欢.东西不错，用着很好，很喜欢.东西不错，用着很好，很喜欢.东西不错，用着很好，很喜欢.";
            CGFloat contentHeight = [Toolkit heightWithString:mContentStr fontSize:14 width:SCREEN_WIDTH-64]+10;
            UITextView *mContent = [[UITextView alloc] initWithFrame:CGRectMake(mName.frame.origin.x, mName.frame.origin.y + mName.frame.size.height + 2, SCREEN_WIDTH - mName.frame.origin.x - 10, contentHeight)];
            mContent.textColor = [UIColor whiteColor];
            mContent.editable = NO;
            mContent.scrollEnabled = NO;
            mContent.font = [UIFont systemFontOfSize:12];
            mContent.backgroundColor = ItemsBaseColor;
            mContent.text = mContentStr;
            [cell addSubview:mContent];
            
            UILabel *mDate = [[UILabel alloc] initWithFrame:CGRectMake(mName.frame.origin.x, mName.frame.origin.y + mName.frame.size.height + 2 + contentHeight + 5, 200, 21)];
            mDate.font = [UIFont systemFontOfSize:12];
            mDate.text = @"2016-01-03 10:20:00";
            mDate.textColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1];
            [cell addSubview:mDate];
            
            return cell;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if (indexPath.row == 0) {
            return 170 + 45;
        }else{
            return 60;
        }
    }else if (indexPath.section == 1){
        return 45;
    }else{
        if (indexPath.row == 0) {
            return 45;
        }else{
            NSString *mContentStr = @"东西不错，用着很好，很喜欢.东西不错，用着很好，很喜欢.东西不错，用着很好，很喜欢.东西不错，用着很好，很喜欢.东西不错，用着很好，很喜欢.";
            CGFloat contentHeight = [Toolkit heightWithString:mContentStr fontSize:14 width:SCREEN_WIDTH-64]+5;
            return 5 + (40 - 21) / 2 + 23 + contentHeight + 31;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [mTableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
