//
//  VideoDetailViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/7.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "VideoDetailViewController.h"
#import "UserHeadView.h"
//#import "MoviePlayer.h"
#import "DataProvider.h"
#import "PlayerControllerDelegate.h"
#import "PlayerController.h"



#define VideoPlaySection    0
#define VideoDetailSection  1
#define OtherVideoSection   2
#define CommentSection      3

#define GapToLeft           13
#define TextColors          [UIColor whiteColor]

//typedef enum _ActionType{
//    
//    cancelZan = 100,
//    setZan,
//    cancelCollect,
//    setCollect,
//    setZhuanfa,
//    jubao
//    
//}ActionType;

@interface VideoDetailViewController ()<PlayerControllerDelegate>
{
#pragma mark - pram for tableView
    NSInteger _sectionNum;
    CGFloat _cellHeight;
    UITableView *_mainTableView;
//    MoviePlayer *moviePlayerview;
    
    
    NSString * VideoPath;
    
    NSDictionary * VideoDict;//视频信息
    
    NSMutableArray * videoCommentArray;//评论列表
    
    int OtherVideo;
    
    NSMutableArray  * otherVideoArray;
    
    PlayerController *playerCtrl;
    
    CGRect _VideoViewFrame;
    
    CGRect _modleBtnFrame;
    
    CGRect _backViewFrame;
    ActionType actionType;
    
    UIButton * btn_goBack;
}
@end

@implementation VideoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"left"];
    [self addRightbuttontitle:@"举报"];
    _lblTitle.text=@"视频详情";
    _topView.backgroundColor=[UIColor clearColor];
    
    OtherVideo=0;
    
    otherVideoArray=[NSMutableArray array];
    
    VideoDict=[[NSDictionary alloc] init];
    _cellHeight = SCREEN_HEIGHT/12;
    if(_cellHeight < 50)
        _cellHeight = 50;

    videoCommentArray=[NSMutableArray array];
    
    commentWidth = SCREEN_WIDTH - _cellHeight -GapToLeft - 40;
    
    [self getData];
    
    [self initViews];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

-(void)initViews
{
    
    _sectionNum = 4;
    
//    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height)];
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height) style:UITableViewStyleGrouped];
    _mainTableView.backgroundColor = BACKGROUND_COLOR;
    
    _mainTableView.delegate = self;
    
    _mainTableView.dataSource = self;
    
    _mainTableView.separatorColor = Separator_Color;
    
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    _mainTableView.tableFooterView = [[UIView alloc] init];
    
    //_mainTableView.scrollEnabled = NO;
    
    _mainTableView.contentSize = CGSizeMake(SCREEN_HEIGHT, _sectionNum*(_cellHeight + 20));
    
    [self.view addSubview:_mainTableView];
    
    
    
    
    //    moviePlayerview.
    
    //     MoviePlayer *view = [[MoviePlayer alloc] initWithFrame:self.view.bounds URL:[NSURL URLWithString:@"http://baobab.cdn.wandoujia.com/14468618701471.mp4"]];
    
    
    
    commentTextView = [[UITextView alloc] init];
    commentTextView.delegate = self;
    commentTextView.textColor = [UIColor whiteColor];
    commentTextView.backgroundColor = [UIColor grayColor];
    
    SupportBtn = [[CustomButton alloc] init];
    collectBtn = [[CustomButton alloc] init];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:) ];
    [self.view addGestureRecognizer:tapGesture];
    tapGesture.delegate = self;

    //
    //    //注册通知,监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    //
    //    //注册通知,监听键盘消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden) name:UIKeyboardDidHideNotification object:nil];
    
    /***************init for video******************/
    
 
    
    
    playerCtrl = [[PlayerController alloc] initWithNibName:nil bundle:nil] ;
 
    
}

- (void)getData
{
    [self GetVideoDetial];
    
    [self GetVideoCommentDetial];
}
/**
 *  获取视频详情
 */
