//
//  NewConcernFriendViewController.m
//  KongFuCenter
//
//  Created by Rain on 16/1/13.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "NewConcernFriendViewController.h"
#import "NewConcernFriendTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UserHeadView.h"

@interface NewConcernFriendViewController (){
    UITableView *mTableView;
    CGFloat mCellHeight;
    NSArray *NewConcernFriendArray;
}

@end

@implementation NewConcernFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化参数
    self.view.backgroundColor = BACKGROUND_COLOR;
    mCellHeight = 70;
    [self setBarTitle:@"新关注好友"];
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
    [SVProgressHUD showWithStatus:@"加载中..."];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getNewConcernFriendCallBack:"];
    [dataProvider SelectFriended:get_sp(@"id")];
}

-(void)getNewConcernFriendCallBack:(id)dict{
    [SVProgressHUD dismiss];
    if ([dict[@"code"] intValue] == 200) {
        NewConcernFriendArray = dict[@"data"];
        [self initViews];
    }
}

-(void)initViews{
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height)];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = BACKGROUND_COLOR;
    mTableView.separatorColor = Separator_Color;
    mTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:mTableView];
}

-(void)cancelConcernEvent:(UIButton *)btn{
    [SVProgressHUD showWithStatus:@"加载中..."];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"deleteFriendCallBack:"];
    [dataProvider DeleteFriend:get_sp(@"id") andfriendid:[NSString stringWithFormat:@"%d",(int)btn.tag]];
}

-(void)deleteFriendCallBack:(id)dict{
    [SVProgressHUD dismiss];
    if ([dict[@"code"] intValue] == 200) {
        [SVProgressHUD showSuccessWithStatus:@"取消关注成功~"];
        [self initData];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"取消关注失败~"];
    }
}

-(void)concernEvent:(UIButton *)btn{
    [SVProgressHUD showWithStatus:@"加载中..."];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"addFriendCallBack:"];
    [dataProvider SaveFriend:get_sp(@"id") andFriendid:[NSString stringWithFormat:@"%d",(int)btn.tag]];
}

-(void)addFriendCallBack:(id)dict{
    [SVProgressHUD dismiss];
    if ([dict[@"code"] intValue] == 200) {
        [SVProgressHUD showSuccessWithStatus:@"关注成功~"];
        [self initData];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"关注失败~"];
    }
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return NewConcernFriendArray.count;
}

#pragma mark setting for section

#pragma mark setting for cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"NewConcernFriendCellIdentifier";
    NewConcernFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NewConcernFriendTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.backgroundColor = ItemsBaseColor;
    }
    NSString *photoPath = [Toolkit judgeIsNull:[NewConcernFriendArray[indexPath.row] valueForKey:@"PhotoPath"]];
    NSString *url = [NSString stringWithFormat:@"%@%@",Url,photoPath];
    UserHeadView *headView = [[UserHeadView alloc] initWithFrame:cell.mImgView.frame andUrl:url andNav:self.navigationController];
    headView.userId = [Toolkit judgeIsNull:[NewConcernFriendArray[indexPath.row] valueForKey:@"UserId"]];
    [headView makeSelfRound];
    
    [cell addSubview:headView];
    cell.mName.text = [Toolkit judgeIsNull:[NewConcernFriendArray[indexPath.row] valueForKey:@"NicName"]];
    NSString *joinTime = [Toolkit judgeIsNull:[NewConcernFriendArray[indexPath.row] valueForKey:@"JoinTime"]];
    cell.mDate.text = [NSString stringWithFormat:@"%@关注了你",joinTime];
    NSString *isFriend = [Toolkit judgeIsNull:[NewConcernFriendArray[indexPath.row] valueForKey:@"IsFriend"]];
    if ([isFriend isEqual:@"1"]) {
        [cell.mConcernBtn setTitle:@"取消关注" forState:UIControlStateNormal];
        cell.mConcernBtn.tag = [[Toolkit judgeIsNull:[NewConcernFriendArray[indexPath.row] valueForKey:@"UserId"]] intValue];
        [cell.mConcernBtn addTarget:self action:@selector(cancelConcernEvent:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [cell.mConcernBtn setTitle:@"关注" forState:UIControlStateNormal];
        cell.mConcernBtn.backgroundColor = [UIColor colorWithRed:0.94 green:0.62 blue:0 alpha:1];
        cell.mConcernBtn.tag = [[Toolkit judgeIsNull:[NewConcernFriendArray[indexPath.row] valueForKey:@"UserId"]] intValue];
        [cell.mConcernBtn addTarget:self action:@selector(concernEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return mCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [mTableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
