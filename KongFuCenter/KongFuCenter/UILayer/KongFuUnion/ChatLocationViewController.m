//
//  ChatLocationViewController.m
//  HiHome
//
//  Created by 于金祥 on 15/10/30.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "ChatLocationViewController.h"
#import "UIImage+NSBundle.h"

#define DefaultLeftImageWidth 44


@interface ChatLocationViewController ()

@end

@implementation ChatLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([Toolkit isSystemIOS7]||[Toolkit isSystemIOS8])
        _orginY = 20;
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavigationBar_HEIGHT + _orginY)];
    //_topView.backgroundColor = [UIColor colorWithRed:238 / 255.0f green:225 / 255.0f blue:208 / 255.0f alpha:1.0f];
    
    _topView.userInteractionEnabled = YES;
    //   _topView.backgroundColor = [UIColor colorWithRed:237/255.0 green:109/255.0 blue:3/255.0 alpha:1];
    
    _topView.backgroundColor = navi_bar_bg_color;//ZY_UIBASECOLOR;
    [self.view addSubview:_topView];
    //    UIImageView *imageline1=[[UIImageView alloc]initWithFrame:CGRectMake(0,NavigationBar_HEIGHT + _orginY-0.3, SCREEN_WIDTH, 0.3)];
    //    imageline1.backgroundColor=[UIColor colorWithRed:0.88 green:0.89 blue:0.89 alpha:1];
    //    [self.view addSubview:imageline1];
    
    
    _lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(DefaultLeftImageWidth, _orginY  + 0, SCREEN_WIDTH - 2 * DefaultLeftImageWidth, NavigationBar_HEIGHT)];
    _lblTitle.backgroundColor = [UIColor clearColor];
    _lblTitle.adjustsFontSizeToFitWidth = YES;
    //[_lblTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    //_lblTitle.font = [UIFont boldSystemFontOfSize:20];
    _lblTitle.textColor = [UIColor whiteColor];
    _lblTitle.font=[UIFont boldSystemFontOfSize:18];
    _lblTitle.textAlignment = NSTextAlignmentCenter;
    _lblTitle.lineBreakMode = NSLineBreakByTruncatingTail;
    _lblTitle.numberOfLines = 0;
    _lblTitle.center = CGPointMake(_topView.center.x, _lblTitle.center.y);
    _lblTitle.text=@"会话";
    [self.view addSubview:_lblTitle];
    
    _imgLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, _orginY, 60, NavigationBar_HEIGHT)];
    _imgLeft.backgroundColor = [UIColor clearColor];
    _imgLeft.center = CGPointMake(_imgLeft.center.x, _lblTitle.center.y);
    [self.view addSubview:_imgLeft];
    
    _lblLeft = [[UILabel alloc] initWithFrame:CGRectMake(0,_orginY ,60,40)];
    
    _lblLeft.numberOfLines = 0;
    _lblLeft.textAlignment=NSTextAlignmentCenter;
    _lblLeft.font = [UIFont systemFontOfSize:15];
    _lblLeft.textColor = [UIColor whiteColor];
    _lblLeft.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_lblLeft];
    
    
    
    _btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, _orginY, 60, NavigationBar_HEIGHT)];
    [_btnLeft addTarget:self action:@selector(clickLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    _btnLeft.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_btnLeft];
    
    _imgRight = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60 , _orginY, 60, NavigationBar_HEIGHT)];
    _imgRight.backgroundColor = [UIColor clearColor];
    _imgRight.center = CGPointMake(_imgRight.center.x, _imgLeft.center.y);
    [self.view addSubview:_imgRight];
    
    _lblRight = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60-10 ,_orginY ,60,40)];
    
    _lblRight.numberOfLines = 0;
    _lblRight.textAlignment=NSTextAlignmentCenter;
    _lblRight.font = [UIFont systemFontOfSize:15];
    _lblRight.textColor = [UIColor whiteColor];
    _lblRight.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_lblRight];
    
    _btnRight = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, _orginY, 60, NavigationBar_HEIGHT)];
    _btnRight.backgroundColor = [UIColor clearColor];
    [_btnRight addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnRight];
    
    
    
    [self addLeftButton:@"goback@2x.png"];
    [self addRightbuttontitle:@"完成"];
    
    
    self.mapViewContainer.frame=CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-113);

}

- (void)setBarTitle:(NSString *)strTitle
{
    _lblTitle.text = strTitle;
    _lblTitle.center = CGPointMake(_topView.center.x, _lblTitle.center.y);
}

- (void)setBarTitleColor:(UIColor *)color
{
    _lblTitle.textColor = color;
}

- (void)addLeftButton:(NSString *)strImage
{
    UIImage *imgBtn = [UIImage imageWithBundleName:strImage];
    _imgLeft.image = imgBtn;
    [_imgLeft setFrame:CGRectMake(_btnLeft.frame.origin.x + 10, _btnLeft.frame.origin.y, imgBtn.size.width , imgBtn.size.height )];
    _imgLeft.center = CGPointMake(_imgLeft.center.x, _lblTitle.center.y);
}

- (void)addRightButton:(NSString *)strImage
{
    UIImage *imgBtn = [UIImage imageWithBundleName:strImage];
    _imgRight.image = imgBtn;
    [_imgRight setFrame:CGRectMake(_btnRight.frame.origin.x + 25, _btnRight.frame.origin.y,imgBtn.size.width , imgBtn.size.height )];
    _imgRight.center = CGPointMake(_imgRight.center.x, _imgLeft.center.y);
    
    
    //    UIImage *imgBtn = [UIImage imageWithBundleName:strImage];
    //    _imgRight.image = imgBtn;
    //    [_imgRight setFrame:CGRectMake(_btnRight.frame.origin.x + 10, _btnRight.frame.origin.y, imgBtn.size.width, imgBtn.size.height)];
    //    _imgRight.center = CGPointMake(_imgRight.center.x, _imgLeft.center.y);
}
- (void)addLeftbuttontitle:(NSString *)strName
{
    _lblLeft.text=strName;
}
- (void)addRightbuttontitle:(NSString *)strName
{
    _lblRight.text=strName;
}

- (void)clickLeftButton:(UIButton *)sender
{
    [self QuitVC];
}

- (void)clickRightButton:(UIButton *)sender
{
    [self rightBarButtonItemPressed:sender];
    [self QuitVC];
    
}
-(void)QuitVC
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setleftbtn" object:nil userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:@"hide"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:@"hide"]];
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
