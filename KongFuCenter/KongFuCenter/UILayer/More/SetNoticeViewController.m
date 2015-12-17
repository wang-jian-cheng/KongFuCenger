//
//  SetNoticeViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/11.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "SetNoticeViewController.h"
#import "ShieldViewController.h"
@interface SetNoticeViewController ()
{
#pragma mark - pram for tableView
    NSInteger _sectionNum;
    CGFloat _cellHeight;
    UITableView *_mainTableView;
}
@end

@implementation SetNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self setBarTitle:@"聊天通知设置"];
    [self initViews];
    [self addLeftButton:@"left"];
    // Do any additional setup after loading the view.
}
-(void)initViews
{
    _cellHeight = SCREEN_HEIGHT/10;
    _sectionNum = 1;
    
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height )];
    _mainTableView.backgroundColor = BACKGROUND_COLOR;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorColor =  Separator_Color;
    _mainTableView.tableFooterView = [[UIView alloc] init];
    //_mainTableView.scrollEnabled = NO;
    
    _mainTableView.contentSize = CGSizeMake(SCREEN_HEIGHT, _sectionNum*(_cellHeight + 20));
    [self.view addSubview:_mainTableView];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}


#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _sectionNum;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
    
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
                cell.textLabel.text  = @"接受新的聊天";
       
                UISwitch *switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width-(20+50), _cellHeight/3 -7, 50, _cellHeight/3)];
                switchBtn.tag = indexPath.row;
                switchBtn.onTintColor = YellowBlock;
                switchBtn.tintColor = Separator_Color;
                switchBtn.backgroundColor = Separator_Color;
                switchBtn.layer.cornerRadius = 14;
                [cell addSubview:switchBtn];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

            }
                break;
            case 1:
            {
                cell.textLabel.text = @"声音";
                UISwitch *switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width-(20+50), _cellHeight/3 - 7, 50, _cellHeight/3)];
                switchBtn.tag = indexPath.row;
                switchBtn.onTintColor = YellowBlock;
                switchBtn.tintColor = Separator_Color;
                switchBtn.backgroundColor = Separator_Color;
                switchBtn.layer.cornerRadius = 14;
                [cell addSubview:switchBtn];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

            }
                 break;
            case 2:
            {
                cell.textLabel.text = @"震动";
                UISwitch *switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width-(20+50), _cellHeight/3 - 7, 50, _cellHeight/3)];
                switchBtn.tag = indexPath.row;
                switchBtn.onTintColor = YellowBlock;
                switchBtn.tintColor = Separator_Color;
                switchBtn.backgroundColor = Separator_Color;
                switchBtn.layer.cornerRadius = 14;
                [cell addSubview:switchBtn];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

            }
                break;
            case 3:
            {
                cell.textLabel.text = @"屏蔽列表";
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
    //跳转到屏蔽消息页面
    if(indexPath.section == 0 && indexPath.row == 3)
    {
        ShieldViewController * shieldViewController = [[ShieldViewController alloc] init];
        [self showViewController:shieldViewController sender:nil];
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
