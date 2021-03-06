//
//  PersonInfoViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/8.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "RegisterViewController.h"

#define HighTAG         (2015+1)
#define WeightTAG       (2015+2)
#define AgeTAG          (2015+3)
#define LearnTimeTAG    (2015+4)
#define ProvinceTAG     (0)
#define CityTAG         (1)
#define AreaTAG         (2)
#define ORIGINAL_MAX_WIDTH 640.0f
@interface PersonInfoViewController ()<UserHeadViewDelegate>
{
#pragma mark - pram for tableView
    NSInteger _sectionNum;
    CGFloat _cellHeight;
    UITableView *_mainTableView;
    
    
#pragma mark - pickerView data arr
    NSArray *weightArr;
    NSArray *highArr;
    NSMutableArray *infoArr;
    BOOL relayoutViewFlag;
    
    NSArray * provinceArray;
    NSArray * cityArray;
    NSArray *areaArray;
    
    NSString *cityID;
    NSString *imgPath;
    BOOL loadDataFlag;
    NSString *birthday;
    
#pragma mark - other Views
    
    UILabel *userName ;
    UILabel *idLab;
    UILabel *jiFenLab ;
    UITextField *nickName;
    UserHeadView  *headView ;
    UUDatePicker *birthDayPicker;

    BOOL clickAddBtn ;
}
@end
#define GapToLeft   20
@implementation PersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"left"];
    [self addRightbuttontitle:@"保存"];
    infoArr = [NSMutableArray array];

    loadDataFlag = YES;
    [self initViews];
    
    [self getDatas];
    // Do any additional setup after loading the view.
}


-(void)initViews
{
    _cellHeight = SCREEN_HEIGHT/12;
    _sectionNum = 3;
    
    cityID = @"1";
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height )];
    _mainTableView.backgroundColor = BACKGROUND_COLOR;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorColor =  Separator_Color;
    _mainTableView.tableFooterView = [[UIView alloc] init];
    _mainTableView.separatorInset = UIEdgeInsetsZero;
    headView = [[UserHeadView alloc] initWithFrame:CGRectMake(GapToLeft, 10,  2*_cellHeight - 20, 2*_cellHeight - 20)
                                        andImgName:@"me"];
    //_mainTableView.scrollEnabled = NO;
    //设置cell分割线从最左边开始
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
    {
        if ([_mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_mainTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        
        if ([_mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_mainTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
    
    
    _mainTableView.contentSize = CGSizeMake(SCREEN_HEIGHT, _sectionNum*(_cellHeight + 20));
    [self.view addSubview:_mainTableView];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:) ];
    [self.view addGestureRecognizer:tapGesture];
    
    
    //    //注册通知,监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    //
    //    //注册通知,监听键盘消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden) name:UIKeyboardDidHideNotification object:nil];
    
    
    
    
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT - 216), SCREEN_WIDTH, 216)];
    // 显示选中框
    _pickerView.showsSelectionIndicator=YES;
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    _pickerView.backgroundColor = [UIColor whiteColor];
    
    introductionText = [[UITextView alloc] init];
    
    [self initBtns];
    [self initViewForCells];
   
}

-(void)initViewForCells
{
    nickName = [[UITextField alloc] init];
}


-(void)initBtns
{
    CGFloat btnFont = 14;
    
    boyBtn  = [[UIButton alloc] init];
    boyBtn.titleLabel.font = [UIFont systemFontOfSize:btnFont];
    grilBtn= [[UIButton alloc] init];
    grilBtn.titleLabel.font = [UIFont systemFontOfSize:btnFont];
    
    weightBtn= [[UIButton alloc] init];
    weightBtn.titleLabel.font = [UIFont systemFontOfSize:btnFont];
    highBtn= [[UIButton alloc] init];
    highBtn.titleLabel.font = [UIFont systemFontOfSize:btnFont];
    
    ageBtn= [[UIButton alloc] init];
    ageBtn.titleLabel.font = [UIFont systemFontOfSize:btnFont];
    learnTimeBtn= [[UIButton alloc] init];
    learnTimeBtn.titleLabel.font = [UIFont systemFontOfSize:btnFont];
    
    provinceBtn= [[UIButton alloc] init];
    provinceBtn.titleLabel.font = [UIFont systemFontOfSize:btnFont];
    cityBtn= [[UIButton alloc] init];
    cityBtn.titleLabel.font = [UIFont systemFontOfSize:btnFont];
    areaBtn= [[UIButton alloc] init];
    areaBtn.titleLabel.font = [UIFont systemFontOfSize:btnFont];
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}


