//
//  ChatViewController.m
//  KongFuCenter
//
//  Created by Rain on 15/12/15.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "ChatContentViewController.h"
#import "ChatLocationViewController.h"
#import "FriendInfoViewController.h"
#import "WechatShortVideoController.h"
#import "BigImageShowViewController.h"
#import "SimpleMessage.h"
#import "SimpleMessageCell.h"
#import "MoviePlayer.h"

@interface ChatContentViewController ()<RCLocationPickerViewControllerDelegate,WechatShortVideoDelegate,RCConversationCellDelegate,ClickImgDelegate>{
    UIView *topView;
    NSUserDefaults *userDefault;
    NSString *friendID;
    UIImage *selectImage;
    UIButton *videoView;
    UIButton *leftBtn;
}

@end

@implementation ChatContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userDefault = [NSUserDefaults standardUserDefaults];
    
    [self initView];
}

//- (void)willDisplayConversationTableCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"%@---%@",[self targetId],get_sp(@"id"));
//    if (![[NSString stringWithFormat:@"%@",[self targetId]] isEqual:[NSString stringWithFormat:@"%@",get_sp(@"id")]] && _mName) {
//        ((RCMessageCell*)cell).nicknameLabel.text = _mName;
//        [((UIImageView *)(((RCMessageCell*)cell).portraitImageView)) sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Url,_mHeadImage]] placeholderImage:[UIImage imageNamed:@"me"]];
//    }
//}

-(void)initView{
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavigationBar_HEIGHT + StatusBar_HEIGHT)];
    topView.backgroundColor = navi_bar_bg_color;
    [self.view addSubview:topView];
    
    UILabel *mTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, StatusBar_HEIGHT + (NavigationBar_HEIGHT - 21) / 2, SCREEN_WIDTH, 21)];
    mTitle.textAlignment = NSTextAlignmentCenter;
    mTitle.textColor = [UIColor whiteColor];
    mTitle.text = _mTitle;
    [topView addSubview:mTitle];
    
    UIButton *leftTitle = [[UIButton alloc] initWithFrame:CGRectMake(14, StatusBar_HEIGHT + (NavigationBar_HEIGHT - 20) / 2, 20, 20)];
    [leftTitle setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [leftTitle addTarget:self action:@selector(clickLeftBtn) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:leftTitle];
    
    UICollectionView *messageCollectionView = self.conversationMessageCollectionView;
    if (_chatPageType == Mode_History) {
        self.conversationMessageCollectionView.frame = CGRectMake(0,NavigationBar_HEIGHT + StatusBar_HEIGHT,SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_HEIGHT - StatusBar_HEIGHT);
        self.chatSessionInputBarControl.hidden = YES;
    }else{
        messageCollectionView.frame = CGRectMake(0, NavigationBar_HEIGHT + StatusBar_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_HEIGHT - StatusBar_HEIGHT - TabBar_HEIGHT);
    }
    messageCollectionView.backgroundColor = BACKGROUND_COLOR;
    [self scrollToBottomAnimated:YES];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveImage) name:@"saveImage" object:nil];
    
    //会话页面注册 UI
    [self registerClass:[SimpleMessageCell class] forCellWithReuseIdentifier:@"SimpleMessageCell"];
    
    //自定义面板功能扩展
    [self.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"me"]
                                        title:@"视频"
                                          tag:101];
}

#pragma mark - 重写方法实现自定义消息的显示
-(RCMessageBaseCell *)rcConversationCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RCMessageModel *model = self.conversationDataRepository[indexPath.row];
    NSString * cellIndentifier=@"SimpleMessageCell";
    SimpleMessageCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier           forIndexPath:indexPath];
    cell.customDelegate = self;
    [cell setDataModel:model];
    NSString *url = [NSString stringWithFormat:@"%@%@",Url,@"UpLoad/Video/b584d41b-82fe-4677-a492-dd9f3791105d.mp4"];
    url = [url stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    //MoviePlayer *player = [[MoviePlayer alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH - 50, 210) URL:[NSURL URLWithString:url]];
    //[cell addSubview:player];
    return cell;
}

