//
//  NewPlanViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/9.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "NewPlanViewController.h"

@interface NewPlanViewController ()
{
@private
    NSInteger _cellCount;
    NSInteger _cellHeight;
    NSInteger _cellTextViewHeight;//包含textview的cell的高度
    UITableView *_mainTableView;
    UITextField *_titleField;//标题
    UITextView *_textView;
    CGFloat _keyHeight;
    UIButton *tipbtn;
    
    
    NSString *startDateStr;
    NSString *endDateStr;
    NSString *updataTimeStr;
    NSString *cateId;
    
    UILabel *textViewHolderLab;
}
@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray   *assetsArray;

@end

@implementation NewPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"left"];
    _cellHeight = self.view.frame.size.height/12;
    [self addRightbuttontitle:@"确定"];
    
    img_uploaded = [NSMutableArray array];
    img_prm = [NSMutableArray array];
    allImgsPicked = [NSMutableDictionary dictionary];
    
    [allImgsPicked setObject:[NSMutableArray array] forKey:PICPICKER_IMGS_KEY];
    [allImgsPicked setObject:[NSMutableArray array] forKey:PHOTO_IMGS_KEY];
    [self initViews];
    
    //添加键盘的监听事件
    
    //    //注册通知,监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    //
    //    //注册通知,监听键盘消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden) name:UIKeyboardDidHideNotification object:nil];

    
    // Do any additional setup after loading the view.
}




// 键盘弹出时
-(void)keyboardDidShow:(NSNotification *)notification
{
    
    //获取键盘高度
    NSValue *keyboardObject = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect;
    [keyboardObject getValue:&keyboardRect];
    
    
    //调整放置有textView的view的位置
    
    //设置动画
    [UIView beginAnimations:nil context:nil];
    
    //定义动画时间
    [UIView setAnimationDuration:0.5];
    //               CGRectMake(0, self.view.frame.size.height-keyboardRect.size.height-kViewHeight, 320, kViewHeight)]
    //设置view的frame，往上平移
    [_mainTableView setFrame:CGRectMake(0, Header_Height, self.view.frame.size.width,self.view.frame.size.height -Header_Height -keyboardRect.size.height)];
    
  //  [_mainTableView scrollToRowAtIndexPath:tempIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    

//    _cellTextViewHeight = _mainTableView.frame.size.height - 3*_cellHeight;
//    [_mainTableView reloadData];
    [UIView commitAnimations];
    
}

//键盘消失时
-(void)keyboardDidHidden
{
    //定义动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
        //设置view的frame，往下平移
    [_mainTableView setFrame:CGRectMake(0, Header_Height, self.view.frame.size.width,self.view.frame.size.height - Header_Height)];
 //   _cellTextViewHeight = _mainTableView.frame.size.height - 3*_cellHeight;
 //   [_mainTableView reloadData];
    [UIView commitAnimations];
    
}


-(void) initViews
{
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, self.view.frame.size.width,self.view.frame.size.height - Header_Height )];
    _mainTableView.backgroundColor =ItemsBaseColor;
    [_mainTableView setDelegate:self];
    [_mainTableView setDataSource:self];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//UITableViewCellSeparatorStyleSingleLine;
    _mainTableView.separatorInset = UIEdgeInsetsZero;
  //  _mainTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _mainTableView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height);
    
    _mainTableView.separatorColor =  Separator_Color;
    //_mainTableView.separatorEffect = ;
    
    
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
    _cellCount = 4;
    _cellTextViewHeight = SCREEN_HEIGHT - 3*_cellHeight - 64;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:) ];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    if(_titleField ==nil)
        _titleField = [[UITextField alloc]init];
    if(_textView == nil)
        _textView = [[UITextView alloc] init];
    if(tipbtn==nil)
    {
        tipbtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150 ), 0, 150, _cellHeight)];
        if(self.planMode !=nil)
        {
            [tipbtn setTitle:self.planMode forState:UIControlStateNormal];
            tipbtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        }
    }
    [self.view addSubview:_mainTableView];
    textViewHolderLab = [[UILabel alloc] init];
    textViewHolderLab.text = @"发帖内容";
    textViewHolderLab.textColor = [UIColor grayColor];
    
    
    picShowView = [[UIView alloc] init];
    if(defaultImgPath == nil || defaultImgPath.count==0)
        picShowView.hidden = YES;
}


