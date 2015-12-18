//
//  JoinTeamViewController.m
//  KongFuCenter
//
//  Created by Rain on 15/12/8.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "JoinTeamViewController.h"
#import "JoinTeamCell.h"
#import "MJRefresh.h"

@interface JoinTeamViewController (){
    //tableview
    UITableView *mTableView;
    CGFloat mCellHeight;
    
    //控件
    UITextField *searchTxt;
    
    //标识变量
    int curpage;//页数
    
    //数据
    NSArray *teamArray;
    
    //通用
    NSUserDefaults *userDefault;
}

@end

@implementation JoinTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化参数
    mCellHeight = 70;
    [self setBarTitle:@"加入战队"];
    [self addLeftButton:@"left"];
    
    teamArray = [[NSArray alloc] init];
    userDefault = [NSUserDefaults standardUserDefaults];
    
    //初始化View
    [self initViews];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

#pragma mark 自定义方法
-(void)initViews{
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height)];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = BACKGROUND_COLOR;
    mTableView.separatorColor = Separator_Color;
    mTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:mTableView];
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    __weak typeof(UITableView *) weakTv = mTableView;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    
    mTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf TeamTopRefresh];
        [weakTv.mj_header endRefreshing];
    }];
    
    // 马上进入刷新状态
    [mTableView.mj_header beginRefreshing];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(TeamFootRefresh)];
    
    // 禁止自动加载
    footer.automaticallyRefresh = NO;
    
    // 设置footer
    mTableView.mj_footer = footer;
}

-(void)initData{
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getTeamInfo:"];
    //dataProvider SelectTeamPage:<#(NSString *)#> andMaximumRows:<#(NSString *)#> andName:<#(NSString *)#> andAreaid:<#(NSString *)#>
}

-(void)getTeamInfo:(id)dict{
    NSLog(@"%@",dict);
}

-(void)TeamTopRefresh
{
    curpage=0;
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"GetTeamListBackCall:"];
    [dataProvider SelectTeamPage:[NSString stringWithFormat:@"%d",curpage * 10] andMaximumRows:@"10" andName:@"" andAreaid:@"20644"];
}

-(void)TeamFootRefresh
{
    curpage++;
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"FootRefireshBackCall:"];
    [dataProvider SelectTeamPage:[NSString stringWithFormat:@"%d",curpage * 10] andMaximumRows:@"10" andName:@"" andAreaid:@"20644"];
}

-(void)GetTeamListBackCall:(id)dict
{
    [SVProgressHUD dismiss];
    NSLog(@"店铺列表%@",dict);
    if ([dict[@"code"] intValue] == 200) {
        teamArray=dict[@"data"];
        [mTableView reloadData];
    }
}

-(void)FootRefireshBackCall:(id)dict
{
    
    NSLog(@"上拉刷新");
    // 结束刷新
    [mTableView.mj_footer endRefreshing];
    NSMutableArray *itemarray=[[NSMutableArray alloc] initWithArray:teamArray];
    if ([dict[@"code"] intValue] == 200) {
        NSArray * arrayitem=[[NSArray alloc] init];
        arrayitem=dict[@"data"];
        for (id item in arrayitem) {
            [itemarray addObject:item];
        }
        teamArray=[[NSArray alloc] initWithArray:itemarray];
    }
    [mTableView reloadData];
}

-(void)joinTeamEvent:(UIButton *)btn{
    NSString *teamId = teamArray[btn.tag][@"Id"];
    NSString *teamName = teamArray[btn.tag][@"Name"];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"joinTeamCallBack:"];
    [dataProvider JoinTeam:[userDefault valueForKey:@"id"] andTeamId:teamId andName:teamName];
}

-(void)joinTeamCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        [SVProgressHUD showSuccessWithStatus:@"加入战队成功~"];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"加入战队失败~"];
    }
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return teamArray.count + 1;
    }
}

#pragma mark setting for section
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BACKGROUND_COLOR;
    return view;
}

