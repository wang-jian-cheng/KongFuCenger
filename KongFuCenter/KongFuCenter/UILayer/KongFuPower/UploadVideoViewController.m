//
//  UploadVideoViewController.m
//  KongFuCenter
//
//  Created by 于金祥 on 15/12/19.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "UploadVideoViewController.h"
#import "SCRecorder.h"
#import "DataProvider.h"

@interface UploadVideoViewController ()
{
//Preview
    SCPlayer *_player;
    
    UITextView * txt_title;
    UITextView * txt_Content;
}

@end

@implementation UploadVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addLeftButton:@"left"];
    [self addRightbuttontitle:@"保存"];
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:) ];
    [self.view addGestureRecognizer:tapGesture];
    
    
    
    [self InitAllView];
}

-(void)InitAllView
{
    // 创建视频播放器
    _player = [SCPlayer player];
    SCVideoPlayerView *playerView = [[SCVideoPlayerView alloc] initWithPlayer:_player];
    playerView.tag = 400;
    playerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    playerView.frame = CGRectMake(10, 74, 100, 100);
    [self.view addSubview:playerView];
    _player.loopEnabled = YES;
    [_player setItemByUrl:_VideoFilePath];
    [_player play];
    
    txt_title=[[UITextView alloc] initWithFrame:CGRectMake(playerView.frame.origin.x+playerView.frame.size.width+10, 74, SCREEN_WIDTH-(playerView.frame.origin.x+playerView.frame.size.width+20), playerView.frame.size.height)];
    txt_title.backgroundColor=ItemsBaseColor;
    
    [self.view addSubview:txt_title];
    
    txt_Content=[[UITextView alloc] initWithFrame:CGRectMake(10,playerView.frame.size.height+playerView.frame.origin.y+10 , SCREEN_WIDTH-20, SCREEN_HEIGHT-playerView.frame.size.height-playerView.frame.origin.y-20)];
    
    txt_Content.backgroundColor=ItemsBaseColor;
    
    [self.view addSubview:txt_Content];
    
    
    
}

-(void)tapViewAction:(id)sender
{
    NSLog(@"tap view---");
    
    
    [self.view endEditing:YES];
    
//    if(_keyShow == true)
//    {
//        _keyShow = false;
//        [_textView resignFirstResponder];//关闭textview的键盘
//        [_titleField resignFirstResponder];//关闭titleField的键盘
//        
//    }
}

-(void)clickRightButton:(UIButton *)sender
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    
    [dataprovider setDelegateObject:self setBackFunctionName:@"uploadVideoCallBack:"];
    
    [dataprovider uploadVideoWithPath:_VideoFilePath];
    [SVProgressHUD showWithStatus:@"正在上传视频..." maskType:SVProgressHUDMaskTypeBlack];
}

-(void)uploadVideoCallBack:(id)dict
{
    NSLog(@"%@",dict);
    [SVProgressHUD dismiss];
    [SVProgressHUD showWithStatus:@"正在保存视频信息..." maskType:SVProgressHUDMaskTypeBlack];
    
//    code = 200;
//    date =     {
//        ImageName = "UpLoad\\Image\\83e46012-91f3-4a31-a27b-fdb658601adf.JPG";
//        VideoDuration = "00:00:08";
//        VideoName = "UpLoad\\Video\\279b6db9-455e-4feb-9e03-1e5fa15a9879.mov";
//    };
    
    if ([dict[@"code"] intValue]==200) {
        DataProvider * dataprovider=[[DataProvider alloc] init];
        
        [dataprovider setDelegateObject:self setBackFunctionName:@"UploadVideoInfoCallBack:"];
    }
}


-(void)UploadVideoInfoCallBack:(id)dict
{
    [SVProgressHUD dismiss];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