-(void)setDefaultDict:(NSDictionary *)DefaultDict
{
    _DefaultDict = DefaultDict;
    
    
    if(defaultImgPath==nil)
    {
        defaultImgPath = [NSMutableArray array];
    }
    else
    {
        [defaultImgPath removeAllObjects];
    }
    NSArray *tempArr = _DefaultDict[@"planImgList"];
    
    for (NSDictionary *tempDict in tempArr) {
       
        NSString *url = [NSString stringWithFormat:@"%@%@",Kimg_path,tempDict[@"ImagePath"]];
        [defaultImgPath addObject:url];
    }
    
    
    
    if(defaultImgPath.count>0)
    {
        picShowView.hidden = NO;
    }
    
    if (_cellCount == 0) {
        _cellHeight = self.view.frame.size.height/12;
        
    }
    
    if(_titleField ==nil)
        _titleField = [[UITextField alloc]init];
    if(_textView == nil)
        _textView = [[UITextView alloc] init];
    if(tipbtn==nil)
    {
        tipbtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 120 ), 0, 120, _cellHeight)];
        if(self.planMode !=nil)
        {
            [tipbtn setTitle:self.planMode forState:UIControlStateNormal];
            tipbtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        }

    }

    
    @try {
        if (_DefaultDict == nil) {
            return;
        }
        _titleField.text  =_DefaultDict[@"planTitle"];
        cateId = _DefaultDict[@"planCateId"];
        _textView.text = _DefaultDict[@"planContent"];
        textViewHolderLab.hidden = YES;
        switch ([cateId integerValue]) {
            case WeekPlan:
                [tipbtn setTitle:@"周计划" forState:UIControlStateNormal];
                break;
            case MonthPlan:
                [tipbtn setTitle:@"月计划" forState:UIControlStateNormal];
                break;
            case SeasonPlan:
                [tipbtn setTitle:@"季计划" forState:UIControlStateNormal];
                break;
            case YearPlan:
                [tipbtn setTitle:@"年计划" forState:UIControlStateNormal];
                break;

            default:
                break;
        }
        tipbtn.titleLabel.textAlignment = NSTextAlignmentLeft;
         [self getDateAndTime];
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

-(void)pushViewAction:(UIButton *)sender
{
    ChoosePlanTypeViewController *choosePlanViewCtl = [[ChoosePlanTypeViewController alloc] init];
    choosePlanViewCtl.navtitle = @"选择计划选项";
    choosePlanViewCtl.delegate = self;
    [self.navigationController pushViewController:choosePlanViewCtl animated:YES];
}


-(void)tapViewAction:(id)sender
{
    NSLog(@"tap view---");

    [self.view endEditing:YES];
}
//设置点在某个view时部触发事件
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"-%@", NSStringFromClass([touch.view class]));
    
    return  YES;
}



-(void)outView:(NSString *)planType
{
    [tipbtn setTitle:planType forState:UIControlStateNormal];
    tipbtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    
    if([planType isEqualToString:@"周计划"])
    {
        cateId = [NSString stringWithFormat:@"%d",WeekPlan];
    }
    else if ([planType isEqualToString:@"月计划"])
    {
        cateId = [NSString stringWithFormat:@"%d",MonthPlan];
    }
    else if([planType isEqualToString:@"季计划"])
    {
        cateId = [NSString stringWithFormat:@"%d",SeasonPlan];
    }
    else if ([planType isEqualToString:@"年计划"])
    {
        cateId = [NSString stringWithFormat:@"%d",YearPlan];
    }
    
    [self getDateAndTime];
    [_mainTableView reloadData];
}
-(void)setPlanMode:(NSString *)planMode
{
    
    _planMode = planMode;
    if(tipbtn!=nil)
    {
        [tipbtn setTitle:planMode forState:UIControlStateNormal];
        tipbtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    if([_planMode isEqualToString:@"周计划"])
    {
        cateId = [NSString stringWithFormat:@"%d",WeekPlan];
    }
    else if ([_planMode isEqualToString:@"月计划"])
    {
        cateId = [NSString stringWithFormat:@"%d",MonthPlan];
    }
    else if([_planMode isEqualToString:@"季计划"])
    {
        cateId = [NSString stringWithFormat:@"%d",SeasonPlan];
    }
    else if ([_planMode isEqualToString:@"年计划"])
    {
        cateId = [NSString stringWithFormat:@"%d",YearPlan];
    }
    
    [self getDateAndTime];
}

#pragma mark - 时间获取
-(void)getDateAndTime
{
    NSDate *now = [NSDate date];
    startDateStr = [NSString stringWithFormat:@"%@",now];
    NSTimeInterval nowTimeInterVal = now.timeIntervalSince1970;
    NSTimeInterval OneDay = 24*60*60;
    switch ([cateId integerValue]) {
        case WeekPlan:
        {
            NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:(nowTimeInterVal +7*OneDay)];
            endDateStr = [NSString stringWithFormat:@"%@",endDate];
        }
            break;
        case MonthPlan:
        {
            NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:(nowTimeInterVal +30*OneDay)];
            endDateStr = [NSString stringWithFormat:@"%@",endDate];
        }
            break;
        case SeasonPlan:
        {
            NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:(nowTimeInterVal +3*30*OneDay)];
            endDateStr = [NSString stringWithFormat:@"%@",endDate];
        }
            break;
        case YearPlan:
        {
            NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:(nowTimeInterVal +365*OneDay)];
            endDateStr = [NSString stringWithFormat:@"%@",endDate];
        }
            break;

        default:
            break;
    }
    
    NSLog(@"start time  = %@",startDateStr);
    NSLog(@"end time = %@",endDateStr);
    
}

