//
//  ClearCacheViewController.m
//  KongFuCenter
//
//  Created by 鞠超 on 15/12/18.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "ClearCacheViewController.h"

@interface ClearCacheViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UIView * view_alert;

@end

@implementation ClearCacheViewController

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
//隐藏tabbar
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

#pragma mark - 背景色和navigation
- (void)p_navigation
{
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self setBarTitle:@"清除缓存"];
    [self addLeftButton:@"left"];
}

#pragma mark - tableView
- (void)p_tableView
{
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT + StatusBar_HEIGHT + 1, self.view.frame.size.width, self.view.frame.size.height - NavigationBar_HEIGHT - StatusBar_HEIGHT - 1) style:(UITableViewStylePlain)];
    
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 30, 0, 0);
    self.tableView.separatorColor = Separator_Color;
    
    [self.view addSubview:self.tableView];
    //注册
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell_clear"];
}

#pragma mark - tableView代理方法
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell_clear" forIndexPath:indexPath];
    cell.backgroundColor = ItemsBaseColor;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:19];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"清除全部缓存";
            break;
        case 1:
            cell.textLabel.text = @"清除全部聊天记录";
            break;
        default:
            break;
    }
    
    
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void )tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
//            NSLog(@"1");
//            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"是否清除全部缓存" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
//            [self presentViewController:alert animated:YES completion:^{
//                
//            }];
//            
//            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//                
//            }];
//            UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//                
//            }];
//            [alert addAction:action1];
//            [alert addAction:action];
            
            [UIView animateWithDuration:0.5 animations:^{
                
                self.tableView.backgroundColor = ItemsBaseColor;
                
            } completion:^(BOOL finished) {
                
                self.view_alert = [[UIView alloc] initWithFrame:CGRectMake(30, self.view.frame.size.height / 4 , self.view.frame.size.width - 60, 130)];
                self.view_alert.backgroundColor = BACKGROUND_COLOR;
                [self.tableView addSubview:self.view_alert];
                
                UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(self.view_alert.frame.size.width / 2 - 95, 30, 190, 30)];
                title.text = @"是否清除全部缓存";
                //            title.backgroundColor = [UIColor orangeColor];
                title.font = [UIFont systemFontOfSize:23];
                title.textColor = [UIColor whiteColor];
                [self.view_alert addSubview:title];
                
                UIButton * btn_cancel = [UIButton buttonWithType:(UIButtonTypeSystem)];
                btn_cancel.frame = CGRectMake(0, 90, self.view_alert.frame.size.width / 2, 39);
                [btn_cancel setTitle:@"取消" forState:(UIControlStateNormal)];
                [btn_cancel setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                btn_cancel.titleLabel.font = [UIFont systemFontOfSize:20];
                btn_cancel.backgroundColor = navi_bar_bg_color;
                [self.view_alert addSubview:btn_cancel];
                [btn_cancel addTarget:self action:@selector(btn_cancelAction) forControlEvents:(UIControlEventTouchUpInside)];
                
                UIButton * btn_ok = [UIButton buttonWithType:(UIButtonTypeSystem)];
                btn_ok.frame = CGRectMake(self.view_alert.frame.size.width / 2, 90, self.view_alert.frame.size.width / 2, 39);
                [btn_ok setTitle:@"确定" forState:(UIControlStateNormal)];
                [btn_ok setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                btn_ok.titleLabel.font = [UIFont systemFontOfSize:20];
                btn_ok.backgroundColor = YellowBlock;
                [self.view_alert addSubview:btn_ok];
                [btn_ok addTarget:self action:@selector(btn_okAction)                forControlEvents:(UIControlEventTouchUpInside)];
            }];
        }
            break;
        case 1:
//            NSLog(@"2");
        {
            [UIView animateWithDuration:0.5 animations:^{
                
                self.tableView.backgroundColor = ItemsBaseColor;
                
            } completion:^(BOOL finished) {
                
                self.view_alert = [[UIView alloc] initWithFrame:CGRectMake(30, self.view.frame.size.height / 4 , self.view.frame.size.width - 60, 130)];
                self.view_alert.backgroundColor = BACKGROUND_COLOR;
                [self.tableView addSubview:self.view_alert];
                
                UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(self.view_alert.frame.size.width / 2 - 115, 30, 230, 30)];
                title.text = @"是否清除全部聊天缓存";
                //            title.backgroundColor = [UIColor orangeColor];
                title.font = [UIFont systemFontOfSize:23];
                title.textColor = [UIColor whiteColor];
                [self.view_alert addSubview:title];
                
                UIButton * btn_cancel = [UIButton buttonWithType:(UIButtonTypeSystem)];
                btn_cancel.frame = CGRectMake(0, 90, self.view_alert.frame.size.width / 2, 39);
                [btn_cancel setTitle:@"取消" forState:(UIControlStateNormal)];
                [btn_cancel setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                btn_cancel.titleLabel.font = [UIFont systemFontOfSize:20];
                btn_cancel.backgroundColor = navi_bar_bg_color;
                [self.view_alert addSubview:btn_cancel];
                [btn_cancel addTarget:self action:@selector(btn_cancelAction) forControlEvents:(UIControlEventTouchUpInside)];
                
                UIButton * btn_ok1 = [UIButton buttonWithType:(UIButtonTypeSystem)];
                btn_ok1.frame = CGRectMake(self.view_alert.frame.size.width / 2, 90, self.view_alert.frame.size.width / 2, 39);
                [btn_ok1 setTitle:@"确定" forState:(UIControlStateNormal)];
                [btn_ok1 setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                btn_ok1.titleLabel.font = [UIFont systemFontOfSize:20];
                btn_ok1.backgroundColor = YellowBlock;
                [self.view_alert addSubview:btn_ok1];
                [btn_ok1 addTarget:self action:@selector(btn_ok1Action)                forControlEvents:(UIControlEventTouchUpInside)];
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 取消和确定的按钮
- (void)btn_cancelAction
{//不做任何操作
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.backgroundColor = BACKGROUND_COLOR;
        self.view_alert.hidden = YES;
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)btn_okAction
{//清除全部缓存
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.backgroundColor = BACKGROUND_COLOR;
        self.view_alert.hidden = YES;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)btn_ok1Action
{//清除全部聊天缓存
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.backgroundColor = BACKGROUND_COLOR;
        self.view_alert.hidden = YES;
    } completion:^(BOOL finished) {
        
    }];
}

@end