-(void)reLayoutTableViewHeight:(CGFloat)height
{
    tempIndexPath = [NSIndexPath indexPathForRow:4 inSection:1];
    [_mainTableView setFrame:CGRectMake(0, Header_Height, self.view.frame.size.width,self.view.frame.size.height -Header_Height -height)];
    [_mainTableView scrollToRowAtIndexPath:tempIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}

#pragma mark - uipickerview

                 
 // pickerView 列数
 - (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
     return 3;
 }
 
 // pickerView 每列个数
 - (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
     switch (component) {
         case 0:
             return provinceArray.count;
         case 1:
             return cityArray.count;
         case 2:
             return areaArray.count;
         default:
             return infoArr.count;
             break;
     }
     
 }
 
// // 每列宽度
// - (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
//     
//     return 180;
// }
 // 返回选中的行
 - (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    switch (component) {
        case ProvinceTAG:
        {
            NSString *provinceId;
         
            provinceRow = row;
            [provinceBtn setTitle:[provinceArray objectAtIndex:row][@"Name"] forState:UIControlStateNormal];
            for (NSDictionary *tempDict in provinceArray) {
//                NSLog(@"[tempDict[Name] = %@",tempDict[@"Name"]);
//                NSLog(@"provinceBtn.titleLabel.text = %@",provinceBtn.titleLabel.text);
                if([tempDict[@"Name"] isEqualToString:provinceBtn.titleLabel.text] )
                {
                    provinceId = [NSString stringWithFormat:@"%@",tempDict[@"Code"]];
                    break;
                }
                
            }
            if(provinceId == nil)
            {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"城市获取失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                [alert show];
                return;
            }
            cityID = provinceArray[row][@"Id"];
            [self getCityByProvince:provinceId];

        }
            break;
        case CityTAG:
        {
                        cityRow = row;
            [cityBtn setTitle:[cityArray objectAtIndex:row][@"Name"] forState:UIControlStateNormal];
            NSString *_cityCode;
            
            for (NSDictionary *tempDict in cityArray) {
                
                if([tempDict[@"Name"] isEqualToString:cityBtn.titleLabel.text] )
                {
                    _cityCode = [NSString stringWithFormat:@"%@",tempDict[@"Code"]];
                    break;
                }
                
            }
            if(_cityCode == nil)
            {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"城市获取失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                [alert show];
                return;
            }
            [self getAreaByCity:_cityCode];

        }
            break;
        case AreaTAG:
            areaRow = row;
            [areaBtn setTitle:[areaArray objectAtIndex:row][@"Name"] forState:UIControlStateNormal];
            cityID = areaArray[row][@"Id"];
            break;
        default:
            break;
    }
    
}
                 
                 //返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return provinceArray[row][@"Name"];
        case 1:
            return cityArray[row][@"Name"];
        case 2:
            return areaArray[row][@"Name"];
        default:
            return infoArr[row][@"Name"];
    }
}





#pragma mark - 键盘操作

// 键盘弹出时
-(void)keyboardDidShow:(NSNotification *)notification
{
    if(relayoutViewFlag == YES)
    {
        //获取键盘高度
        NSValue *keyboardObject = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
        
        CGRect keyboardRect;
        [keyboardObject getValue:&keyboardRect];
        
        
        _keyHeight = keyboardRect.size.height;
        //调整放置有textView的view的位置
        
        //设置动画
        [UIView beginAnimations:nil context:nil];
        
        //定义动画时间
        [UIView setAnimationDuration:0.5];
        //               CGRectMake(0, self.view.frame.size.height-keyboardRect.size.height-kViewHeight, 320, kViewHeight)]
        //设置view的frame，往上平移
        [_mainTableView setFrame:CGRectMake(0, Header_Height, self.view.frame.size.width,self.view.frame.size.height -Header_Height -keyboardRect.size.height)];
        
        [_mainTableView scrollToRowAtIndexPath:tempIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        
        //[_mainTableView reloadData];
        [UIView commitAnimations];
    }
    
}

//键盘消失时
-(void)keyboardDidHidden
{
    
    if(relayoutViewFlag == YES)
    {
    //定义动画
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        //设置view的frame，往下平移
        [_mainTableView setFrame:CGRectMake(0, Header_Height, self.view.frame.size.width,SCREEN_HEIGHT - Header_Height)];
        
        //[_mainTableView reloadData];
        [UIView commitAnimations];
        relayoutViewFlag = NO;
    }
    
}


#pragma mark - self data source
-(NSString *)calculateAge:(NSString *)birthDay
{
    NSString *age;
    NSString *now;
    NSInteger numAge;
    now = [NSString stringWithFormat:@"%@",[NSDate date]];
    
    NSInteger bYear = [[birthDay substringToIndex:4] integerValue];
    NSInteger nYear = [[now substringToIndex:4] integerValue];
    
    NSRange tempRang;
    tempRang.length = 2;
    tempRang.location = 5;
    NSInteger bMonth = [[birthDay substringWithRange:tempRang] integerValue];
    NSInteger nMonth = [[now substringWithRange:tempRang] integerValue];
    
    tempRang.length = 2;
    tempRang.location =8;
    NSInteger bDay = [[birthDay substringWithRange:tempRang] integerValue];
    NSInteger nDay = [[now substringWithRange:tempRang] integerValue];
    
    
    if(bYear > nYear)
        return @"0";
    numAge = nYear - bYear;
    
    if(bMonth>nMonth)//不到生日减一岁
    {
        if(numAge >0)
            numAge--;
    }
    else if(bMonth == nMonth)
    {
        if(bDay > nDay)
        {
            if(numAge >0)
                numAge--;
        }
    }
    
    age = [NSString stringWithFormat:@"%ld",numAge];
    return age;
}
-(void)getDatas
{
    [self getUserInfo];
    
}

-(void)getUserInfo
{
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeBlack];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"getUserInfoCallBack:"];
    [dataprovider getUserInfo:[Toolkit getUserID]];
    
}