#pragma mark - 保存计划
-(void)clickRightButton:(UIButton *)sender
{
    if(_titleField.text == nil || _titleField.text.length ==0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入完整信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    if(cateId == nil)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择分类" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    
   
    [self BuildSliderData];
    
}

#pragma mark - self datasource

-(void)delPlanCallBack:(id)dict
{
    [SVProgressHUD dismiss];
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
//        [self BuildSliderData];
        
        [SVProgressHUD showSuccessWithStatus:@"上传成功" maskType:SVProgressHUDMaskTypeBlack];
        [self.navigationController popViewControllerAnimated:YES];
        
        if([self.delegate respondsToSelector:@selector(endOfEdit)])
        {
            [self.delegate endOfEdit];
        }
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:[dict[@"data"] substringToIndex:4] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        
    }
}
-(void)BuildSliderData
{
    
    @try {
//        NSUserDefaults * userdefaults=[NSUserDefaults standardUserDefaults];
        
        NSMutableArray *tempArr = [NSMutableArray array];
        
        [tempArr addObjectsFromArray:allImgsPicked[PICPICKER_IMGS_KEY]];
        [tempArr addObjectsFromArray:allImgsPicked[PHOTO_IMGS_KEY]];
        [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"正在保存图片(1/%ld)",tempArr.count] maskType:SVProgressHUDMaskTypeBlack];
        for (int i=0; i<tempArr.count; i++) {
            UIImage *tempImg = tempArr[i];
            NSData *imgData = UIImagePNGRepresentation(tempImg);// [userdefaults objectForKey:[NSString stringWithFormat:@"%d",i]];
            NSString *imagebase64= [imgData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
            [img_uploaded addObject:imagebase64];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"构造图片数据出错");
    }
    @finally {
        
        if(img_uploaded != nil&&img_uploaded.count>0)
        {
            UploadDataToServer *uploadImg = [[UploadDataToServer alloc] init];
            uploadImg.delegate = self;
            [uploadImg uploadImg:img_uploaded];
        }
        else{
            DataProvider * dataprovider=[[DataProvider alloc] init];
            [dataprovider setDelegateObject:self setBackFunctionName:@"uploadPlansCallBack:"];
            [dataprovider updatePlan:[Toolkit getUserID] andCateId:cateId andTitle:_titleField.text andContent:_textView.text andPicList:@"" andStartDate:startDateStr andEndDate:endDateStr ];

        }
    }
}

#pragma mark - upload img delegate
-(void)uploadImgsOneFinishDelegate:(NSDictionary *)dict andImgIndex:(NSInteger)ImgIndex
{
    NSMutableArray *tempArr = [NSMutableArray array];
    
    [tempArr addObjectsFromArray:allImgsPicked[PICPICKER_IMGS_KEY]];
    [tempArr addObjectsFromArray:allImgsPicked[PHOTO_IMGS_KEY]];
    [SVProgressHUD dismiss];
    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"正在保存图片(%ld/%ld)",ImgIndex,tempArr.count] maskType:SVProgressHUDMaskTypeBlack];
}