-(void)GetVideoDetial
{
    [SVProgressHUD showWithStatus:@"加载..." maskType:SVProgressHUDMaskTypeBlack];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetVideoDetialCallBack:"];
    [dataprovider getStudyOnlineVideoDetial:_videoID andUserId:[Toolkit getUserID]];
}
-(void)GetVideoDetialCallBack:(id)dict
{
    [SVProgressHUD dismiss];
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
//        _lblTitle.text=[dict[@"data"][@"Title"] isEqual:[NSNull null]]?@"":dict[@"data"][@"Title"];
        
        VideoPath=[NSString stringWithFormat:@"%@%@",Url,[dict[@"data"][@"VideoPath"] isEqual:[NSNull null]]?@"":dict[@"data"][@"VideoPath"]];
        
        VideoPath=[VideoPath stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
        
        VideoDict=dict[@"data"];
        //赞
        if ([VideoDict[@"Islike"] integerValue] == 1) {
            SupportBtn.selected = YES;
        }
        else
        {
            SupportBtn.selected = NO;
        }
        //收藏
        if ([VideoDict[@"IsFavorite"] integerValue] == 1) {
            collectBtn.selected = YES;
        }
        else
        {
            collectBtn.selected = NO;
        }
        
        if([VideoDict[@"IsFree"] intValue] == 0&&[Toolkit isVip] == NO)
        {
            
                shouldPay = YES;
                if(playerCtrl.view.superview !=nil)
                {
                    [playerCtrl.view removeFromSuperview];
                    [playerCtrl goBackButtonAction];
                }
            
        }
        else
        {
            shouldPay = NO;
            
            playerCtrl.delegate = self;
            
            playerCtrl.view.frame=CGRectMake(0, 0, SCREEN_WIDTH, 4*_cellHeight +172);
            
            playerCtrl.backView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 4*_cellHeight+172);
            
            _VideoViewFrame=CGRectMake(0, 0, SCREEN_WIDTH, 4*_cellHeight+172);
            
            _backViewFrame=playerCtrl.backView.frame;
            
            playerCtrl.modeBtn.frame=CGRectMake(SCREEN_WIDTH-50, playerCtrl.modeBtn.frame.origin.y, playerCtrl.modeBtn.frame.size.width, playerCtrl.modeBtn.frame.size.height);
            
             _modleBtnFrame=playerCtrl.modeBtn.frame;
            
            [playerCtrl.modeBtn addTarget:self action:@selector(changeModle:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.view addSubview:playerCtrl.view];
            
            btn_goBack=[[UIButton alloc] initWithFrame:CGRectMake(10, 20, 30, 30)];
            
            [btn_goBack setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
            
            [btn_goBack addTarget:self action:@selector(clickLeftButton:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.view addSubview:btn_goBack];
            
            [self.view bringSubviewToFront:btn_goBack];
            
            [playerCtrl nextVideo:[NSURL URLWithString:VideoPath] andTitle:dict[@"data"][@"Title"]];
        }
        
        
        DataProvider * dataprovider=[[DataProvider alloc] init];
        
        [dataprovider setDelegateObject:self setBackFunctionName:@"GetOtherVideoDetialCallBack:"];
        
        [dataprovider getUserid:dict[@"data"][@"UserId"] andNum:@"4" andmessageID:dict[@"data"][@"Id"]];
        
        
        
    }
}

-(void)changeModle:(UIButton *)sender
{
    if (sender.tag!=1) {
        
        [playerCtrl.modeBtn setImage:[UIImage imageNamed:@"small"] forState:UIControlStateNormal];
        
        sender.tag=1;
        
        playerCtrl.view.frame=CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT);
        
        playerCtrl.backView.frame=CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
        
        playerCtrl.carrier.frame=CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
        
        playerCtrl.modeBtn.frame=CGRectMake(SCREEN_HEIGHT-40,playerCtrl.modeBtn.frame.origin.y , playerCtrl.modeBtn.frame.size.width , playerCtrl.modeBtn.frame.size.height);
        
        playerCtrl.backView.center=CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT/2 );
        
        CGAffineTransform transform = CGAffineTransformMakeRotation(90 * M_PI/180.0);
        
        [playerCtrl.backView setTransform:transform];
        
        [self.view bringSubviewToFront:playerCtrl.view];
        
    
        
    }
    else
    {
        
        [sender setImage:[UIImage imageNamed:@"big"] forState:UIControlStateNormal];
        
        sender.tag=0;
        
        CGAffineTransform transform = CGAffineTransformMakeRotation(0 * M_PI/180.0);
        
        [playerCtrl.backView setTransform:transform];
        
        playerCtrl.modeBtn.frame=_modleBtnFrame;
        
        playerCtrl.backView.frame=_backViewFrame;
        
        playerCtrl.view.frame=_VideoViewFrame;
    }
    [self.view bringSubviewToFront:btn_goBack];
}

-(void)GetVideoCommentDetial
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetVideoCommentDetialCallBack:"];
    
    [dataprovider getMessageIdInfo:_videoID];
}

-(void)GetVideoCommentDetialCallBack:(id)dict
{
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try
        {
            if(videoCommentArray !=nil && videoCommentArray.count>0)
              [ videoCommentArray removeAllObjects];
            
            [videoCommentArray addObjectsFromArray:dict[@"data"]];
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
            [_mainTableView reloadData];
            [SVProgressHUD dismiss];
            NSLog(@"完成");
        }
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"data"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }
    
}


