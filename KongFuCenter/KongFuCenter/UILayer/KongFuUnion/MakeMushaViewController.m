//
//  MakeMushaViewController.m
//  KongFuCenter
//
//  Created by Rain on 15/12/11.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "MakeMushaViewController.h"
#import "MakeMushaCell.h"
#import "MJRefresh.h"
#import "UserHeadView.h"

@interface MakeMushaViewController (){
    
    //datatable
    UITableView *mTableView;
    CGFloat mCellHeight;
    
    //控件
    UITextField *searchTxt;
    UIView *BackView;
    UIPickerView *addressPickView;
    UIButton *btnAge;
    UIButton *btnSex;
    
    //数据
    NSArray *mushaArray;
    NSMutableArray *provinceArray;
    NSMutableArray *cityArray;
    NSMutableArray *countryArray;
    NSString *provinceId;
    NSString *provinceCode;
    NSString *provinceTxt;
    NSString *cityId;
    NSString *cityCode;
    NSString *cityTxt;
    NSString *countryId;
    NSString *countryCode;
    NSString *countryTxt;
    NSString *selectCityId;
    NSString *selectCountryId;
    int selectAge;
    NSString *selectAgeTxt;
    int selectSex;
    NSString *selectSexTxt;
    
    //通用
    DataProvider *dataProvider;
    NSUserDefaults *userDefault;
    
    //标识
    int curpage;
}

@end

@implementation MakeMushaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化参数
    //self.view.backgroundColor = BACKGROUND_COLOR;
    mCellHeight = 70;
    [self setBarTitle:@"交友"];
    [self addLeftButton:@"left"];
    
    mushaArray = [[NSArray alloc] init];
    userDefault = [NSUserDefaults standardUserDefaults];

    
    NSString *HomeCode = [userDefault valueForKey:@"HomeCode"];
    NSArray *HomeCodeArray = [HomeCode componentsSeparatedByString:@"&"];
    
    provinceCode = HomeCodeArray[0];
    provinceTxt = [[userDefault valueForKey:@"HomeAreaprovinceName"] isEqual:@""]?@"--全部--":[userDefault valueForKey:@"HomeAreaprovinceName"];//@"山东省";
    cityCode = HomeCodeArray[1];
    cityTxt = [[userDefault valueForKey:@"HomeAreaCityName"] isEqual:@""]?@"--全部--":[userDefault valueForKey:@"HomeAreaCityName"];//@"临沂市";
    countryId = [userDefault valueForKey:@"HomeAreaId"];//@"20644";
    countryCode = HomeCodeArray[2];
    countryTxt = [[userDefault valueForKey:@"HomeAreaCountyName"] isEqual:@""]?@"--全部--":[userDefault valueForKey:@"HomeAreaCountyName"];//@"兰山区";
    selectAge = 0;
    selectAgeTxt = @"--全部--";
    selectSex = 0;
    selectSexTxt = @"--全部--";
    
    //初始化地址数据
    [self initAddressData];
    
    //初始化View
    [self initViews];
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
    [self TeamTopRefresh];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [searchTxt resignFirstResponder];
}

#pragma mark 自定义方法
-(void)initAddressData{
    [SVProgressHUD showWithStatus:@""];
    dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getInitProvinceCallBack:"];
    [dataProvider getProvince];
}

-(void)getInitProvinceCallBack:(id)dict{
    [SVProgressHUD dismiss];
    if ([dict[@"code"] intValue] == 200) {
        NSDictionary *itemDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"0",@"Id",@"0",@"Code",@"-全部-",@"Name", nil];
        provinceArray = [[NSMutableArray alloc] init];
        [provinceArray addObject:itemDict];
        
        NSArray *itemArray = dict[@"data"];
        for (int i = 0; i < itemArray.count; i++) {
            [provinceArray addObject:itemArray[i]];
        }
        if([provinceCode isEqual:@"0"]){
            NSDictionary *itemDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"0",@"Id",@"0",@"Code",@"-全部-",@"Name", nil];
            cityArray = [[NSMutableArray alloc] init];
            countryArray = [[NSMutableArray alloc] init];
            [cityArray addObject:itemDict];
            [countryArray addObject:itemDict];
            return;
        }
        [SVProgressHUD showWithStatus:@""];
        dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"getInitCityCallBack:"];
        [dataProvider getCityByProvinceCode:[NSString stringWithFormat:@"%@",provinceCode]];
    }
}

