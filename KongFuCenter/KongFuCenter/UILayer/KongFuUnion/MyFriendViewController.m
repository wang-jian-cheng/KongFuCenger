//
//  MyFriendViewController.m
//  KongFuCenter
//
//  Created by Rain on 15/12/21.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "MyFriendViewController.h"

@interface MyFriendViewController (){
    
    //tableview
    UITableView *mTableView;
    CGFloat mCellHeight;
    
    //数据
    NSArray *keys;
    NSMutableDictionary *names;
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
    
    //初始化数据
    [self initData];
    
    //初始化View
    [self initViews];
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

#pragma mark 自定义方法
-(void)initData{
    names = [[NSMutableDictionary alloc] init];
    [names setValue:[[NSArray alloc] initWithObjects:@"1",@"2",@"3", nil] forKey:@"A"];
    [names setValue:[[NSArray alloc] initWithObjects:@"4",@"5",@"6", nil] forKey:@"B"];
    [names setValue:[[NSArray alloc] initWithObjects:@"7",@"8",@"9", nil] forKey:@"C"];
    
    keys = [[names allKeys] sortedArrayUsingSelector:@selector(compare:)];
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
    return keys.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *key = [keys objectAtIndex:section];
    NSDictionary *nameSection = [names valueForKey:key];
    return nameSection.count;
}

#pragma mark setting for section
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [keys objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return keys;
}

#pragma mark setting for cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    cell.backgroundColor = ItemsBaseColor;
    cell.textLabel.text = [[names objectForKey:[keys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return mCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [mTableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