-(void)GetOtherVideoDetialCallBack:(id)dict
{
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try
        {
            if(otherVideoArray !=nil && otherVideoArray.count>0)
              [ otherVideoArray removeAllObjects];
            
            [otherVideoArray addObjectsFromArray:dict[@"data"]];
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
            [_mainTableView reloadData];
            [SVProgressHUD dismiss];
            NSLog(@"完成");
        }
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"data"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }
    
}
-(void)commentCallBack:(id)dict
{
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try
        {
            [SVProgressHUD showSuccessWithStatus:@"评论成功" maskType:SVProgressHUDMaskTypeBlack];
            commentTextView.text = @"";
            [self GetVideoCommentDetial];
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
            [_mainTableView reloadData];
        }
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"data"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark - 手势代理

//设置点在某个view时部触发事件
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"-%@", NSStringFromClass([touch.view class]));
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}
////设置多个view同时响应事件
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    NSLog(@"--%@", NSStringFromClass([otherGestureRecognizer.view class]));
//    if (
//        [NSStringFromClass([otherGestureRecognizer.view class]) isEqualToString:@"UITableViewCellContentView"]
//        ||[NSStringFromClass([otherGestureRecognizer.view class]) isEqualToString:@"UITableView"]
//        ||[NSStringFromClass([otherGestureRecognizer.view class]) isEqualToString:@"UILayoutContainerView"]
//        ||[NSStringFromClass([otherGestureRecognizer.view class]) isEqualToString:@"UITableViewCellScrollView"]
//        )
//        //    if ([otherGestureRecognizer.view isKindOfClass:[UITableViewWrapperView class]])
//    {
//        NSLog(@"return Yes");
//        return YES;
//    }
//    return NO;
//}

#pragma mark - click actions

-(void)otherVideoBtnClick:(UIButton *)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否切换视频" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
    alertView.delegate = self;
    alertView.tag = sender.tag+2016;
    [alertView show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0&&alertView.tag>=2016)
    {
        self.videoID = otherVideoArray[alertView.tag-2016][@"Id"];
        [self getData];
    }
}

-(void)shareContentBuild
{
    NSArray* imageArray = @[[UIImage imageNamed:@"108"]];
    
    NSString *strurl=[NSString stringWithFormat:@"http://www.hewuzhe.com/"];
    if (imageArray) {
        @try {
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKSetupShareParamsByText:[[@"艾特功夫上线啦！快来乐享" stringByAppendingString:@"降龙十八掌"] stringByAppendingString:strurl]
                                             images:imageArray
                                                url:[NSURL URLWithString:strurl]
                                              title:@"艾特功夫"
                                               type:SSDKContentTypeAuto];
            
            
            [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                     items:nil
                               shareParams:shareParams
                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                           
                           switch (state) {
                               case SSDKResponseStateSuccess:
                               {
                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                       message:nil
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"确定"
                                                                             otherButtonTitles:nil];
                                   [alertView show];
                                   break;
                               }
                               case SSDKResponseStateFail:
                               {
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                   message:[NSString stringWithFormat:@"%@",error]
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"OK"
                                                                         otherButtonTitles:nil, nil];
                                   [alert show];
                                   break;
                               }
                               default:
                                   break;
                           }
                           
                       }];

        }
        @catch (NSException *exception) {
            NSLog(@"Crash");
        }
        @finally {
            
        }
        
    }
}

-(void)tapViewAction:(id)sender
{
    [self.view endEditing:YES];
//    [commentTextView resignFirstResponder];
}

-(void)clickLeftButton:(UIButton *)sender
{
 //   moviePlayerview=[[MoviePlayer alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 4*_cellHeight) URL:[NSURL URLWithString:@""]];
//    [moviePlayerview stopPlayer];
    [playerCtrl goBackButtonAction];
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

-(void)goPayBtnClick:(UIButton *)sender
{
    VipViewController *vipViewCtl = [[VipViewController alloc] init];
    vipViewCtl.navtitle = @"会员详情";
    [self.navigationController pushViewController:vipViewCtl animated:YES];
}

//-(void)clickRightButton:(UIButton *)sender
//{
//    JvbaoView *jvbaoView = [[JvbaoView alloc] init];
//    jvbaoView.delegate = self;
//    [jvbaoView show];
//    
////    DataProvider * dataprovider=[[DataProvider alloc] init];
////    [dataprovider setDelegateObject:self setBackFunctionName:@"MakeActionCallBack:"];
////    //举报
////    [dataprovider voiceAction:_videoID andUserId:[Toolkit getUserID] andFlg:@"3" andDescription:nil];
//}

-(void)JUbao:(UIButton *)sender
{
    JvbaoView *jvbaoView = [[JvbaoView alloc] init];
    jvbaoView.delegate = self;
    [jvbaoView show];
}

-(void)JvbaoSureBtnClick:(NSString *)content
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"MakeActionCallBack:"];
    //举报
    actionType = jubao;
    [dataprovider voiceAction:_videoID andUserId:[Toolkit getUserID] andFlg:@"3" andDescription:content];
}

