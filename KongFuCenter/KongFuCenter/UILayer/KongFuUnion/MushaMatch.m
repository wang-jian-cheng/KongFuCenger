//
//  MushaMatch.m
//  KongFuCenter
//
//  Created by Rain on 15/12/8.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "MushaMatch.h"
#import "MushaMatchCell.h"

@interface MushaMatch (){
    //tableview
    UITableView *mTableView;
    CGFloat mCellHeight;
    
    //data
    NSMutableArray *menuArray;
    
    //view
    UIImageView *menuImgView;
}

@end

@implementation MushaMatch

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化参数
    mCellHeight = SCREEN_HEIGHT / 7;
    [self setBarTitle:@"武者大赛"];
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self addLeftButton:@"left"];
    
    //初始化数据
    [self initDatas];
    
    //初始化View
    [self initViews];
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

#pragma mark 自定义方法
-(void)initDatas{
    menuArray = [[NSMutableArray alloc] init];
    [menuArray addObjectsFromArray:@[@"武者赛事",@"战队赛事"]];
}

-(void)initViews{
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, 44)];
    menuImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btnFlag"]];
    menuImgView.contentMode = UIViewContentModeScaleAspectFit;
    menuView.backgroundColor = ItemsBaseColor;
    CGFloat everyMenuWidth = SCREEN_WIDTH / menuArray.count;
    for (int i = 0; i < menuArray.count; i++) {
        UIButton *btnMenu = [[UIButton alloc] initWithFrame:CGRectMake(i * everyMenuWidth, 0, everyMenuWidth , menuView.frame.size.height)];
        if (i == 0) {
            btnMenu.selected = YES;
            menuImgView.frame = CGRectMake((btnMenu.frame.size.width - 15) / 2, btnMenu.frame.size.height - 14, 15, 10);
            [btnMenu addSubview:menuImgView];
        }
        
        [btnMenu setTitle:menuArray[i] forState:UIControlStateNormal];
        btnMenu.titleLabel.font = [UIFont systemFontOfSize:16];
        [btnMenu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnMenu setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        btnMenu.tag = i;
        [btnMenu addTarget:self action:@selector(clickBtnMenuEvent:) forControlEvents:UIControlEventTouchUpInside];
        [menuView addSubview:btnMenu];
    }
    [self.view addSubview:menuView];
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height + 46, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height - 46)];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = BACKGROUND_COLOR;
    mTableView.separatorColor = Separator_Color;
    mTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:mTableView];
}

-(void)clickBtnMenuEvent:(UIButton *)btnMenu{
    for (UIView *view in btnMenu.superview.subviews) {
        ((UIButton *)view).selected = NO;
    }
    menuImgView.frame = CGRectMake((btnMenu.frame.size.width - 15) / 2, btnMenu.frame.size.height - 14, 15, 10);
    [btnMenu addSubview:menuImgView];
    btnMenu.selected = YES;
    
    NSLog(@"%d",(int)btnMenu.tag);
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

#pragma mark setting for section

#pragma mark setting for cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"MushaMatchCellIdentifier";
    MushaMatchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MushaMatchCell" owner:self options:nil] objectAtIndex:0];
        cell.backgroundColor = ItemsBaseColor;
    }
    cell.mImageView.image = [UIImage imageNamed:@"jhstory"];
    cell.mName.text = @"永春拳公益巡回演出";
    cell.mDetail.text = @"咏春拳是最快的制敌拳法,公益巡回演出,让大家更好的理解咏春拳";
    cell.mDate.text = @"4月20日";
    cell.mEndDate.text = @"结束时间:2015年10月30日";
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.mState.frame.size.width, cell.mState.frame.size.height)];
    
    if(indexPath.row == 1)
    {
        imageView.image = [UIImage imageNamed:@"jinxingzhong"];
    }
    else if(indexPath.row== 2)
    {
        imageView.image = [UIImage imageNamed:@"yijieshou"];
    }
    else
    {
        imageView.image = [UIImage imageNamed:@"weikaishi"];
    }
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.mState addSubview:imageView];
//    
//    
//    [cell.mState setTitle:@"未开始" forState:UIControlStateNormal];
//    [cell.mState setTitleColor:[UIColor colorWithRed:0.94 green:0.61 blue:0 alpha:1] forState:UIControlStateNormal];
//    cell.mState.layer.cornerRadius = 5;
//    cell.mState.layer.borderWidth = 1;
//    cell.mState.layer.borderColor = [UIColor colorWithRed:0.94 green:0.61 blue:0 alpha:1].CGColor;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return mCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [mTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == 1)
    {
        
    }
    else if(indexPath.row == 2)
    {
        
    }
    else
    {
        MushaMatchDetailViewController *mushaMatchDetailViewCtl = [[MushaMatchDetailViewController alloc] init];
        mushaMatchDetailViewCtl.navtitle  = @"武者大赛";
        [self.navigationController pushViewController:mushaMatchDetailViewCtl animated:YES];
    }
}

@end
