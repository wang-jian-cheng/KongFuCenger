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

@property (nonatomic, strong) UIView * view_alertChat;

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
            //不让用户点击cell
            self.tableView.userInteractionEnabled = NO;
            
            if(self.view_alert == nil)
            {
                [UIView animateWithDuration:0.5 animations:^{
                    
                    self.tableView.backgroundColor = ItemsBaseColor;
                    
                } completion:^(BOOL finished) {
                    
                    self.view_alert = [[UIView alloc] initWithFrame:CGRectMake(30 , self.view.frame.size.height / 4 + NavigationBar_HEIGHT + StatusBar_HEIGHT, self.view.frame.size.width - 60, 130)];
                    self.view_alert.backgroundColor = BACKGROUND_COLOR;
                    [self.view addSubview:self.view_alert];
                    
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
            else
            {
                [UIView animateWithDuration:0.5 animations:^{
                    self.tableView.backgroundColor = ItemsBaseColor;

                } completion:^(BOOL finished) {
                    self.view_alert.backgroundColor = BACKGROUND_COLOR;
                    self.view_alert.hidden = NO;
                }];
            }
        }
            break;
        case 1:
        {
            
            self.tableView.userInteractionEnabled = NO;

            
            if(self.view_alertChat == nil)
            {
                [UIView animateWithDuration:0.5 animations:^{
                    
                    self.tableView.backgroundColor = ItemsBaseColor;
                    
                } completion:^(BOOL finished) {
                    
                    self.view_alertChat = [[UIView alloc] initWithFrame:CGRectMake(30, self.view.frame.size.height / 4 + NavigationBar_HEIGHT + StatusBar_HEIGHT, self.view.frame.size.width - 60, 130)];
                    self.view_alertChat.backgroundColor = BACKGROUND_COLOR;
                    [self.view addSubview:self.view_alertChat];
                    
                    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(self.view_alertChat.frame.size.width / 2 - 115, 30, 230, 30)];
                    title.text = @"是否清除全部聊天缓存";
                    //            title.backgroundColor = [UIColor orangeColor];
                    title.font = [UIFont systemFontOfSize:23];
                    title.textColor = [UIColor whiteColor];
                    [self.view_alertChat addSubview:title];
                    
                    UIButton * btn_cancel1 = [UIButton buttonWithType:(UIButtonTypeSystem)];
                    btn_cancel1.frame = CGRectMake(0, 90, self.view_alertChat.frame.size.width / 2, 39);
                    [btn_cancel1 setTitle:@"取消" forState:(UIControlStateNormal)];
                    [btn_cancel1 setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                    btn_cancel1.titleLabel.font = [UIFont systemFontOfSize:20];
                    btn_cancel1.backgroundColor = navi_bar_bg_color;
                    [self.view_alertChat addSubview:btn_cancel1];
                    [btn_cancel1 addTarget:self action:@selector(btn_cancel1Action) forControlEvents:(UIControlEventTouchUpInside)];
                    
                    UIButton * btn_ok1 = [UIButton buttonWithType:(UIButtonTypeSystem)];
                    btn_ok1.frame = CGRectMake(self.view_alertChat.frame.size.width / 2, 90, self.view_alertChat.frame.size.width / 2, 39);
                    [btn_ok1 setTitle:@"确定" forState:(UIControlStateNormal)];
                    [btn_ok1 setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                    btn_ok1.titleLabel.font = [UIFont systemFontOfSize:20];
                    btn_ok1.backgroundColor = YellowBlock;
                    [self.view_alertChat addSubview:btn_ok1];
                    [btn_ok1 addTarget:self action:@selector(btn_ok1Action)                forControlEvents:(UIControlEventTouchUpInside)];
                }];

            }
            else
            {
                [UIView animateWithDuration:0.5 animations:^{
                    self.tableView.backgroundColor = ItemsBaseColor;
                    
                } completion:^(BOOL finished) {
                    self.view_alertChat.backgroundColor = BACKGROUND_COLOR;
                    self.view_alertChat.hidden = NO;
                }];
            }
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
        
        self.tableView.userInteractionEnabled = YES;
    }];
}

- (void)btn_okAction
{//清除全部缓存
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.backgroundColor = BACKGROUND_COLOR;
        self.view_alert.hidden = YES;
        [self clearCache];
    } completion:^(BOOL finished) {
        self.tableView.userInteractionEnabled = YES;
    }];
}

- (void)btn_cancel1Action
{//不做任何操作
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.backgroundColor = BACKGROUND_COLOR;
        self.view_alertChat.hidden = YES;
    } completion:^(BOOL finished) {
        self.tableView.userInteractionEnabled = YES;

    }];
    
}

- (void)btn_ok1Action
{//清除全部聊天缓存
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.backgroundColor = BACKGROUND_COLOR;
        self.view_alertChat.hidden = YES;
        [self clearCache];
    } completion:^(BOOL finished) {
        
        self.tableView.userInteractionEnabled = YES;

    }];
}

#pragma mark - 清除缓存
-(void)clearCache
{
    dispatch_async(
       dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
       , ^{
           
           NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
           NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
           
           for (NSString *p in files) {
               NSError *error;
               NSString *path = [cachPath stringByAppendingPathComponent:p];
               if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                   [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
               }
           }
           [self performSelectorOnMainThread:@selector(clearCacheSuccess)
                                  withObject:nil waitUntilDone:YES];});
}

- (void)clearCacheSuccess
{
    [SVProgressHUD showSuccessWithStatus:@"清除成功" maskType:SVProgressHUDMaskTypeBlack];
}

@end
