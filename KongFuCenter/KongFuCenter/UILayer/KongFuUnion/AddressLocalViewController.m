//
//  AddressLocalViewController.m
//  HiHome
//
//  Created by 于金祥 on 15/10/17.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "AddressLocalViewController.h"
#import "AddressLocalCell.h"
#import "AppDelegate.h"
#import "CommonDef.h"
#import "DataProvider.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"
//#import "UMSocial.h"
//#import "UMSocialSnsService.h"

@interface AddressLocalViewController (){
    DataProvider *dataProvider;
    NSString *phoneStr;
    NSArray *machAddressArray;
    NSMutableArray *mDictInfo;
    NSString *currentFriendID;
    UITableView *_tableView;
}

@end

@implementation AddressLocalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBarTitle:@"通讯录"];
    [self addLeftButton:@"left"];
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _tableView.backgroundColor = BACKGROUND_COLOR;
    [self.view addSubview:_tableView];
    
    //去除多余的横线
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexColor = [UIColor whiteColor];
    
    [self address];
    NSLog(@"%@",phoneStr);
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    __weak typeof(UITableView *) weakTv = _tableView;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf initData];
        [weakTv.mj_header endRefreshing];
    }];
    
    // 马上进入刷新状态
    [_tableView.mj_header beginRefreshing];
}

-(void)initData{
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeBlack];
    dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"matchAddressBackCall:"];
    [dataProvider ContactsMatch:get_sp(@"id") andcontacts:phoneStr];
}

-(void)matchAddressBackCall:(id)dict{
    [SVProgressHUD dismiss];
    NSLog(@"%@",dict);
    int code = [dict[@"code"] intValue];
    if (code == 200) {
        machAddressArray = dict[@"data"];
        dataSource = [[NSMutableArray alloc] init];
        for (int i = 0; i < mDictInfo.count; i++) {
            NSString *tempPhone = [Toolkit judgeIsNull:[mDictInfo[i] allKeys][0]];
            Model *model = [[Model alloc] init];
            model.name = mDictInfo[i][tempPhone][0];
            model.tel = tempPhone;
            model.photo = mDictInfo[i][tempPhone][1];
            
            model.recordID = -1;
            model.friendID = @"-1";
            for(int j = 0;j < machAddressArray.count; j++){
                if ([tempPhone isEqual:[machAddressArray[j] valueForKey:@"Phone"]]) {
                    model.recordID = [[machAddressArray[j] valueForKey:@"IsFriend"] intValue];
                    model.friendID = [machAddressArray[j] valueForKey:@"Id"];
                    break;
                }
            }
            [dataSource addObject:model];
        }
        [self setUserSource];
    }else{

    }
}

-(NSString *)getUserID
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    NSDictionary *userInfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];//read plist
    NSString *userID = [userInfoWithFile objectForKey:@"id"];//获取userID
    
    return  userID;
}

