//
//  ShopListViewController.m
//  KongFuCenter
//
//  Created by Rain on 16/1/22.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "ShopListViewController.h"
#import "ShopTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface ShopListViewController (){
    UITableView *mTableView;
}

@end

@implementation ShopListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化参数
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self setBarTitle:@"商品列表"];
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
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 45)];
    headView.backgroundColor = ItemsBaseColor;
    CGFloat mWidth = SCREEN_WIDTH / 4;
    UIButton *mBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, mWidth, 45)];
    mBtn1.titleLabel.font = [UIFont systemFontOfSize:16];
    [mBtn1 setTitle:@"销量" forState:UIControlStateNormal];
    [mBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [headView addSubview:mBtn1];
    UIImageView *mIv1 = [[UIImageView alloc] initWithFrame:CGRectMake(mBtn1.frame.origin.x + mBtn1.frame.size.width, (45 - 10) / 2, 10, 10)];
    mIv1.image = [UIImage imageNamed:@"store_shop_selectdown"];
    UIButton *mBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(mWidth, 0, mWidth, 45)];
    mBtn2.titleLabel.font = [UIFont systemFontOfSize:16];
    [mBtn2 setTitle:@"价格" forState:UIControlStateNormal];
    [mBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [headView addSubview:mBtn2];
    UIButton *mBtn3 = [[UIButton alloc] initWithFrame:CGRectMake(mWidth * 2, 0, mWidth, 45)];
    mBtn3.titleLabel.font = [UIFont systemFontOfSize:16];
    [mBtn3 setTitle:@"好评" forState:UIControlStateNormal];
    [mBtn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [headView addSubview:mBtn3];
    UIButton *mBtn4 = [[UIButton alloc] initWithFrame:CGRectMake(mWidth * 3, 0, mWidth, 45)];
    mBtn4.titleLabel.font = [UIFont systemFontOfSize:16];
    [mBtn4 setTitle:@"最新" forState:UIControlStateNormal];
    [mBtn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [headView addSubview:mBtn4];
    
    [self.view addSubview:headView];
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height + 45, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height)];
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
    return 5;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    return view;
}

#pragma mark setting for cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"ShopCellIdentifier";
    ShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ShopTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.backgroundColor = ItemsBaseColor;
    }
    [cell.mImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"KongFuStoreProduct"]];
    cell.mName.text = @"男士哑铃一对10公斤";
    cell.mPrice.text = [NSString stringWithFormat:@"¥20.00"];
    cell.watchNum.text = [NSString stringWithFormat:@"%@人",@"1000"];
    cell.salesNum.text = [NSString stringWithFormat:@"销量:%@",@"1000"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [mTableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
