//
//  MoreViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/3.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "MoreViewController.h"
#import "ClearCacheViewController.h"
#import "IntroViewController.h"
#import "MessagefankuiViewController.h"
@interface MoreViewController ()
{
#pragma mark - pram for tableView
    NSInteger _sectionNum;
    CGFloat _cellHeight;
    UITableView *_mainTableView;
}
//公司信息
@property (nonatomic, strong) UILabel * label_1;
@property (nonatomic, strong) UILabel * label_2;

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self setBarTitle:@"更多"];
    [self initViews];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showTabBar];
}

-(void)initViews
{
    _cellHeight = SCREEN_HEIGHT/12;
    _sectionNum = 3;
    
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height )];
    _mainTableView.backgroundColor = BACKGROUND_COLOR;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorColor =  Separator_Color;
    _mainTableView.tableFooterView = [[UIView alloc] init];
    //_mainTableView.scrollEnabled = NO;
    
    _mainTableView.contentSize = CGSizeMake(SCREEN_HEIGHT, _sectionNum*(_cellHeight + 20));
    [self.view addSubview:_mainTableView];
    
    
    UIButton *outBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, _cellHeight*6 + 20,
                                                            (SCREEN_WIDTH - 20*2), _cellHeight)];
    [outBtn setTitle:@"退出" forState:UIControlStateNormal];
    [outBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    outBtn.backgroundColor = ItemsBaseColor;
    [outBtn addTarget:self action:@selector(clickOutBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_mainTableView addSubview:outBtn];
    
    //公司信息
    self.label_1 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 85, self.view.frame.size.height - TabBar_HEIGHT - 45 - StatusBar_HEIGHT - NavigationBar_HEIGHT, 170, 17)];
    self.label_1.text = @"临沂九野文化传媒有限公司";
    self.label_1.textColor = Separator_Color;
//    self.label_1.backgroundColor = [UIColor orangeColor];
    self.label_1.font = [UIFont systemFontOfSize:14];
    [_mainTableView addSubview:self.label_1];
    
    self.label_2 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 50, self.view.frame.size.height - TabBar_HEIGHT - 25 - StatusBar_HEIGHT - NavigationBar_HEIGHT, 100, 17)];
    self.label_2.text = @"copyright©2015";
    self.label_2.textColor = Separator_Color;
//    self.label_2.backgroundColor = [UIColor orangeColor];
    self.label_2.font = [UIFont systemFontOfSize:13];
    [_mainTableView addSubview:self.label_2];
}


#pragma mark - 退出

-(void)clickOutBtn:(UIButton *)sender
{
    set_sp( @"OUTLOGIN",@"YES");

    [self ClearCache];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeRootView" object:nil userInfo:[NSDictionary dictionaryWithObject:@"loginpage" forKey:@"rootView"]];
    
}

-(void)ClearCache
{
    [Toolkit delPlist:NewsCaChePlist];
    [Toolkit delPlist:FirendCaChePlist];
}

#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _sectionNum;
    
}

//指定每个分区中有多少行，默认为1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section == 1)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}

#pragma mark - setting for cell
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight)];
    cell.backgroundColor = ItemsBaseColor;
    cell.textLabel.textColor = [UIColor whiteColor];
    if(indexPath.section == 0)
    {
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text  = @"聊天通知设置";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
//            case 1:
//                cell.textLabel.text = @"朋友圈的评论提示";
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                break;
            default:
                break;
        }
    }
    else if(indexPath.section == 1)
    {
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text  = @"清除缓存";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
//                UIImageView *rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right"]];
//                rightView.frame = CGRectMake((SCREEN_WIDTH - 20 -20), 0, 15, 15);
//                rightView.center = CGPointMake((SCREEN_WIDTH - 15 -10), _cellHeight/2);
//                rightView.contentMode = UIViewContentModeScaleAspectFit;
//                [cell addSubview:rightView];
            }
                break;
            case 1:
                cell.textLabel.text = @"关于艾特功夫";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            default:
                break;
        }
    }
    else if (indexPath.section == 2)
    {
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text  = @"留言反馈";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
            default:
                break;
        }
    }
    return cell;
    
}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return _cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
//    NSLog(@"click cell section : %ld row : %ld",(long)indexPath.section,(long)indexPath.row);
    
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            SetNoticeViewController *setNoticeViewCtl = [[SetNoticeViewController alloc] init];
//            setNoticeViewCtl.navtitle = @"聊天通知设置";
            [self.navigationController pushViewController:setNoticeViewCtl animated:YES];
        }
//        else
//        {//推出朋友圈的评论提示页面
//            PromptViewController * promptViewController = [[PromptViewController alloc] init];
//            [self showViewController:promptViewController sender:nil];
//            
//        }
    }
    else if (indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            //推出清除缓存页面
            ClearCacheViewController * clearCacheViewController = [[ClearCacheViewController alloc] init];
            [self.navigationController pushViewController:clearCacheViewController animated:YES];
//            [self showViewController:clearCacheViewController sender:nil];
        }
        else if(indexPath.row == 1)
        {
            //推出关于核武者页面
            IntroViewController * introduceViewController = [[IntroViewController alloc] init];
            [self.navigationController pushViewController:introduceViewController animated:YES];
            //[self showViewController:introduceViewController sender:nil];
            
        }
    }
    else if (indexPath.section == 2)
    {
        if(indexPath.row == 0)
        {
            MessagefankuiViewController * messagefankuiViewController = [[MessagefankuiViewController alloc] init];
            [self.navigationController pushViewController:messagefankuiViewController animated:YES];
//            [self showViewController:messagefankuiViewController sender:nil];
        }
    }
    
}


//设置划动cell是否出现del按钮，可供删除数据里进行处理

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

- (UITableViewCellEditingStyle)tableView: (UITableView *)tableView editingStyleForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  YES;
}


-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  @"删除";
}

//设置选中的行所执行的动作

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return indexPath;
    
}

#pragma mark - setting for section
//设置section的header view

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView = [[UIView alloc] init];
    return tempView;
}

//设置section header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

//设置section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
    
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