-(CGSize)rcConversationCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //返回自定义cell的实际高度
    NSLog(@"%f",SCREEN_WIDTH);
    return CGSizeMake(SCREEN_WIDTH + 20, 210);
}



-(void)viewDidAppear:(BOOL)animated{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag{
    switch (tag) {
        case  PLUGIN_BOARD_ITEM_LOCATION_TAG : {
            {
                ChatLocationViewController * chatlocationVC=[[ChatLocationViewController alloc] init];
                chatlocationVC.delegate=self;
                //[self presentModalViewController:chatlocationVC animated:YES];
                [self.navigationController pushViewController:chatlocationVC animated:YES];
            }
            break;
        case 101:{
            WechatShortVideoController *wechatShortVideoController = [[WechatShortVideoController alloc] init];
            wechatShortVideoController.delegate = self;
            [self presentViewController:wechatShortVideoController animated:YES completion:^{}];
        }
            break;
        default:
            [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
            break;
        }
    }
}

- (void)locationPicker:(ChatLocationViewController *)locationPicker
     didSelectLocation:(CLLocationCoordinate2D)location
          locationName:(NSString *)locationName
         mapScreenShot:(UIImage *)mapScreenShot {
    RCLocationMessage *locationMessage =
    [RCLocationMessage messageWithLocationImage:mapScreenShot
                                       location:location
                                   locationName:locationName];
    [self sendMessage:locationMessage pushContent:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)presentImagePreviewController:(RCMessageModel *)model{
    BigImageShowViewController *bigImageShowVC = [[BigImageShowViewController alloc] init];
    bigImageShowVC.imgUrl = ((RCImageMessage *)model.content).imageUrl;
    selectImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:((RCImageMessage *)model.content).imageUrl]];
    [self.navigationController pushViewController:bigImageShowVC animated:YES];
}

- (void)saveNewPhotoToLocalSystemAfterSendingSuccess:(UIImage *)newImage{
    UIImageWriteToSavedPhotosAlbum(selectImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    [SVProgressHUD showSuccessWithStatus:@"保存成功~" maskType:SVProgressHUDMaskTypeBlack];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error == nil) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已存入手机相册" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
}

- (void)didTapCellPortrait:(NSString *)userId{
    if ([userId isEqual:[userDefault valueForKey:@"id"]]) {
        PersonInfoViewController *personInfoViewCtl = [[PersonInfoViewController alloc] init];
        personInfoViewCtl.navtitle = @"个人资料";
        [self.navigationController pushViewController:personInfoViewCtl animated:YES];
    }else{
        friendID = userId;
        DataProvider *dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"isFriendCallBack:"];
        [dataProvider IsWuyou:[userDefault valueForKey:@"id"] andfriendid:userId];
    }
}

-(void)isFriendCallBack:(id)dict{
    NSLog(@"%@",dict);
    if ([dict[@"code"] intValue] == 200) {
        if([dict[@"data"] intValue] == 1)//好友
        {
            FriendInfoViewController *friendInfoViewCtl = [[FriendInfoViewController alloc] init];
            friendInfoViewCtl.navtitle = @"好友资料";
            friendInfoViewCtl.userID = friendID;
            [self.navigationController pushViewController:friendInfoViewCtl animated:YES];
        }
        else//陌生人
        {
            StrangerInfoViewController *strangerInfoViewCtl = [[StrangerInfoViewController alloc] init];
            strangerInfoViewCtl.navtitle = @"陌生人资料";
            strangerInfoViewCtl.userID = friendID;
            [self.navigationController pushViewController:strangerInfoViewCtl animated:YES];
        }
    }
}