-(void)getUserInfoCallBack:(id)dict
{
    [SVProgressHUD dismiss];
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try {
            NSDictionary *tempDict = dict[@"data"];
            
            [[NSUserDefaults standardUserDefaults] setValue:[dict[@"data"] valueForKey:@"NicName"] forKey:@"NicName"];
            
            if(tempDict[@"PhotoPath"] == nil || [tempDict[@"PhotoPath"] length] == 0)
            {
                [headView.headImgView sd_setImageWithURL:[NSURL URLWithString:get_sp(ThirdLoginHeadImg)] placeholderImage:[UIImage imageNamed:@"me"]];
            }
            else
            {
                NSString * url=[NSString stringWithFormat:@"%@%@",Kimg_path,tempDict[@"PhotoPath"]];
                [headView.headImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"me"]];
            }
            jiFenLab.text = [NSString stringWithFormat:@"积分：%@",tempDict[@"Credit"]];
            userName.text = [NSString stringWithFormat:@"%@",tempDict[@"NicName"]];
            if([NSString stringWithFormat:@"%@",tempDict[@"Phone"]].length>0)
            {
                idLab.text = [NSString stringWithFormat:@"ID:%@",tempDict[@"Phone"]];
            }
            else
            {
                idLab.text = [NSString stringWithFormat:@"ID:%08d",[[Toolkit getUserID] intValue]];
            }
            if([tempDict[@"Sexuality"] integerValue] == 1)
            {
                boyBtn.selected = YES;
                grilBtn.selected = NO;
            }
            else
            {
                grilBtn.selected = YES;
                boyBtn.selected = NO;
            }
            
            [highBtn setTitle:[NSString stringWithFormat:@"%@cm",tempDict[@"Height"]] forState:UIControlStateNormal];
            [weightBtn setTitle:[NSString stringWithFormat:@"%@kg",tempDict[@"Weight"]] forState:UIControlStateNormal];
           // [ageBtn setTitle:[NSString stringWithFormat:@"%@岁",tempDict[@"Birthday"]] forState:UIControlStateNormal];
            birthday =tempDict[@"Birthday"];
            [ageBtn setTitle:[self calculateAge:tempDict[@"Birthday"]] forState:UIControlStateNormal];
            [learnTimeBtn setTitle:[NSString stringWithFormat:@"%@年",tempDict[@"Experience"]] forState:UIControlStateNormal];
            nickName.text =tempDict[@"NicName"];
            [provinceBtn setTitle:tempDict[@"HomeAreaprovinceName"] forState:UIControlStateNormal];
            [cityBtn setTitle:tempDict[@"HomeAreaCityName"] forState:UIControlStateNormal];
            [areaBtn setTitle:tempDict[@"HomeAreaCountyName"] forState:UIControlStateNormal];
            introductionText.text = tempDict[@"Description"];
            cityID = tempDict[@"HomeAreaId"];
            if(loadDataFlag == YES)
                [self getProvince];
//2015-09-09 09:09:09
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





-(void)setuserInfo
{
    
    NSString *areaId = @"";
    
    for (NSDictionary *tempDict in areaArray) {
        
        if([tempDict[@"Name"] isEqualToString:areaBtn.titleLabel.text] )
        {
            areaId = [NSString stringWithFormat:@"%@",tempDict[@"Id"]];
            break;
        }
        
    }
    
    [SVProgressHUD showWithStatus:@"更新中" maskType:SVProgressHUDMaskTypeBlack];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"setUserInfoCallBack:"];
    NSString *sex;
    if(boyBtn.selected == YES)
        sex = @"1";
    else
        sex = @"2";
    [dataprovider setUserInfo:[Toolkit getUserID]
                  andNickName:nickName.text
                       andSex:sex
                    andHeight:[highBtn.titleLabel.text substringToIndex:(highBtn.titleLabel.text.length - 2)]
                    andWeight:[weightBtn.titleLabel.text substringToIndex:(weightBtn.titleLabel.text.length - 2)]
                      andAddr:cityID
                      andExpe:[learnTimeBtn.titleLabel.text substringToIndex:(learnTimeBtn.titleLabel.text.length - 1)]
               andDescription:introductionText.text
                  andBirthday:birthday];
}


-(void)setUserInfoCallBack:(id)dict
{
    [SVProgressHUD dismiss];
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try {
            [self getDatas];
           // [_mainTableView reloadData];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:[dict[@"data"] substringToIndex:4] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        
    }
}


#pragma mark - get Locations
-(void)getProvince
{

//    [SVProgressHUD showWithStatus:@"刷新中" maskType:SVProgressHUDMaskTypeBlack];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"getProvinceCallBack:"];
    [dataprovider getProvince];
}

-(void)getProvinceCallBack:(id) dict
{
    [SVProgressHUD dismiss];
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try {

            provinceArray=dict[@"data"];
            NSString *provinceId;
            int i=0;
            for (NSDictionary *tempDict in provinceArray) {
                
//                NSLog(@"[tempDict[Name] = %@",tempDict[@"Name"]);
//                NSLog(@"provinceBtn.titleLabel.text = %@",provinceBtn.titleLabel.text);
                if([tempDict[@"Name"] isEqualToString:provinceBtn.titleLabel.text] )
                {
                    provinceId = [NSString stringWithFormat:@"%@",tempDict[@"Code"]];
                    [_pickerView selectRow:i inComponent:ProvinceTAG animated:NO];
                    [_pickerView reloadComponent:ProvinceTAG];
                    break;
                }
                i++;
                
            }
//            if(provinceId == nil)
//            {
////                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"城市获取失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
////                [alert show];
//                return;
//            }
//            if(clickAddBtn == YES || loadDataFlag ==YES)
//            [self getCityByProvince:provinceId];
            [self getCityByProvince:(provinceId== nil?provinceArray[0][@"Code"]:provinceId)];

        }
        @catch (NSException *exception) {
            
        }
        @finally {
            [_pickerView reloadAllComponents];
        }
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:[dict[@"data"] substringToIndex:4] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        [_pickerView reloadAllComponents];
        [SVProgressHUD dismiss];
    }
}

