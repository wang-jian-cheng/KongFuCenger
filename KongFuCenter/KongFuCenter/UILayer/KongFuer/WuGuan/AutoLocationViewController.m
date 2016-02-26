//
//  AutoLocationViewController.m
//  BuerShopping
//
//  Created by 于金祥 on 15/7/7.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "AutoLocationViewController.h"
#import "ChineseString.h"
#import "AppDelegate.h"
#import "DataProvider.h"
#import "CCLocationManager.h"

@interface AutoLocationViewController ()
@property(nonatomic,retain)NSMutableArray *indexArray;
@property(nonatomic,retain)NSMutableArray *LetterResultArr;

@property(nonatomic)NSMutableArray *searchArr;
@end

@implementation AutoLocationViewController
{
    NSDictionary * cityinfoWithFile;
    UIButton * btn_autolocation;
    NSArray * itemarray;
    
    
    BOOL searchMode;
}
@synthesize indexArray;
@synthesize LetterResultArr;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"left"];
    _lblTitle.text=@"当前位置";
    _lblTitle.textColor=[UIColor whiteColor];
    itemarray=[[NSArray alloc] init];
   // [SVProgressHUD showWithStatus:@"正在加载数据。。" maskType:SVProgressHUDMaskTypeBlack];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:) ];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    [self LoadAllData];
}
-(void)LoadAllData
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetCityListBackCall:"];
    [dataprovider getAllCitys];
}
-(UIView *)BuildHeaderVeiw
{
    UIView * myHeaderVeiw=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 215)];
    myHeaderVeiw.backgroundColor=[UIColor whiteColor];
    UILabel * lbl_autolocationTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 5, myHeaderVeiw.frame.size.width-20, 20)];
    lbl_autolocationTitle.text=@"定位城市";
    [myHeaderVeiw addSubview:lbl_autolocationTitle];
    UIView * backview_auto=[[UIView alloc] initWithFrame:CGRectMake(0, lbl_autolocationTitle.frame.size.height+lbl_autolocationTitle.frame.origin.y, myHeaderVeiw.frame.size.width, 80)];
    backview_auto.backgroundColor=[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    [myHeaderVeiw addSubview:backview_auto];
    btn_autolocation=[[UIButton alloc] initWithFrame:CGRectMake(10, backview_auto.frame.origin.y+15, 130, 50)];
    [btn_autolocation setTitle:@"正在定位中..." forState:UIControlStateNormal];
    [btn_autolocation setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] forState:UIControlStateNormal];
    btn_autolocation.backgroundColor=[UIColor whiteColor];
    btn_autolocation.tag=0;
    [btn_autolocation addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
//    [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
//        
//        DataProvider * dataprovider=[[DataProvider alloc] init];
//        [dataprovider setDelegateObject:self setBackFunctionName:@"GetCityInfoBackCall:"];
////        [dataprovider GetcityInfoWithlng:[NSString stringWithFormat:@"%f",locationCorrrdinate.longitude] andlat:[NSString stringWithFormat:@"%f",locationCorrrdinate.latitude]];
//        
//    
//    }];
    
    [[CCLocationManager shareLocation] getCity:^(NSString *addressString) {
        NSLog(@"City : %@",addressString);
        NSString *cityName = [self getRealCityName:addressString];
        NSLog(@"cityname = %@",cityName);
        [btn_autolocation setTitle:cityName forState:UIControlStateNormal];
    }];
    [myHeaderVeiw addSubview:btn_autolocation];
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"CityInfo.plist"];
    cityinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    UILabel * lbl_history=[[UILabel alloc] initWithFrame:CGRectMake(10, backview_auto.frame.origin.y+backview_auto.frame.size.height+5, myHeaderVeiw.frame.size.width-20, 20)];
    lbl_history.text=@"最近访问城市";
    [myHeaderVeiw addSubview:lbl_history];
    
    UIView * backview_history=[[UIView alloc] initWithFrame:CGRectMake(0, lbl_history.frame.size.height+lbl_history.frame.origin.y, myHeaderVeiw.frame.size.width, 80)];
    backview_history.backgroundColor=[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    [myHeaderVeiw addSubview:backview_history];
    
    NSArray * array=[[NSArray alloc] initWithArray:cityinfoWithFile[@"history"]];
    if (cityinfoWithFile[@"history"]) {
        if (array.count>0) {
            CGFloat w=(myHeaderVeiw.frame.size.width-40)/3;
            int num=0;
            if (array.count>=3) {
                num=3;
            }
            else
            {
                num=array.count;
            }
//            for (int i=0; i<num ;i++) {
//                UIButton * btn_historyItem=[[UIButton alloc] initWithFrame:CGRectMake(w*(i%3)+10*(i%3+1), backview_history.frame.origin.y+15,w, 50)];
//                [btn_historyItem setTitle:array[i][@"Name"] forState:UIControlStateNormal];
//                btn_historyItem.tag=[array[i][@"Id"] intValue];
//                [btn_historyItem setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] forState:UIControlStateNormal];
//                btn_historyItem.backgroundColor=[UIColor whiteColor];
//                [btn_historyItem addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
//                [myHeaderVeiw addSubview:btn_historyItem];
//            }
            
            //最新历史应该从后往前遍历
            for (int i=(int)array.count - 1; i>((int)array.count - num - 1) ;i--) {
                
                UIButton * btn_historyItem=[[UIButton alloc] initWithFrame:CGRectMake(w*(( array.count  - i -1 )%3)+10*((array.count - i -1)%3+1), backview_history.frame.origin.y+15,w, 50)];
                NSString *cityName = array[i][@"Name"];
                NSInteger tag = [array[i][@"Id"] intValue];
                
                if(cityName == nil || [cityName isEqualToString:@""])
                {
                    cityName = array[i][@"Name"];
                }
                
                if(tag == 0)
                {
                    tag = [array[i][@"Id"] intValue];
                }
                [btn_historyItem setTitle:cityName forState:UIControlStateNormal];
                btn_historyItem.tag=tag;
                
                
                [btn_historyItem setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] forState:UIControlStateNormal];
                btn_historyItem.backgroundColor=[UIColor whiteColor];
                [btn_historyItem addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
                [myHeaderVeiw addSubview:btn_historyItem];
                
            }

        }
    }
    return myHeaderVeiw;
}

