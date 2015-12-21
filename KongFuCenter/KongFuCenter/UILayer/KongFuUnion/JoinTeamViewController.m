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
    UIPickerView *addressPickView;
    UIView * BackView;
    NSString *provinceCode;
    NSString *provinceTxt;
    NSString *cityCode;
    NSString *cityTxt;
    NSString *countryCode;
    NSString *countryTxt;
    
    //标识变量
    int curpage;//页数
    
    //数据
    NSArray *teamArray;
    NSArray *provinceArray;
    NSArray *cityArray;
    NSMutableArray *countryArray;
    
    //通用
    NSUserDefaults *userDefault;
    DataProvider *dataProvider;
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
    provinceArray = [[NSArray alloc] init];
    cityArray = [[NSArray alloc] init];
    NSDictionary *itemDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"-1",@"Code",@"-全部-",@"Name", nil];
    countryArray = [[NSMutableArray alloc] init];
    [countryArray addObject:itemDict];
    
    NSString *HomeCode = [userDefault valueForKey:@"HomeCode"];
    NSArray *HomeCodeArray = [HomeCode componentsSeparatedByString:@"&"];
    
    provinceCode = HomeCodeArray[0];//@"37";
    provinceTxt = [userDefault valueForKey:@"HomeAreaprovinceName"];//@"山东省";
    cityCode = HomeCodeArray[1];//@"3713";
    cityTxt = [userDefault valueForKey:@"HomeAreaCityName"];//@"临沂市";
    countryCode = HomeCodeArray[2];//@"371302";
    countryTxt = [userDefault valueForKey:@"HomeAreaCountyName"];//@"兰山区";
    
    //初始化数据
    [self initAddressData];
    
    //初始化View
    [self initViews];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

#pragma mark 自定义方法
-(void)initAddressData{
    dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getInitProvinceCallBack:"];
    [dataProvider getProvince];
}

-(void)getInitProvinceCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        provinceArray = dict[@"data"];
        dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"getInitCityCallBack:"];
        [dataProvider getCityByProvinceCode:[NSString stringWithFormat:@"%@",provinceCode]];
    }
}

-(void)getInitCityCallBack:(id)dict{
    NSLog(@"%@",dict);
    cityArray = [[NSArray alloc] init];
    NSDictionary *itemDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"-1",@"Code",@"-全部-",@"Name", nil];
    countryArray = [[NSMutableArray alloc] init];
    [countryArray addObject:itemDict];
    if ([dict[@"code"] intValue] == 200) {
        cityArray = dict[@"data"];
        if (cityArray.count > 0) {
            dataProvider = [[DataProvider alloc] init];
            [dataProvider setDelegateObject:self setBackFunctionName:@"getInitCountryCallBack:"];
            [dataProvider getCountryByCityCode:cityCode];
        }
    }
    NSLog(@"%@",cityArray);
    
}

-(void)getInitCountryCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        NSLog(@"%@",dict[@"data"]);
        NSArray *itemArray = dict[@"data"];
        for (int i = 0; i < itemArray.count; i++) {
            [countryArray addObject:itemArray[i]];
        }
        [addressPickView selectRow:[[provinceArray valueForKey:@"Code"] indexOfObject:provinceCode] inComponent:0 animated:YES];
        [addressPickView selectRow:[[cityArray valueForKey:@"Code"] indexOfObject:cityCode] inComponent:1 animated:YES];
        [addressPickView selectRow:[[countryArray valueForKey:@"Code"] indexOfObject:countryCode] inComponent:2 animated:YES];
        [addressPickView reloadAllComponents];
    }
}

-(void)getCityCallBack:(id)dict{
    NSLog(@"%@",dict);
    cityArray = [[NSArray alloc] init];
    NSDictionary *itemDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"-1",@"Code",@"-全部-",@"Name", nil];
    countryArray = [[NSMutableArray alloc] init];
    [countryArray addObject:itemDict];
    if ([dict[@"code"] intValue] == 200) {
        cityArray = dict[@"data"];
        if (cityArray.count > 0) {
            NSString *cityCodeStr = cityArray[0][@"Code"];
            cityCode = cityCodeStr;
            dataProvider = [[DataProvider alloc] init];
            [dataProvider setDelegateObject:self setBackFunctionName:@"getCountryCallBack:"];
            [dataProvider getCountryByCityCode:cityCodeStr];

            cityTxt = cityArray[0][@"Name"];
        }
        [addressPickView selectRow:0 inComponent:1 animated:YES];
        [addressPickView reloadComponent:1];
        [addressPickView reloadComponent:2];
    }
}

-(void)getCountryCallBack:(id)dict{
    NSDictionary *itemDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"-1",@"Code",@"-全部-",@"Name", nil];
    countryArray = [[NSMutableArray alloc] init];
    [countryArray addObject:itemDict];
    if ([dict[@"code"] intValue] == 200) {
        NSLog(@"%@",dict[@"data"]);
        NSArray *itemArray = dict[@"data"];
        for (int i = 0; i < itemArray.count; i++) {
            [countryArray addObject:itemArray[i]];
        }
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

-(void)TeamTopRefresh
{
    curpage=0;
    dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"GetTeamListBackCall:"];
    [dataProvider SelectTeamPage:[NSString stringWithFormat:@"%d",curpage * 10] andMaximumRows:@"10" andName:searchTxt.text andAreaid:[countryCode isEqual:@"-1"]?cityCode:countryCode];
}

