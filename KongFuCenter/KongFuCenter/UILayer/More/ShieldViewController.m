//
//  ShieldViewController.m
//  KongFuCenter
//
//  Created by 鞠超 on 15/12/17.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "ShieldViewController.h"

@interface ShieldViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation ShieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self p_navigation];
    
    [self p_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 背景色和navigation
- (void)p_navigation
{
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self setBarTitle:@"屏蔽列表"];
    [self addLeftButton:@"left"];
}
#pragma mark - tableView
- (void)p_tableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT + StatusBar_HEIGHT + 10, self.view.frame.size.width, self.view.frame.size.height - 10 - NavigationBar_HEIGHT - StatusBar_HEIGHT) style:(UITableViewStylePlain)];
    
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 30, 0, 0);
    self.tableView.separatorColor = Separator_Color;
    
    [self.view addSubview:self.tableView];
    //注册
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell_shield"];
}

#pragma mark - tableView代理方法
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 23;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell_shield" forIndexPath:indexPath];
    
    cell.backgroundColor = ItemsBaseColor;
    cell.textLabel.textColor = [UIColor whiteColor];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.imageView.image = [UIImage imageNamed:@"headImg@2x"];
    cell.textLabel.text = @"测试数据";
    
    
    
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
