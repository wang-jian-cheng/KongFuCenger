//
//  ApplyForMatchViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/12.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "ApplyForMatchViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "SCRecorder.h"

@interface ApplyForMatchViewController ()
{
#pragma mark - pram for tableView
    NSInteger _sectionNum;
    CGFloat _cellHeight;
    UITableView *_mainTableView;
    
    UILabel *textHolderView;
    SCPlayer *_player;
    UIButton *uploadImgBtn;
    NSString *imagebase64;
    NSURL *videoURL;
    NSString *videoName;
    UITextView  *titleView;
    UITextView  *contentView;
    NSUserDefaults *userDefault;
}
@end

@implementation ApplyForMatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self addLeftButton:@"left"];
    [self addRightbuttontitle:@"确定"];
    imagebase64 = @"";
    userDefault = [NSUserDefaults standardUserDefaults];
    [self initViews];
    // Do any additional setup after loading the view.
}
-(void)initViews
{
    _cellHeight = SCREEN_HEIGHT/8;
    _sectionNum = 3;
    
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height )];
    _mainTableView.backgroundColor = BACKGROUND_COLOR;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorColor =  Separator_Color;
    _mainTableView.tableFooterView = [[UIView alloc] init];
    //_mainTableView.scrollEnabled = NO;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _mainTableView.contentSize = CGSizeMake(SCREEN_HEIGHT, _sectionNum*(_cellHeight + 20));
    [self.view addSubview:_mainTableView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:) ];
    [self.view addGestureRecognizer:tapGesture];
    
    //添加键盘的监听事件
    
    //    //注册通知,监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    //
    //    //注册通知,监听键盘消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden) name:UIKeyboardDidHideNotification object:nil];
    
    
}

// 键盘弹出时
-(void)keyboardDidShow:(NSNotification *)notification
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
    
    NSLog(@"tempIndexPath.section = %ld tempIndexPath.row = %ld",(long)tempIndexPath.section,tempIndexPath.row);
    
    [_mainTableView scrollToRowAtIndexPath:tempIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    
    //[_mainTableView reloadData];
    [UIView commitAnimations];
    
}

//键盘消失时
-(void)keyboardDidHidden
{
    //定义动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    //设置view的frame，往下平移
    [_mainTableView setFrame:CGRectMake(0, Header_Height, self.view.frame.size.width,SCREEN_HEIGHT - Header_Height)];
    
    //[_mainTableView reloadData];
    [UIView commitAnimations];
    
}

#pragma click actions 
-(void)tapViewAction:(id)sender
{
    [self.view endEditing:YES];
}

-(void)uploadVideoEvent{
    UIImagePickerController * pick = [[UIImagePickerController alloc] init];
    pick.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    pick.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    //是否允许编辑
    pick.allowsEditing = YES;
    //代理
    pick.delegate = self;
    [self presentViewController:pick animated:YES completion:^{
        
    }];
}

-(void)uploadImgEvent{
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        UIImagePickerController *mImagePick = [[UIImagePickerController alloc] init];
        mImagePick.sourceType = UIImagePickerControllerSourceTypeCamera;
        mImagePick.delegate = self;
        mImagePick.allowsEditing = YES;
        [self presentViewController:mImagePick animated:YES completion:nil];
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        UIImagePickerController *mImagePick = [[UIImagePickerController alloc] init];
        mImagePick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        mImagePick.delegate = self;
        mImagePick.allowsEditing = YES;
        [self presentViewController:mImagePick animated:YES completion:nil];
    }
}

-(UIImage *)scaleFromImage:(UIImage *)image andSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)clickRightButton:(UIButton *)sender{
    if (!videoURL || [videoURL isEqual:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请上传视频" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alertView show];
        return;
    }
    if (!titleView || [titleView isEqual:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写标题" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alertView show];
        return;
    }
    if (!contentView || [contentView isEqual:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写内容" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alertView show];
        return;
    }
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getVideoCallBack:"];
    [dataProvider uploadVideoWithPath:videoURL];
}

-(void)getVideoCallBack:(id)dict{
    if([dict[@"code"] intValue] == 200){
        NSLog(@"%@",dict);
        DataProvider *dataProvider = [[DataProvider alloc] init];
        if ([imagebase64 isEqual:@""]) {
            [dataProvider setDelegateObject:self setBackFunctionName:@"saveMushaMatchCallBack:"];
            [dataProvider JoinMatch:_matchId anduserid:[userDefault valueForKey:@"id"] andmatchVideo:[dict[@"data"] valueForKey:@"VideoName"] andmatchImage:[dict[@"data"] valueForKey:@"ImageName"] andmatchDescription:contentView.text];
        }else{
            videoName = [dict[@"data"] valueForKey:@"VideoName"];
            [dataProvider setDelegateObject:self setBackFunctionName:@"getImgCallBack:"];
            [dataProvider UploadImgWithImgdata:imagebase64];
        }
    }
}

-(void)getImgCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        NSLog(@"%@",dict);
        DataProvider *dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"saveMushaMatchCallBack:"];
        [dataProvider JoinMatch:_matchId anduserid:[userDefault valueForKey:@"id"] andmatchVideo:[dict[@"data"] valueForKey:@"VideoName"] andmatchImage:[dict[@"data"] valueForKey:@"ImageName"] andmatchDescription:contentView.text];
    }
}

