//
//  ReceiveAddressViewController.m
//  KongFuCenter
//
//  Created by Rain on 16/1/31.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "ReceiveAddressViewController.h"
#import "ReceiveAddressTableViewCell.h"
#import "MJRefresh.h"
#import "AddressManageViewController.h"

@interface ReceiveAddressViewController (){
    UITableView *mTableView;
    DataProvider *dataProvider;
    NSArray *receiveArray;
    NSUserDefaults *mUserDefault;
}

@end

@implementation ReceiveAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化参数
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self setBarTitle:@"地址管理"];
    [self addLeftButton:@"left"];
    
    dataProvider = [[DataProvider alloc] init];
    receiveArray =[[NSArray alloc] init];
    mUserDefault = [NSUserDefaults standardUserDefaults];
    [mUserDefault setValue:@"0" forKey:@"UpdateAddressFlag"];
    
    //初始化View
    [self initViews];
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
    if ([[mUserDefault valueForKey:@"UpdateAddressFlag"] isEqual:@"1"]) {
        [mUserDefault setValue:@"0" forKey:@"UpdateAddressFlag"];
        [mTableView.mj_header beginRefreshing];
    }
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
    [addReceiveAddressBtn setTitle:@"新增收货地址" forState:UIControlStateNormal];
    addReceiveAddressBtn.backgroundColor = YellowBlock;
    [addReceiveAddressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addReceiveAddressBtn addTarget:self action:@selector(addReceiveAddressCallBack:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:addReceiveAddressBtn];
    
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    __weak typeof(UITableView *) weakTv = mTableView;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    
    mTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf initData];
        [weakTv.mj_header endRefreshing];
    }];
    // 马上进入刷新状态
    [mTableView.mj_header beginRefreshing];
}

-(void)initData{
    [dataProvider setDelegateObject:self setBackFunctionName:@"receiveAddressCallBack:"];
    [dataProvider SelectAllDeliveryAddress:get_sp(@"id")];
}

-(void)receiveAddressCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        receiveArray = dict[@"data"];
        [mTableView reloadData];
    }
}

-(void)addReceiveAddressCallBack:(UIButton *)btn{
    AddressManageViewController *addressManageVC = [[AddressManageViewController alloc] init];
    [addressManageVC setAddressManage:Mode_Add];
    [self.navigationController pushViewController:addressManageVC animated:YES];
}

-(void)editAddressEvent:(UIButton *)btn{
    AddressManageViewController *addressManageVC = [[AddressManageViewController alloc] init];
    [addressManageVC setAddressManage:Mode_Edit];
    addressManageVC.addressId = [receiveArray[btn.tag] valueForKey:@"Id"];
    addressManageVC.receiveName = [receiveArray[btn.tag] valueForKey:@"ReceiverName"];
    addressManageVC.phone = [receiveArray[btn.tag] valueForKey:@"Phone"];
    addressManageVC.areaId = [receiveArray[btn.tag] valueForKey:@"AreaId"];
    addressManageVC.area = [receiveArray[btn.tag] valueForKey:@"Area"];
    addressManageVC.address = [receiveArray[btn.tag] valueForKey:@"Address"];
    addressManageVC.code = [receiveArray[btn.tag] valueForKey:@"Code"];
    [self.navigationController pushViewController:addressManageVC animated:YES];
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return receiveArray.count;
}

#pragma mark setting for section

#pragma mark setting for cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ReceiveAddressCellIdentifier";
    ReceiveAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ReceiveAddressTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.backgroundColor = ItemsBaseColor;
    }
    cell.mNameLbl.text = [Toolkit judgeIsNull:[receiveArray[indexPath.row] valueForKey:@"ReceiverName"]];
    cell.mPhoneLbl.text = [Toolkit judgeIsNull:[receiveArray[indexPath.row] valueForKey:@"Phone"]];
    cell.mAddressLbl.text = [NSString stringWithFormat:@"%@%@",[[Toolkit judgeIsNull:[receiveArray[indexPath.row] valueForKey:@"Area"]] stringByReplacingOccurrencesOfString:@"/" withString:@""],[Toolkit judgeIsNull:[receiveArray[indexPath.row] valueForKey:@"Address"]]];
    cell.mEditAddressBtn.tag = indexPath.row;
    [cell.mEditAddressBtn addTarget:self action:@selector(editAddressEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0)
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
        [cell setPreservesSuperviewLayoutMargins:false];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [mTableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [SVProgressHUD showWithStatus:@"删除中..." maskType:SVProgressHUDMaskTypeBlack];
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"delAddressBackCall:"];
        [dataprovider DeleteDeliveryAddress:[receiveArray[indexPath.row] valueForKey:@"Id"] anduserId:get_sp(@"id")];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }
}

-(void)delAddressBackCall:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        [SVProgressHUD showSuccessWithStatus:@"删除成功~" maskType:SVProgressHUDMaskTypeBlack];
        [mTableView.mj_header beginRefreshing];
    }else{
        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"data"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

@end