-(void)btnClick:(UIButton *)sender
{
//    sender.selected = !sender.selected;
    
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"MakeActionCallBack:"];
    switch (sender.tag) {
        case 0:
        {
            if(sender.selected == NO)
            {
                sender.selected = YES;
                NSLog(@"点赞");
                actionType = setZan;
                [dataprovider voiceAction:_videoID andUserId:[Toolkit getUserID] andFlg:@"2" andDescription:nil];
            }
            else
            {
                sender.selected = NO;
                NSLog(@"取消点赞");
                actionType = cancelZan;
//                DataProvider * dataprovider=[[DataProvider alloc] init];
                [dataprovider voicedelete:_videoID andUserId:[Toolkit getUserID] andFlg:@"2"];
            }
        }
            break;
        case 1:
        {
            if(sender.selected == NO)
            {
                sender.selected = YES;
                NSLog(@"收藏");
                actionType = setCollect;
//                DataProvider * dataprovider=[[DataProvider alloc] init];
                [dataprovider voiceAction:_videoID andUserId:[Toolkit getUserID] andFlg:@"1" andDescription:nil];
            }
            else
            {
                sender.selected = NO;
                NSLog(@"取消收藏");
                actionType = cancelCollect;
//                DataProvider * dataprovider=[[DataProvider alloc] init];
                
                [dataprovider voicedelete:_videoID andUserId:[Toolkit getUserID] andFlg:@"1"];
            }
        }
            break;
        case 3:
        {
            if(sender.selected == NO)
            {
                sender.selected = YES;
                NSLog(@"转发");
                actionType = setZhuanfa;
//                DataProvider * dataprovider=[[DataProvider alloc] init];
                [dataprovider voiceAction:_videoID andUserId:[Toolkit getUserID] andFlg:@"0" andDescription:nil];
            }
            else
            {
                sender.selected = NO;
            }
        }
            break;
        case 4:
        {
            
        }
        default:
            break;
    }
    
}



-(void)MakeActionCallBack:(id)dict
{
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        
        
        switch (actionType) {
            case cancelZan:
                [SVProgressHUD showSuccessWithStatus:@"取消赞" maskType:SVProgressHUDMaskTypeBlack];
                break;
            case setZan:
                [SVProgressHUD showSuccessWithStatus:@"赞＋1" maskType:SVProgressHUDMaskTypeBlack];
                break;
            case setCollect:
                [SVProgressHUD showSuccessWithStatus:@"收藏成功" maskType:SVProgressHUDMaskTypeBlack];
                break;
            case cancelCollect:
                [SVProgressHUD showSuccessWithStatus:@"取消收藏" maskType:SVProgressHUDMaskTypeBlack];
                break;
            case setZhuanfa:
                [SVProgressHUD showSuccessWithStatus:@"转发成功" maskType:SVProgressHUDMaskTypeBlack];
                break;
            case jubao:
                [SVProgressHUD showSuccessWithStatus:@"举报已提交等待后台审核" maskType:SVProgressHUDMaskTypeBlack];
                break;
            default:
            {
                [SVProgressHUD showSuccessWithStatus:@"操作成功" maskType:SVProgressHUDMaskTypeBlack];
            }
                break;
        }
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"操作失败:%@",dict[@"data"]] maskType:SVProgressHUDMaskTypeBlack];
    }
}
-(void)sendCommentBtnClick:(id)sender
{
    if(commentTextView.text.length == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入评论内容" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alertView show];
        return;
        
    }
    
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"commentCallBack:"];
    [dataprovider commentVideo:self.videoID andUserId:[Toolkit getUserID] andComment:commentTextView.text];
}

#pragma mark - 键盘操作

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
    //tableView 滚动
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
#pragma mark - text view delegate
- (void)textViewDidChangeSelection:(UITextView *)textView

{
    
//    NSRange range;
//    
//    range.location = 0;
//    
//    range.length = 0;
//    
//    textView.selectedRange = range;
//    
}


#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _sectionNum;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case VideoDetailSection:
            return 2;
            break;
        case OtherVideoSection:
            return 2;
            break;
        case CommentSection:
            return 2+videoCommentArray.count;
            break;
        default:
            break;
    }
    return 1;
    
}

#define ShortHight  10

