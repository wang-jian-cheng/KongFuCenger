//
//  CustomTabBarViewController.m
//  Blinq
//
//  Created by Sugar on 13-8-12.
//  Copyright (c) 2013年 Sugar Hou. All rights reserved.
//

#import "CustomTabBarViewController.h"
#import "UIImage+NSBundle.h"
#import "KongFuerViewController.h"
#import "KongFuPowerViewController.h"
#import "KongFuUnionViewController.h"
#import "MoreViewController.h"
#import "Toolkit.h"


#if KONGFU_VER2
#define tabBarButtonNum 5
#else
#define tabBarButtonNum 4
#endif
@interface CustomTabBarViewController ()
{
    NSArray *_arrayImages;
    UIButton *_btnSelected;
    UIView *_tabBarBG;
    
    NSMutableArray *btnArr;
}
@end

@implementation CustomTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //隐藏系统tabbar
    self.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
 //    NSArray *arrayImages_H = [[NSArray alloc] initWithObjects:@"home_H@2x.png",@"classes_H@2x.png" ,@"cate_H@2x.png",@"user_H@2x.png", nil];
 	NSArray *arrayImages = [[NSArray alloc] initWithObjects:@"hewuzhe@2x.png",@"helianmeng@2x.png",@"hedongli@2x.png",
#if KONGFU_VER2
                            @"hezhuangbei@2x.png",
#endif
                            @"more@2x.png",  nil];
 
    _tabBarBG = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - TabBar_HEIGHT, SCREEN_WIDTH, TabBar_HEIGHT)];
      _tabBarBG.backgroundColor = navi_bar_bg_color;
    
    //_tabBarBG.backgroundColor=[UIColor clearColor];
    //_tabBarBG.alpha=0.9;
    [self.view addSubview:_tabBarBG];