-(NSMutableArray *)searchArr
{
    if(_searchArr == nil)
    {
        _searchArr = [NSMutableArray array];
    }
    
    return _searchArr;
}


-(void)tapViewAction:(id)sender
{
    [self.view endEditing:YES];
}

#pragma mark - 手势代理

//设置点在某个view时部触发事件
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"-%@", NSStringFromClass([touch.view class]));
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]||[NSStringFromClass([touch.view class]) isEqualToString:@"UIButton"])
    {
        return NO;
    }

    return  YES;
}

#pragma mark - 定位相关

-(NSString *)getCityIdbyName:(NSString *)cityName
{
    if(cityName ==nil || itemarray==nil || itemarray.count == 0)
        return nil;
    
    for (NSDictionary *tempDict in itemarray) {
        if([tempDict[@"Name"] isEqualToString:cityName])
            return tempDict[@"Id"];
    }
    
    return nil;
}
-(NSString *)getRealCityName:(NSString *)address
{
    if(address==nil)
        return nil;
    NSRange tempRang;
    tempRang.location = 0;
    tempRang.length= 0;
    tempRang = [address rangeOfString:@"省"];
    if (tempRang.length == 0) {
        tempRang = [address rangeOfString:@"区" ];
    }
    
    return [address substringFromIndex:(tempRang.location+1)];
}


-(void)GetCityInfoBackCall:(id)dict
{
//    if ([dict[@"status"][@"succeed"] intValue]==1) {
    if (!dict[@"datas"][@"error"]) {
        _lblTitle.text=[NSString stringWithFormat:@"当前位置－%@",dict[@"datas"][@"Name"]];
        [btn_autolocation setTitle:dict[@"datas"][@"Name"] forState:UIControlStateNormal];
        btn_autolocation.tag=[dict[@"datas"][@"Id"] intValue];
//        NSMutableArray * strforhistory=cityinfoWithFile[@"history"];
//        BOOL isexist=NO;
//        for (NSDictionary *item in strforhistory) {
//            if ([item[@"Name"] isEqualToString:dict[@"datas"][@"Name"]]) {
//                isexist=YES;
//                break;
//            }
//        }
//        if (!isexist) {
//            [strforhistory addObject:dict[@"datas"]];
//        }
//        NSDictionary * areaData=@{@"Id":dict[@"datas"][@"Id"],@"Name":dict[@"datas"][@"Name"],@"history":strforhistory};
//        [self SaveCityInfo:areaData];
    }
    [SVProgressHUD dismiss];
}