-(void)getCityByProvince:(NSString *)ProvinceId
{
    areaArray = [[NSArray alloc] init];
    //[SVProgressHUD showWithStatus:@"刷新地址" maskType:SVProgressHUDMaskTypeBlack];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"getCityByProvinceCallBack:"];
    [dataprovider getCityByProvinceCode:ProvinceId];

}

-(void)getCityByProvinceCallBack:(id)dict
{
    [SVProgressHUD dismiss];
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try {
            cityArray=dict[@"data"];
            if(loadDataFlag == NO)//首次只填充city的数据
            {
                if(cityArray.count > 0)
                {
                    if(cityRow>=cityArray.count)
                    {
                        cityRow = cityArray.count - 1;
                    }
                    
                    [cityBtn setTitle:cityArray[cityRow][@"Name"] forState:UIControlStateNormal];
                    
                }
                else
                {
                    [cityBtn setTitle:@"" forState:UIControlStateNormal];
                    [areaBtn setTitle:@"" forState:UIControlStateNormal];
                    return;
                }
                [infoArr addObjectsFromArray:dict[@"data"]];
//                [self.view addSubview:_pickerView];
                if(clickAddBtn == YES)
                {
                
                    if(_pickerView.tag == CityTAG)
                        [_pickerView reloadAllComponents];
                    [self reLayoutTableViewHeight:_pickerView.frame.size.height];
                    clickAddBtn = NO;
                }
                NSString *_cityCode;
                
                for (NSDictionary *tempDict in cityArray) {
                    
                    if([tempDict[@"Name"] isEqualToString:cityBtn.titleLabel.text] )
                    {
                        _cityCode = [NSString stringWithFormat:@"%@",tempDict[@"Code"]];
                        break;
                    }
                    
                }
//                if(cityCode == nil)
//                {
////                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"城市获取失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
////                    [alert show];
//                    return;
//                }
                [self getAreaByCity:_cityCode== nil?cityArray[0][@"Code"]:_cityCode];

            }
            else
            {

                NSString *cityid;
                int i=0;
                for (NSDictionary *tempDict in cityArray) {
                    
                    if([tempDict[@"Name"] isEqualToString:cityBtn.titleLabel.text] )
                    {
                        cityid = [NSString stringWithFormat:@"%@",tempDict[@"Code"]];
                        [_pickerView reloadComponent:CityTAG];
                        [_pickerView selectRow:i inComponent:CityTAG animated:NO];
                        //
                        break;
                    }
                    i++;
                    
                }
                
                [self getAreaByCity:(cityid ==nil? cityArray[0][@"Code"]:cityid)];
            }
            

        }
        @catch (NSException *exception) {
            
        }
        @finally {
            [_pickerView reloadAllComponents];
        }
    }
    else
    {
        
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:[dict[@"data"] substringToIndex:4] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        [_pickerView reloadAllComponents];
        
    }
}

-(void)getAreaByCity:(NSString *)_cityCode
{
    //[SVProgressHUD showWithStatus:@"刷新地址" maskType:SVProgressHUDMaskTypeBlack];
    
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"getAreaByCityCallBack:"];
    [dataprovider getCityByProvinceCode:_cityCode];
    

}
-(void)getAreaByCityCallBack:(id)dict
{
    [SVProgressHUD dismiss];
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try {
           if(loadDataFlag == NO)
           {
               
               
                areaArray=dict[@"data"];
                cityID = areaArray[areaRow][@"Id"];
               
                if(areaArray.count > 0)
                {
                    if(areaRow>=areaArray.count)
                    {
                        areaRow = areaArray.count - 1;
                    }
                    [areaBtn  setTitle:areaArray[areaRow][@"Name"] forState:UIControlStateNormal] ;
                }
                else
                {
                    [areaBtn setTitle:@"" forState:UIControlStateNormal];
                    return;
                }
                [infoArr addObjectsFromArray:dict[@"data"]];
                            if(clickAddBtn == YES)
                {
                    if(_pickerView.tag == AreaTAG)
                        [_pickerView reloadAllComponents];
                    [self reLayoutTableViewHeight:_pickerView.frame.size.height];
                    clickAddBtn = NO;
                }
           }
           else
           {
               
               areaArray = dict[@"data"];
               cityID = areaArray[0][@"Id"];
                NSString *areaid;
                int i=0;
                for (NSDictionary *tempDict in areaArray) {
                    
                    //                NSLog(@"[tempDict[Name] = %@",tempDict[@"Name"]);
                    //                NSLog(@"provinceBtn.titleLabel.text = %@",provinceBtn.titleLabel.text);
                    if([tempDict[@"Name"] isEqualToString:areaBtn.titleLabel.text] )
                    {
                        areaid = [NSString stringWithFormat:@"%@",tempDict[@"Code"]];
                        [_pickerView reloadComponent:AreaTAG];
                        [_pickerView selectRow:i inComponent:AreaTAG animated:NO];
//                        [_pickerView reloadComponent:AreaTAG];
                        break;
                    }
                    i++;
                    
                }
               
           }
            
            
            loadDataFlag = NO;
            
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            [_pickerView reloadAllComponents];
//            [_pickerView reloadComponent:1];
//            [_pickerView reloadComponent:2];
        }
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:[dict[@"data"] substringToIndex:4] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        [_pickerView reloadAllComponents];
        
    }
}





#pragma mark - textView delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    relayoutViewFlag = YES;
}


