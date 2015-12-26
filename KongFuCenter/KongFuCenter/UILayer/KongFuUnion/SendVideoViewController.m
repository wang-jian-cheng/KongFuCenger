//
//  UploadVideoViewController.m
//  KongFuCenter
//
//  Created by 于金祥 on 15/12/19.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "SendVideoViewController.h"
#import "SCRecorder.h"
#import "DataProvider.h"
#import "ChannelViewController.h"

@interface SendVideoViewController ()
{
    //Preview
    SCPlayer *_player;
    
    UITextView * txt_title;
    UITextView * txt_Content;
    
    NSString * channelID;
    
    NSUserDefaults *userDefault;
}

@end

@implementation SendVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addLeftButton:@"left"];
    channelID=@"";
    _lblTitle.text=@"视频信息";
    [self addRightbuttontitle:@"保存"];
    self.view.backgroundColor = BACKGROUND_COLOR;
    userDefault = [NSUserDefaults standardUserDefaults];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SelectChannelCallBack:) name:@"select_channel_finish" object:nil];
    
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
    playerView.frame = CGRectMake(10, 74, SCREEN_WIDTH - 20, SCREEN_HEIGHT * 0.3);
    [self.view addSubview:playerView];
    _player.loopEnabled = YES;
    [_player setItemByUrl:_VideoFilePath];
    [_player play];
    
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
//    if (txt_Content.text.length==0) {
//        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写内容信息" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
//        [alert show];
//        return;
//    }
    
    DataProvider * dataprovider=[[DataProvider alloc] init];
    
    [dataprovider setDelegateObject:self setBackFunctionName:@"sendVideoCallBack:"];
    
    [dataprovider uploadVideoWithPath:_VideoFilePath];
    [SVProgressHUD showWithStatus:@"正在上传视频..." maskType:SVProgressHUDMaskTypeBlack];
}

-(void)sendVideoCallBack:(id)dict
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
        
        [dataprovider setDelegateObject:self setBackFunctionName:@"sendVideoInfoCallBack:"];
        [dataprovider SaveDongtai:[userDefault valueForKey:@"id"] andcontent:txt_Content.text andpathlist:dict[@"data"][@"ImageName"] andvideopath:dict[@"data"][@"VideoName"] andvideoDuration:dict[@"data"][@"VideoDuration"]];
        
        
//        NSMutableDictionary * prm=[[NSMutableDictionary alloc] init];
//        
//        [prm setObject:@"0" forKey:@"id"];
//        
//        [prm setObject:dict[@"data"][@"ImageName"] forKey:@"ImagePath"];
//        
//        [prm setObject:txt_Content.text forKey:@"Content"];
//        
//        [prm setObject:txt_title.text forKey:@"Title"];
//        
//        [prm setObject:dict[@"data"][@"VideoName"] forKey:@"VideoPath"];
//        
//        [prm setObject:@"TRUE" forKey:@"IsOriginal"];
//        
//        [prm setObject:@"TRUE" forKey:@"IsFree"];
//        
//        [prm setObject:channelID forKey:@"CategoryId"];
//        
//        [prm setObject:[Toolkit getUserID] forKey:@"UserId"];
//        
//        [prm setObject:dict[@"data"][@"VideoDuration"] forKey:@"VideoDuration"];
        
        //[dataprovider SendVideoInfo:prm];
        
        
    }
}


-(void)sendVideoInfoCallBack:(id)dict
{
    [SVProgressHUD dismiss];
    if ([dict[@"code"] intValue]==200) {
        
        [SVProgressHUD showSuccessWithStatus:@"发布成功" maskType:SVProgressHUDMaskTypeBlack];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)JumpToChannelVC
{
    ChannelViewController *channelViewCtl = [[ChannelViewController alloc] init];
    
    channelViewCtl.navtitle = @"请选择分类";
    
    channelViewCtl.isVideoSelectCadagray=YES;
    
    [self.navigationController pushViewController:channelViewCtl animated:YES];
}
-(void)SelectChannelCallBack:(NSNotification *)notice
{
    NSLog(@"%@",[notice object]);
    
    channelID=[notice object];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
