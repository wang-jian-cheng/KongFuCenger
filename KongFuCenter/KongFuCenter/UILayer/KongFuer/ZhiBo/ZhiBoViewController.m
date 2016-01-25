//
//  ZhiBoViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/9.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "ZhiBoViewController.h"

@interface ZhiBoViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIImageView *_mainImgView;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@end

@implementation ZhiBoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"left"];
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    
//    [self initViews];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height)];
    
    webView.scalesPageToFit = YES;
    
    [self.view addSubview:webView];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@zhibo.aspx",Url]];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [webView loadRequest:request];
//    [[UIDevice currentDevice] setValue: [NSNumber numberWithInteger: UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
    
    // Do any additional setup after loading the view from its nib.
}


-(void)initViews
{
    _contentView.backgroundColor = ItemsBaseColor;
    _titleLab.backgroundColor = ItemsBaseColor;
    _titleLab.textColor = [UIColor whiteColor];
    
    _dateLab.backgroundColor = ItemsBaseColor;
    _dateLab.textColor = [UIColor whiteColor];
    
    _contentLab.backgroundColor = ItemsBaseColor;
    _contentLab.textColor = [UIColor whiteColor];
    _contentLab.font = [UIFont systemFontOfSize:14];
    
    _checkBtn.backgroundColor = ItemsBaseColor;
    [_checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    CGRect temprect;
    temprect = _checkBtn.frame;
    temprect.size.width = (SCREEN_WIDTH/3);
    _checkBtn.frame = temprect;
    
}

//-(UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskAll;
//}
//
//-(BOOL)shouldAutorotate
//{
//    return YES;
//}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
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