-(void)btn_click:(UIButton *)sender
{
    if(sender.tag == 0)
    {
        NSString *cityId = [self getCityIdbyName:sender.titleLabel.text];
        
        if(cityId == nil)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"城市id获取失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return;
        }
        BOOL isexist=NO;
        NSMutableArray *array=[[NSMutableArray alloc] initWithArray:cityinfoWithFile[@"history"]];
        if (array) {
            for (NSDictionary *item in array) {
                if ([item[@"Name"] isEqualToString:sender.currentTitle]) {
                    isexist=YES;
                    break;
                }
            }
            if (!isexist) {
                NSDictionary * dict=[[ NSDictionary alloc] initWithObjectsAndKeys:sender.currentTitle,@"Name",
                                     [NSString stringWithFormat:@"%ld",(long)sender.tag],@"Id", nil];
                [array addObject:dict];
            }
            
            NSDictionary * areaData=@{@"Id":cityId,
                                      @"Name":sender.titleLabel.text,
                                      @"history":array};
            [self SaveCityInfo:areaData];
        }
        
    }
    if (sender.tag!=0) {
        BOOL isexist=NO;
        NSMutableArray *array=[[NSMutableArray alloc] initWithArray:cityinfoWithFile[@"history"]];
        if (array) {
            for (NSDictionary *item in array) {
                if ([item[@"Name"] isEqualToString:sender.currentTitle]) {
                    isexist=YES;
                    break;
                }
            }
            if (!isexist) {
                NSDictionary * dict=[[ NSDictionary alloc] initWithObjectsAndKeys:sender.currentTitle,@"Name",
                                     [NSString stringWithFormat:@"%ld",(long)sender.tag],@"Id", nil];
                [array addObject:dict];
            }
            
            NSDictionary * areaData=@{@"Id":[NSString stringWithFormat:@"%ld",(long)sender.tag],@"Name":sender.currentTitle,@"history":array};
            [self SaveCityInfo:areaData];
        }
    }
}
-(BOOL)SaveCityInfo:(NSDictionary *)dict
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"CityInfo.plist"];
    BOOL result= [dict writeToFile:plistPath atomically:YES];
    if (result) {
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"CityInfo.plist"];
        cityinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeCity" object:nil];
        if([self.delegate respondsToSelector:@selector(outCitySetting:andID:)])
        {
            [self.delegate outCitySetting:dict[@"Name"] andID:dict[@"Id"]];
        }

        
        [self.navigationController popViewControllerAnimated:YES];
        
       }
    return result;
}
-(void)GetCityListBackCall:(id)dict
{
    DLog(@"获取城市列表%@",dict);
    if ([dict[@"code"] intValue]==200) {
//    if (!dict[@"datas"][@"error"]) {
        
        @try {
            //        itemarray=[[NSArray alloc] initWithArray:dict[@"datas"][@"area_list"]];
            itemarray=[[NSArray alloc] initWithArray:dict[@"data"]];
            NSMutableArray * itemmutablearray=[[NSMutableArray alloc] init];
            for (int i=0; i<itemarray.count; i++) {
                //            [itemmutablearray addObject:itemarray[i][@"Name"]];
                
                [itemmutablearray addObject:itemarray[i][@"Name"]];
            }
            UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
            searchBar.delegate = self;
            [self.view addSubview:searchBar];
            
            self.indexArray = [ChineseString IndexArray:itemmutablearray];
            self.LetterResultArr = [ChineseString LetterSortArray:itemmutablearray];
            tableview=[[UITableView alloc] initWithFrame:CGRectMake(0, 64+44, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
            tableview.delegate=self;
            tableview.dataSource=self;
            tableview.tableHeaderView=[self BuildHeaderVeiw];
            tableview.tableFooterView = [[UIView alloc] init];
            [self.view addSubview:tableview];

            
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"未获取到数据" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }
    [SVProgressHUD dismiss];
}

#pragma mark -  搜索


-(void)startSearchFunction:(NSString *)searchStr andDestArr:(NSArray *)destArr
{
 
    [self.searchArr removeAllObjects];
    
    if(destArr == 0 || destArr == nil)
        return;
    if(searchStr == nil || searchStr.length == 0 )
    {
        [self.searchArr addObjectsFromArray:destArr];
        [tableview reloadData];
    }
    
    
    if (searchStr.length>0&&![ChineseInclude isIncludeChineseInString:searchStr]) /*无汉字*/{
//        @try {
//            for (int i=0; i<destArr.count/*按首字母分组的*/; i++) {
//                
//                NSArray *tempArr = destArr[i];
//                for (int j = 0; j<tempArr.count; j++) {
//                    
//                    NSString *nickStr;
//                    nickStr = tempArr[j];
//                    if ([ChineseInclude isIncludeChineseInString:nickStr]) {
//                        NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:nickStr];
//                        NSRange titleResult=[tempPinYinStr rangeOfString:searchStr options:NSCaseInsensitiveSearch];
//                        if (titleResult.length>0) {
//                            [self.searchArr addObject:destArr[i]];
//                            continue;
//                        }
//                        NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:nickStr];
//                        NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:searchStr options:NSCaseInsensitiveSearch];
//                        if (titleHeadResult.length>0) {
//                            [self.searchArr addObject:destArr[i]];
//                            continue;
//                        }
//                    }
//                    else {
//                        NSRange titleResult=[nickStr rangeOfString:searchStr options:NSCaseInsensitiveSearch];
//                        if (titleResult.length>0) {
//                            [self.searchArr addObject:destArr[i]];
//                            continue;
//                        }
//                    }
//                }
//               
//                
//            }
//        }
//        @catch (NSException *exception) {
//            
//        }
//        @finally {
//            
//        }
        
    } else if (searchStr.length>0&&[ChineseInclude isIncludeChineseInString:searchStr]) {
        for (int i = 0; i < destArr.count/*以城市首字母分组的*/; i++) {
            NSArray *tempArr = destArr[i];
            
            for (NSString *nickStr in tempArr) {
                
                NSRange titleResult=[nickStr rangeOfString:searchStr options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [self.searchArr addObject:nickStr];
                }
            }
        }
        
        
    }
    
    searchMode = YES;
    tableview.tableHeaderView = nil;
    [tableview reloadData];
}

#pragma mark - search bar delegate 

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    DLog(@"Search bar btn click");
    
    
    [self startSearchFunction:searchBar.text andDestArr:self.LetterResultArr];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchMode = NO;
    tableview.tableHeaderView = [self BuildHeaderVeiw];
    [tableview reloadData];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        searchMode = NO;
        tableview.tableHeaderView = [self BuildHeaderVeiw];
        [tableview reloadData];
    }
}
#pragma mark -Section的Header的值
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(searchMode == YES)
    {
        return @"";
    }
    else
    {
        NSString *key = [indexArray objectAtIndex:section];
        return key;
    }
}
#pragma mark - Section header view
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if(searchMode == YES)
    {
        return [[UIView alloc] init];
    }
    else
    {
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        lab.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
        lab.text = [indexArray objectAtIndex:section];
        lab.textColor = [UIColor grayColor];
        return lab;
    }
}
#pragma mark - row height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0;
}

