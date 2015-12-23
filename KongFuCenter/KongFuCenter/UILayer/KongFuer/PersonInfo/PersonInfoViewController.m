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
#define ProvinceTAG     (2015+5)
#define CityTAG         (2015+6)
#define AreaTAG         (2015+7)
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
    /*省*/
    NSMutableArray *provinceArr;
    /*市*/
    NSMutableArray *cityArr;
    /*区／县*/
    NSMutableArray  *areaArr;
    
    NSString *imgPath;
    BOOL loadDataFlag;
    
#pragma mark - other Views
    
    UILabel *userName ;
    UILabel *idLab;
    UILabel *jiFenLab ;
    UITextField *nickName;
    UserHeadView  *headView ;
    
    
}
@end
#define GapToLeft   20
@implementation PersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"left"];
    [self addRightbuttontitle:@"保存"];
    infoArr = [NSMutableArray array];
    provinceArr = [NSMutableArray array];
    cityArr  = [NSMutableArray array];
    areaArr = [NSMutableArray array];
    loadDataFlag = YES;
    [self initViews];
    
    [self getDatas];
    // Do any additional setup after loading the view.
}


-(void)initViews
{
    _cellHeight = SCREEN_HEIGHT/12;
    _sectionNum = 3;
    
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height )];
    _mainTableView.backgroundColor = BACKGROUND_COLOR;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorColor =  Separator_Color;
    _mainTableView.tableFooterView = [[UIView alloc] init];
    _mainTableView.separatorInset = UIEdgeInsetsZero;
    headView = [[UserHeadView alloc] initWithFrame:CGRectMake(GapToLeft, 10,  2*_cellHeight - 20, 2*_cellHeight - 20)
                                        andImgName:@"headImg"];
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
     return 1;
 }
 
 // pickerView 每列个数
 - (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
     return infoArr.count;
 }
 
 // 每列宽度
 - (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
     
     return 180;
 }
 // 返回选中的行
 - (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (pickerView.tag  ) {
        case ProvinceTAG:
        {
            NSString *provinceId;
            
            [provinceBtn setTitle:[infoArr objectAtIndex:row][@"Name"] forState:UIControlStateNormal];
            for (NSDictionary *tempDict in provinceArr) {
                NSLog(@"[tempDict[Name] = %@",tempDict[@"Name"]);
                NSLog(@"provinceBtn.titleLabel.text = %@",provinceBtn.titleLabel.text);
                if([tempDict[@"Name"] isEqualToString:provinceBtn.titleLabel.text] )
                {
                    provinceId = [NSString stringWithFormat:@"%@",tempDict[@"Code"]];
                    break;
                }
                
            }
            if(provinceId == nil)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"城市获取失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                return;
            }
            [self getCityByProvince:provinceId];

        }
            break;
        case CityTAG:
        {
            [cityBtn setTitle:[infoArr objectAtIndex:row][@"Name"] forState:UIControlStateNormal];
            NSString *cityCode;
            
            for (NSDictionary *tempDict in cityArr) {
                
                if([tempDict[@"Name"] isEqualToString:cityBtn.titleLabel.text] )
                {
                    cityCode = [NSString stringWithFormat:@"%@",tempDict[@"Code"]];
                    break;
                }
                
            }
            if(cityCode == nil)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"城市获取失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                return;
            }
            [self getAreaByCity:cityCode];

        }
            break;
        case AreaTAG:
            [areaBtn setTitle:[infoArr objectAtIndex:row][@"Name"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
}
                 
                 //返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return  infoArr[row][@"Name"];
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

-(void)getDatas
{
    [self getUserInfo];
    
}

-(void)getUserInfo
{
    [SVProgressHUD showWithStatus:@"刷新中" maskType:SVProgressHUDMaskTypeBlack];
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
            
            
            NSString * url=[NSString stringWithFormat:@"%@%@",Kimg_path,tempDict[@"PhotoPath"]];
            
            [headView.headImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"headImg"]];
            
            jiFenLab.text = [NSString stringWithFormat:@"积分：%@",tempDict[@"Credit"]];
            userName.text = [NSString stringWithFormat:@"%@",tempDict[@"NicName"]];
            idLab.text = [NSString stringWithFormat:@"ID:%@",tempDict[@"UserName"]];
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
            [ageBtn setTitle:[NSString stringWithFormat:@"%@岁",tempDict[@"Experience"]] forState:UIControlStateNormal];
        
            [learnTimeBtn setTitle:[NSString stringWithFormat:@"%@年",tempDict[@"Experience"]] forState:UIControlStateNormal];
            nickName.text =tempDict[@"NicName"];
            [provinceBtn setTitle:tempDict[@"HomeAreaprovinceName"] forState:UIControlStateNormal];
            [cityBtn setTitle:tempDict[@"HomeAreaCityName"] forState:UIControlStateNormal];
            [areaBtn setTitle:tempDict[@"HomeAreaCountyName"] forState:UIControlStateNormal];
            
            
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
    
    NSString *areaId = @"1";
    
    for (NSDictionary *tempDict in areaArr) {
        
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
                      andAddr:@"19387"
                      andExpe:[learnTimeBtn.titleLabel.text substringToIndex:(learnTimeBtn.titleLabel.text.length - 1)]];
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
{//    [SVProgressHUD showWithStatus:@"刷新中" maskType:SVProgressHUDMaskTypeBlack];
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
            if(provinceArr != nil || provinceArr.count > 0)
                [provinceArr removeAllObjects];

            [provinceArr addObjectsFromArray:dict[@"data"]];
            
            
            NSString *provinceId;
            
            for (NSDictionary *tempDict in provinceArr) {
                NSLog(@"[tempDict[Name] = %@",tempDict[@"Name"]);
                NSLog(@"provinceBtn.titleLabel.text = %@",provinceBtn.titleLabel.text);
                if([tempDict[@"Name"] isEqualToString:provinceBtn.titleLabel.text] )
                {
                    provinceId = [NSString stringWithFormat:@"%@",tempDict[@"Code"]];
                    break;
                }
                
            }
            if(provinceId == nil)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"城市获取失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                return;
            }
            [self getCityByProvince:provinceId];
            

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

-(void)getCityByProvince:(NSString *)ProvinceId
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"getCityByProvinceCallBack:"];
    [dataprovider getCityByProvinceCode:ProvinceId];

}