-(void)saveMushaMatchCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker   didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum) {
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        
        if([mediaType isEqualToString:@"public.movie"])
        {
            videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
            //        NSLog(@"found a video");
            //        NSLog(@"%@",videoURL);
            
            // 创建视频播放器
            _player = [SCPlayer player];
            SCVideoPlayerView *playerView = [[SCVideoPlayerView alloc] initWithPlayer:_player];
            playerView.tag = 400;
            playerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            playerView.frame = CGRectMake(0, 64, SCREEN_WIDTH, _cellHeight*3);
            [self.view addSubview:playerView];
            _player.loopEnabled = YES;
            [_player setItemByUrl:videoURL];
            [_player play];
            
            UIButton *uploadVideo = [[UIButton alloc] initWithFrame:playerView.frame];
            [uploadVideo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            //[uploadVideo setTitle:@"重新上传视频" forState:UIControlStateNormal];
            [uploadVideo addTarget:self action:@selector(uploadVideoEvent) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:uploadVideo];
        }
        else
        {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请您选择视频文件" preferredStyle:(UIAlertControllerStyleAlert)];
            
            [self presentViewController:alert animated:YES completion:^{
                
            }];
            
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:action];
        }
    }else{
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        UIImage *smallImage = [self scaleFromImage:image andSize:CGSizeMake(800, 800)];
        [uploadImgBtn setImage:smallImage forState:UIControlStateNormal];
        NSData *imageData = UIImagePNGRepresentation(smallImage);
        imagebase64= [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        //[self changeHeadImage:imageData];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    
}

#pragma mark - textView delegate
//将要开始编辑
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    tempIndexPath = [NSIndexPath indexPathForRow:0 inSection:textView.tag];
    return YES;
}


#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _sectionNum;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}

#pragma mark - setting for cell
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight)];
    cell.backgroundColor = BACKGROUND_COLOR;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.section) {
        case 0:
        {
            //            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight*5)];
            UIButton *uploadVideo = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150)/2, (3*_cellHeight - 50)/2, 150, 50)];
            uploadVideo.backgroundColor = YellowBlock;
            uploadVideo.center = CGPointMake(SCREEN_WIDTH/2, 3*_cellHeight /2);
            [uploadVideo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [uploadVideo setTitle:@"点击上传视频" forState:UIControlStateNormal];
            [uploadVideo addTarget:self action:@selector(uploadVideoEvent) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:uploadVideo];
            
        }
            break;
        case 1:
        {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _cellHeight*1.5, _cellHeight*1.5)];
            //imgView.image = [UIImage imageNamed:@"yewenback"];
            imgView.backgroundColor = ItemsBaseColor;
            [cell addSubview:imgView];
            
            UILabel *tiplab = [[UILabel alloc] initWithFrame:CGRectMake(0, (_cellHeight*1.5 - 30-10), _cellHeight*1.5, 30)];
            [imgView addSubview:tiplab];
            tiplab.text = @"点击上传主图";
            tiplab.textColor = [UIColor whiteColor];
            tiplab.font = [UIFont systemFontOfSize:14];
            tiplab.textAlignment = NSTextAlignmentCenter;
            [imgView addSubview:tiplab];
            
            uploadImgBtn = [[UIButton alloc] initWithFrame:imgView.frame];
            [uploadImgBtn setImage:[UIImage imageNamed:@"dajiahao"] forState:UIControlStateNormal];
            [uploadImgBtn addTarget:self action:@selector(uploadImgEvent) forControlEvents:UIControlEventTouchUpInside];
            uploadImgBtn.userInteractionEnabled = YES;
            [cell addSubview:uploadImgBtn];
            
            
            titleView = [[UITextView alloc] initWithFrame:CGRectMake((imgView.frame.size.width + imgView.frame.origin.x+10),
                                                                                 0,
                                                                                 SCREEN_WIDTH - (imgView.frame.size.width + imgView.frame.origin.x+10),
                                                                                 _cellHeight*1.5)];
            titleView.backgroundColor = ItemsBaseColor;
            titleView.text = @"视频标题";
            titleView.tag = indexPath.section;
            titleView.textAlignment = NSTextAlignmentLeft;
            titleView.font = [UIFont systemFontOfSize:14];
            titleView.textColor = [UIColor whiteColor];
            titleView.delegate = self;
            [cell addSubview:titleView];

        }
            break;
        case 2:
        {
            contentView = [[UITextView alloc] initWithFrame:CGRectMake(0,
                                                                                  0,
                                                                                  SCREEN_WIDTH,
                                                                                  _cellHeight*3)];
            contentView.backgroundColor = ItemsBaseColor;
            contentView.text = @"视频简介";
            contentView.textAlignment = NSTextAlignmentLeft;
            contentView.tag = indexPath.section;
            contentView.font = [UIFont systemFontOfSize:14];
            contentView.textColor = [UIColor whiteColor];
            contentView.delegate = self;
            [cell addSubview:contentView];
            
            
        }
            break;
            
               default:
            break;
    }
    return cell;
    
}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            return _cellHeight*3;
            break;
        case 1:
            return _cellHeight*1.5;
            break;
        case 2:
            return _cellHeight*3;
            break;

        default:
            break;
    }
    
    return _cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    NSLog(@"click cell section : %ld row : %ld",(long)indexPath.section,(long)indexPath.row);
    
    
    
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

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *tempView = [[UIView alloc] init];
    tempView.backgroundColor = BACKGROUND_COLOR;
    return tempView;
}
//设置section header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

//设置section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
    
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