#pragma mark -
#pragma mark Table View Data Source Methods
#pragma mark -设置右方表格的索引数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(searchMode == YES)
    {
        return nil;
    }
    else
    {
        return indexArray;
    }
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

#pragma mark -允许数据源告知必须加载到Table View中的表的Section数。
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if(searchMode == YES)
    {
        return 1;
    }
    else
    {
        return [indexArray count];
    }
}
#pragma mark -设置表格的行数为数组的元素个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(searchMode == YES)
    {
        return self.searchArr.count;
    }
    else
    {
        return [[self.LetterResultArr objectAtIndex:section] count];
    }
}
#pragma mark -每一行的内容为数组相应索引的值
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if(searchMode == YES)
    {
        cell.textLabel.text =  self.searchArr[indexPath.row];
    }
    else
    {
        cell.textLabel.text = [[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    }
    return cell;
}
#pragma mark - Select内容为数组相应索引的值
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        NSLog(@"---->%@",[[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]);
        
        //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
        //                                                    message:[[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]
        //                                                   delegate:nil
        //                                          cancelButtonTitle:@"YES" otherButtonTitles:nil];
        //    [alert show];
        NSString * strCityName;
        if(searchMode == YES)
        {
            strCityName = self.searchArr[indexPath.row];
        }
        else
        {
            strCityName=[[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        }
        BOOL isexist=NO;
        NSDictionary * dict=[[NSDictionary alloc] init];
        for (NSDictionary *item in itemarray) {
            if ([item[@"Name"] isEqualToString:strCityName]) {
                dict=item;
            }
        }
        NSMutableArray *array=[[NSMutableArray alloc] initWithArray:cityinfoWithFile[@"history"]];
        if (array) {
            for (NSDictionary *item in array) {
                if ([item[@"Name"] isEqualToString:dict[@"Name"]]) {
                    isexist=YES;
                    break;
                }
                
                if ([item[@"cityname"] isEqualToString:dict[@"Name"]]) {
                    isexist=YES;
                    break;
                }

                
            }
            if (!isexist) {
                [array addObject:dict];
            }
            NSDictionary * areaData=@{@"Id":dict[@"Id"],@"citynum":dict[@"Code"],@"Name":dict[@"Name"],@"history":array};
         //   NSDictionary * areaData=@{@"Id":dict[@"Id"],@"Name":dict[@"cityname"],@"history":array};
            [self SaveCityInfo:areaData];
        }
        else
        {
            NSMutableArray * myarr=[[NSMutableArray alloc] initWithObjects:dict, nil];
            array=myarr;
        }
//        NSDictionary * prm=[[NSDictionary alloc] initWithObjectsAndKeys:dict[@"Id"],@"Id",
//                            dict[@"Name"],@"Name",
//                            dict[@"Code"], @"citynum",
//                            array,@"history",nil];
        //    NSDictionary * prm=@{@"Id":dict[@"datas"][@"Id"],@"Name":dict[@"datas"][@"Name"],@"history":jsonString};
     //   [self SaveCityInfo:prm];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}


@end
