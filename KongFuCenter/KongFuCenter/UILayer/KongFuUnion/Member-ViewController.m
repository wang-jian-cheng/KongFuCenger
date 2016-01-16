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
    NSString *clickId;
    
    
    NSMutableArray *searchArr;
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
    if(searchArr ==nil)
    {
        searchArr = [NSMutableArray array];
    }
    [self p_navigation];

    [self p_searchView];
    
    [self p_tableView];
    
    [self getTeamMembers];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:) ];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
//    [self TeamTopRefresh];
    
    [self startSearchBtnClick:nil];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.textField resignFirstResponder];
    return YES;
}


//设置点在某个view时部触发事件
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"-%@", NSStringFromClass([touch.view class]));
    

    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"])
    {
        return NO;
    }
    //  NSLog(@"return YES");
    return  YES;
}

#pragma mark - click action


-(void)tapViewAction:(id)sender
{
    
    [self.view endEditing:YES];
    
}

-(void)infoBtnClick:(UIButton *)sender
{
//    clickId = searchArr[sender.tag][@"Id"];
//    
//    [self CheckIsFriend:clickId];
}

-(void)startSearchBtnClick:(UIButton *)sender
{
    
    if(searchArr ==nil)
    {
        searchArr = [NSMutableArray array];
    }
    else if(searchArr.count > 0)
    {
        [searchArr removeAllObjects];
    }
    if(self.textField.text.length == 0)
    {
        [searchArr addObjectsFromArray:teamMemberArr];
        [self.tableView reloadData];
        return;
    }
    
    if (self.textField.text.length>0&&![ChineseInclude isIncludeChineseInString:self.textField.text]) /*无汉字*/{
        @try {
            for (int i=0; i<teamMemberArr.count; i++) {
                
                NSString *nickStr;
                NSDictionary *tempDict = teamMemberArr[i];
                
                nickStr = [tempDict objectForKey:@"NicName"];
                /*先搜索昵称*/
                if ([ChineseInclude isIncludeChineseInString:nickStr]) {
                    NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:nickStr];
                    NSRange titleResult=[tempPinYinStr rangeOfString:self.textField.text options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0) {
                        [searchArr addObject:teamMemberArr[i]];
                        continue;
                    }
                    NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:nickStr];
                    NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:self.textField.text options:NSCaseInsensitiveSearch];
                    if (titleHeadResult.length>0) {
                        [searchArr addObject:teamMemberArr[i]];
                        continue;
                    }
                }
                else {
                    NSRange titleResult=[nickStr rangeOfString:self.textField.text options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0) {
                        [searchArr addObject:teamMemberArr[i]];
                        continue;
                    }
                }
                
                /*若昵称未搜索到则搜索ID*/
                /*判断是否全是数字,是则开始搜索id*/
                if([ChineseInclude isAllNumber:self.textField.text])
                {
                    NSString *phone;
                    NSDictionary *tempDict = teamMemberArr[i];
                    phone = [tempDict objectForKey:@"Phone"];
                    
                    
                    NSRange titleResult=[phone rangeOfString:self.textField.text options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0) {
                        [searchArr addObject:teamMemberArr[i]];
                        
                    }
                }
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    } else if (self.textField.text.length>0&&[ChineseInclude isIncludeChineseInString:self.textField.text]) {
        for (NSDictionary *tempDict in teamMemberArr) {
            NSString *nickStr;
            nickStr = [tempDict objectForKey:@"NicName"];
            NSRange titleResult=[nickStr rangeOfString:self.textField.text options:NSCaseInsensitiveSearch];
            if (titleResult.length>0) {
                [searchArr addObject:tempDict];
            }
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - self data source
-(void)getTeamMembers
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"getTeamMemberCallBack:"];
    [dataprovider getTeamMember:get_sp(@"TeamId") andUserId:[Toolkit getUserID]];

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
            [searchArr addObjectsFromArray:teamMemberArr];
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

    UIButton * searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(25, 20, 25, 25)];
    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(startSearchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.searchView addSubview:searchBtn];
    
    
    //搜索框
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(searchBtn.frame) + 20,
                                                                   15,
                                                                   SCREEN_WIDTH  - (searchBtn.frame.origin.x+searchBtn.frame.size.width),
                                                                   35)];
    self.textField.placeholder = @"搜索战队昵称、id号";
    [self.textField setValue:Separator_Color forKeyPath:@"_placeholderLabel.textColor"];
    self.textField.textColor = [UIColor whiteColor];
//    self.textField.backgroundColor = [UIColor orangeColor];
    [self.searchView addSubview:self.textField];
    self.textField.returnKeyType = UIReturnKeySearch;
    self.textField.delegate = self;
//    self.textField.keyboardAppearance = UIReturnKeySearch;
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
    return searchArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemberTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell_member" forIndexPath:indexPath];
    
    cell.backgroundColor = ItemsBaseColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    @try {
        if(indexPath.row > searchArr.count - 1||searchArr == nil || searchArr.count == 0)
            return cell;
        
        NSDictionary *tempDict = searchArr[indexPath.row];
        if([tempDict[@"RemarkName"] length] == 0)
        {
            cell.name.text = tempDict[@"NicName"];
        }
        else
        {
            cell.name.text = tempDict[@"RemarkName"];
        }
        cell.number.text = tempDict[@"Phone"];
        NSString *url = [NSString stringWithFormat:@"%@%@",Kimg_path,tempDict[@"PhotoPath"]];
        
        
        [cell.image sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"me"]];
        UIButton *btn = [[UIButton alloc] initWithFrame:cell.image.frame];
        btn.tag = indexPath.row;
        [btn addTarget:self action:@selector(infoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btn];
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
    
    clickId = searchArr[indexPath.row][@"MemnerId"];
    
    [self CheckIsFriend:clickId];
    
}

-(void)CheckIsFriend:(NSString *)userId
{
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"isFriendCallBack:"];
    [dataProvider IsWuyou:[Toolkit getUserID] andfriendid:userId];
}

-(void)isFriendCallBack:(id)dict{
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue] == 200) {
        if([dict[@"data"] intValue] == 1)//好友
        {
            FriendInfoViewController *friendInfoViewCtl = [[FriendInfoViewController alloc] init];
            friendInfoViewCtl.navtitle = @"好友资料";
            friendInfoViewCtl.userID = clickId;
            [self.navigationController pushViewController:friendInfoViewCtl animated:YES];
        }
        else//陌生人
        {
            
            StrangerInfoViewController *strangerInfoViewCtl = [[StrangerInfoViewController alloc] init];
            strangerInfoViewCtl.navtitle = @"好友资料";
            strangerInfoViewCtl.userID = clickId;
            [self.navigationController pushViewController:strangerInfoViewCtl animated:YES];
        }
    }
}
#pragma mark - textfiled代理
//这个根据需求写



@end