-(void)uploadImgsAllFinishDelegate:(NSArray *)imgPath
{
    NSString *allImgPath;
    if(imgPath.count >0)
    {
        allImgPath = imgPath[0];
        for(int i = 1;i< imgPath.count ;i++)
        {
            allImgPath = [NSString stringWithFormat:@"%@&%@",allImgPath,imgPath[i]];
            
        }
    }
    
    if(defaultImgPath!=nil)
    {
        for (int i = 0; i<defaultImgPath.count; i++) {
            allImgPath = [NSString stringWithFormat:@"%@&%@",allImgPath,[defaultImgPath[i] substringFromIndex:Kimg_path.length]];
        }
    }
    [SVProgressHUD showWithStatus:@"正在保存数据" maskType:SVProgressHUDMaskTypeBlack];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"uploadPlansCallBack:"];
    [dataprovider updatePlan:[Toolkit getUserID] andCateId:cateId andTitle:_titleField.text andContent:_textView.text andPicList:allImgPath andStartDate:startDateStr andEndDate:endDateStr ];
    
}

-(void)uploadPlansCallBack:(id)dict
{
    [SVProgressHUD dismiss];
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try {
            if(self.DefaultDict !=nil)//先上传再删除原有的以防出现网络错误，倒是计划消失
            {
                
                [SVProgressHUD showInfoWithStatus:@"更新中..." maskType:SVProgressHUDMaskTypeBlack];
                DataProvider * dataprovider=[[DataProvider alloc] init];
                [dataprovider setDelegateObject:self setBackFunctionName:@"delPlanCallBack:"];
                [dataprovider delePlan:self.DefaultDict[@"planId"]];
            }
            else
            {
                [SVProgressHUD showSuccessWithStatus:@"上传成功" maskType:SVProgressHUDMaskTypeBlack];
                [self.navigationController popViewControllerAnimated:YES];
            }
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

#pragma mark - textField

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
   
    
    return YES;
}

#pragma mark - TextView
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{

    return YES;
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return _cellCount;
}

//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell  *cell = [[UITableViewCell alloc] init];
    if(indexPath.row == 2)
    {
        cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, _cellTextViewHeight);
    }
    else
    {
        cell.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, _cellHeight);
    }
    cell.backgroundColor = ItemsBaseColor;
    
    switch (indexPath.row) {
        case 0:
        {
            _titleField.frame = CGRectMake(10, 0, cell.frame.size.width, _cellHeight);
            _titleField.placeholder = @"标题";
            
            _titleField.backgroundColor  = ItemsBaseColor;
            _titleField.delegate = self;
            _titleField.textColor = [UIColor whiteColor];
            _titleField.textAlignment = NSTextAlignmentCenter;
            _titleField.font = [UIFont boldSystemFontOfSize:16];
            [cell addSubview:_titleField];
            
        }
            break;
        case  1:
        {
            cell.textLabel.text = [NSString stringWithFormat:@"%@~%@",[startDateStr  substringToIndex:10],[endDateStr substringToIndex:10] ];//@"选择周期";
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            tipbtn.backgroundColor = ItemsBaseColor;
            [tipbtn addTarget:self action:@selector(pushViewAction:) forControlEvents:UIControlEventTouchUpInside];
            tipbtn.titleLabel.font = [UIFont systemFontOfSize:14];
            
            
            UIImageView *rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right"]];
            rightView.frame = CGRectMake((tipbtn.frame.size.width - 20 -20), 0, 15, 15);
            rightView.center = CGPointMake((tipbtn.frame.size.width - 15 -10), _cellHeight/2);
            rightView.contentMode = UIViewContentModeScaleAspectFit;
            [tipbtn addSubview:rightView];
            
            [cell addSubview:tipbtn];
        }
            break;
        case 2:
        {
            if(picShowView.hidden == YES)
            {
                _textView.frame = CGRectMake(0, 0, cell.frame.size.width,_cellTextViewHeight);
            }
            else{
            
                _textView.frame = CGRectMake(0, 0, cell.frame.size.width,_cellTextViewHeight -150);
            }
            _textView.textColor = [UIColor whiteColor];
            _textView.backgroundColor  = ItemsBaseColor;
            _textView.font = [UIFont systemFontOfSize:15];
            _textView.delegate = self;
            
            [_textView addSubview:textViewHolderLab];
            textViewHolderLab.text = @"发帖内容";
            textViewHolderLab.frame = CGRectMake(10, 0, _textView.frame.size.width, 30);
//            _textView.returnKeyType = UIReturnKeyDefault;
//            _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            
            
            picShowView.frame = CGRectMake(0, _cellTextViewHeight - 150, SCREEN_WIDTH, 150);
            picShowView.backgroundColor = BACKGROUND_COLOR;
            [cell addSubview:picShowView];
            
            
            if (!_collectionView) {
                CGFloat titleH = 30;
                
                UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
                layout.minimumLineSpacing = 5.0;
                layout.minimumInteritemSpacing = 5.0;
                layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
                layout.sectionInset =  UIEdgeInsetsMake(0,20,0,20);
                layout.itemSize = CGSizeMake(picShowView.frame.size.height - 20 - titleH, picShowView.frame.size.height - 20 - titleH);
//                layout.minimumLineSpacing = 10;//cell 的左右间距
                
                _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-2*_cellHeight, _cellHeight) collectionViewLayout:layout];
                _collectionView.backgroundColor = ItemsBaseColor;
                [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kPhotoCellIdentifier];
                _collectionView.delegate = self;
                _collectionView.dataSource = self;
                _collectionView.showsHorizontalScrollIndicator = NO;
                _collectionView.showsVerticalScrollIndicator = NO;
                
                
                _collectionView.frame = CGRectMake(0, 10+titleH, SCREEN_WIDTH, picShowView.frame.size.height - 20-titleH);
                
                [picShowView addSubview:_collectionView];
                
                UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10,SCREEN_WIDTH , titleH)];
                titleLab.backgroundColor = ItemsBaseColor;
                titleLab.textColor = [UIColor whiteColor];
                titleLab.text = @"  文章图片";
                [picShowView addSubview:titleLab];
                
                
            }
            else
            {
                [picShowView addSubview:_collectionView];
            }

            
            [cell addSubview:_textView];
        }
            break;
        case 3:
        {
            
            tempIndexPath = indexPath;
            
            UIButton *picBtns = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.height, cell.frame.size.height)];
            [picBtns setImage:[UIImage imageNamed:@"picture"] forState:UIControlStateNormal];
            [picBtns addTarget:self action:@selector(composePicAdd) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *photoBtns = [[UIButton alloc] initWithFrame:CGRectMake(cell.frame.size.height, 0, cell.frame.size.height, cell.frame.size.height)];
            [photoBtns setImage:[UIImage imageNamed:@"photo"] forState:UIControlStateNormal];
            [photoBtns addTarget:self action:@selector(editPortrait) forControlEvents:UIControlEventTouchUpInside];
            
            [cell addSubview:picBtns];
            [cell addSubview:photoBtns];
            
            
           
        }
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