-(void)getInitCityCallBack:(id)dict{
    [SVProgressHUD dismiss];
    NSLog(@"%@",dict);
    NSDictionary *itemDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"0",@"Id",@"0",@"Code",@"-全部-",@"Name", nil];
    cityArray = [[NSMutableArray alloc] init];
    countryArray = [[NSMutableArray alloc] init];
    [cityArray addObject:itemDict];
    [countryArray addObject:itemDict];
    if ([dict[@"code"] intValue] == 200) {
        NSArray *itemArray = dict[@"data"];
        for (int i = 0; i < itemArray.count; i++) {
            [cityArray addObject:itemArray[i]];
        }
        if (cityArray.count > 0) {
            [SVProgressHUD showWithStatus:@""];
            dataProvider = [[DataProvider alloc] init];
            [dataProvider setDelegateObject:self setBackFunctionName:@"getInitCountryCallBack:"];
            [dataProvider getCountryByCityCode:cityCode];
        }
    }
}

-(void)getInitCountryCallBack:(id)dict{
    [SVProgressHUD dismiss];
    if ([dict[@"code"] intValue] == 200) {
        NSLog(@"%@",dict[@"data"]);
        NSArray *itemArray = dict[@"data"];
        for (int i = 0; i < itemArray.count; i++) {
            [countryArray addObject:itemArray[i]];
        }
        if (![provinceCode isEqual:@"0"] && ![cityCode isEqual:@"0"] && ![countryCode isEqual:@"0"]) {
            [addressPickView selectRow:[[provinceArray valueForKey:@"Code"] indexOfObject:provinceCode] inComponent:0 animated:YES];
            [addressPickView selectRow:[[cityArray valueForKey:@"Code"] indexOfObject:cityCode] inComponent:1 animated:YES];
            [addressPickView selectRow:[[countryArray valueForKey:@"Code"] indexOfObject:countryCode] inComponent:2 animated:YES];
            [addressPickView reloadAllComponents];
        }
    }
}

-(void)getCityCallBack:(id)dict{
    [SVProgressHUD dismiss];
    NSLog(@"%@",dict);
    NSDictionary *itemDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"0",@"Id",@"0",@"Code",@"-全部-",@"Name", nil];
    cityArray = [[NSMutableArray alloc] init];
    countryArray = [[NSMutableArray alloc] init];
    [cityArray addObject:itemDict];
    [countryArray addObject:itemDict];
    if ([dict[@"code"] intValue] == 200) {
        if ([provinceCode isEqual:@"0"]) {
            NSDictionary *itemDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"0",@"Id",@"0",@"Code",@"-全部-",@"Name", nil];
            cityArray = [[NSMutableArray alloc] init];
            [cityArray addObject:itemDict];
            [addressPickView reloadAllComponents];
            
            cityCode = @"0";
            cityTxt = @"-全部-";
            countryCode = @"0";
            countryTxt = @"-全部-";
            return;
        }
        NSArray *itemArray = dict[@"data"];
        for (int i = 0; i < itemArray.count; i++) {
            [cityArray addObject:itemArray[i]];
        }
        if (cityArray.count > 0) {
            cityCode = cityArray[0][@"Code"];
            cityId = cityArray[0][@"Id"];
            if ([cityCode isEqual:@"0"]) {
                NSDictionary *itemDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"0",@"Id",@"0",@"Code",@"-全部-",@"Name", nil];
                countryArray = [[NSMutableArray alloc] init];
                [countryArray addObject:itemDict];
                [addressPickView reloadAllComponents];
                countryCode = @"0";
                countryTxt = @"--全部--";
            }else{
                [SVProgressHUD showWithStatus:@""];
                dataProvider = [[DataProvider alloc] init];
                [dataProvider setDelegateObject:self setBackFunctionName:@"getCountryCallBack:"];
                [dataProvider getCountryByCityCode:cityCode];
            }
            
            cityTxt = cityArray[0][@"Name"];
        }
        [addressPickView selectRow:0 inComponent:1 animated:YES];
        [addressPickView reloadComponent:1];
        [addressPickView reloadComponent:2];
    }
}