#pragma mark - 获取通讯录里联系人姓名和手机号
- (void)address
{
    mDictInfo = [[NSMutableArray alloc] init];
    
    //    NSMutableArray *contactsdata= [[NSMutableArray alloc] init];
    //新建一个通讯录类
    ABAddressBookRef addressBooks = nil;
    
    //判断是否在ios6.0版本以上
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0){
        addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
        //获取通讯录权限
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }else{
        CFErrorRef* error=nil;
        addressBooks = ABAddressBookCreateWithOptions(NULL, error);
    }
    
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    //通讯录中人数
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    
    //循环，获取每个人的个人信息
    for (NSInteger i = 0; i < nPeople; i++)
    {
        //新建一个addressBook model类
        Model *addressBook = [[Model alloc] init];
        //获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        //获取个人名字
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        }else {
            if ((__bridge id)abLastName != nil){
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        addressBook.name = nameString;
        //        addressBook.recordID = (int)ABRecordGetRecordID(person);
        
        //获取头像
        NSData *imageData = (__bridge NSData *)(ABPersonCopyImageData(person));
        if (imageData != nil){
            UIImage *image = [UIImage imageWithData:imageData];
            addressBook.photo = image;
        }else{
            addressBook.photo = [UIImage imageNamed:@"me"];
        }
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSString *temtPhone;
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            //获取电话号码和email
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        addressBook.tel = (__bridge NSString*)value;
                        temtPhone = addressBook.tel;
                        if ([temtPhone componentsSeparatedByString:@"-"].count > 1) {
                            temtPhone = [temtPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
                        }
                        if ([temtPhone componentsSeparatedByString:@"+86"].count > 1) {
                            temtPhone = [temtPhone stringByReplacingOccurrencesOfString:@"+86" withString:@""];
                        }
                        
                        if (phoneStr) {
                            phoneStr = [NSString stringWithFormat:@"%@&'%@'",phoneStr,temtPhone];
                        }else{
                            phoneStr = [NSString stringWithFormat:@"'%@'",temtPhone];
                        }
                        NSLog(@"%@",addressBook.tel);
                        break;
                    }
                        //                    case 1: {// Email
                        //                        addressBook.email = (__bridge NSString*)value;
                        //                        break;
                        //                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        //将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
        //[dataSource addObject:addressBook];
        
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
        
        if (temtPhone != nil) {
            NSMutableDictionary *mtempDict = [[NSMutableDictionary alloc] init];
            [mtempDict setValue:[NSArray arrayWithObjects:addressBook.name,addressBook.photo, nil] forKey:temtPhone];
            [mDictInfo addObject:mtempDict];
        }else{
            
        }
    }
    //[_tableView reloadData];
}
#pragma mark - 索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    //便立构造器
    for (NSDictionary *dic in userSource)
    {
        
        //将取出来的数据封装成NSNumber类型
        NSNumber *num = [[dic allKeys] lastObject];
        //给a开空间，并且强转成char类型
        char *a = (char *)malloc(2);
        //将num里面的数据取出放进a里面
        sprintf(a, "%c", [num charValue]);
        //把c的字符串转换成oc字符串类型
        NSString *str = [[NSString alloc]initWithUTF8String:a];
        [array addObject:str];
    }
    /*
     for (char i='A'; i<'Z'; i++)
     {
     //将取出来的数据封装成NSNumber类型
     NSNumber *num = [NSNumber numberWithChar:i];
     //给a开空间，并且强转成char类型
     char *a = (char *)malloc(2);
     //将num里面的数据取出放进a里面
     sprintf(a, "%c", [num charValue]);
     //把c的字符串转换成oc字符串类型
     NSString *str = [[NSString alloc]initWithUTF8String:a];
     [array addObject:str];
     }
     */
    return array;
}
#pragma mark - 设置section的行数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return userSource.count;
}
#pragma mark - 设置section的头部高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
#pragma mark - 设置section显示的内容
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *dic = [userSource objectAtIndex:section];
    NSNumber *num = [[dic allKeys] lastObject];
    char *a = (char *)malloc(2);
    sprintf(a, "%c", [num charValue]);
    NSString *str = [[NSString alloc] initWithUTF8String:a];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    [btn setTitle:str forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:BACKGROUND_COLOR];
    return btn;
}
#pragma mark - 设置每个section里的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dic = [userSource objectAtIndex:section];
    NSArray *array = [[dic allValues] firstObject];
    return array.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