//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 //   NSLog(@"%f-%f",SCREEN_HEIGHT,self.view.frame.size.height);
    if(indexPath.row==2)
        return _cellTextViewHeight;
    return _cellHeight;
    
}


#pragma mark - textview delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textViewHolderLab.hidden = YES;
}
#pragma mark - 图片截取

- (void)editPortrait {
    if ([Toolkit isCameraAvailable] && [Toolkit doesCameraSupportTakingPhotos]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([Toolkit isFrontCameraAvailable]) {
            controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
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
}
#define ORIGINAL_MAX_WIDTH 640.0f
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

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        photoImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        if(photoImgs == nil)
        {
            photoImgs = [NSMutableArray array];
        }
        
        [photoImgs addObject:photoImg];
        
        [allImgsPicked setObject:photoImgs forKey:PHOTO_IMGS_KEY];
        _textView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _cellTextViewHeight-picShowView.frame.size.height);
        picShowView.hidden = NO;
        [_mainTableView reloadData];
        [_collectionView reloadData];
        //photoImg = portraitImg;
//        portraitImg = [self imageByScalingToMaxSize:portraitImg];
//        // 裁剪
//        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
//        imgEditorVC.delegate = self;
//        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
//        }];
    }];
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    photoImg = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
        [self saveImage:editedImage withName:@"avatar.jpg"];
        
        photoImg = editedImage ;
        
        