-(void)getCountryCallBack:(id)dict{
    [SVProgressHUD dismiss];
    NSDictionary *itemDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"0",@"Id",@"0",@"Code",@"-全部-",@"Name", nil];
    countryArray = [[NSMutableArray alloc] init];
    [countryArray addObject:itemDict];

    if ([cityCode isEqual:@"0"]) {
        countryId = countryArray[0][@"Id"];
        countryCode = countryArray[0][@"Code"];
        countryTxt = countryArray[0][@"Name"];
        [addressPickView selectRow:0 inComponent:2 animated:YES];
        [addressPickView reloadComponent:2];
        return;
    }
    if ([dict[@"code"] intValue] == 200) {
        NSLog(@"%@",dict[@"data"]);
        NSArray *itemArray = dict[@"data"];
        for (int i = 0; i < itemArray.count; i++) {
            [countryArray addObject:itemArray[i]];
        }
        countryId = countryArray[0][@"Id"];
        countryCode = countryArray[0][@"Code"];
        countryTxt = countryArray[0][@"Name"];
        [addressPickView selectRow:0 inComponent:2 animated:YES];
        [addressPickView reloadComponent:2];
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
    
    BackView=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-250, SCREEN_WIDTH, 50)];
    [BackView setBackgroundColor:[UIColor whiteColor]];
    UIButton * btn_cancel=[[UIButton alloc] initWithFrame:CGRectMake(10, 0, 60, 50)];
    [btn_cancel setTitle:@"取消" forState:UIControlStateNormal];
    [btn_cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_cancel addTarget:self action:@selector(cancelSelect:) forControlEvents:UIControlEventTouchUpInside];
    UIButton * btn_sure=[[UIButton alloc] initWithFrame:CGRectMake(BackView.frame.size.width-70, 0, 60, 50)];
    [btn_sure setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_sure setTitle:@"确定" forState:UIControlStateNormal];
    [btn_sure addTarget:self action:@selector(sureForSelect:) forControlEvents:UIControlEventTouchUpInside];
    UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(0, BackView.frame.size.height-1, BackView.frame.size.width, 1)];
    fenge.backgroundColor=[UIColor grayColor];
    [BackView addSubview:btn_sure];
    [BackView addSubview:btn_cancel];
    [BackView addSubview:fenge];
    
    addressPickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 200, SCREEN_WIDTH, 200)];
    addressPickView.delegate = self;
    addressPickView.dataSource = self;
    addressPickView.backgroundColor = [UIColor grayColor];
}

-(void)cancelSelect:(UIButton * )sender
{
    [BackView removeFromSuperview];
    [addressPickView removeFromSuperview];
}
-(void)sureForSelect:(UIButton *)sender
{
    [BackView removeFromSuperview];
    [addressPickView removeFromSuperview];
    [mTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    searchTxt.text = @"";
    [self TeamTopRefresh];
}

-(void)tempBtnEvent{
    [self.view addSubview:BackView];
    [self.view addSubview:addressPickView];
    
    [searchTxt resignFirstResponder];
}

-(void)TeamTopRefresh
{
    [mTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
    curpage=0;
    NSString *arreaCode = @"";
    if ([countryCode isEqual:@"0"]) {
        if ([cityCode isEqual:@"0"]) {
            arreaCode = provinceCode;
        }else{
            arreaCode = cityCode;
        }
    }else{
        arreaCode = countryCode;
    }
    [SVProgressHUD showWithStatus:@"加载中..."];
    dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"GetTeamListBackCall:"];
    [dataProvider GetFriendBySearch:[NSString stringWithFormat:@"%d",curpage * 10] andMaximumRows:@"10" andNicName:searchTxt.text andAreaCode:arreaCode andAge:[NSString stringWithFormat:@"%d",selectAge] andSexuality:[NSString stringWithFormat:@"%d",selectSex] andUserid:[userDefault valueForKey:@"id"]];
}

-(void)TeamFootRefresh
{
    curpage++;
    NSString *arreaCode = @"";
    if ([countryCode isEqual:@"0"]) {
        if ([cityCode isEqual:@"0"]) {
            arreaCode = provinceCode;
        }else{
            arreaCode = cityCode;
        }
    }else{
        arreaCode = countryCode;
    }
    dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"FootRefireshBackCall:"];
    [dataProvider GetFriendBySearch:[NSString stringWithFormat:@"%d",curpage * 10] andMaximumRows:@"10" andNicName:searchTxt.text andAreaCode:arreaCode andAge:[NSString stringWithFormat:@"%d",selectAge] andSexuality:[NSString stringWithFormat:@"%d",selectSex] andUserid:[userDefault valueForKey:@"id"]];
}

