//
//  JHStoryViewController.m
//  KongFuCenter
//
//  Created by Rain on 15/12/4.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "JHStoryViewController.h"
#import "JHStoryTableViewCell.h"

@interface JHStoryViewController (){
    UITableView *mTableView;
    CGFloat mCellHeight;
}

@end

@implementation JHStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化参数
    self.view.backgroundColor = BACKGROUND_COLOR;
    mCellHeight = SCREEN_HEIGHT / 12;
    [self setBarTitle:@"江湖故事"];
    
    //初始化View
    [self initViews];
}

#pragma mark 自定义方法
-(void)initViews{
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height - TabBar_HEIGHT)];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    //mTableView.backgroundColor =
    mTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:mTableView];
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

#pragma mark setting for section


#pragma mark setting for cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JHStoryTableViewCell *cell = nil;
    return cell;
}

@end
