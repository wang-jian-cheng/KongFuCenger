//
//  NewPlanViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/9.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "SendNewsViewController.h"

@interface SendNewsViewController ()
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
    
    NSUserDefaults *userDefault;
}
@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray   *assetsArray;

@end

@implementation SendNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"left"];
    [self setBarTitle:@"发送动态"];
    _cellHeight = self.view.frame.size.height/12;
    [self addRightbuttontitle:@"确定"];
    
    img_uploaded = [NSMutableArray array];
    img_prm = [NSMutableArray array];
    userDefault = [NSUserDefaults standardUserDefaults];
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
    _mainTableView.backgroundColor =BACKGROUND_COLOR;
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
    _cellCount = 2;
    _cellTextViewHeight = SCREEN_HEIGHT - 3*_cellHeight - 64;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:) ];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    
    _titleField = [[UITextField alloc]init];
    
    _textView = [[UITextView alloc] init];
    //   _textView.text = @"发帖内容";
    
    
    
    
    [self.view addSubview:_mainTableView];
    
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
            NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:(nowTimeInterVal +12*30*OneDay)];
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
    
//    if(cateId == nil)
//    {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择分类" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alertView show];
//        return;
//    }
    
    if([_textView.text isEqual:@""]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写动态内容" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    [self BuildSliderData];
}

#pragma mark - self datasource

-(void)BuildSliderData
{
    [SVProgressHUD showWithStatus:@"正在保存数据" maskType:SVProgressHUDMaskTypeBlack];
    @try {
        NSUserDefaults * userdefaults=[NSUserDefaults standardUserDefaults];
        for (int i=0; i<self.assetsArray.count; i++) {
            NSData *imgData = [userdefaults objectForKey:[NSString stringWithFormat:@"%d",i]];
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
            if(_textView.text == nil || _textView.text.length ==0)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入内容信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
                return;
            }
            DataProvider * dataprovider=[[DataProvider alloc] init];
            [dataprovider setDelegateObject:self setBackFunctionName:@"sendNewsCallBack:"];
            //[dataprovider SaveDongtai:[userDefault valueForKey:@"id"] andcontent:_textView.text andpathlist:@"" andvideopath:@"" andvideoDuration:@""];
            [dataprovider SaveDongtai:[userDefault valueForKey:@"id"] andcontent:_textView.text andpathlist:@"" andvideoImage:@"" andvideopath:@"" andvideoDuration:@""];
        }
    }
}

#pragma mark - upload img delegate

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
    
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"uploadPlansCallBack:"];
    //[dataprovider updatePlan:[Toolkit getUserID] andCateId:cateId andTitle:_titleField.text andContent:_textView.text andPicList:allImgPath andStartDate:startDateStr andEndDate:endDateStr ];
    //[dataprovider SaveDongtai:[userDefault valueForKey:@"id"] andcontent:_textView.text andpathlist:allImgPath andvideopath:@"" andvideoDuration:@""];
    [dataprovider SaveDongtai:[userDefault valueForKey:@"id"] andcontent:_textView.text andpathlist:allImgPath andvideoImage:@"" andvideopath:@"" andvideoDuration:@""];
}

