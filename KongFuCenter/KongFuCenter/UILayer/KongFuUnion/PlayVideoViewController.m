//
//  PlayVideoViewController.m
//  KongFuCenter
//
//  Created by Rain on 15/12/28.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "PlayVideoViewController.h"
#import "MoviePlayer.h"

@interface PlayVideoViewController ()
{
    MoviePlayer *player;
}
@end

@implementation PlayVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarTitle:@"视频"];
    [self addLeftButton:@"left"];
    NSLog(@"%@",_videoPath);
    NSString *url = [NSString stringWithFormat:@"%@%@",Url,_videoPath];
    url = [url stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    player = [[MoviePlayer alloc] initWithFrame:CGRectMake(0,64,SCREEN_WIDTH, SCREEN_HEIGHT - 64) URL:[NSURL URLWithString:url]];
    [self.view addSubview:player];
}


-(void)clickLeftButton:(UIButton *)sender
{
    [player stopPlayer];
    
    [self.navigationController popViewControllerAnimated:NO];
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