-(void)GetTeamListBackCall:(id)dict
{
    [SVProgressHUD dismiss];
    NSLog(@"店铺列表%@",dict);
    if ([dict[@"code"] intValue] == 200) {
        mushaArray=dict[@"data"];
        [mTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(void)FootRefireshBackCall:(id)dict
{
    
    NSLog(@"上拉刷新");
    // 结束刷新
    [mTableView.mj_footer endRefreshing];
    NSMutableArray *itemarray=[[NSMutableArray alloc] initWithArray:mushaArray];
    if ([dict[@"code"] intValue] == 200) {
        NSArray * arrayitem=[[NSArray alloc] init];
        arrayitem=dict[@"data"];
        for (id item in arrayitem) {
            [itemarray addObject:item];
        }
        mushaArray=[[NSArray alloc] initWithArray:itemarray];
    }
    [mTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)selectAgeEvent{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择年龄段" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"--全部--",@"18岁以下",@"18-22岁",@"23-26岁",@"27-35岁",@"35岁以上", nil];
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
}

-(void)selectSexEvent{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"--全部--",@"男",@"女", nil];
    actionSheet.tag = 2;
    [actionSheet showInView:self.view];
}

-(void)addFriendEvent:(UIButton *)btn{
    [SVProgressHUD showWithStatus:@"加载中..."];
    dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"addFriendCallBack:"];
    [dataProvider SaveFriend:[userDefault valueForKey:@"id"] andFriendid:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
}

-(void)addFriendCallBack:(id)dict{
    [SVProgressHUD dismiss];
    if ([dict[@"code"] intValue] == 200) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateMyFriend" object:nil];
        [SVProgressHUD showSuccessWithStatus:@"关注成功~"];
        [self TeamTopRefresh];
    }else if ([dict[@"code"] intValue] == 50){
        [SVProgressHUD showSuccessWithStatus:@"已经是您的好友~"];
        [self TeamTopRefresh];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"关注失败~"];
    }
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }else if (section == 1){
        return 2;
    }else{
        return mushaArray.count;
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
        searchTxt.returnKeyType = UIReturnKeySearch;
        searchTxt.delegate = self;
        searchTxt.textColor = [UIColor whiteColor];
        searchTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索用户昵称、手机号" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.44 green:0.43 blue:0.44 alpha:1]}];
        UIImageView *searchIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 20)];
        searchIv.contentMode = UIViewContentModeScaleAspectFit;
        searchIv.image = [UIImage imageNamed:@"search"];
        searchTxt.leftView = searchIv;
        searchTxt.leftViewMode = UITextFieldViewModeAlways;
        [cell addSubview:searchTxt];
        return cell;
    }else if (indexPath.section == 1){
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        cell.backgroundColor = ItemsBaseColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(indexPath.row == 0){
            UILabel *mLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, 100, cell.frame.size.height)];
            mLabel.font = [UIFont systemFontOfSize:20];
            mLabel.textColor = [UIColor whiteColor];
            mLabel.text = @"条件筛选";
            [cell addSubview:mLabel];
        }else{
            //第一行
            //地区
            UILabel *lbl_address = [[UILabel alloc] initWithFrame:CGRectMake(14, (cell.frame.size.height - 25) / 2, 45,30)];
            lbl_address.textColor = [UIColor whiteColor];
            lbl_address.text = @"地区:";
            [cell addSubview:lbl_address];
            
            //省
            UIButton *btnProvince = [[UIButton alloc] initWithFrame:CGRectMake(lbl_address.frame.origin.x + lbl_address.frame.size.width + 5, (cell.frame.size.height - 25) / 2, 80, 30)];
            btnProvince.backgroundColor = [UIColor colorWithRed:0.24 green:0.24 blue:0.25 alpha:1];
            [btnProvince setTitle:provinceTxt forState:UIControlStateNormal];
            [cell addSubview:btnProvince];
            UIImageView *provinceIv = [[UIImageView alloc] initWithFrame:CGRectMake(btnProvince.frame.origin.x + btnProvince.frame.size.width - 11, btnProvince.frame.origin.y + btnProvince.frame.size.height - 11, 10, 10)];
            provinceIv.image = [UIImage imageNamed:@"btnCorner"];
            [cell addSubview:provinceIv];
            //市
            UIButton *btnCity = [[UIButton alloc] initWithFrame:CGRectMake(btnProvince.frame.origin.x + btnProvince.frame.size.width + 5, (cell.frame.size.height - 25) / 2, 80, 30)];
            btnCity.backgroundColor = [UIColor colorWithRed:0.24 green:0.24 blue:0.25 alpha:1];
            [btnCity setTitle:cityTxt forState:UIControlStateNormal];
            [cell addSubview:btnCity];
            UIImageView *cityIv = [[UIImageView alloc] initWithFrame:CGRectMake(btnCity.frame.origin.x + btnCity.frame.size.width - 11, btnCity.frame.origin.y + btnCity.frame.size.height - 11, 10, 10)];
            cityIv.image = [UIImage imageNamed:@"btnCorner"];
            [cell addSubview:cityIv];
            //县
            UIButton *btnCountry = [[UIButton alloc] initWithFrame:CGRectMake(btnCity.frame.origin.x + btnCity.frame.size.width + 5, (cell.frame.size.height - 25) / 2, 80, 30)];
            btnCountry.backgroundColor = [UIColor colorWithRed:0.24 green:0.24 blue:0.25 alpha:1];
            [btnCountry setTitle:countryTxt forState:UIControlStateNormal];
            [cell addSubview:btnCountry];
            UIImageView *countryIv = [[UIImageView alloc] initWithFrame:CGRectMake(btnCountry.frame.origin.x + btnCountry.frame.size.width - 11, btnCountry.frame.origin.y + btnCountry.frame.size.height - 11, 10, 10)];
            countryIv.image = [UIImage imageNamed:@"btnCorner"];
            [cell addSubview:countryIv];
            
            UIButton *tempBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, (cell.frame.size.height - 25) / 2, SCREEN_WIDTH, 30)];
            [tempBtn addTarget:self action:@selector(tempBtnEvent) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:tempBtn];
            
            //第二行
            //年龄
            UILabel *age_lbl = [[UILabel alloc] initWithFrame:CGRectMake(14, lbl_address.frame.origin.y + lbl_address.frame.size.height + (cell.frame.size.height - 25) / 2, 45,30)];
            age_lbl.textColor = [UIColor whiteColor];
            age_lbl.text = @"年龄:";
            [cell addSubview:age_lbl];
            btnAge = [[UIButton alloc] initWithFrame:CGRectMake(age_lbl.frame.origin.x + age_lbl.frame.size.width + 5, lbl_address.frame.origin.y + lbl_address.frame.size.height + (cell.frame.size.height - 25) / 2, 80, 30)];
            btnAge.backgroundColor = [UIColor colorWithRed:0.24 green:0.24 blue:0.25 alpha:1];;
            [btnAge setTitle:selectAgeTxt forState:UIControlStateNormal];
            [btnAge addTarget:self action:@selector(selectAgeEvent) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btnAge];
            UIImageView *ageIv = [[UIImageView alloc] initWithFrame:CGRectMake(btnAge.frame.origin.x + btnAge.frame.size.width - 11, btnAge.frame.origin.y + btnAge.frame.size.height - 11, 10, 10)];
            ageIv.image = [UIImage imageNamed:@"btnCorner"];
            [cell addSubview:ageIv];
            
            //第三行
            //性别
            UILabel *sex_lbl = [[UILabel alloc] initWithFrame:CGRectMake(14, age_lbl.frame.origin.y + age_lbl.frame.size.height + (cell.frame.size.height - 25) / 2, 45,30)];
            sex_lbl.textColor = [UIColor whiteColor];
            sex_lbl.text = @"性别:";
            [cell addSubview:sex_lbl];
            btnSex = [[UIButton alloc] initWithFrame:CGRectMake(sex_lbl.frame.origin.x + sex_lbl.frame.size.width + 5, age_lbl.frame.origin.y + age_lbl.frame.size.height + (cell.frame.size.height - 25) / 2, 80, 30)];
            btnSex.backgroundColor = [UIColor colorWithRed:0.24 green:0.24 blue:0.25 alpha:1];;
            [btnSex setTitle:selectSexTxt forState:UIControlStateNormal];
            [btnSex addTarget:self action:@selector(selectSexEvent) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btnSex];
            UIImageView *sexIv = [[UIImageView alloc] initWithFrame:CGRectMake(btnSex.frame.origin.x + btnSex.frame.size.width - 11, btnSex.frame.origin.y + btnSex.frame.size.height - 11, 10, 10)];
            sexIv.image = [UIImage imageNamed:@"btnCorner"];
            [cell addSubview:sexIv];
        }
         return cell;
    }else{
        NSString *CellIdentifier = @"MakeMushaCellIdentifier";
        MakeMushaCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MakeMushaCell" owner:self options:nil] objectAtIndex:0];
            cell.backgroundColor = ItemsBaseColor;
        }
        NSString *PhotoPath = mushaArray[indexPath.row][@"PhotoPath"];
        NSString *url = [NSString stringWithFormat:@"%@%@",Url,PhotoPath];
        UserHeadView *headView = [[UserHeadView alloc] initWithFrame:cell.mImageView.frame andUrl:url andNav:self.navigationController];
        headView.userId = mushaArray[indexPath.row][@"Id"];
        [headView makeSelfRound];
        
        [cell addSubview:headView];
        cell.mName.text = mushaArray[indexPath.row][@"NicName"];//@"李小龙";