//        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"avatar.jpg"];
//        NSLog(@"选择完成");
//        //[SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeBlack];
//        NSData* imageData = UIImageJPEGRepresentation(editedImage, 0.8) ;
//        NSString *imagebase64= [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
//        DataProvider * dataprovider=[[DataProvider alloc] init];
//        [dataprovider setDelegateObject:self setBackFunctionName:@"UploadCallBack:"];
//        [dataprovider uploadHeadImg:[Toolkit getUserID] andImgData:imagebase64 andImgName:nil];
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



#pragma mark 新浪图片多选


- (void)composePicAdd
{
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 6;
    imagePickerController.selectedAssetArray = self.assetsArray;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
    
}

#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{
    self.assetsArray = [NSMutableArray arrayWithArray:assets];
    imgPickerImgs = [NSMutableArray array];
    
    for (int i = 0; i < self.assetsArray.count; i++) {
        
        JKAssets *_asset = self.assetsArray[i];
        ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
        [lib assetForURL:_asset.assetPropertyURL resultBlock:^(ALAsset *asset) {
            NSUserDefaults * userdef=[NSUserDefaults standardUserDefaults];
            if (asset) {
                [imgPickerImgs addObject:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]]];
                [userdef setObject:UIImageJPEGRepresentation
                 ([UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]], 1.0) forKey:[NSString stringWithFormat:@"%ld",(long)i]];
            }
            NSLog(@"%ld",(long)i);
        } failureBlock:^(NSError *error) {
            
        }];

    }
    _textView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _cellTextViewHeight-picShowView.frame.size.height);
    picShowView.hidden = NO;
    [_mainTableView reloadData];
    [allImgsPicked setObject:imgPickerImgs forKey:PICPICKER_IMGS_KEY];
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        [self.collectionView reloadData];
    }];
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

static NSString *kPhotoCellIdentifier = @"kPhotoCellIdentifier";

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    NSInteger picNum;
    NSInteger photoNum;
    if(photoImgs == nil)
    {
       photoNum = 0;
    }
    else
    {
        photoNum = photoImgs.count;
    }
    
    if(imgPickerImgs == nil)
    {
        picNum = 0;
    }
    else
    {
        picNum = imgPickerImgs.count;
    }
    
    if(defaultImgPath!=nil&&defaultImgPath.count>0)
    {
        return picNum + photoNum+defaultImgPath.count;
    }
    
    return picNum + photoNum;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCellIdentifier forIndexPath:indexPath];
    @try {
        UIImageView *showImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, cell.frame.size.width-20,  cell.frame.size.height-20)];
        if(imgPickerImgs!=nil && imgPickerImgs.count -1 >= indexPath.row && imgPickerImgs.count !=0)
        {
            showImgView.image = imgPickerImgs[indexPath.row];
        }
        else
        {
            NSInteger imgpickerCount;
            if(imgPickerImgs == nil)
            {
                imgpickerCount = 0;
            }
            else
            {
                imgpickerCount = imgPickerImgs.count;
            }
            if(photoImgs !=nil&&photoImgs.count - 1 >= (indexPath.row - imgpickerCount)&&photoImgs.count!=0)
            {
                showImgView.image = photoImgs[indexPath.row - imgpickerCount ];
            }
            else
            {
                NSInteger photoImgsCount;
                if(photoImgs == nil)
                {
                    photoImgsCount = 0;
                }
                else
                {
                    photoImgsCount = imgPickerImgs.count;
                }
                if(defaultImgPath!=nil&&
                   defaultImgPath.count>0&&
                   defaultImgPath.count - 1 >= (indexPath.row - photoImgsCount- imgpickerCount))
                {
//                    NSString *url = [NSString stringWithFormat:@"%@%@",Kimg_path,defaultImgPath[indexPath.row - photoImgsCount- imgpickerCount][@"ImagePath"]];
                    [showImgView sd_setImageWithURL:[NSURL URLWithString:defaultImgPath[indexPath.row - photoImgsCount- imgpickerCount]] placeholderImage:[UIImage imageNamed:@"me"]];
                }
            }
            
            
        }
        [cell addSubview:showImgView];