#pragma mark - 显示每行内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        NSString *CellIdentifier = @"AddressLocalCellIdentifier";
        AddressLocalCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddressLocalCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = ItemsBaseColor;
        }
        
        NSDictionary *dic = [userSource objectAtIndex:indexPath.section];
        NSArray *arr = [[dic allValues] lastObject];
        NSArray *array = [arr objectAtIndex:indexPath.row];
        NSString *name = nil;
        NSString *tel = nil;
        int state = -1;
        if (array.count != 1)
        {
            if ([[array objectAtIndex:0] isEqualToString:@"无"]) {
                tel = [array objectAtIndex:1];
                state = [[array objectAtIndex:2] intValue];
            }
            else
            {
                name = [array objectAtIndex:0];
                tel = [array objectAtIndex:1];
                state = [[array objectAtIndex:2] intValue];
            }
        }
        else
        {
            name = [array lastObject];
            state = [[array objectAtIndex:2] intValue];
        }
        NSLog(@"%@",userSource);
        // cell.iconView.image = [UIImage imageNamed:@"headImg"];
        cell.mImage.image = [array objectAtIndex:4];
        cell.mName.text = name;
        cell.mName.textColor = [UIColor grayColor];
        cell.mHandle.backgroundColor=RGB(26, 200, 133);
        switch (state) {
            case 1:
                [cell.mHandle setTitle:@"已添加" forState:UIControlStateNormal];
                [cell.mHandle setTitleColor:[UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:1] forState:UIControlStateNormal];
                [cell.mHandle setBackgroundColor:[UIColor clearColor]];
                break;
            case 0:
                [cell.mHandle setTitle:@"添加" forState:UIControlStateNormal];
                [cell.mHandle addTarget:self action:@selector(applyAddFriend:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case -1:
                [cell.mHandle setTitle:@"邀请" forState:UIControlStateNormal];
                [cell.mHandle setBackgroundColor:[UIColor colorWithRed:0.92 green:0.33 blue:0.07 alpha:1]];
                [cell.mHandle addTarget:self action:@selector(inviteEvent:) forControlEvents:UIControlEventTouchUpInside];
                break;
                
            default:
                break;
        }
        
        //分割线设置
        if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
        {
            [cell setSeparatorInset:UIEdgeInsetsZero];
            [cell setLayoutMargins:UIEdgeInsetsZero];
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
        return cell;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

//重写退出页面方法
-(void)quitView
{
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0)
    {
        [self popoverPresentationController];
    }
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setleftbtn" object:nil userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:@"hide"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:@"hide"]];
}

-(void)setUserSource{
    userSource = [[NSMutableArray alloc] init];
    for (char i = 'A'; i<='Z'; i++)
    {
        NSMutableArray *numarr = [[NSMutableArray alloc] init];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        for (int j=0; j<dataSource.count; j++)
        {
            Model *model = [dataSource objectAtIndex:j];
            //获取姓名首位
            NSString *string = [model.name substringWithRange:NSMakeRange(0, 1)];
            //将姓名首位转换成NSData类型
            NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
            //data的长度大于等于3说明姓名首位是汉字
            if (data.length >=3)
            {
                //将汉字首字母拿出
                char a = pinyinFirstLetter([model.name characterAtIndex:0]);
                
                //将小写字母转成大写字母
                char b = a-32;
                if (b == i)
                {
                    NSMutableArray *array = [[NSMutableArray alloc] init];
                    [array addObject:model.name];
                    if (model.tel != nil)
                    {
                        [array addObject:model.tel];
                    }
                    [array addObject:[NSString stringWithFormat:@"%d",model.recordID]];
                    [array addObject:model.friendID];
                    [array addObject:model.photo];
                    [numarr addObject:array];
                    [dic setObject:numarr forKey:[NSNumber numberWithChar:i]];
                }
                
            }
            else
            {
                //data的长度等于1说明姓名首位是字母或者数字
                if (data.length == 1)
                {
                    //判断姓名首位是否位小写字母
                    NSString * regex = @"^[a-z]$";
                    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
                    BOOL isMatch = [pred evaluateWithObject:string];
                    if (isMatch == YES)
                    {
                        //NSLog(@"这是小写字母");
                        
                        //把大写字母转换成小写字母
                        char j = i+32;
                        //数据封装成NSNumber类型
                        NSNumber *num = [NSNumber numberWithChar:j];
                        //给a开空间，并且强转成char类型
                        char *a = (char *)malloc(2);
                        //将num里面的数据取出放进a里面
                        sprintf(a, "%c", [num charValue]);
                        //把c的字符串转换成oc字符串类型
                        NSString *str = [[NSString alloc]initWithUTF8String:a];
                        if ([string isEqualToString:str])
                        {
                            NSMutableArray *array = [[NSMutableArray alloc] init];
                            [array addObject:model.name];
                            if (model.tel != nil)
                            {
                                [array addObject:model.tel];
                            }
                            [array addObject:[NSString stringWithFormat:@"%d",model.recordID]];
                            [array addObject:model.friendID];
                            [array addObject:model.photo];
                            [numarr addObject:array];
                            [dic setObject:numarr forKey:[NSNumber numberWithChar:i]];
                        }
                        
                    }
                    else
                    {
                        //判断姓名首位是否为大写字母
                        NSString * regexA = @"^[A-Z]$";
                        NSPredicate *predA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexA];
                        BOOL isMatchA = [predA evaluateWithObject:string];
                        if (isMatchA == YES)
                        {
                            //NSLog(@"这是大写字母");
                            //
                            NSNumber *num = [NSNumber numberWithChar:i];
                            //给a开空间，并且强转成char类型
                            char *a = (char *)malloc(2);
                            //将num里面的数据取出放进a里面
                            sprintf(a, "%c", [num charValue]);
                            //把c的字符串转换成oc字符串类型
                            NSString *str = [[NSString alloc]initWithUTF8String:a];
                            if ([string isEqualToString:str])
                            {
                                
                                NSMutableArray *array = [[NSMutableArray alloc] init];
                                [array addObject:model.name];
                                if (model.tel != nil)
                                {
                                    [array addObject:model.tel];
                                }
                                [array addObject:[NSString stringWithFormat:@"%d",model.recordID]];
                                [array addObject:model.friendID];
                                [array addObject:model.photo];
                                [numarr addObject:array];
                                [dic setObject:numarr forKey:[NSNumber numberWithChar:i]];
                            }
                        }
                    }
                }
            }
        }
        if (dic.count != 0)
        {
            [userSource addObject:dic];
        }
    }
    
    char n = '#';
    int cont = 0;
    for (int j=0; j<dataSource.count; j++)
    {
        Model *model = [dataSource objectAtIndex:j];
        //获取姓名的首位
        NSString *string = [model.name substringWithRange:NSMakeRange(0, 1)];
        //将姓名首位转化成NSData类型
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
        //判断data的长度是否小于3
        if (data.length < 3)
        {
            if (cont == 0)
            {
                dic1 = [[NSMutableDictionary alloc] init];
                numarr1 = [[NSMutableArray alloc] init];
                cont++;
            }
            if (data.length == 1)
            {
                //判断首位是否为数字
                NSString * regexs = @"^[0-9]$";
                NSPredicate *preds = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexs];
                BOOL isMatch = [preds evaluateWithObject:string];
                if (isMatch == YES)
                {
                    //如果姓名为数字
                    NSMutableArray *array = [[NSMutableArray alloc] init];
                    [array addObject:model.name];
                    if (model.tel != nil)
                    {
                        [array addObject:model.tel];
                    }
                    [array addObject:[NSString stringWithFormat:@"%d",model.recordID]];
                    [array addObject:model.friendID];
                    [array addObject:model.photo];
                    [numarr1 addObject:array];
                    [dic1 setObject:numarr1 forKey:[NSNumber numberWithChar:n]];
                }
            }
            else
            {
                //如果姓名为空
                NSMutableArray *array = [[NSMutableArray alloc] init];
                model.name = @"无";
                [array addObject:model.name];
                if (model.tel != nil)
                {
                    [array addObject:model.tel];
                    [array addObject:[NSString stringWithFormat:@"%d",model.recordID]];
                    [array addObject:model.friendID];
                    [array addObject:model.photo];
                    [numarr1 addObject:array];
                    [dic1 setObject:numarr1 forKey:[NSNumber numberWithChar:n]];
                }
            }
        }
    }
    
    if (dic1.count != 0)
    {
        [userSource addObject:dic1];
    }
    
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

-(void)applyAddFriend:(id)sender{
    UIView *v = [sender superview];
    UITableViewCell *cell = (UITableViewCell *)[v superview];
    NSIndexPath *mIndexPath = [_tableView indexPathForCell:cell];
    NSString *firstKey = [userSource[mIndexPath.section] allKeys][0];
    NSString *selectFriendID = [userSource[mIndexPath.section] objectForKey:firstKey][mIndexPath.row][3];
    
    dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"addFriendCallBack:"];
    [dataProvider SaveFriend:get_sp(@"id") andFriendid:selectFriendID];
}