-(void)TeamFootRefresh
{
    curpage++;
    dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"FootRefireshBackCall:"];
    [dataProvider SelectTeamPage:[NSString stringWithFormat:@"%d",curpage * 10] andMaximumRows:@"10" andName:searchTxt.text andAreaid:[countryCode isEqual:@"-1"]?cityCode:countryCode];
}

-(void)GetTeamListBackCall:(id)dict
{
    [SVProgressHUD dismiss];
    NSLog(@"店铺列表%@",dict);
    if ([dict[@"code"] intValue] == 200) {
        teamArray=dict[@"data"];
        [mTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
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
    [mTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)joinTeamEvent:(UIButton *)btn{
    NSString *teamId = teamArray[btn.tag][@"Id"];
    NSString *teamName = teamArray[btn.tag][@"Name"];
    dataProvider = [[DataProvider alloc] init];
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
    
    [self TeamTopRefresh];
}

-(void)tempBtnEvent{
    [self.view addSubview:BackView];
    [self.view addSubview:addressPickView];
    
    [searchTxt resignFirstResponder];
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
        searchTxt.delegate = self;
        searchTxt.returnKeyType = UIReturnKeySearch;
        searchTxt.textColor = [UIColor whiteColor];
        searchTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索战队昵称" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.44 green:0.43 blue:0.44 alpha:1]}];
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
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = ItemsBaseColor;
            //地区
            UILabel *addressLbl = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, 50, cell.frame.size.height)];
            addressLbl.textColor = [UIColor whiteColor];
            addressLbl.text = @"地区:";
            [cell addSubview:addressLbl];
            //省
            UIButton *btnProvince = [[UIButton alloc] initWithFrame:CGRectMake(addressLbl.frame.origin.x + addressLbl.frame.size.width, (cell.frame.size.height - 25) / 2, 60, 25)];
            btnProvince.backgroundColor = [UIColor colorWithRed:0.51 green:0.51 blue:0.51 alpha:1];
            [btnProvince setTitle:provinceTxt forState:UIControlStateNormal];
            [cell addSubview:btnProvince];
            UIImageView *provinceIv = [[UIImageView alloc] initWithFrame:CGRectMake(btnProvince.frame.origin.x + btnProvince.frame.size.width + 8, 0, 10, cell.frame.size.height)];
            provinceIv.contentMode = UIViewContentModeScaleAspectFit;
            provinceIv.image = [UIImage imageNamed:@"down_icon"];
            [cell addSubview:provinceIv];
            //市
            UIButton *btnCity = [[UIButton alloc] initWithFrame:CGRectMake(btnProvince.frame.origin.x + btnProvince.frame.size.width + 25, (cell.frame.size.height - 25) / 2, 60, 25)];
            btnCity.backgroundColor = [UIColor colorWithRed:0.51 green:0.51 blue:0.51 alpha:1];
            [btnCity setTitle:cityTxt forState:UIControlStateNormal];
            [cell addSubview:btnCity];
            UIImageView *cityIv = [[UIImageView alloc] initWithFrame:CGRectMake(btnCity.frame.origin.x + btnCity.frame.size.width + 8, 0, 10, cell.frame.size.height)];
            cityIv.contentMode = UIViewContentModeScaleAspectFit;
            cityIv.image = [UIImage imageNamed:@"down_icon"];
            [cell addSubview:cityIv];
            //县
            UIButton *btnCountry = [[UIButton alloc] initWithFrame:CGRectMake(btnCity.frame.origin.x + btnCity.frame.size.width + 25, (cell.frame.size.height - 25) / 2, 60, 25)];
            btnCountry.backgroundColor = [UIColor colorWithRed:0.51 green:0.51 blue:0.51 alpha:1];
            [btnCountry setTitle:countryTxt forState:UIControlStateNormal];
            [cell addSubview:btnCountry];
            UIImageView *countryIv = [[UIImageView alloc] initWithFrame:CGRectMake(btnCountry.frame.origin.x + btnCountry.frame.size.width + 8, 0, 10, cell.frame.size.height)];
            countryIv.contentMode = UIViewContentModeScaleAspectFit;
            countryIv.image = [UIImage imageNamed:@"down_icon"];
            [cell addSubview:countryIv];

            UIButton *tempBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, cell.frame.size.height)];
            [tempBtn addTarget:self action:@selector(tempBtnEvent) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:tempBtn];
            
            return cell;
        }else{
            NSString *CellIdentifier = @"JoinTeamCellIdentifier";
            JoinTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"JoinTeamCell" owner:self options:nil] objectAtIndex:0];
                cell.backgroundColor = ItemsBaseColor;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            NSLog(@"%@",teamArray);
            cell.mImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Url,teamArray[indexPath.row - 1][@"ImagePath"]]]]];//[UIImage imageNamed:@"jointeam"];
            cell.mName.text = teamArray[indexPath.row - 1][@"Name"];//@"跆拳道战队(123456789)";
            cell.mAddress.text = teamArray[indexPath.row - 1][@"Address"];
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
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self TeamTopRefresh];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [searchTxt resignFirstResponder];
    return YES;
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
        NSString *provinceCodeStr = provinceArray[row][@"Code"];
        dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"getCityCallBack:"];
        [dataProvider getCityByProvinceCode:provinceCodeStr];
    }else if(component == 1){
        cityCode = cityArray[row][@"Code"];
        cityTxt = cityArray[row][@"Name"];
        NSString *cityCodeStr = cityArray[row][@"Code"];
        dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"getCountryCallBack:"];
        [dataProvider getCountryByCityCode:cityCodeStr];
    }else{
        countryCode = countryArray[row][@"Code"];
        countryTxt = countryArray[row][@"Name"];
    }
}

@end