#pragma mark - setting for cell
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = ItemsBaseColor;
    
    
    switch (indexPath.section) {
        case VideoPlaySection:
        {
            if(shouldPay == YES)
            {
                UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _cellHeight, SCREEN_WIDTH, 50)];
                tipLab.textAlignment  = NSTextAlignmentCenter;
                tipLab.text = @"此视频是付费视频，只有会员才可观看";
                tipLab.textColor = [UIColor whiteColor];
                [cell addSubview:tipLab];
                
                
                UIButton *payBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3, 2*_cellHeight, SCREEN_WIDTH/3, 50)];
                [payBtn setTitle:@"点击付费" forState:UIControlStateNormal];
                payBtn.backgroundColor = YellowBlock;
                payBtn.titleLabel.textColor = [UIColor whiteColor];
                [payBtn addTarget:self action:@selector(goPayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:payBtn];
            }
        }
        break;
        case VideoDetailSection:
        {
            if(indexPath.row == 0)
            {
                
                CGFloat FontSize = 12;
                @try {
                    
                    if(VideoDict == nil)
                        return cell;
                    
                    UserHeadView *headView = [[UserHeadView alloc] initWithFrame:CGRectMake(GapToLeft, 5, _cellHeight-10, _cellHeight-10)
                                                                      andImgName:@"me" andNav:self.navigationController];
                    
                    NSString *url = [NSString stringWithFormat:@"%@%@",Kimg_path,VideoDict[@"PhotoPath"]];
                    [headView.headImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"headImg"]];
                    
                    headView.userId = VideoDict[@"UserId"];
                    
                    [headView makeSelfRound];
                    [cell addSubview:headView];
                    /*name*/
                    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake((headView.frame.origin.x +headView.frame.size.width + 10),
                                                                                 headView.frame.origin.y, 140, headView.frame.size.height/2)];
                    nameLab.text = [VideoDict[@"UserNicName"] isEqual:[NSNull null]]?@"":VideoDict[@"UserNicName"];
                    nameLab.textColor = TextColors;
                    nameLab.font = [UIFont systemFontOfSize:FontSize];
                    
                    if(VideoDict[@"UserNicName"]==nil || [VideoDict[@"UserNicName"] length] == 0)
                    {
                        nameLab.text = @"佚名";
                    }
                    
                    [cell addSubview:nameLab];
                    
                    
//                    /*举报*/
//                    UIButton *jubaoBtn = [[UIButton alloc] initWithFrame:CGRectMake((nameLab.frame.origin.x +nameLab.frame.size.width + 10),
//                                         btnClick:) forControlEvents:UIControlEventTouchUpInside];
//                    [cell addSubview:jubaoBtn];                                           headView.frame.origin.y, 40, headView.frame.size.height/2)];
//                    [jubaoBtn setTitle:@"举报" forState:UIControlStateNormal];
//                    jubaoBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize];
//                    jubaoBtn.tag = 4;
//                    
                    /*date*/
                    UILabel *dateLab = [[UILabel alloc] initWithFrame:CGRectMake(nameLab.frame.origin.x,
                                                                                 (nameLab.frame.origin.y + nameLab.frame.size.height + 2),
                                                                                 100, headView.frame.size.height/2)];
                    
                    dateLab.text = [[NSString stringWithFormat:@"%@",VideoDict[@"UserId"]] isEqualToString:@"0"]?[NSString stringWithFormat:@"播放次数%@",[VideoDict[@"VisitNum"] isEqual:[NSNull null]]?@"0":VideoDict[@"VisitNum"]]:[NSString stringWithFormat:@"发布于%@",[self GetDateWith:VideoDict[@"PublishTime"]]];//如果是系统发布的，则显示播放次数
                    dateLab.textColor = TextColors;
                    dateLab.font = [UIFont systemFontOfSize:FontSize];
                    [cell addSubview:dateLab];
                    
                    /* 四个点击图标 放到一个新的view上方便计算位置*/
                    
                    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/2 ), 0, SCREEN_WIDTH/2 , _cellHeight)];
                    backView.backgroundColor = cell.backgroundColor;
                    [cell addSubview:backView];
                    CGFloat btnW = backView.frame.size.width/4 - 5;
                    CGFloat btnGap = 5;
                    SupportBtn.frame = CGRectMake(backView.frame.size.width-2*(btnW+5), 5, btnW, backView.frame.size.height-10);
                    [SupportBtn setTitle:@"点赞" forState:UIControlStateNormal];
                    SupportBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize];
                    [SupportBtn setImage:[UIImage imageNamed:@"support"] forState:UIControlStateNormal];
                    [SupportBtn setImage:[UIImage imageNamed:@"support_h"] forState:UIControlStateSelected];
                    SupportBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
                    
                    SupportBtn.tag = 0;
                    SupportBtn.imageView.contentMode = UIViewContentModeCenter;
                    [SupportBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                    //SupportBtn.backgroundColor = [UIColor redColor];
                    [backView addSubview:SupportBtn];
                    
                    
                    
                    
                    collectBtn.frame = CGRectMake(backView.frame.size.width-btnW-5, 5, btnW, backView.frame.size.height-10);
                    [collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
                    collectBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize];
                    [collectBtn setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
                    [collectBtn setImage:[UIImage imageNamed:@"collect_h"] forState:UIControlStateSelected];
                    collectBtn.imageView.contentMode = UIViewContentModeCenter;
                    collectBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
                    collectBtn.tag = 1;
                    [collectBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [backView addSubview:collectBtn];
                    if ([VideoDict[@"IsFree"] intValue] == 1) {
                        CustomButton *shareBtn = [[CustomButton alloc] initWithFrame:CGRectMake(backView.frame.size.width-3*(btnW+5), 5, btnW, backView.frame.size.height-10)];
                        [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
                        shareBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize];
                        [shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
                        shareBtn.imageView.contentMode = UIViewContentModeCenter;
                        shareBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
                        shareBtn.tag = 2;
                        [shareBtn addTarget:self action:@selector(shareContentBuild) forControlEvents:UIControlEventTouchUpInside];
                        [backView addSubview:shareBtn];
                        
                        CustomButton *relayBtn = [[CustomButton alloc] initWithFrame:CGRectMake(backView.frame.size.width-4*(btnW+5), 5, btnW, backView.frame.size.height-10)];
                        [relayBtn setTitle:@"转发" forState:UIControlStateNormal];
                        relayBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize];
                        relayBtn.imageView.contentMode = UIViewContentModeCenter;
                        relayBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
                        [relayBtn setImage:[UIImage imageNamed:@"relay"] forState:UIControlStateNormal];
                        relayBtn.tag = 3;
                        [relayBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [backView addSubview:relayBtn];
                    }
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
                /*head */
               
                
            }
            
            if(indexPath.row == 1)
            {
                UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 10, SCREEN_WIDTH-60, 30)];
                titleLab.textColor = TextColors;
                titleLab.text = [VideoDict[@"Title"] isEqual:[NSNull null]]?@"":VideoDict[@"Title"];
                titleLab.font = [UIFont boldSystemFontOfSize:14];
                [cell addSubview:titleLab];
                
                NSString *detailStr = [VideoDict[@"Content"] isEqual:[NSNull null]]?@"":VideoDict[@"Content"];
                CGFloat detailWidth = SCREEN_WIDTH-GapToLeft*2;
                CGFloat detailHeight = [Toolkit heightWithString:detailStr fontSize:12 width:detailWidth];
                
                UILabel *detailLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft,
                                                                               (titleLab.frame.origin.y+titleLab.frame.size.height+5),
                                                                               detailWidth, detailHeight)];
                detailLab.textColor = TextColors;
                detailLab.text = detailStr;
                detailLab.numberOfLines = 0;
                detailLab.font = [UIFont boldSystemFontOfSize:12];
                [cell addSubview:detailLab];
                
                UIButton * btn_jubao=[[UIButton alloc] initWithFrame:CGRectMake(titleLab.frame.origin.x+titleLab.frame.size.width, 10, 40, detailHeight+40)];
                
                [btn_jubao setTitle:@"举报" forState:UIControlStateNormal];
                
                [btn_jubao setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                btn_jubao.backgroundColor=ItemsBaseColor;
                
                [btn_jubao addTarget:self action:@selector(JUbao:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell addSubview:btn_jubao];
            
            }
        }
            break;
        case OtherVideoSection:
        {
            
            
            @try {
                
                if(indexPath.row == 0)
                {
                    cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight-ShortHight);
                    
                    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 0, 150, _cellHeight-ShortHight)];
                    titleLab.text = @"其他作品";
                    titleLab.font = [UIFont systemFontOfSize:14];
                    titleLab.textColor = TextColors;
                    [cell addSubview:titleLab];
                    
                    
                    UILabel *numLab = [[UILabel alloc ] initWithFrame:CGRectMake((SCREEN_WIDTH -80 ), 0, 80, _cellHeight-ShortHight)];
                    if(otherVideoArray == nil)
                    {
                        numLab.text = [NSString stringWithFormat:@"共%d部",0];
                    }
                    else
                        numLab.text = [NSString stringWithFormat:@"共%ld部",(unsigned long)otherVideoArray.count];
                    numLab.font = [UIFont systemFontOfSize:12];
                    numLab.textColor = TextColors;
                    [cell addSubview:numLab];
                    
                    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(numLab.frame.origin.x - 10, 5, 1, _cellHeight-10-ShortHight)];
                    lineView.backgroundColor = Separator_Color;
                    [cell addSubview:lineView];
                    
                }
                
                if(indexPath.row == 1)
                {
                    if(otherVideoArray==nil || otherVideoArray.count <=0  )
                        return cell;
                    
                    UIScrollView *showOtherVideoView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight*2+20)];
                    CGFloat gapWidth;
                    gapWidth =(SCREEN_WIDTH - GapToLeft*2)/3 - (2*_cellHeight -30);