////        
        UIButton *imgBtn = [[UIButton alloc] initWithFrame:showImgView.frame];
        [imgBtn addTarget:self action:@selector(imgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        imgBtn.tag = indexPath.row;
        // imgBtn.backgroundColor = [UIColor redColor];
        [cell bringSubviewToFront:imgBtn];
        [cell addSubview:imgBtn];
        
        UIButton *imgDelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,  30,  30)];
        [imgDelBtn addTarget:self action:@selector(imgDelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        imgDelBtn.tag = indexPath.row;
        [imgDelBtn setImage:[UIImage imageNamed:@"del"] forState:UIControlStateNormal];
       // imgDelBtn.backgroundColor = [UIColor blackColor];
       // imgDelBtn.alpha = 0.5;
        imgDelBtn.center = CGPointMake(10, 10);
        // imgBtn.backgroundColor = [UIColor redColor];
        [cell bringSubviewToFront:imgDelBtn];
        [cell addSubview:imgDelBtn];
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
    return cell;
    
}

-(void)imgDelBtnClick:(UIButton *)sender
{
    if(imgPickerImgs!=nil && imgPickerImgs.count -1 >= sender.tag &&imgPickerImgs.count !=0)
    {
      //  showImgView.image = imgPickerImgs[sender.tag];
        [imgPickerImgs removeObjectAtIndex:sender.tag];
        [allImgsPicked setObject:imgPickerImgs forKey:PICPICKER_IMGS_KEY];
    }
    else
    {
        NSInteger imgpickerCount;
        if(imgPickerImgs == nil)
        {
            imgpickerCount = 0;
        }
        else
        {
            imgpickerCount = imgPickerImgs.count;
        }
        if(photoImgs !=nil&&photoImgs.count - 1 >= (sender.tag - imgpickerCount)&&photoImgs.count!=0)
        {
            [photoImgs removeObjectAtIndex:(sender.tag - imgpickerCount)];
            [allImgsPicked setObject:photoImgs forKey:PHOTO_IMGS_KEY];
        }
        else
        {
            NSInteger photoImgsCount;
            if(photoImgs == nil)
            {
                photoImgsCount = 0;
            }
            else
            {
                photoImgsCount = imgPickerImgs.count;
            }
            if(defaultImgPath!=nil&&
               defaultImgPath.count>0&&
               defaultImgPath.count - 1 >= (sender.tag - photoImgsCount- imgpickerCount))
            {
                [defaultImgPath removeObjectAtIndex:(sender.tag - photoImgsCount- imgpickerCount)];
            }
        }
    }
    
    if((imgPickerImgs.count == 0|| imgPickerImgs==nil) && (photoImgs.count == 0||photoImgs==nil)&&(defaultImgPath==nil||defaultImgPath.count==0))
    {
        picShowView.hidden = YES;
        _textView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _cellTextViewHeight);
        [_mainTableView reloadData];
    }
    
    [_collectionView reloadData];
}

-(void)imgBtnClick:(UIButton *)sender
{
    
  //  NSLog(@"sender .tag = %ld",sender.tag);
 
    NSMutableArray *tempArr = [NSMutableArray array];
    
    [tempArr addObjectsFromArray:allImgsPicked[PICPICKER_IMGS_KEY]];
    [tempArr addObjectsFromArray:allImgsPicked[PHOTO_IMGS_KEY]];
    [tempArr addObjectsFromArray:defaultImgPath];
//    PictureShowView *picShow = [[PictureShowView alloc] initWithTitle:@"" andImgs:tempArr andShowIndex:sender.tag];
    PictureShowView *picShow  = [[PictureShowView alloc] initWithTitle:@"" andImgsOrUrl:tempArr andShowIndex:sender.tag];
    [picShow show];
}
#pragma mark - pick show delegate

-(void)longPressCallBack
{
    NSLog(@"long press delegate");
}
-(void)didClickDelPicBtn
{
    NSLog(@"click del btn");
}

#pragma mark - UICollectionViewDelegateFlowLayout
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(40, 40);
//}

-( UIEdgeInsets )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section
{
    return UIEdgeInsetsMake(0, 10, 0, 0);

}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)[indexPath row]);
    
}


-(void)UpdateAndRequest
{
    if (img_uploaded.count>0) {
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"uploadImgBackCall:"];
        
        NSString *imagebase64= [img_uploaded[uploadImgIndex] base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        [dataprovider UploadImgWithImgdata:imagebase64];
    }
    else
    {
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"SubmitBackCall:"];

    }
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
