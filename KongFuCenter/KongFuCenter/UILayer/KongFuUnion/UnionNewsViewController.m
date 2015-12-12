//
//  UnionNewsViewController.m
//  KongFuCenter
//
//  Created by Rain on 15/12/12.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "UnionNewsViewController.h"
#import "UnionNewsCell.h"

@interface UnionNewsViewController (){
    
    //datatable
    UITableView *mTableView;
    CGFloat mCellHeight;
    
    //data
    NSMutableArray *menuArray;
    
    //view
    UIImageView *menuImgView;
}

@end

@implementation UnionNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化参数
    //self.view.backgroundColor = BACKGROUND_COLOR;
    mCellHeight = SCREEN_HEIGHT / 6;
    [self setBarTitle:@"联盟动态"];
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
    [menuArray addObjectsFromArray:@[@"公益慈善",@"交流活动",@"技术培训",@"全国巡演"]];
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
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height + 44, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height - 44)];
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
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 2;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BACKGROUND_COLOR;
    return view;
}

#pragma mark setting for cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"UnionNewsCellIdentifier";
    UnionNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UnionNewsCell" owner:self options:nil] objectAtIndex:0];
        cell.backgroundColor = ItemsBaseColor;
    }
    cell.mImageView.image = [UIImage imageNamed:@"jhstory"];
    cell.mName.text = @"咏春拳公益巡回演出";
    cell.mDetail.text = @"咏春拳是最快的制敌拳法,公益巡回演出,让大家更好的理解咏春拳";
    cell.mDate.text = @"4月20日";
    cell.mReadNum.text = @"200";
    cell.mCollectionNum.text = @"100";
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return mCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [mTableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
