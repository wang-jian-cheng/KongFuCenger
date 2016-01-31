//
//  AddressManageViewController.m
//  KongFuCenter
//
//  Created by Rain on 16/1/31.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "AddressManageViewController.h"

@interface AddressManageViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    UITableView *mTableView;
    NSUserDefaults *mUserDefault;
    UITextField *mNameTxt;
    UITextField *mPhoneTxt;
    UITextField *mAddressTxt;
    UITextField *mAddressDetailTxt;
    UITextField *mPostCodeTxt;
    DataProvider *dataProvider;
    UIPickerView *addressPickView;
    UIView *BackView;
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
    NSString *addressStr;
    NSString *selectAddressId;
}

@end

@implementation AddressManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化参数
    self.view.backgroundColor = BACKGROUND_COLOR;
    if (_addressManage == Mode_Add) {
        [self setBarTitle:@"新增地址"];
    }else{
        [self setBarTitle:@"修改地址"];
    }
    [self addLeftButton:@"left"];
    
    dataProvider = [[DataProvider alloc] init];
    mUserDefault = [NSUserDefaults standardUserDefaults];
    provinceArray = [[NSMutableArray alloc] init];
    cityArray = [[NSMutableArray alloc] init];
    countryArray = [[NSMutableArray alloc] init];
    
    provinceId = @"-1";
    cityId = @"-1";
    countryId = @"-1";
    
    //初始化View
    [self initViews];
    
    //初始化省市县数据
    [self initAddressData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [mNameTxt resignFirstResponder];
    [mPhoneTxt resignFirstResponder];
    [mAddressDetailTxt resignFirstResponder];
    [mPostCodeTxt resignFirstResponder];
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
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 60)];
    mTableView.tableFooterView = footerView;
    UIButton *addReceiveAddressBtn = [[UIButton alloc] initWithFrame:CGRectMake(14, 20, footerView.frame.size.width - 28, 40)];
    if(_addressManage == Mode_Add){
        [addReceiveAddressBtn setTitle:@"新增收货地址" forState:UIControlStateNormal];
    }else{
        [addReceiveAddressBtn setTitle:@"修改收货地址" forState:UIControlStateNormal];
    }
    addReceiveAddressBtn.backgroundColor = YellowBlock;
    [addReceiveAddressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addReceiveAddressBtn addTarget:self action:@selector(addReceiveAddressEvent) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:addReceiveAddressBtn];
    
    addressPickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 200, SCREEN_WIDTH, 200)];
    addressPickView.delegate = self;
    addressPickView.dataSource = self;
    addressPickView.backgroundColor = [UIColor grayColor];
    
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
}

-(void)initAddressData{
    if (_addressManage == Mode_Add) {
        addressStr = @"";
    }else{
        addressStr = [_area stringByReplacingOccurrencesOfString:@"/" withString:@""];
        selectAddressId = _areaId;
        NSArray *areaArray = [_area componentsSeparatedByString:@"/"];
        @try {
            provinceTxt = areaArray[0];
            cityTxt = areaArray[1];
            countryTxt = areaArray[2];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getInitProvinceCallBack:"];
    [dataProvider getProvince];
}

-(void)getInitProvinceCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        NSArray *itemArray = dict[@"data"];
        for (int i = 0; i < itemArray.count; i++) {
            [provinceArray addObject:itemArray[i]];
        }
        NSInteger mIndex;
        if (_addressManage == Mode_Add) {
            mIndex = 0;
        }else{
            mIndex = [[provinceArray valueForKey:@"Name"] indexOfObject:provinceTxt];
        }
        provinceId = [provinceArray[mIndex] valueForKey:@"Id"];
        provinceCode = [provinceArray[mIndex] valueForKey:@"Code"];
        provinceTxt = [provinceArray[mIndex] valueForKey:@"Name"];
        
        dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"getInitCityCallBack:"];
        [dataProvider getCityByProvinceCode:[NSString stringWithFormat:@"%@",provinceCode]];
    }
}