-(void)getCityByProvinceCallBack:(id)dict
{
    
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try {
            if(cityArr != nil || cityArr.count > 0)
                [cityArr removeAllObjects];
            [cityArr addObjectsFromArray:dict[@"data"]];
            
           
            if(loadDataFlag == NO)//首次只填充city的数据
            {
                if(cityArr.count > 0)
                {
                    [cityBtn setTitle:cityArr[0][@"Name"] forState:UIControlStateNormal];
                    
                }
                [infoArr addObjectsFromArray:dict[@"data"]];
                [self.view addSubview:_pickerView];
                [_pickerView reloadAllComponents];
                [self reLayoutTableViewHeight:_pickerView.frame.size.height];
                
                
                NSString *cityCode;
                
                for (NSDictionary *tempDict in cityArr) {
                    
                    if([tempDict[@"Name"] isEqualToString:cityBtn.titleLabel.text] )
                    {
                        cityCode = [NSString stringWithFormat:@"%@",tempDict[@"Code"]];
                        break;
                    }
                    
                }
                if(cityCode == nil)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"城市获取失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                    return;
                }
                [self getAreaByCity:cityCode];

            }
            loadDataFlag = NO;

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

-(void)getAreaByCity:(NSString *)cityCode
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"getAreaByCityCallBack:"];
    [dataprovider getCityByProvinceCode:cityCode];
    

}
-(void)getAreaByCityCallBack:(id)dict
{
    
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try {
            if(areaArr != nil || areaArr.count > 0)
                [areaArr removeAllObjects];
            
            [areaArr addObjectsFromArray:dict[@"data"]];
            
            if(areaArr.count > 0)
                [areaBtn  setTitle:areaArr[0][@"Name"] forState:UIControlStateNormal] ;
            [infoArr addObjectsFromArray:dict[@"data"]];
            [self.view addSubview:_pickerView];
            [_pickerView reloadAllComponents];
            [self reLayoutTableViewHeight:_pickerView.frame.size.height];
            
            
            
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





#pragma mark - textView delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    relayoutViewFlag = YES;
}


#pragma mark - click action
- (void)btn_passwordAction:(UIButton *)sender
{
    RegisterViewController * registerViewController = [[RegisterViewController alloc] init];
    
    registerViewController.pageMode = 2;
    [self presentViewController:registerViewController animated:YES completion:^{
        
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *textNum=[alertView textFieldAtIndex:0];
    switch (alertView.tag) {
        case HighTAG:
        {
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
        {
            [infoArr addObjectsFromArray:provinceArr];
            [self.view addSubview:_pickerView];
            [_pickerView reloadAllComponents];
            [self reLayoutTableViewHeight:_pickerView.frame.size.height];
        }
            break;
        case CityTAG:
        {
            NSString *provinceId;
            
            for (NSDictionary *tempDict in provinceArr) {
                NSLog(@"[tempDict[Name] = %@",tempDict[@"Name"]);
                NSLog(@"provinceBtn.titleLabel.text = %@",provinceBtn.titleLabel.text);
                if([tempDict[@"Name"] isEqualToString:provinceBtn.titleLabel.text] )
                {
                    provinceId = [NSString stringWithFormat:@"%@",tempDict[@"Code"]];
                    break;
                }
                
            }
            if(provinceId == nil)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"城市获取失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                return;
            }
            [self getCityByProvince:provinceId];
            
          
        }
            break;
        case AreaTAG:
        {
            NSString *cityCode;
            
            for (NSDictionary *tempDict in cityArr) {
                
                if([tempDict[@"Name"] isEqualToString:cityBtn.titleLabel.text] )
                {
                    cityCode = [NSString stringWithFormat:@"%@",tempDict[@"Code"]];
                    break;
                }
                
            }
            if(cityCode == nil)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"城市获取失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                return;
            }
            [self getAreaByCity:cityCode];
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
    
    
    [self.view endEditing:YES];
    
}

-(void)clickRightButton:(UIButton *)sender
{
    [self setuserInfo];
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

#define BtnWidth    60
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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

                [ageBtn addTarget:self action:@selector(infoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
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
                                                                     5, BtnWidth, _cellHeight - 10);
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
                
                cityBtn.frame = CGRectMake((provinceBtn.frame.size.width + provinceBtn.frame.origin.x + 2), 5, BtnWidth, _cellHeight - 10);
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
                [cell addSubview:areaBtn];
                
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
                
                introductionText.text = @"喜欢习武喜欢习武喜欢习武喜欢习武喜欢习武喜欢习武喜欢习武喜欢习武喜欢习武喜欢习武";
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