-(void)addFriendCallBack:(id)dict{
    [SVProgressHUD dismiss];
    if ([dict[@"code"] intValue] == 200) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateMyFriend" object:nil];
        [SVProgressHUD showSuccessWithStatus:@"添加成功~"];
        [_tableView.mj_header beginRefreshing];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"添加失败~"];
    }
}

-(void)inviteEvent:(id)sender{
    [SVProgressHUD showWithStatus:@"请稍等..." maskType:SVProgressHUDMaskTypeBlack];
    UIView *v = [sender superview];
    UITableViewCell *cell = (UITableViewCell *)[v superview];
    NSIndexPath *mIndexPath = [_tableView indexPathForCell:cell];
    NSString *firstKey = [userSource[mIndexPath.section] allKeys][0];
    NSLog(@"%@",userSource[mIndexPath.section]);
    NSString *selectPhone = [userSource[mIndexPath.section] objectForKey:firstKey][mIndexPath.row][1];
    
    
    [self showMessageView:selectPhone];
}

- (void)showMessageView:(NSString *)phoneTxt
{
    
    if( [MFMessageComposeViewController canSendText] ){
        
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc]init]; //autorelease];
        
        controller.recipients = [NSArray arrayWithObject:phoneTxt];
        controller.body = @"http://www.pgyer.com/NACr";
        controller.messageComposeDelegate = self;
        
        [self presentViewController:controller animated:YES completion:nil];
        
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:@"测试短信"];//修改短信界面标题
    }else{
        
        [self alertWithTitle:@"提示信息" msg:@"设备没有短信功能"];
    }
    
    [SVProgressHUD dismiss];
}


//MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    [controller dismissViewControllerAnimated:NO completion:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setleftbtn" object:nil userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:@"hide"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:@"hide"]];
    
//    switch ( result ) {
//            
//        case MessageComposeResultCancelled:
//            
//            [self alertWithTitle:@"提示信息" msg:@"发送取消"];
//            break;
//        case MessageComposeResultFailed:// send failed
//            [self alertWithTitle:@"提示信息" msg:@"发送失败"];
//            break;
//        case MessageComposeResultSent:
//            [self alertWithTitle:@"提示信息" msg:@"发送成功"];
//            break;
//        default:
//            break;
//    }
}


- (void) alertWithTitle:(NSString *)title msg:(NSString *)msg {
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"确定", nil];
    
    [alert show];
    
}


@end
