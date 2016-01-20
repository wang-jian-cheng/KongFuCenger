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

@interface ChatContentViewController ()<RCLocationPickerViewControllerDelegate>{
    UIView *topView;
    NSUserDefaults *userDefault;
    NSString *friendID;
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
    messageCollectionView.frame = CGRectMake(0, NavigationBar_HEIGHT + StatusBar_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_HEIGHT - StatusBar_HEIGHT - TabBar_HEIGHT);
    messageCollectionView.backgroundColor = BACKGROUND_COLOR;
    [self scrollToBottomAnimated:YES];
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

@end
