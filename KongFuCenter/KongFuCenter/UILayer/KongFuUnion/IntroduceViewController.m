//
//  IntroduceViewController.m
//  KongFuCenter
//
//  Created by 鞠超 on 15/12/16.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "IntroduceViewController.h"

@interface IntroduceViewController ()

@property (nonatomic, strong) UIScrollView * scrollView;
//顶部图片
@property (nonatomic, strong) UIImageView * image;
//文字详情
@property (nonatomic, strong) UILabel * detail;
@end

@implementation IntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_navigation];
    
    [self p_scrollView];
    
    [self getTeamIntro];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - self data source 
-(void)getTeamIntro
{
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getTeamIntroCallBack:"];
    [dataProvider getTeamIntro:get_sp(TEAM_ID)];
    
}

-(void)getTeamIntroCallBack:(id)dict
{
    DLog(@"%@",dict);
    [SVProgressHUD dismiss];
    if ([dict[@"code"] intValue] == 200) {
        @try {
            NSString * str = dict[@"data"][@"TeamIntroduce"];
            CGFloat H = [str boundingRectWithSize:CGSizeMake(self.scrollView.frame.size.width - 20, 2000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:18]} context:nil].size.height;

            CGRect tempRect = self.detail.frame;
            tempRect.size.height = H;
            self.detail.text = str;
            self.detail.frame = tempRect;
            NSString *url = [NSString stringWithFormat:@"%@%@",Kimg_path,dict[@"data"][@"ImagePath"]];
            [self.image sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"yewenback"]];
            
            
            self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, H+SCREEN_HEIGHT);
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"data"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }

}


#pragma mark - 背景色和navigation
- (void)p_navigation
{
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self setBarTitle:@"战队介绍"];
    [self addLeftButton:@"left"];
}

#pragma mark - scrollView
- (void)p_scrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT + StatusBar_HEIGHT + 10, self.view.frame.size.width, self.view.frame.size.height - NavigationBar_HEIGHT - StatusBar_HEIGHT - 10)];
    self.scrollView.backgroundColor = ItemsBaseColor;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    
    self.image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.width * 0.7)];
    self.image.backgroundColor = [UIColor orangeColor];
//    self.image.image = [UIImage imageNamed:@""];
    [self.scrollView addSubview:self.image];
    
    //需要先得到文字的内容判断frame
    NSString * str = @"";
    CGFloat H = [str boundingRectWithSize:CGSizeMake(self.scrollView.frame.size.width - 20, 2000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:18]} context:nil].size.height;
    
    self.detail = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.image.frame) + 10, self.scrollView.frame.size.width - 20, H)];
    self.detail.textColor = [UIColor whiteColor];
    self.detail.text = str;
    self.detail.numberOfLines = 0;
    self.detail.font = [UIFont systemFontOfSize:18];
    [self.scrollView addSubview:self.detail];
    
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(self.detail.frame) + 10);
    [self.view addSubview:self.scrollView];
}




@end