//                    showOtherVideoView.backgroundColor = [UIColor redColor];
                    if (otherVideoArray.count < 4) {
                        showOtherVideoView.contentSize = CGSizeMake(SCREEN_WIDTH, 0);
                    }
                    else
                    {
                        showOtherVideoView.contentSize = CGSizeMake(SCREEN_WIDTH+((otherVideoArray.count-3)*gapWidth)+100, 0);
                    }
                    showOtherVideoView.scrollEnabled = YES;
                    [cell addSubview:showOtherVideoView];
                    
                    for(int i = 0;i< otherVideoArray.count;i++)
                    {
                        NSDictionary *tempDict = otherVideoArray[i];
                        
                        
                        UIImageView *tempView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"temp"]];
                        
                        tempView.frame = CGRectMake(GapToLeft+i*(2*_cellHeight -30 + gapWidth), 10, 2*_cellHeight -30,(2*_cellHeight -30) );
                        NSString *url = [NSString stringWithFormat:@"%@%@",Kimg_path,tempDict[@"ImagePath"]];
                        [tempView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"headImg"]];
                        
                        [showOtherVideoView addSubview:tempView];
                        UILabel *templab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft+i*(2*_cellHeight -30 + gapWidth),
                                                                                     (tempView.frame.origin.y+tempView.frame.size.height+2),
                                                                                     2*_cellHeight -30,
                                                                                     2*_cellHeight+ 20 - (tempView.frame.origin.y+tempView.frame.size.height+2 ) )];
                        templab.text = tempDict[@"Title"];
                        templab.textColor = TextColors;
                        templab.font = [UIFont systemFontOfSize:12];
                        templab.textAlignment = NSTextAlignmentCenter;
                        templab.numberOfLines = 2;
                        [showOtherVideoView addSubview:templab];
                        
                        UIButton *videoBtn = [[UIButton alloc] initWithFrame:CGRectMake(tempView.frame.origin.x, 0, 2*_cellHeight -30, _cellHeight*2)];
                        
                        videoBtn.tag = i;
                        [videoBtn addTarget:self action:@selector(otherVideoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [showOtherVideoView addSubview:videoBtn];
                        
                    }
                }
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
            
        }
            
            break;
        case CommentSection:
        {
            
            
            if(indexPath.row == 0)
            {
                cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight-ShortHight);
                
                UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 0, 150, _cellHeight-ShortHight)];
                titleLab.text = @"用户评论";
                titleLab.font = [UIFont systemFontOfSize:14];
                titleLab.textColor = TextColors;
                [cell addSubview:titleLab];
                
                
                
                UILabel *numLab = [[UILabel alloc ] initWithFrame:CGRectMake((SCREEN_WIDTH -80 ), 0, 80, _cellHeight-ShortHight)];
                numLab.text = [NSString stringWithFormat:@"共%ld条",(unsigned long)videoCommentArray.count];
                numLab.font = [UIFont systemFontOfSize:12];
                numLab.textColor = TextColors;
                [cell addSubview:numLab];
                
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(numLab.frame.origin.x - 10, 5, 1, _cellHeight-10-ShortHight)];
                lineView.backgroundColor = Separator_Color;
                [cell addSubview:lineView];
                
            }
            else if(indexPath.row == 1)
            {
                /*head */
                UserHeadView *headView = [[UserHeadView alloc] initWithFrame:CGRectMake(GapToLeft, 5, _cellHeight-10, _cellHeight-10)
                                                                  andImgName:@"headImg"
                                                                      andNav:self.navigationController];
                
                NSString *url = [NSString stringWithFormat:@"%@%@",Kimg_path,get_sp(@"PhotoPath")];
                [headView.headImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed: @"headImg"]];
                [headView makeSelfRound];
                [cell addSubview:headView];
                
                 commentTextView.frame = CGRectMake((headView.frame.origin.x + headView.frame.size.width+5),
                                                                                      (_cellHeight -44)/2,
                                                                                       (SCREEN_WIDTH -(headView.frame.origin.x + headView.frame.size.width+5) - 80),44 );
                
                tempIndexPath = indexPath;