-(void)getInitCityCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        NSArray *itemArray = dict[@"data"];
        for (int i = 0; i < itemArray.count; i++) {
            [cityArray addObject:itemArray[i]];
        }
        NSInteger mIndex;
        if (_addressManage == Mode_Add) {
            mIndex = 0;
        }else{
            mIndex = [[cityArray valueForKey:@"Name"] indexOfObject:cityTxt];
        }
        cityId = [cityArray[mIndex] valueForKey:@"Id"];
        cityCode = [cityArray[mIndex] valueForKey:@"Code"];
        cityTxt = [cityArray[mIndex] valueForKey:@"Name"];

        dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"getInitCountryCallBack:"];
        [dataProvider getCountryByCityCode:cityCode];
    }
}

-(void)getInitCountryCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        NSArray *itemArray = dict[@"data"];
        for (int i = 0; i < itemArray.count; i++) {
            [countryArray addObject:itemArray[i]];
        }
        NSInteger mIndex;
        if (_addressManage == Mode_Add) {
            mIndex = 0;
        }else{
            mIndex = [[countryArray valueForKey:@"Name"] indexOfObject:countryTxt];
        }
        countryId = [countryArray[mIndex] valueForKey:@"Id"];
        countryCode = [countryArray[mIndex] valueForKey:@"Code"];
        countryTxt = [countryArray[mIndex] valueForKey:@"Name"];
        
        [addressPickView selectRow:[[provinceArray valueForKey:@"Name"] indexOfObject:provinceTxt] inComponent:0 animated:YES];
        [addressPickView selectRow:[[cityArray valueForKey:@"Name"] indexOfObject:cityTxt] inComponent:1 animated:YES];
        [addressPickView selectRow:[[countryArray valueForKey:@"Name"] indexOfObject:countryTxt] inComponent:2 animated:YES];
        [addressPickView reloadAllComponents];
    }
}

-(void)getCityCallBack:(id)dict{
    [SVProgressHUD dismiss];
    if ([dict[@"code"] intValue] == 200) {
        cityArray = [[NSMutableArray alloc] init];
        countryArray = [[NSMutableArray alloc] init];
        NSArray *itemArray = dict[@"data"];
        for (int i = 0; i < itemArray.count; i++) {
            [cityArray addObject:itemArray[i]];
        }
        if (cityArray.count > 0) {
            cityId = cityArray[0][@"Id"];
            cityCode = cityArray[0][@"Code"];
            cityTxt = cityArray[0][@"Name"];
            dataProvider = [[DataProvider alloc] init];
            [dataProvider setDelegateObject:self setBackFunctionName:@"getCountryCallBack:"];
            [dataProvider getCountryByCityCode:cityCode];
        }else{
            [addressPickView reloadAllComponents];
        }
    }
}

-(void)getCountryCallBack:(id)dict{
    [SVProgressHUD dismiss];
    if ([dict[@"code"] intValue] == 200) {
        countryArray = [[NSMutableArray alloc] init];
        NSArray *itemArray = dict[@"data"];
        for (int i = 0; i < itemArray.count; i++) {
            [countryArray addObject:itemArray[i]];
        }
        countryId = countryArray[0][@"Id"];
        countryCode = countryArray[0][@"Code"];
        countryTxt = countryArray[0][@"Name"];
        [addressPickView reloadAllComponents];
    }
}