#pragma mark setting for cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        cell.backgroundColor = ItemsBaseColor;
        searchTxt = [[UITextField alloc] initWithFrame:CGRectMake(14, 0, SCREEN_WIDTH - 28, cell.frame.size.height)];
        searchTxt.textColor = [UIColor whiteColor];
        searchTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索战队昵称、所在地区" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.44 green:0.43 blue:0.44 alpha:1]}];
        UIImageView *searchIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 20)];
        searchIv.contentMode = UIViewContentModeScaleAspectFit;
        searchIv.image = [UIImage imageNamed:@"search"];
        searchTxt.leftView = searchIv;
        searchTxt.leftViewMode = UITextFieldViewModeAlways;
        [cell addSubview:searchTxt];
        return cell;
    }else{
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
            cell.backgroundColor = ItemsBaseColor;
            //地区
            UILabel *addressLbl = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, 50, cell.frame.size.height)];
            addressLbl.textColor = [UIColor whiteColor];
            addressLbl.text = @"地区:";
            [cell addSubview:addressLbl];
            //省
            UIButton *btnProvince = [[UIButton alloc] initWithFrame:CGRectMake(addressLbl.frame.origin.x + addressLbl.frame.size.width, (cell.frame.size.height - 25) / 2, 40, 25)];
            btnProvince.backgroundColor = [UIColor colorWithRed:0.51 green:0.51 blue:0.51 alpha:1];
            [btnProvince setTitle:@"山东" forState:UIControlStateNormal];
            [cell addSubview:btnProvince];
            UIImageView *provinceIv = [[UIImageView alloc] initWithFrame:CGRectMake(btnProvince.frame.origin.x + btnProvince.frame.size.width + 8, 0, 10, cell.frame.size.height)];
            provinceIv.contentMode = UIViewContentModeScaleAspectFit;
            provinceIv.image = [UIImage imageNamed:@"down_icon"];
            [cell addSubview:provinceIv];
            //市
            UIButton *btnCity = [[UIButton alloc] initWithFrame:CGRectMake(btnProvince.frame.origin.x + btnProvince.frame.size.width + 25, (cell.frame.size.height - 25) / 2, 40, 25)];
            btnCity.backgroundColor = [UIColor colorWithRed:0.51 green:0.51 blue:0.51 alpha:1];
            [btnCity setTitle:@"临沂" forState:UIControlStateNormal];
            [cell addSubview:btnCity];
            UIImageView *cityIv = [[UIImageView alloc] initWithFrame:CGRectMake(btnCity.frame.origin.x + btnCity.frame.size.width + 8, 0, 10, cell.frame.size.height)];
            cityIv.contentMode = UIViewContentModeScaleAspectFit;
            cityIv.image = [UIImage imageNamed:@"down_icon"];
            [cell addSubview:cityIv];
            //县
            UIButton *btnCountry = [[UIButton alloc] initWithFrame:CGRectMake(btnCity.frame.origin.x + btnCity.frame.size.width + 25, (cell.frame.size.height - 25) / 2, 55, 25)];
            btnCountry.backgroundColor = [UIColor colorWithRed:0.51 green:0.51 blue:0.51 alpha:1];
            [btnCountry setTitle:@"兰山区" forState:UIControlStateNormal];
            [cell addSubview:btnCountry];
            UIImageView *countryIv = [[UIImageView alloc] initWithFrame:CGRectMake(btnCountry.frame.origin.x + btnCountry.frame.size.width + 8, 0, 10, cell.frame.size.height)];
            countryIv.contentMode = UIViewContentModeScaleAspectFit;
            countryIv.image = [UIImage imageNamed:@"down_icon"];
            [cell addSubview:countryIv];
            return cell;
        }else{
            NSString *CellIdentifier = @"JoinTeamCellIdentifier";
            JoinTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"JoinTeamCell" owner:self options:nil] objectAtIndex:0];
                cell.backgroundColor = ItemsBaseColor;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.mImageView.image = [UIImage imageNamed:@"jointeam"];
            cell.mName.text = teamArray[indexPath.row - 1][@"Name"];//@"跆拳道战队(123456789)";
            cell.mAddress.text = @"所在地:山东临沂";
            [cell.mJoin setTitle:@"加入" forState:UIControlStateNormal];
            cell.mJoin.tag = indexPath.row - 1;
            [cell.mJoin addTarget:self action:@selector(joinTeamEvent:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 45;
    }else{
        if (indexPath.row == 0) {
            return 40;
        }else{
            return mCellHeight;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [mTableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark UITextFieldDelegate


@end
