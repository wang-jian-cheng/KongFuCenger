//
//  Member-ViewController.m
//  KongFuCenter
//
//  Created by 鞠超 on 15/12/16.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "Member-ViewController.h"
#import "CommonDef.h"
#import "MemberTableViewCell.h"
@interface Member_ViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSMutableArray *teamMemberArr;
}
@property (nonatomic, strong) UIView * searchView;

@property (nonatomic, strong) UITableView * tableView;
//搜索框
@property (nonatomic, strong) UITextField * textField;
@end

@implementation Member_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    teamMemberArr = [NSMutableArray array];
    
    [self p_navigation];

    [self p_searchView];
    
    [self p_tableView];
    
    [self getTeamMembers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - self data source
-(void)getTeamMembers
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"getTeamMemberCallBack:"];
    [dataprovider getTeamMember:get_sp(@"TeamId")];

}

-(void)getTeamMemberCallBack:(id)dict
{
    [SVProgressHUD dismiss];
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try {
            if(teamMemberArr !=nil && teamMemberArr.count > 0)
            {
                [teamMemberArr removeAllObjects];
            }
            [teamMemberArr addObjectsFromArray:dict[@"data"]];
            [self.tableView reloadData];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"data"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        
    }
}
#pragma mark - 背景色和navigation
- (void)p_navigation
{
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self setBarTitle:@"战队成员"];
    [self addLeftButton:@"left"];
}
#pragma mark - search框
- (void)p_searchView
{
    self.searchView = [[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT + StatusBar_HEIGHT + 10, self.view.frame.size.width, 60)];
    self.searchView.backgroundColor = ItemsBaseColor;
    [self.view addSubview:self.searchView];

    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(25, 20, 25, 25)];
    image.image = [UIImage imageNamed:@"search"];
    [self.searchView addSubview:image];
    
    //搜索框
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(image.frame) + 20, 15, 150, 35)];
    self.textField.placeholder = @"搜索战队昵称、id号";
    [self.textField setValue:Separator_Color forKeyPath:@"_placeholderLabel.textColor"];
    self.textField.textColor = [UIColor whiteColor];
//    self.textField.backgroundColor = [UIColor orangeColor];
    [self.searchView addSubview:self.textField];
    
    self.textField.delegate = self;
    
    
}
#pragma mark - tableView
- (void)p_tableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchView.frame) + 10, self.view.frame.size.width, self.view.frame.size.height - 80 - NavigationBar_HEIGHT - StatusBar_HEIGHT) style:(UITableViewStylePlain)];
    
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 30, 0, 0);
    self.tableView.separatorColor = Separator_Color;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    //注册
    [self.tableView registerClass:[MemberTableViewCell class] forCellReuseIdentifier:@"cell_member"];
    
}
#pragma mark - tableView代理方法
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return teamMemberArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemberTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell_member" forIndexPath:indexPath];
    
    cell.backgroundColor = ItemsBaseColor;
    
    @try {
        if(indexPath.row > teamMemberArr.count - 1||teamMemberArr == nil || teamMemberArr.count == 0)
            return cell;
        
        NSDictionary *tempDict = teamMemberArr[indexPath.row];
        cell.name.text = tempDict[@"NicName"];
        cell.number.text = tempDict[@"Phone"];
        NSString *url = [NSString stringWithFormat:@"%@%@",Kimg_path,tempDict[@"PhotoPath"]];
        [cell.image sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"me"]];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - textfiled代理
//这个根据需求写



@end