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
@end

@implementation AutoLocationViewController
{
    NSDictionary * cityinfoWithFile;
    UIButton * btn_autolocation;
    NSArray * itemarray;
}
@synthesize indexArray;
@synthesize LetterResultArr;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"Icon_Back@2x.png"];
    _lblTitle.text=@"当前位置－临沂";
    _lblTitle.textColor=[UIColor whiteColor];
    itemarray=[[NSArray alloc] init];
   // [SVProgressHUD showWithStatus:@"正在加载数据。。" maskType:SVProgressHUDMaskTypeBlack];
    [self LoadAllData];
}
-(void)LoadAllData
{
//    DataProvider * dataprovider=[[DataProvider alloc] init];
//    [dataprovider setDelegateObject:self setBackFunctionName:@"GetCityListBackCall:"];
//    [dataprovider GetCity];
//    [dataprovider GetCityList];
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
    [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
//        DataProvider * dataprovider=[[DataProvider alloc] init];
//        [dataprovider setDelegateObject:self setBackFunctionName:@"GetCityInfoBackCall:"];
//        [dataprovider GetcityInfoWithlng:[NSString stringWithFormat:@"%f",locationCorrrdinate.longitude] andlat:[NSString stringWithFormat:@"%f",locationCorrrdinate.latitude]];
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
//                [btn_historyItem setTitle:array[i][@"area_name"] forState:UIControlStateNormal];
//                btn_historyItem.tag=[array[i][@"area_id"] intValue];
//                [btn_historyItem setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] forState:UIControlStateNormal];
//                btn_historyItem.backgroundColor=[UIColor whiteColor];
//                [btn_historyItem addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
//                [myHeaderVeiw addSubview:btn_historyItem];
//            }
            
            //最新历史应该从后往前遍历
            for (int i=(int)array.count - 1; i>((int)array.count - num - 1) ;i--) {
                
                UIButton * btn_historyItem=[[UIButton alloc] initWithFrame:CGRectMake(w*(( array.count  - i -1 )%3)+10*((array.count - i -1)%3+1), backview_history.frame.origin.y+15,w, 50)];
                NSString *cityName = array[i][@"area_name"];
                NSInteger tag = [array[i][@"area_id"] intValue];
                
                if(cityName == nil || [cityName isEqualToString:@""])
                {
                    cityName = array[i][@"cityname"];
                }
                
                if(tag == 0)
                {
                    tag = [array[i][@"id"] intValue];
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
-(void)GetCityInfoBackCall:(id)dict
{
//    if ([dict[@"status"][@"succeed"] intValue]==1) {
    if (!dict[@"datas"][@"error"]) {
        _lblTitle.text=[NSString stringWithFormat:@"当前位置－%@",dict[@"datas"][@"area_name"]];
        [btn_autolocation setTitle:dict[@"datas"][@"area_name"] forState:UIControlStateNormal];
        btn_autolocation.tag=[dict[@"datas"][@"area_id"] intValue];
//        NSMutableArray * strforhistory=cityinfoWithFile[@"history"];
//        BOOL isexist=NO;
//        for (NSDictionary *item in strforhistory) {
//            if ([item[@"area_name"] isEqualToString:dict[@"datas"][@"area_name"]]) {
//                isexist=YES;
//                break;
//            }
//        }
//        if (!isexist) {
//            [strforhistory addObject:dict[@"datas"]];
//        }
//        NSDictionary * areaData=@{@"area_id":dict[@"datas"][@"area_id"],@"area_name":dict[@"datas"][@"area_name"],@"history":strforhistory};
//        [self SaveCityInfo:areaData];
    }
    [SVProgressHUD dismiss];
}

-(void)btn_click:(UIButton *)sender
{
    if (sender.tag!=0) {
        BOOL isexist=NO;
        NSMutableArray *array=[[NSMutableArray alloc] initWithArray:cityinfoWithFile[@"history"]];
        if (array) {
            for (NSDictionary *item in array) {
                if ([item[@"area_name"] isEqualToString:sender.currentTitle]) {
                    isexist=YES;
                    break;
                }
            }
            if (!isexist) {
                NSDictionary * dict=[[ NSDictionary alloc] initWithObjectsAndKeys:sender.currentTitle,@"area_name",
                                     [NSString stringWithFormat:@"%ld",(long)sender.tag],@"area_id", nil];
                [array addObject:dict];
            }
            
            NSDictionary * areaData=@{@"area_id":[NSString stringWithFormat:@"%ld",(long)sender.tag],@"area_name":sender.currentTitle,@"history":array};
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
        
        
        [self.navigationController popViewControllerAnimated:YES];
        
        if([self.delegate respondsToSelector:@selector(outCitySetting:)])
        {
            [self.delegate outCitySetting:dict[@"area_name"]];
        }
    }
    return result;
}
-(void)GetCityListBackCall:(id)dict
{
    NSLog(@"获取城市列表%@",dict);
    if ([dict[@"status"][@"succeed"] intValue]==1) {
//    if (!dict[@"datas"][@"error"]) {
//        itemarray=[[NSArray alloc] initWithArray:dict[@"datas"][@"area_list"]];
        itemarray=[[NSArray alloc] initWithArray:dict[@"data"][@"citylist"]];
        NSMutableArray * itemmutablearray=[[NSMutableArray alloc] init];
        for (int i=0; i<itemarray.count; i++) {
//            [itemmutablearray addObject:itemarray[i][@"area_name"]];
            
            [itemmutablearray addObject:itemarray[i][@"cityname"]];
        }
        self.indexArray = [ChineseString IndexArray:itemmutablearray];
        self.LetterResultArr = [ChineseString LetterSortArray:itemmutablearray];
        UITableView * tableview=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        tableview.delegate=self;
        tableview.dataSource=self;
        tableview.tableHeaderView=[self BuildHeaderVeiw];
        [self.view addSubview:tableview];
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"未获取到数据" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }
    [SVProgressHUD dismiss];
}

#pragma mark -Section的Header的值
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *key = [indexArray objectAtIndex:section];
    return key;
}
#pragma mark - Section header view
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    lab.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    lab.text = [indexArray objectAtIndex:section];
    lab.textColor = [UIColor grayColor];
    return lab;
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
    return indexArray;
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

#pragma mark -允许数据源告知必须加载到Table View中的表的Section数。
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [indexArray count];
}
#pragma mark -设置表格的行数为数组的元素个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.LetterResultArr objectAtIndex:section] count];
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
    
    cell.textLabel.text = [[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
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
        NSString * strCityName=[[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        BOOL isexist=NO;
        NSDictionary * dict=[[NSDictionary alloc] init];
        for (NSDictionary *item in itemarray) {
            if ([item[@"cityname"] isEqualToString:strCityName]) {
                dict=item;
            }
        }
        NSMutableArray *array=[[NSMutableArray alloc] initWithArray:cityinfoWithFile[@"history"]];
        if (array) {
            for (NSDictionary *item in array) {
                if ([item[@"area_name"] isEqualToString:dict[@"cityname"]]) {
                    isexist=YES;
                    break;
                }
                
                if ([item[@"cityname"] isEqualToString:dict[@"cityname"]]) {
                    isexist=YES;
                    break;
                }

                
            }
            if (!isexist) {
                [array addObject:dict];
            }
            NSDictionary * areaData=@{@"area_id":dict[@"id"],@"citynum":dict[@"citynum"],@"area_name":dict[@"cityname"],@"history":array};
            [self SaveCityInfo:areaData];
        }
        else
        {
            NSMutableArray * myarr=[[NSMutableArray alloc] initWithObjects:dict, nil];
            array=myarr;
        }
        NSDictionary * prm=[[NSDictionary alloc] initWithObjectsAndKeys:dict[@"id"],@"area_id",
                            dict[@"cityname"],@"area_name",
                            dict[@"citynum"], @"citynum",
                            array,@"history",nil];
        //    NSDictionary * prm=@{@"area_id":dict[@"datas"][@"area_id"],@"area_name":dict[@"datas"][@"area_name"],@"history":jsonString};
        [self SaveCityInfo:prm];
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
