//
//  ClassificationViewController.m
//  KongFuCenter
//
//  Created by Rain on 16/1/21.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "ClassificationViewController.h"
#import "ShopListViewController.h"

@interface ClassificationViewController (){
    UITableView *firstTableView;
    UITableView *secondTableView;
    UITableView *threeTableView;
    
    NSArray *firstShopArray;
    NSArray *secondShopArray;
    NSArray *threeShopArray;
    
    NSIndexPath *firstLastIndexPath;
    NSIndexPath *secondLastIndexPath;
    
    DataProvider *dataProvider;
}

@end

@implementation ClassificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化参数
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self setBarTitle:@"商品分类"];
    [self addLeftButton:@"left"];
    
    dataProvider = [[DataProvider alloc] init];
    
    //初始化View
    [self initFirstData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

#pragma mark 自定义方法
-(void)initFirstData{
    firstLastIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    secondLastIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    firstShopArray = [[NSArray alloc] init];
    secondShopArray = [[NSArray alloc] init];
    threeShopArray = [[NSArray alloc] init];
    
    [dataProvider setDelegateObject:self setBackFunctionName:@"getFirstShopDataCallBack:"];
    [dataProvider SelectBigCategory];
}

-(void)getFirstShopDataCallBack:(id)dict{
    NSLog(@"%@",dict);
    if ([dict[@"code"] intValue] == 200) {
        firstShopArray = dict[@"data"];
        [self initViews];
    }
}

-(void)getSecondShopData:(NSString *)parentId{
    [dataProvider setDelegateObject:self setBackFunctionName:@"getSecondShopDataCallBack:"];
    [dataProvider SelectSmallCategory:parentId];
}

-(void)getSecondShopDataCallBack:(id)dict{
    NSLog(@"%@",dict);
    if ([dict[@"code"] intValue] == 200) {
        secondShopArray = dict[@"data"];
        [secondTableView reloadData];
    }
}

-(void)getThreeShopData:(NSString *)parentId{
    [dataProvider setDelegateObject:self setBackFunctionName:@"getThreeShopDataCallBack:"];
    [dataProvider SelectSmallCategory:parentId];
}

-(void)getThreeShopDataCallBack:(id)dict{
    NSLog(@"%@",dict);
    if ([dict[@"code"] intValue] == 200) {
        threeShopArray = dict[@"data"];
        [threeTableView reloadData];
    }
}

-(void)initViews{
    firstTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height)];
    firstTableView.delegate = self;
    firstTableView.dataSource = self;
    firstTableView.backgroundColor = BACKGROUND_COLOR;
    firstTableView.separatorColor = Separator_Color;
    firstTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:firstTableView];
    
    secondTableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 3, Header_Height,SCREEN_WIDTH / 3 * 2, SCREEN_HEIGHT - Header_Height)];
    secondTableView.delegate = self;
    secondTableView.dataSource = self;
    secondTableView.backgroundColor = BACKGROUND_COLOR;
    secondTableView.separatorColor = Separator_Color;
    secondTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:secondTableView];
    
    threeTableView = [[UITableView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH / 3) * 2, Header_Height, SCREEN_WIDTH / 3, SCREEN_HEIGHT - Header_Height)];
    threeTableView.delegate = self;
    threeTableView.dataSource = self;
    threeTableView.backgroundColor = BACKGROUND_COLOR;
    threeTableView.separatorColor = Separator_Color;
    threeTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:threeTableView];
    
    secondTableView.hidden = YES;
    threeTableView.hidden = YES;
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == firstTableView){
        return firstShopArray.count;
    }else if (tableView == secondTableView){
        return secondShopArray.count;
    }else{
        return threeShopArray.count;
    }
}

#pragma mark setting for section

#pragma mark setting for cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }else{
        for (UIView *view in cell.subviews) {
            if ([view isKindOfClass:[UILabel class]]) {
                [view removeFromSuperview];
            }
        }
    }
    if (tableView == firstTableView) {
        cell.backgroundColor = ItemsBaseColor;
        UILabel *firstName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 3, 70)];
        firstName.font = [UIFont systemFontOfSize:15];
        firstName.textAlignment = NSTextAlignmentCenter;
        firstName.textColor = [UIColor whiteColor];
        firstName.text = [firstShopArray[indexPath.row] valueForKey:@"Name"];
        [cell addSubview:firstName];
    }else if(tableView == secondTableView){
        cell.backgroundColor = [UIColor colorWithRed:0.22 green:0.23 blue:0.25 alpha:1];
        UILabel *secondName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 3, 70)];
        secondName.font = [UIFont systemFontOfSize:15];
        secondName.textAlignment = NSTextAlignmentCenter;
        secondName.textColor = [UIColor whiteColor];
        secondName.text = [secondShopArray[indexPath.row] valueForKey:@"Name"];
        [cell addSubview:secondName];
    }else{
        cell.backgroundColor = YellowBlock;
        UILabel *threeName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 3, 70)];
        threeName.font = [UIFont systemFontOfSize:15];
        threeName.textAlignment = NSTextAlignmentCenter;
        threeName.textColor = [UIColor whiteColor];
        threeName.text = [threeShopArray[indexPath.row] valueForKey:@"Name"];
        [cell addSubview:threeName];
    }
    
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
        [cell setPreservesSuperviewLayoutMargins:false];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == firstTableView) {
        [firstTableView deselectRowAtIndexPath:indexPath animated:YES];
        secondShopArray = [[NSArray alloc] init];
        secondTableView.hidden = NO;
        threeTableView.hidden = YES;
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:firstLastIndexPath];
        oldCell.backgroundColor = ItemsBaseColor;
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.backgroundColor = [UIColor colorWithRed:0.22 green:0.23 blue:0.25 alpha:1];
        firstLastIndexPath = indexPath;
        [self getSecondShopData:[firstShopArray[indexPath.row] valueForKey:@"Id"]];
    }else if (tableView == secondTableView){
        [secondTableView deselectRowAtIndexPath:indexPath animated:YES];
        threeShopArray = [[NSArray alloc] init];
        threeTableView.hidden = NO;
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:secondLastIndexPath];
        oldCell.backgroundColor = [UIColor colorWithRed:0.22 green:0.23 blue:0.25 alpha:1];
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.backgroundColor = YellowBlock;
        secondLastIndexPath = indexPath;
        [self getThreeShopData:[secondShopArray[indexPath.row] valueForKey:@"Id"]];
    }else{
        [threeTableView deselectRowAtIndexPath:indexPath animated:YES];
        ShopListViewController *shopListVC = [[ShopListViewController alloc] init];
        shopListVC.categoryId = [threeShopArray[indexPath.row] valueForKey:@"Id"];
        [self.navigationController pushViewController:shopListVC animated:YES];
    }
}

@end