//                if(commentTextView.superview !=nil)
//                {
//                    [commentTextView removeFromSuperview];
//                }
                [cell addSubview:commentTextView];
                
                UIButton * btn_SendComment=[[UIButton alloc] initWithFrame:CGRectMake(commentTextView.frame.size.width+commentTextView.frame.origin.x+10, commentTextView.frame.origin.y, 60, commentTextView.frame.size.height)];
                
                [btn_SendComment setTitle:@"发布" forState:UIControlStateNormal];
                [btn_SendComment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btn_SendComment addTarget:self action:@selector(sendCommentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                btn_SendComment.backgroundColor=ItemsBaseColor;
                [cell addSubview:btn_SendComment];
            }
            else
            {
                
                
                if(videoCommentArray == nil || videoCommentArray.count <= 0 || videoCommentArray.count < indexPath.row-1)
                    return cell;
                
                @try {
                    NSDictionary *tempDict = videoCommentArray[indexPath.row - 2];
                    
                    
                    UserHeadView *headView = [[UserHeadView alloc] initWithFrame:CGRectMake(GapToLeft, 5, _cellHeight-10, _cellHeight-10)
                                                                      andImgName:@"me"
                                                                          andNav:self.navigationController];
                    
                    NSString *url = [NSString stringWithFormat:@"%@%@",Kimg_path,tempDict[@"CommenterPhotoPath"]];
                    [headView.headImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"headImg"]] ;
                    headView.userId = tempDict[@"CommenterId"];
                    [headView makeSelfRound];
                    [cell addSubview:headView];
                    
                    /*name*/
                    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake((headView.frame.origin.x +headView.frame.size.width + 10),
                                                                                 headView.frame.origin.y, 200, headView.frame.size.height/2)];
                    nameLab.text = tempDict[@"CommenterNicName"];
                    nameLab.textColor = TextColors;
                    nameLab.font = [UIFont systemFontOfSize:12];
                    [cell addSubview:nameLab];
                    
                    
                    UIButton *supportBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 44),headView.frame.origin.y , 44, headView.frame.size.height/2)];
                    [supportBtn setImage:[UIImage imageNamed:@"support"] forState:UIControlStateNormal];
                    [supportBtn setImage:[UIImage imageNamed:@"support_h"] forState:UIControlStateSelected];
                    [supportBtn setTitle:@"20" forState:UIControlStateNormal];
                    [supportBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                    supportBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                   // [cell addSubview:supportBtn];
                    
                    
                    NSString *commentStr = tempDict[@"Content"];
                   // commentWidth = (SCREEN_WIDTH-(headView.frame.origin.x +headView.frame.size.width + 10) - 10);
                    CGFloat commentHeight = [Toolkit heightWithString:commentStr fontSize:12 width:commentWidth];
                    
                    UILabel *commentLab = [[UILabel alloc] initWithFrame:CGRectMake((headView.frame.origin.x +headView.frame.size.width + 10),
                                                                                    headView.frame.size.height/2+5,
                                                                                    commentWidth,
                                                                                    commentHeight)];
                    commentLab.text = commentStr;
                    commentLab.font = [UIFont systemFontOfSize:12];
                    commentLab.numberOfLines = 0;
                    commentLab.textColor = [UIColor whiteColor];
                    [cell addSubview:commentLab];
                    
                    UILabel *dateLab = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100),
                                                                                 (commentLab.frame.size.height+commentLab.frame.origin.y),
                                                                                 100, 30)];
                    dateLab.text =[tempDict[@"PublishTime"] substringToIndex:10];
                    dateLab.font = [UIFont systemFontOfSize:12];
                    dateLab.textColor = [UIColor grayColor];
                    
                    [cell addSubview:dateLab];
                    

                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
                
            }
        }
            break;
        default:
            break;
    }
    
    
    return cell;
    
}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section != 0)
    {
       
        
        if(indexPath.section == OtherVideoSection || indexPath.section == CommentSection)
        {
            if(indexPath.row == 0)
                return _cellHeight -ShortHight;
        }
        if(indexPath.row == 0)
        {
            return _cellHeight;
        }
    }
    
    switch (indexPath.section) {
        case 0:
            return 4*_cellHeight+108 ;
            break;
        case 1:
        {
            NSString *detailStr = [VideoDict[@"Content"] isEqual:[NSNull null]]?@"":VideoDict[@"Content"];
            CGFloat detailWidth = SCREEN_WIDTH-GapToLeft*2;
            CGFloat detailHeight = [Toolkit heightWithString:detailStr fontSize:12 width:detailWidth];
            
            return detailHeight + 10+_cellHeight;
        }
            break;
        case 2:
            return 2*_cellHeight+20;
            break;
        case CommentSection:
        {
            if(indexPath.row == 1)
                return _cellHeight;
        
            NSString *commentStr = videoCommentArray[indexPath.row - 2][@"Content"];
            //commentWidth = (SCREEN_WIDTH-(headView.frame.origin.x +headView.frame.size.width + 10) - 10);
            CGFloat commentHeight = [Toolkit heightWithString:commentStr fontSize:12 width:commentWidth];
            return commentHeight + 30+(_cellHeight-10)/2+10;
        }
            break;

        default:
            break;
    }
    
    return _cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    NSLog(@"click cell section : %ld row : %ld",(long)indexPath.section,(long)indexPath.row);
    
    if(indexPath.section == CommentSection)
    {
        if(indexPath.row < 2)
            return;

        if(videoCommentArray == nil || videoCommentArray.count <= 0 || videoCommentArray.count < indexPath.row-1)
            return;
        @try {
            NSDictionary *tempDict = videoCommentArray[indexPath.row -2];
            
            commentTextView.text = [NSString stringWithFormat:@"回复://%@:%@",tempDict[@"CommenterNicName"],tempDict[@"Content"]];
            [_mainTableView scrollToRowAtIndexPath:tempIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            [commentTextView becomeFirstResponder];
            
            NSRange range;
            range.location = 0;
            range.length = 0;
            commentTextView.selectedRange = range;//光标设置到开始位置
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }

    }
    
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
    tempView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
    return tempView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *tempView = [[UIView alloc] init];
    tempView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 10);
    return tempView;
}
//设置section header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
//    if(section != 0)
//        return _cellHeight;
//    else
    return 1;
}

//设置section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark 播放器代理
- (NSURL *)playCtrlGetCurrMediaTitle:(NSString **)title lastPlayPos:(long *)lastPlayPos
{
    return [NSURL URLWithString:VideoPath];
}
- (NSURL *)playCtrlGetNextMediaTitle:(NSString **)title lastPlayPos:(long *)lastPlayPos
{
    return [NSURL URLWithString:VideoPath];
}

- (NSURL *)playCtrlGetPrevMediaTitle:(NSString **)title lastPlayPos:(long *)lastPlayPos
{
    return [NSURL URLWithString:VideoPath];
}

-(NSString *)GetDateWith:(NSString *)dateStr
{
    @try {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDate *date = [dateFormatter dateFromString:dateStr];
        
        [dateFormatter setDateFormat:@"MM月dd日"];
        
        NSString *strHour = [dateFormatter stringFromDate:date];
        
        return strHour;
    }
    @catch (NSException *exception) {
        return @"";
    }
    @finally {
        
    }
}



@end
