//
//  AnnounceDetailViewController.m
//  KongFuCenter
//
//  Created by Wangjc on 16/1/6.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "AnnounceDetailViewController.h"

@interface AnnounceDetailViewController ()
{
    UITextView *ContentView;
}
@end

@implementation AnnounceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"left"];
    
    if(ContentView ==nil)
        ContentView = [[UITextView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height)];
    
    ContentView.editable = NO;
    ContentView.backgroundColor = BACKGROUND_COLOR;
    ContentView.textColor = [UIColor whiteColor];
    ContentView.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:ContentView];
    // Do any additional setup after loading the view.
}

-(void)setAnnounceDetailDict:(NSDictionary *)announceDetailDict
{
    _announceDetailDict = announceDetailDict;
    
    if(ContentView ==nil)
        ContentView = [[UITextView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height)];
    
    ContentView.text = _announceDetailDict[@"Content"];
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
