//
//  JoinTeamViewController.m
//  KongFuCenter
//
//  Created by Rain on 15/12/8.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "JoinTeamViewController.h"
#import "JoinTeamCell.h"

@interface JoinTeamViewController (){
    //tableview
    UITableView *mTableView;
    CGFloat mCellHeight;
}

@end

@implementation JoinTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化参数
    //self.view.backgroundColor = BACKGROUND_COLOR;
    mCellHeight = 70;
    [self setBarTitle:@"加入战队"];
    
    //初始化View
    [self initViews];
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

#pragma mark 自定义方法
-(void)initViews{
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height)];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = BACKGROUND_COLOR;
    mTableView.separatorColor = Separator_Color;
    mTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:mTableView];
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

#pragma mark setting for cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"JoinTeamCellIdentifier";
    JoinTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JoinTeamCell" owner:self options:nil] objectAtIndex:0];
        cell.backgroundColor = ItemsBaseColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.mImageView.image = [UIImage imageNamed:@"jointeam"];
    cell.mName.text = @"跆拳道战队(123456789)";
    cell.mAddress.text = @"所在地:山东临沂";
    [cell.mJoin setTitle:@"加入" forState:UIControlStateNormal];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return mCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [mTableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