#pragma mark - click action
- (void)btn_passwordAction:(UIButton *)sender
{
    RegisterViewController * registerViewController = [[RegisterViewController alloc] init];
    
    registerViewController.pageMode = MODE_change;
    [self.navigationController pushViewController:registerViewController animated:YES];
//    [self presentViewController:registerViewController animated:YES completion:^{
//        
//    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (alertView.tag) {
        case HighTAG:
        {
            UITextField *textNum=[alertView textFieldAtIndex:0];
            if ([textNum.text intValue]==0) {
            // [Dialog simpleToast:@"请正确"];
            return;
            }
            else
            {
                [highBtn setTitle:[NSString stringWithFormat:@"%@cm",textNum.text] forState:UIControlStateNormal];
            }
        }
            break;
        case WeightTAG:
        {
            UITextField *textNum=[alertView textFieldAtIndex:0];
            if ([textNum.text intValue]==0) {
                // [Dialog simpleToast:@"请正确"];
                return;
            }
            else
            {
                [weightBtn setTitle:[NSString stringWithFormat:@"%@Kg",textNum.text] forState:UIControlStateNormal];
            }

        }
            break;
            
        case AgeTAG:
        {
            UITextField *textNum=[alertView textFieldAtIndex:0];
            if ([textNum.text intValue]==0) {
                // [Dialog simpleToast:@"请正确"];
                return;
            }
            else
            {
                [ageBtn setTitle:[NSString stringWithFormat:@"%@岁",textNum.text] forState:UIControlStateNormal];
            }
        }
            break;
        case LearnTimeTAG:
        {
            UITextField *textNum=[alertView textFieldAtIndex:0];
            if ([textNum.text intValue]==0) {
                // [Dialog simpleToast:@"请正确"];
                return;
            }
            else
            {
                [learnTimeBtn setTitle:[NSString stringWithFormat:@"%@年",textNum.text] forState:UIControlStateNormal];
            }
            
        }
            break;

        default:
            break;
    }
  
}


-(void)infoBtnClick:(UIButton *)sender
{
    _pickerView.tag = sender.tag;
   // [self.view addSubview:_pickerView];
    
    if(infoArr.count>0&&infoArr != nil)
    {
        [infoArr removeAllObjects];
    }
    
    switch (sender.tag) {
        case HighTAG:
        {
            
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入身高（Cm）" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            
            alert.tag=sender.tag;
            alert.alertViewStyle=UIAlertViewStylePlainTextInput;
            UITextField *tf = [alert textFieldAtIndex:0];
            tf.keyboardType = UIKeyboardTypeNumberPad;
            
            [alert show];
            
        }
            break;
        case WeightTAG:
        {
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入体重（Kg）" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            
            alert.tag=sender.tag;
            alert.alertViewStyle=UIAlertViewStylePlainTextInput;
            UITextField *tf = [alert textFieldAtIndex:0];
            tf.keyboardType = UIKeyboardTypeNumberPad;
            
            [alert show];
            
        }
            break;
        case AgeTAG:
        {
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入年龄（岁）" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            
            alert.tag=sender.tag;
            alert.alertViewStyle=UIAlertViewStylePlainTextInput;
            UITextField *tf = [alert textFieldAtIndex:0];
            tf.keyboardType = UIKeyboardTypeNumberPad;
            
            [alert show];
            
        }
            break;
        case LearnTimeTAG:
        {
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入习武时间（年）" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            
            alert.tag=sender.tag;
            alert.alertViewStyle=UIAlertViewStylePlainTextInput;
            UITextField *tf = [alert textFieldAtIndex:0];
            tf.keyboardType = UIKeyboardTypeNumberPad;
            
            [alert show];
            
        }
            break;
        case ProvinceTAG:
            case CityTAG:
            case AreaTAG:
        {
            [infoArr addObjectsFromArray:provinceArray];
            [self.view addSubview:_pickerView];
            clickAddBtn = YES;
//            [_pickerView reloadAllComponents];
            [self reLayoutTableViewHeight:_pickerView.frame.size.height];
        }
            break;
               default:
            break;
    }
}



-(void)sexBtnClick:(UIButton *)sender
{
    sender.selected = YES;
    
    if(sender == boyBtn)
    {
        grilBtn.selected = NO;
    }
    else
    {
        boyBtn.selected = NO;
    }
}

-(void)tapViewAction:(id)sender
{
    if( _pickerView.superview != nil)
    {
        [_pickerView removeFromSuperview];
        [self reLayoutTableViewHeight:0];
    }
    if(birthDayPicker.superview!=nil)
    {
        [birthDayPicker removeFromSuperview];
        [self reLayoutTableViewHeight:0];
    }
    
    [self.view endEditing:YES];
    
}

-(void)clickRightButton:(UIButton *)sender
{
    [self setuserInfo];
}

-(void)ageBtnClick:(UIButton *)sender
{
    birthDayPicker
    = [[UUDatePicker alloc]initWithframe:CGRectMake(0, SCREEN_HEIGHT - 200, SCREEN_WIDTH, 200)
                             PickerStyle:UUDateStyle_YearMonthDay
                             didSelected:^(NSString *year,
                                           NSString *month,
                                           NSString *day,
                                           NSString *hour,
                                           NSString *minute,
                                           NSString *weekDay) {
                                 
                                 NSString *scrolDate = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
                                 birthday = scrolDate;
                                [sender setTitle:[self calculateAge:birthday] forState:UIControlStateNormal];
                                
                             }];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];

    
    birthDayPicker.minLimitDate = [formatter dateFromString:@"1900-01-01"];
    birthDayPicker.maxLimitDate = [NSDate date];
    if( birthday != nil && birthday > 0)
    {
        NSDate *date = [formatter dateFromString:birthday];
        NSLog(@"date = %@",date);
        birthDayPicker.ScrollToDate =date ;
    }
    else
    {
        birthDayPicker.ScrollToDate = [NSDate date];
    }
    
    [self.view addSubview:birthDayPicker];
}
#pragma mark - userheadview delegate

