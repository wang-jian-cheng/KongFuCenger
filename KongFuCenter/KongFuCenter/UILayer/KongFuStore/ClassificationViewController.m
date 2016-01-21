//
//  ClassificationViewController.m
//  KongFuCenter
//
//  Created by Rain on 16/1/21.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "ClassificationViewController.h"

@interface ClassificationViewController (){
    UITableView *firstTableView;
    UITableView *secondTableView;
    UITableView *threeTableView;
    
    NSArray *firstShopArray;
    NSMutableArray *secondShopArray;
    NSMutableArray *threeShopArray;
    
    NSIndexPath *firstLastIndexPath;
    NSIndexPath *secondLastIndexPath;
}

@end

@implementation ClassificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化参数
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self setBarTitle:@"商品分类"];
    [self addLeftButton:@"left"];
    
    //初始化View
    [self initData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

#pragma mark 自定义方法
-(void)initData{
    firstLastIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    secondLastIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    firstShopArray = [[NSArray alloc] initWithObjects:@"跆拳道系列",@"运动系列",@"特技用品相关",@"体育用品",@"户外鞋帽",@"户外装备",@"垂钓用品",@"游泳用品", nil];
    secondShopArray = [[NSMutableArray alloc] initWithObjects:@"全部商品", nil];
    threeShopArray = [[NSMutableArray alloc] initWithObjects:@"全部商品", nil];
    [self initViews];
    //initWithObjects:@"全部商品",@"跆拳道服",@"跆拳道鞋",@"跆拳道护具",@"跆拳道练习靶",@"跆拳道周边", nil];
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
        firstName.text = firstShopArray[indexPath.row];
        [cell addSubview:firstName];
    }else if(tableView == secondTableView){
        cell.backgroundColor = [UIColor colorWithRed:0.22 green:0.23 blue:0.25 alpha:1];
        UILabel *secondName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 3, 70)];
        secondName.font = [UIFont systemFontOfSize:15];
        secondName.textAlignment = NSTextAlignmentCenter;
        secondName.textColor = [UIColor whiteColor];
        secondName.text = secondShopArray[indexPath.row];
        [cell addSubview:secondName];
    }else{
        cell.backgroundColor = YellowBlock;
        UILabel *threeName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 3, 70)];
        threeName.font = [UIFont systemFontOfSize:15];
        threeName.textAlignment = NSTextAlignmentCenter;
        threeName.textColor = [UIColor whiteColor];
        threeName.text = threeShopArray[indexPath.row];
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
        [secondShopArray removeAllObjects];
        secondTableView.hidden = NO;
        threeTableView.hidden = YES;
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:firstLastIndexPath];
        oldCell.backgroundColor = ItemsBaseColor;
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.backgroundColor = [UIColor colorWithRed:0.22 green:0.23 blue:0.25 alpha:1];
        firstLastIndexPath = indexPath;
        if (indexPath.row == 0) {
            [secondShopArray addObject:@"第一个"];
            [secondShopArray addObject:@"第二个"];
            [secondShopArray addObject:@"第三个"];
        }else if(indexPath.row == 1){
            [secondShopArray addObject:@"第四个"];
            [secondShopArray addObject:@"第五个"];
            [secondShopArray addObject:@"第六个"];
        }
        [secondTableView reloadData];
    }else if (tableView == secondTableView){
        [secondTableView deselectRowAtIndexPath:indexPath animated:YES];
        [threeShopArray removeAllObjects];
        threeTableView.hidden = NO;
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:secondLastIndexPath];
        oldCell.backgroundColor = [UIColor colorWithRed:0.22 green:0.23 blue:0.25 alpha:1];
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.backgroundColor = YellowBlock;
        secondLastIndexPath = indexPath;
        if (indexPath.row == 0) {
            [threeShopArray addObject:@"第一个"];
            [threeShopArray addObject:@"第二个"];
            [threeShopArray addObject:@"第三个"];
        }else if(indexPath.row == 1){
            [threeShopArray addObject:@"第四个"];
            [threeShopArray addObject:@"第五个"];
            [threeShopArray addObject:@"第六个"];
        }
        [threeTableView reloadData];
    }else{
        [threeTableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