#pragma mark - 自定义方法
-(void)clickLeftBtn{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - WechatShortVideoDelegate
- (void)finishWechatShortVideoCapture:(NSURL *)filePath {
    NSLog(@"filePath is %@", filePath);
    DataProvider * dataprovider=[[DataProvider alloc] init];
    
    [dataprovider setDelegateObject:self setBackFunctionName:@"sendVideoCallBack:"];
    
    [dataprovider uploadVideoWithPath:filePath];
    [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeBlack];
}

-(void)sendVideoCallBack:(id)dict
{
    [SVProgressHUD dismiss];
    NSLog(@"%@",dict);
    if ([dict[@"code"] intValue] == 200) {
        //SimpleMessage *simpleMsg = [SimpleMessage messageWithContent:[NSString stringWithFormat:@"%@;%@",@"http://img.ivsky.com/img/tupian/pre/201312/04/nelumbo_nucifera-009.jpg",[NSString stringWithFormat:@"%@%@",Url,@"UpLoad/Video/b584d41b-82fe-4677-a492-dd9f3791105d.mp4"]] imageUrl:@"" url:@""];
        SimpleMessage *simpleMsg = [SimpleMessage messageWithContent:[NSString stringWithFormat:@"%@;%@",[NSString stringWithFormat:@"%@%@",Url,[dict[@"data"] valueForKey:@"ImageName"]],[NSString stringWithFormat:@"%@%@",Url,[dict[@"data"] valueForKey:@"VideoName"]]] imageUrl:@"" url:@""];
        [self sendMessage:simpleMsg pushContent:@"Hello World"];
    }
}

-(void)clickImgEvent:(NSString *)videoUrl{
    videoView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    videoView.backgroundColor = [UIColor grayColor];
    //videoView.alpha = 0.6;
    MoviePlayer *player = [[MoviePlayer alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH, SCREEN_HEIGHT) URL:[NSURL URLWithString:videoUrl]];
    [videoView addSubview:player];
    [self.view addSubview:videoView];
    
    //添加退出按钮
    leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 60, 60)];
    [leftBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backViewEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
}

-(void)backViewEvent{
    [videoView removeFromSuperview];
    [leftBtn removeFromSuperview];
}

#pragma mark - 相册的代理
//- (void)imagePickerController:(UIImagePickerController *)picker   didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//    }];
//    
//    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
//    
//    if([mediaType isEqualToString:@"public.movie"])
//    {
//        
//        RCImageMessage *imageMsg = [RCImageMessage messageWithImageURI:@"http://img4.imgtn.bdimg.com/it/u=128811874,840272376&fm=21&gp=0.jpg"];
////        imageMsg.thumbnailImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://img4.imgtn.bdimg.com/it/u=128811874,840272376&fm=21&gp=0.jpg"]]];
////        imageMsg.imageUrl = @"http://img4.imgtn.bdimg.com/it/u=128811874,840272376&fm=21&gp=0.jpg";
////        imageMsg.originalImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://img4.imgtn.bdimg.com/it/u=128811874,840272376&fm=21&gp=0.jpg"]]];
////        MyVideoMessage *myVideoMessage = [[MyVideoMessage alloc] init];
////        myVideoMessage.videoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://120.27.115.235/UpLoad/Video/902e869c-b934-495b-9862-7359fae9f9ea.mov"]];
////        
////        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:txtMsg];
////        RCMessageContent *content = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE targetId:[self targetId] content:imageMsg pushContent:nil success:nil error:nil];
//        
////        self.defaultInputType = RCChatSessionInputBarInputExtention;
////        RCInformationNotificationMessage *warningMsg = [RCInformationNotificationMessage notificationWithMessage:@"请不要轻易给陌生人汇钱！" extra:nil];
////        BOOL saveToDB = NO;  //是否保存到数据库中
////        RCMessage *savedMsg ;
////        if (saveToDB) {
////            savedMsg = [[RCIMClient sharedRCIMClient] insertMessage:self.conversationType targetId:self.targetId senderUserId:[RCIMClient sharedRCIMClient].currentUserInfo.userId sendStatus:SentStatus_SENT content:warningMsg];
////        } else {
////            savedMsg =[[RCMessage alloc] initWithType:self.conversationType targetId:self.targetId direction:MessageDirection_SEND messageId:-1 content:warningMsg];//注意messageId要设置为－1
////        }
////        [self appendAndDisplayMessage:savedMsg];
//        
//        
//    }
//}

@end
