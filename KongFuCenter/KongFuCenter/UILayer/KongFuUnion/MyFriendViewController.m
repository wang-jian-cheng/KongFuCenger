//
//  MyFriendViewController.m
//  KongFuCenter
//
//  Created by Rain on 15/12/21.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "MyFriendViewController.h"
#import "ChineseString.h"
#import "MyFriendTableViewCell.h"

@interface MyFriendViewController (){
    
    //tableview
    UITableView *mTableView;
    CGFloat mCellHeight;
    
    //数据
    NSArray *friendArray;
    NSMutableArray *indexArray;
    NSMutableArray *LetterResultArr;
    
    //通用
    DataProvider *dataProvider;
    NSUserDefaults *userDefault;
}

@end

@implementation MyFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化参数
    self.view.backgroundColor = ItemsBaseColor;
    mCellHeight = 50;
    [self setBarTitle:@"我的武友"];
    [self addLeftButton:@"left"];
    
    dataProvider = [[DataProvider alloc] init];
    userDefault = [NSUserDefaults standardUserDefaults];
    friendArray = [[NSArray alloc] init];
    
    //初始化数据
    [self initData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

#pragma mark 自定义方法
-(void)initData{
    [SVProgressHUD showWithStatus:@"加载中"];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getFriendCallBack:"];
    [dataProvider getFriendForKeyValue:[userDefault valueForKey:@"id"]];
}

-(void)getFriendCallBack:(id)dict{
    friendArray = dict[@"data"];
    NSMutableArray * itemmutablearray=[[NSMutableArray alloc] init];
    for (int i=0; i<friendArray.count; i++) {
        [itemmutablearray addObject:friendArray[i][@"Value"][@"NicName"]];
    }
    indexArray = [ChineseString IndexArray:itemmutablearray];
    LetterResultArr = [ChineseString LetterSortArray:itemmutablearray];
    [SVProgressHUD dismiss];
    //初始化View
    [self initViews];
}

-(void)initViews{
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height)];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    
    mTableView.backgroundColor = BACKGROUND_COLOR;
    mTableView.separatorColor = Separator_Color;
    mTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:mTableView];
    
    mTableView.sectionIndexBackgroundColor = [UIColor clearColor];
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return indexArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[LetterResultArr objectAtIndex:section] count];
}

#pragma mark setting for section
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [indexArray objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return indexArray;
}

#pragma mark setting for cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyFriendTableViewCell *cell = [[MyFriendTableViewCell alloc] init];
    cell.backgroundColor = ItemsBaseColor;
    //NSString *photoImage =
    //cell.mImageView.image =
    
    
    
    
    //cell.textLabel.text = [[LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return mCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [mTableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