-(void)addReceiveAddressEvent{
    if (selectAddressId == nil || [selectAddressId isEqual:@""] || [mAddressDetailTxt.text isEqual:@""] || [mNameTxt.text isEqual:@""] || [mPhoneTxt.text isEqual:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先完善信息" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alertView show];
    }else{
        [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
        [dataProvider setDelegateObject:self setBackFunctionName:@"addReceiveAddressCallBack:"];
        [dataProvider EditDeliveryAddress:_addressManage == Mode_Add?@"0":_addressId andareaId:selectAddressId andaddress:mAddressDetailTxt.text andisDefaul:@"0" anduserId:get_sp(@"id") andreceiverName:mNameTxt.text andphone:mPhoneTxt.text andcodeForAddress:mPostCodeTxt.text];
    }
}

-(void)addReceiveAddressCallBack:(id)dict{
    [SVProgressHUD dismiss];
    if([dict[@"code"] intValue] == 200){
        [SVProgressHUD showSuccessWithStatus:@"添加成功~" maskType:SVProgressHUDMaskTypeBlack];
        [mUserDefault setValue:@"1" forKey:@"UpdateAddressFlag"];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"data"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alertView show];
    }
}

-(void)addressBtnEvent{
    [mNameTxt resignFirstResponder];
    [mPhoneTxt resignFirstResponder];
    [mAddressDetailTxt resignFirstResponder];
    [mPostCodeTxt resignFirstResponder];
    
    [self.view addSubview:BackView];
    [self.view addSubview:addressPickView];
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
    if (!provinceTxt) {
        provinceId = [provinceArray[0] valueForKey:@"Id"];
        provinceTxt = [provinceArray[0] valueForKey:@"Name"];
    }
    if (!cityTxt) {
        cityId = [cityArray[0] valueForKey:@"Id"];
        cityTxt = [cityArray[0] valueForKey:@"Name"];
    }
    if (!countryTxt) {
        countryId = [countryArray[0] valueForKey:@"Id"];
        countryTxt = [countryArray[0] valueForKey:@"Name"];
    }
    if (![countryId isEqual:@"-1"]) {
        selectAddressId = countryId;
    }else if (![cityId isEqual:@"-1"]){
        selectAddressId = cityId;
    }else{
        selectAddressId = provinceId;
    }
    addressStr = [NSString stringWithFormat:@"%@%@%@",provinceTxt,cityTxt,countryTxt];
    
    [mTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 4;
    }
}

#pragma mark setting for section

#pragma mark setting for cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = ItemsBaseColor;
    }else{
        for (UIView *view in cell.subviews) {
            [view removeFromSuperview];
        }
    }
    if (indexPath.section == 0) {
        mNameTxt = [[UITextField alloc] initWithFrame:CGRectMake(14, 0, SCREEN_WIDTH - 28, cell.frame.size.height)];
        mNameTxt.textColor = [UIColor whiteColor];
        mNameTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"你的姓名" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
        mNameTxt.text = _receiveName;
        UILabel *mNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 21)];
        mNameLbl.textColor = [UIColor whiteColor];
        mNameLbl.textAlignment = NSTextAlignmentLeft;
        mNameLbl.font = [UIFont systemFontOfSize:16];
        mNameLbl.text = @"收货人:";
        mNameTxt.leftView = mNameLbl;
        mNameTxt.leftViewMode = UITextFieldViewModeAlways;
        [cell addSubview:mNameTxt];
    }else{
        if (indexPath.row == 0) {
            mPhoneTxt = [[UITextField alloc] initWithFrame:CGRectMake(14, 0, SCREEN_WIDTH - 28, cell.frame.size.height)];
            mPhoneTxt.textColor = [UIColor whiteColor];
            mPhoneTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"你的手机号" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
            mPhoneTxt.keyboardType = UIKeyboardTypePhonePad;
            mPhoneTxt.text = _phone;
            UILabel *mPhoneLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 21)];
            mPhoneLbl.textColor = [UIColor whiteColor];
            mPhoneLbl.textAlignment = NSTextAlignmentLeft;
            mPhoneLbl.font = [UIFont systemFontOfSize:16];
            mPhoneLbl.text = @"联系电话:";
            mPhoneTxt.leftView = mPhoneLbl;
            mPhoneTxt.leftViewMode = UITextFieldViewModeAlways;
            [cell addSubview:mPhoneTxt];
        }else if (indexPath.row == 1){
            mAddressTxt = [[UITextField alloc] initWithFrame:CGRectMake(14, 0, SCREEN_WIDTH - 28, cell.frame.size.height)];
            mAddressTxt.textColor = [UIColor whiteColor];
            mAddressTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请选择省/市/区(县)" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
            mAddressTxt.text = [addressStr isEqual:@""]?@"":addressStr;
            UILabel *mAddressLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 21)];
            mAddressLbl.textColor = [UIColor whiteColor];
            mAddressLbl.textAlignment = NSTextAlignmentLeft;
            mAddressLbl.font = [UIFont systemFontOfSize:16];
            mAddressLbl.text = @"省/市/区(县):";
            mAddressTxt.leftView = mAddressLbl;
            mAddressTxt.leftViewMode = UITextFieldViewModeAlways;
            [cell addSubview:mAddressTxt];
            UIButton *mAddressBtn = [[UIButton alloc] initWithFrame:mAddressTxt.frame];
            [mAddressBtn addTarget:self action:@selector(addressBtnEvent) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:mAddressBtn];
        }else if(indexPath.row == 2){
            mAddressDetailTxt = [[UITextField alloc] initWithFrame:CGRectMake(14, 0, SCREEN_WIDTH - 28, cell.frame.size.height)];
            mAddressDetailTxt.textColor = [UIColor whiteColor];
            mAddressDetailTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"详细地址(如门牌号)" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
            mAddressDetailTxt.text = _address;
            UILabel *mAddressDetailLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 21)];
            mAddressDetailLbl.textColor = [UIColor whiteColor];
            mAddressDetailLbl.textAlignment = NSTextAlignmentLeft;
            mAddressDetailLbl.font = [UIFont systemFontOfSize:16];
            mAddressDetailLbl.text = @"详细地址:";
            mAddressDetailTxt.leftView = mAddressDetailLbl;
            mAddressDetailTxt.leftViewMode = UITextFieldViewModeAlways;
            [cell addSubview:mAddressDetailTxt];
        }else{
            mPostCodeTxt = [[UITextField alloc] initWithFrame:CGRectMake(14, 0, SCREEN_WIDTH - 28, cell.frame.size.height)];
            mPostCodeTxt.keyboardType = UIKeyboardTypeNumberPad;
            mPostCodeTxt.textColor = [UIColor whiteColor];
            mPostCodeTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入邮编" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
            mPostCodeTxt.text = _code;
            UILabel *mPostCodeLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 21)];
            mPostCodeLbl.textColor = [UIColor whiteColor];
            mPostCodeLbl.textAlignment = NSTextAlignmentLeft;
            mPostCodeLbl.font = [UIFont systemFontOfSize:16];
            mPostCodeLbl.text = @"邮编号码:";
            mPostCodeTxt.leftView = mPostCodeLbl;
            mPostCodeTxt.leftViewMode = UITextFieldViewModeAlways;
            [cell addSubview:mPostCodeTxt];
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
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
    provinceId = @"-1";
    cityId = @"-1";
    countryId = @"-1";
    if (component == 0) {
        provinceId = provinceArray[row][@"Id"];
        provinceCode = provinceArray[row][@"Code"];
        provinceTxt = provinceArray[row][@"Name"];
        dataProvider = [[DataProvider alloc] init];
        [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
        [dataProvider setDelegateObject:self setBackFunctionName:@"getCityCallBack:"];
        [dataProvider getCityByProvinceCode:provinceCode];
    }else if(component == 1){
        cityId = cityArray[row][@"Id"];
        cityTxt = cityArray[row][@"Name"];
        cityCode = cityArray[row][@"Code"];
        dataProvider = [[DataProvider alloc] init];
        [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
        [dataProvider setDelegateObject:self setBackFunctionName:@"getCountryCallBack:"];
        [dataProvider getCountryByCityCode:cityCode];
    }else{
        countryId = countryArray[row][@"Id"];
        countryCode = countryArray[row][@"Code"];
        countryTxt = countryArray[row][@"Name"];
    }
}

@end