-(void)sendNewsCallBack:(id)dict
{
    [SVProgressHUD dismiss];
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try {
            [SVProgressHUD showSuccessWithStatus:@"发布成功~"];
            [self.navigationController popViewControllerAnimated:YES];
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
    cell.backgroundColor = BACKGROUND_COLOR;
    
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"发帖内容";
            _textView.frame = CGRectMake(10, 0, cell.frame.size.width,_cellTextViewHeight);
            _textView.backgroundColor  = BACKGROUND_COLOR;
            _textView.font = [UIFont systemFontOfSize:15];
            _textView.delegate = self;
            //            _textView.returnKeyType = UIReturnKeyDefault;
            //            _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            
            [cell addSubview:_textView];
            
        }
            break;
        case 1:
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
            
            
            if (!_collectionView) {
                
                UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
                layout.minimumLineSpacing = 5.0;
                layout.minimumInteritemSpacing = 5.0;
                layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
                
                
                _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-2*_cellHeight, _cellHeight) collectionViewLayout:layout];
                _collectionView.backgroundColor = [UIColor clearColor];
                [_collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:kPhotoCellIdentifier];
                _collectionView.delegate = self;
                _collectionView.dataSource = self;
                _collectionView.showsHorizontalScrollIndicator = NO;
                _collectionView.showsVerticalScrollIndicator = NO;
                
                
                _collectionView.frame = CGRectMake(picBtns.frame.size.width+photoBtns.frame.origin.x+5, 0, SCREEN_WIDTH-(2*cell.frame.size.height), cell.frame.size.height);
                
                [cell addSubview:_collectionView];
                
                
                
            }
            else
            {
                [cell addSubview:_collectionView];
            }
            
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
    if(indexPath.row==0)
        return _cellTextViewHeight + _cellHeight * 2;
    return _cellHeight;
    
}


#pragma mark - 图片截取

- (void)editPortrait {
    if ([Toolkit isCameraAvailable] && [Toolkit doesCameraSupportTakingPhotos]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([Toolkit isFrontCameraAvailable]) {
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
        
        [self.collectionView reloadData];
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
    imagePickerController.maximumNumberOfSelection = 3;
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
    if(photoImg != nil)
    {
        
        return 1+[self.assetsArray count];
    }
    return [self.assetsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = (PhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCellIdentifier forIndexPath:indexPath];
    
    if(photoImg != nil)
    {
        if(indexPath.row == 0)
        {
            UIImageView *imgView = [[UIImageView alloc] initWithImage:photoImg];
            imgView.frame = cell.frame;
            
            [cell addSubview:imgView];
        }
        
        if(indexPath.row > 0)
        {
            cell.tag=indexPath.row;
            cell.asset = [self.assetsArray objectAtIndex:([indexPath row]-1)];
        }
    }
    else
    {
        
        cell.tag=indexPath.row;
        cell.asset = [self.assetsArray objectAtIndex:[indexPath row]];
    }
    
    UIButton *imgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,  cell.frame.size.width,  cell.frame.size.height)];
    [imgBtn addTarget:self action:@selector(imgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    imgBtn.tag = indexPath.row;
    // imgBtn.backgroundColor = [UIColor redColor];
    [cell bringSubviewToFront:imgBtn];
    [cell addSubview:imgBtn];
    
    return cell;
    
}

-(void)imgBtnClick:(UIButton *)sender
{
    
    NSLog(@"sender .tag = %ld",sender.tag);
    if(photoImg !=nil)
    {
        if (sender.tag == 0) {
            PictureShowView *picShow = [[PictureShowView alloc] initWithTitle:nil showImg:photoImg];
            [picShow show];
        }
        else
        {
            JKAssets *_asset = self.assetsArray[sender.tag-1];
            ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
            [lib assetForURL:_asset.assetPropertyURL resultBlock:^(ALAsset *asset) {
                if (asset) {
                    PictureShowView *picShow = [[PictureShowView alloc] initWithTitle:nil showImg:[UIImage imageWithCGImage:[[asset  defaultRepresentation] fullScreenImage]]];
                    [picShow show];
                }
                
            } failureBlock:^(NSError *error) {
                
            }];
            
        }
    }
    else
    {
        
        JKAssets *_asset = self.assetsArray[sender.tag];
        ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
        [lib assetForURL:_asset.assetPropertyURL resultBlock:^(ALAsset *asset) {
            if (asset) {
                PictureShowView *picShow = [[PictureShowView alloc] initWithTitle:nil showImg:[UIImage imageWithCGImage:[[asset  defaultRepresentation] fullScreenImage]]];
                [picShow show];
            }
            
        } failureBlock:^(NSError *error) {
            
        }];
        
        
    }
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(40, 40);
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