-(void)userHeadViewClick
{
    [self editPortrait];
}

#pragma mark - 图片截取

- (void)editPortrait {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    headView.headImgView.image = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
        [self saveImage:editedImage withName:@"avatar.jpg"];
        
        headView.headImgView.image = editedImage ;
        
//        headView = [[UserHeadView alloc] initWithFrame:CGRectMake(GapToLeft, 10,  2*_cellHeight - 20, 2*_cellHeight - 20)
//                                                andImg:editedImage];
//        [_mainTableView reloadData];
   //     headView.headImgView = [];
        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"avatar.jpg"];
        NSLog(@"选择完成");
        //[SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeBlack];
        NSData* imageData = UIImageJPEGRepresentation(editedImage, 0.8) ;
        NSString *imagebase64= [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"UploadCallBack:"];
        [dataprovider uploadHeadImg:[Toolkit getUserID] andImgData:imagebase64 andImgName:nil];
    }];
}

#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}


#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}
#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}
- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}
-(void)UploadCallBack:(id)dict
{
    DLog(@"%@",dict);
    @try {
        if([dict[@"code"] integerValue] == 200)
        {
            imgPath = dict[@"data"][@"ImagePath"];
            
            [self getUserInfo];
        }
        else
        {
            UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"data"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
            [alert show];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    [SVProgressHUD dismiss];
//    if ([dict[@"code"] intValue]==200) {
//        imgAvatar=[dict[@"datas"][@"imgsrc"][@"imgsrc"] isEqual:[NSNull null]]?@"":dict[@"datas"][@"imgsrc"][@"imgsrc"];
//    }
//    else
//    {
//        [SVProgressHUD showErrorWithStatus:dict[@"message"] maskType:SVProgressHUDMaskTypeBlack];
//    }
}


#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _sectionNum;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 1)
    {
        
        return 6;
    }
    return 1;
    
}

#pragma mark - setting for cell

#define BtnWidth  60
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    @try {
        if(indexPath.section == 0)
        {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight*2)];
            cell.backgroundColor = ItemsBaseColor;
            
            
            headView.delegate  = self;
            
            [headView makeSelfRound];
            
            
            
            userName = [[UILabel alloc] initWithFrame:CGRectMake((headView.frame.origin.x + headView.frame.size.width +10),
                                                                 20, 100,((headView.frame.size.height )/3 -5) )];
            // userName.text = @"成龙";
            userName.textColor = [UIColor whiteColor];
            userName.font = [UIFont systemFontOfSize:14];
            [cell addSubview:userName];
            
            idLab = [[UILabel alloc] initWithFrame:CGRectMake((headView.frame.origin.x + headView.frame.size.width +10),
                                                              (userName.frame.origin.y+userName.frame.size.height), 200,
                                                              ((headView.frame.size.height )/3 -5))];
            idLab.textColor = [UIColor whiteColor];
            //  idLab.text = @"ID:12345678900";
            idLab.font = [UIFont systemFontOfSize:14];
            [cell addSubview:idLab];
            
            jiFenLab = [[UILabel alloc] initWithFrame:CGRectMake((headView.frame.origin.x + headView.frame.size.width +10),
                                                                 (idLab.frame.origin.y+idLab.frame.size.height), 200,
                                                                 userName.frame.size.height)];
            //  jiFenLab.text = @"积分：1000";
            jiFenLab.textColor = [UIColor whiteColor];
            jiFenLab.font = [UIFont systemFontOfSize:14];
            [cell addSubview:jiFenLab];
            
            
            [cell addSubview:headView];
            cell.backgroundColor = ItemsBaseColor;
            
            if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
            {
                [cell setSeparatorInset:UIEdgeInsetsZero];
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            return cell;
        }
        else if(indexPath.section == 1)
        {
            
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight)];
            cell.backgroundColor = ItemsBaseColor;
            
            switch (indexPath.row) {
                case 0:
                {
                    UILabel * titlLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 0, 40, _cellHeight)];
                    titlLab.text =@"昵称:";
                    titlLab.textColor = [UIColor whiteColor];
                    titlLab.font = [UIFont systemFontOfSize:14];
                    [cell addSubview:titlLab];
                    
                    nickName.frame =  CGRectMake((titlLab.frame.size.width + titlLab.frame.origin.x) + 23,
                                                 0, SCREEN_HEIGHT - (titlLab.frame.size.width + titlLab.frame.origin.x)
                                                 , _cellHeight);
                    nickName.backgroundColor = ItemsBaseColor;
                    nickName.placeholder = @"请输入您的昵称";
                    nickName.textColor = [UIColor whiteColor];
                    
                    [cell addSubview:nickName];
                    
                }
                    break;
                case 1:
                {
                    UILabel * titlLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 0, 40, _cellHeight)];
                    titlLab.text =@"性别:";
                    titlLab.textColor = [UIColor whiteColor];
                    titlLab.font = [UIFont systemFontOfSize:14];
                    [cell addSubview:titlLab];
                    
                    boyBtn.frame = CGRectMake((titlLab.frame.size.width + titlLab.frame.origin.x + 10) + 5,
                                              5, 50, _cellHeight - 10);
                    
                    [boyBtn setTitle:@"男" forState:UIControlStateNormal];
                    [boyBtn setImage:[UIImage imageNamed:@"point"] forState:UIControlStateNormal];
                    [boyBtn setImage:[UIImage imageNamed:@"pointH"] forState:UIControlStateSelected];
                    [boyBtn addTarget:self action:@selector(sexBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    // boyBtn.selected = YES;
                    [cell addSubview:boyBtn];
                    
                    grilBtn.frame = CGRectMake((boyBtn.frame.size.width + boyBtn.frame.origin.x+20),
                                               5, 50, _cellHeight - 10);
                    
                    [grilBtn setTitle:@"女" forState:UIControlStateNormal];
                    [grilBtn setImage:[UIImage imageNamed:@"point"] forState:UIControlStateNormal];
                    [grilBtn setImage:[UIImage imageNamed:@"pointH"] forState:UIControlStateSelected];
                    [grilBtn addTarget:self action:@selector(sexBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:grilBtn];
                    
                }
                    break;
                case 2:
                {
                    UILabel * titlLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 0, 40, _cellHeight)];
                    titlLab.text =@"身高:";
                    titlLab.textColor = [UIColor whiteColor];
                    titlLab.font = [UIFont systemFontOfSize:14];
                    [cell addSubview:titlLab];
                    
                    
                    highBtn.frame =  CGRectMake((titlLab.frame.size.width + titlLab.frame.origin.x + 10) + 15,
                                                5, BtnWidth, _cellHeight - 10);
                    highBtn.backgroundColor = BACKGROUND_COLOR;
                    [highBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    //                UIImageView *btnCornerView = [[UIImageView alloc] initWithFrame:CGRectMake((highBtn.frame.size.width - 15),
                    //                                                                                          (highBtn.frame.size.height - 15),
                    //                                                                                          13, 13)];
                    //                btnCornerView.image = [UIImage imageNamed:@"btnCorner"];
                    //                [highBtn addSubview:btnCornerView];
                    [highBtn addTarget:self action:@selector(infoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    highBtn.tag = HighTAG;
                    [cell addSubview:highBtn];
                    
                    UILabel * weightTitlLab = [[UILabel alloc] initWithFrame:CGRectMake((highBtn.frame.size.width + highBtn.frame.origin.x + 10), 0, 65, _cellHeight)];
                    weightTitlLab.text =@"体重:";
                    weightTitlLab.textColor = [UIColor whiteColor];
                    weightTitlLab.font = [UIFont systemFontOfSize:14];
                    
                    [cell addSubview:weightTitlLab];
                    
                    weightBtn.frame = CGRectMake((weightTitlLab.frame.size.width + weightTitlLab.frame.origin.x + 10),
                                                 5, BtnWidth, _cellHeight - 10);
                    weightBtn.backgroundColor = BACKGROUND_COLOR;
                    [weightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    weightBtn.tag = WeightTAG;
                    
                    [weightBtn addTarget:self action:@selector(infoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:weightBtn];
                    
                    
                }
                    break;
                case 3:
                {
                    UILabel * titlLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 0, 40, _cellHeight)];
                    titlLab.text =@"年龄:";
                    titlLab.textColor = [UIColor whiteColor];
                    titlLab.font = [UIFont systemFontOfSize:14];
                    [cell addSubview:titlLab];
                    
                    
                    ageBtn.frame = CGRectMake((titlLab.frame.size.width + titlLab.frame.origin.x + 10) + 15,
                                              5, BtnWidth, _cellHeight - 10);
                    ageBtn.backgroundColor = BACKGROUND_COLOR;
                    [ageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    
                    [ageBtn addTarget:self action:@selector(ageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    ageBtn.tag = AgeTAG;
                    [cell addSubview:ageBtn];
                    
                    UILabel * timeTitlLab = [[UILabel alloc] initWithFrame:CGRectMake((ageBtn.frame.size.width + ageBtn.frame.origin.x + 10), 0, 65, _cellHeight)];
                    timeTitlLab.text =@"习武时间:";
                    timeTitlLab.textColor = [UIColor whiteColor];
                    timeTitlLab.font = [UIFont systemFontOfSize:14];
                    
                    [cell addSubview:timeTitlLab];
                    
                    learnTimeBtn.frame = CGRectMake((timeTitlLab.frame.size.width + timeTitlLab.frame.origin.x + 10),
                                                    5, BtnWidth, _cellHeight - 10);
                    learnTimeBtn.backgroundColor = BACKGROUND_COLOR;
                    [learnTimeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    learnTimeBtn.tag = LearnTimeTAG;
                    
                    [learnTimeBtn addTarget:self action:@selector(infoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:learnTimeBtn];
                    
                }
                    break;
                case 4:
                {
                    UILabel * titlLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 0, 60, _cellHeight)];
                    titlLab.text =@"所在地:";
                    titlLab.textColor = [UIColor whiteColor];
                    titlLab.font = [UIFont systemFontOfSize:14];
                    [cell addSubview:titlLab];
                    
                    provinceBtn.frame = CGRectMake((titlLab.frame.size.width + titlLab.frame.origin.x + 10) - 5,
                                                   5, 100, _cellHeight - 10);
                    provinceBtn.backgroundColor = BACKGROUND_COLOR;
                    [provinceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    UIImageView *btnCornerView = [[UIImageView alloc] initWithFrame:CGRectMake((provinceBtn.frame.size.width - 15),
                                                                                               (provinceBtn.frame.size.height - 15),
                                                                                               13, 13)];
                    btnCornerView.image = [UIImage imageNamed:@"btnCorner"];
                    [provinceBtn addSubview:btnCornerView];
                    [provinceBtn addTarget:self action:@selector(infoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    provinceBtn.tag = ProvinceTAG;
                    [cell addSubview:provinceBtn];
                    
                    cityBtn.frame = CGRectMake((provinceBtn.frame.size.width + provinceBtn.frame.origin.x + 2), 5, 100, _cellHeight - 10);
                    cityBtn.backgroundColor = BACKGROUND_COLOR;
                    [cityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    UIImageView *btnCornerView2 = [[UIImageView alloc] initWithFrame:CGRectMake((cityBtn.frame.size.width - 15),
                                                                                                (cityBtn.frame.size.height - 15),
                                                                                                13, 13)];
                    btnCornerView2.image = [UIImage imageNamed:@"btnCorner"];
                    [cityBtn addSubview:btnCornerView2];
                    [cityBtn addTarget:self action:@selector(infoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    cityBtn.tag = CityTAG;
                    [cell addSubview:cityBtn];
                    
                    
                    areaBtn.frame = CGRectMake((cityBtn.frame.size.width + cityBtn.frame.origin.x + 2),
                                               5, BtnWidth, _cellHeight - 10);
                    areaBtn.backgroundColor = BACKGROUND_COLOR;
                    [areaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    areaBtn.tag = AreaTAG;
                    UIImageView *btnCornerView3 = [[UIImageView alloc] initWithFrame:CGRectMake((cityBtn.frame.size.width - 15),
                                                                                                (cityBtn.frame.size.height - 15),
                                                                                                13, 13)];
                    btnCornerView3.image = [UIImage imageNamed:@"btnCorner"];
                    [areaBtn addSubview:btnCornerView3];
                    [areaBtn addTarget:self action:@selector(infoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//                    [cell addSubview:areaBtn];
                    
                }
                    break;
                case 5:
                {
                    UILabel * titlLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 0, 80, _cellHeight)];
                    titlLab.text =@"个人简历:";
                    titlLab.textColor = [UIColor whiteColor];
                    titlLab.font = [UIFont systemFontOfSize:14];
                    [cell addSubview:titlLab];
                    
                    
                    introductionText.frame = CGRectMake((titlLab.frame.size.width+titlLab.frame.origin.x + 5) - 19 , 5,
                                                        (SCREEN_WIDTH - 10 - (titlLab.frame.size.width+titlLab.frame.origin.x + 5)) + 19,
                                                        (3*_cellHeight - 5*2) ) ;
                    
                    //                introductionText.text = @"喜欢习武喜欢习武喜欢习武喜欢习武喜欢习武喜欢习武喜欢习武喜欢习武喜欢习武喜欢习武";
                    introductionText.textColor = [UIColor whiteColor];
                    introductionText.backgroundColor = BACKGROUND_COLOR;
                    introductionText.font = [UIFont systemFontOfSize:14];
                    introductionText.textAlignment = NSTextAlignmentLeft;
                    introductionText.delegate = self;
                    tempIndexPath = indexPath;
                    [cell addSubview:introductionText];
                }
                    break;
                    
                    break;
                default:
                    break;
            }
            
            if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
            {
                [cell setSeparatorInset:UIEdgeInsetsZero];
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            return cell;
            
        }
        else if(indexPath.section == 2)
        {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight)];
            cell.backgroundColor = ItemsBaseColor;
            
            UILabel * titlLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 0, 80, _cellHeight)];
            titlLab.text =@"修改密码:";
            titlLab.textColor = [UIColor whiteColor];
            titlLab.font = [UIFont systemFontOfSize:14];
            [cell addSubview:titlLab];
            
            UIImageView *rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right"]];
            //        rightView.backgroundColor = [UIColor orangeColor];
            rightView.frame = CGRectMake((SCREEN_WIDTH - 20 -20), 0, 15, 15);
            rightView.center = CGPointMake((SCREEN_WIDTH - 15 -10), _cellHeight/2);
            rightView.contentMode = UIViewContentModeScaleAspectFit;
            [cell addSubview:rightView];
            
            UIButton * btn_password = [UIButton buttonWithType:(UIButtonTypeSystem)];
            btn_password.frame = CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight);
            [cell addSubview:btn_password];
            //        btn_password.backgroundColor = [UIColor orangeColor];
            [btn_password addTarget:self action:@selector(btn_passwordAction:) forControlEvents:(UIControlEventTouchUpInside)];
            
            
            if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
            {
                [cell setSeparatorInset:UIEdgeInsetsZero];
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            return cell;
            
        }
        else
        {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight)];
            cell.backgroundColor = ItemsBaseColor;
            
            
            if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
            {
                [cell setSeparatorInset:UIEdgeInsetsZero];
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            return cell;
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
  
    
}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0)
    {
        return 2*_cellHeight;
    }
    if(indexPath.section == 1)
    {
        if(indexPath.row == 5)
        {
            return 3*_cellHeight;
        }
    }
    
    return _cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    NSLog(@"click cell section : %ld row : %ld",(long)indexPath.section,(long)indexPath.row);
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor); CGContextFillRect(context, rect); //上分割线，
    
    CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1)); //下分割线
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(5, 10, 100, 10));
}


//设置划动cell是否出现del按钮，可供删除数据里进行处理

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

- (UITableViewCellEditingStyle)tableView: (UITableView *)tableView editingStyleForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  YES;
}


-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  @"删除";
}

//设置选中的行所执行的动作

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return indexPath;
    
}

#pragma mark - setting for section
//设置section的header view

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView = [[UIView alloc] init];
    
    return tempView;
}

//设置section header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0;
}

//设置section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section ==0||section ==1)
        return 10;
    else
        return 0;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