//        cell.mLevel.text = [NSString stringWithFormat:@"等级:lv%@",mushaArray[indexPath.row][@"Rank"]];//@"等级:lv1";
        cell.mConcern.backgroundColor = [UIColor colorWithRed:0.51 green:0.51 blue:0.51 alpha:1];
        [cell.mConcern setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        int isFriend = [mushaArray[indexPath.row][@"IsFriend"] intValue];
        if (isFriend == 0) {
            [cell.mConcern setTitle:@"关注" forState:UIControlStateNormal];
            [cell.mConcern setTitleColor:YellowBlock forState:UIControlStateNormal];
            cell.mConcern.tag = [mushaArray[indexPath.row][@"Id"] intValue];
            [cell.mConcern addTarget:self action:@selector(addFriendEvent:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [cell.mConcern setTitle:@"已关注" forState:UIControlStateNormal];
        }
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 45;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            return 40;
        }else{
            return 125;
        }
    }else{
        return mCellHeight;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [mTableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - pickerView delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return provinceArray.count;
    }else if (component == 1){
        return cityArray.count;
    }else{
        return countryArray.count;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return provinceArray[row][@"Name"];
    }else if(component == 1){
        return cityArray[row][@"Name"];
    }else{
        return countryArray[row][@"Name"];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"%ld---%ld",(long)component,(long)row);
    if (component == 0) {
        provinceTxt = provinceArray[row][@"Name"];
        provinceCode = provinceArray[row][@"Code"];
        dataProvider = [[DataProvider alloc] init];
        [SVProgressHUD showWithStatus:@""];
        [dataProvider setDelegateObject:self setBackFunctionName:@"getCityCallBack:"];
        [dataProvider getCityByProvinceCode:provinceCode];
    }else if(component == 1){
        cityId = cityArray[row][@"Id"];
        cityTxt = cityArray[row][@"Name"];
        cityCode = cityArray[row][@"Code"];
        dataProvider = [[DataProvider alloc] init];
        [SVProgressHUD showWithStatus:@""];
        [dataProvider setDelegateObject:self setBackFunctionName:@"getCountryCallBack:"];
        [dataProvider getCountryByCityCode:cityCode];
    }else{
        countryId = countryArray[row][@"Id"];
        countryCode = countryArray[row][@"Code"];
        countryTxt = countryArray[row][@"Name"];
    }
}

#pragma mark - UIActionSheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1) {
        if(buttonIndex == 0){
            selectAgeTxt = @"--全部--";
            selectAge = 0;
            [self TeamTopRefresh];
        }else if (buttonIndex == 1) {
            selectAgeTxt = @"18岁以下";
            selectAge = 1;
            [self TeamTopRefresh];
        }else if (buttonIndex == 2){
            selectAgeTxt = @"18-22岁";
            selectAge = 2;
            [self TeamTopRefresh];
        }else if (buttonIndex == 3){
            selectAgeTxt = @"23-26岁";
            selectAge = 3;
            [self TeamTopRefresh];
        }else if (buttonIndex == 4){
            selectAgeTxt = @"27-35岁";
            selectAge = 4;
            [self TeamTopRefresh];
        }else if (buttonIndex == 5){
            selectAgeTxt = @"35岁以上";
            selectAge = 5;
            [self TeamTopRefresh];
        }
    }else{
        if(buttonIndex == 0){
            selectSexTxt = @"--全部--";
            selectSex = 0;
            [self TeamTopRefresh];
        }else if (buttonIndex == 1) {
            selectSexTxt = @"男";
            selectSex = 1;
            [self TeamTopRefresh];
        }else if (buttonIndex == 2){
            selectSexTxt = @"女";
            selectSex = 2;
            [self TeamTopRefresh];
        }
    }
}

#pragma mark - textfield delegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    provinceCode = @"0";
    cityCode = @"0";
    countryCode = @"0";
    selectAge = 0;
    selectSex = 0;
    [self TeamTopRefresh];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [searchTxt resignFirstResponder];
    return YES;
}

@end