//    UIImageView *imageline1=[[UIImageView alloc]initWithFrame:CGRectMake(0,0.3, SCREEN_WIDTH, 0.3)];
//    imageline1.backgroundColor=[UIColor colorWithRed:0.88 green:0.89 blue:0.89 alpha:1];
//    [self.view addSubview:imageline1];
    //自定义tabbar的按钮和图片
    btnArr = [NSMutableArray array];
    int tabBarWitdh = SCREEN_WIDTH * 1.0f / tabBarButtonNum;
	for(int i = 0; i < tabBarButtonNum; i++)
	{
		CGRect frame=CGRectMake(i * tabBarWitdh, 0, tabBarWitdh, TabBar_HEIGHT);
    
		UIButton * btnTabBar = [[UIButton alloc] initWithFrame:frame];
		 [btnTabBar setImage: [UIImage imageWithBundleName:[arrayImages objectAtIndex:i]] forState:UIControlStateNormal];
         //[btnTabBar setImage:[UIImage imageWithBundleName:[arrayImages_H objectAtIndex:i]]forState:UIControlStateSelected] ;
        
//        [btnTabBar setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
//        [btnTabBar setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        
        btnTabBar.titleLabel.font=[UIFont systemFontOfSize:8.0];
        btnTabBar.titleLabel.textAlignment=NSTextAlignmentCenter;

		btnTabBar.tag = i + 1000;
		[btnTabBar addTarget:self action:@selector(onTabButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[_tabBarBG addSubview:btnTabBar];
        [btnArr addObject:btnTabBar];
        
//        UILabel *lbl_title = [[UILabel alloc] initWithFrame:CGRectMake(btnTabBar.frame.origin.x, 37, btnTabBar.frame.size.width, 9)];
//        lbl_title.text =[arrayTitle objectAtIndex:i];
//        lbl_title.textAlignment=NSTextAlignmentCenter;
//        lbl_title.numberOfLines = 0;
//        lbl_title.font = [UIFont systemFontOfSize:10];
//        lbl_title.textColor = [UIColor darkGrayColor];
//        lbl_title.backgroundColor = [UIColor clearColor];
//        [_tabBarBG addSubview:lbl_title];
        

        
	}
    
    
   
    KongFuerViewController *HomeView=[[KongFuerViewController alloc]init];
    if ([Toolkit isSystemIOS7]||[Toolkit isSystemIOS8])
        HomeView.automaticallyAdjustsScrollViewInsets = NO;
    BaseNavViewController * homeviewnav=[[BaseNavViewController alloc]initWithRootViewController:HomeView];
//    homePageNavigation.automaticallyAdjustsScrollViewInsets = YES;
    HomeView.hidesBottomBarWhenPushed = YES;
    homeviewnav.navigationBar.hidden=YES;
    
    KongFuUnionViewController *typeView=[[KongFuUnionViewController alloc]init];
    BaseNavViewController *typeViewnav = [[BaseNavViewController alloc] initWithRootViewController:typeView];
    typeView.hidesBottomBarWhenPushed=YES;
    typeViewnav.navigationBar.hidden=YES;
    
    KongFuPowerViewController *shoplistView=[[KongFuPowerViewController alloc]init];
    BaseNavViewController *shoplistViewnav = [[BaseNavViewController alloc] initWithRootViewController:shoplistView];
    shoplistView.hidesBottomBarWhenPushed = YES;
    shoplistViewnav.navigationBarHidden=YES;
    //消息
    
#if KONGFU_VER2
    
    KongFuStoreViewController *store = [[KongFuStoreViewController alloc] init];
    BaseNavViewController *storenav = [[BaseNavViewController alloc] initWithRootViewController:store];
    store.hidesBottomBarWhenPushed=YES;
    storenav.navigationBar.hidden=YES;
#endif
    
    MoreViewController *ShoppingCart=[[MoreViewController alloc]init];
    BaseNavViewController *ShoppingCartnav = [[BaseNavViewController alloc] initWithRootViewController:ShoppingCart];
    ShoppingCart.hidesBottomBarWhenPushed=YES;
    ShoppingCartnav.navigationBar.hidden=YES;
 

    //加入到真正的tabbar
    //fix me 商铺选项卡暂时隐藏
    self.viewControllers=[NSArray arrayWithObjects:homeviewnav,typeViewnav,shoplistViewnav,
#if KONGFU_VER2
                          storenav,
#endif
                          ShoppingCartnav,nil];
    
    UIButton *btnSender = (UIButton *)[self.view viewWithTag:0 + 1000];
    [self onTabButtonPressed:btnSender];
    
    
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.selectedViewController supportedInterfaceOrientations];//UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate
{
    return [self.selectedViewController shouldAutorotate];
}


//点击tab页时的响应
-(void)onTabButtonPressed:(UIButton *)sender
{
    
    sender.backgroundColor = YellowBlock;
    for(int i = 0;i<btnArr.count;i++)
    {
        UIButton *tempBtn;
        if(i == sender.tag-1000)
            continue;
        tempBtn = btnArr[i];
        tempBtn.backgroundColor = navi_bar_bg_color;
    }
    
    if (_btnSelected == sender)
        return ;
    
    if (_btnSelected)
        _btnSelected.selected = !_btnSelected.selected;
    
    sender.selected = !sender.selected;
    _btnSelected = sender;
    [self setSelectedIndex:sender.tag - 1000];
}

- (void)selectTableBarIndex:(NSInteger)index
{
    if (index < 0 || index > 5)
        return ;
    UIButton *btnSender = (UIButton *)[self.view viewWithTag:index + 1000];
    [self onTabButtonPressed:btnSender];
}

//隐藏tabbar
- (void)hideCustomTabBar
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	_tabBarBG.frame=CGRectMake(0, SCREEN_HEIGHT, 320, _tabBarBG.frame.size.height);
	[UIView commitAnimations];
	
}
//显示tabbar
-(void)showTabBar
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	_tabBarBG.frame=CGRectMake(0, SCREEN_HEIGHT - TabBar_HEIGHT, SCREEN_WIDTH, _tabBarBG.frame.size.height);
	[UIView commitAnimations];
}

- (void)goToHomePage
{
    [self setSelectedIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
