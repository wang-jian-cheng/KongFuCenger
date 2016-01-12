//
//  ChatSetViewController.m
//  KongFuCenter
//
//  Created by Wangjc on 16/1/9.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "ChatSetViewController.h"

@interface ChatSetViewController ()
{
#pragma mark - pram for tableView
    NSInteger _sectionNum;
    CGFloat _cellHeight;
    UITableView *_mainTableView;
    DataProvider *dataProvider;
    NSUserDefaults *userDefault;
    NSDictionary *userInfoArray;
}
@end
#define GapToLeft   20//(cell.textLabel.frame.origin.x)

@implementation ChatSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"left"];
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    userInfoArray = [[NSDictionary alloc] init];
    userDefault = [NSUserDefaults standardUserDefaults];
    
    [self initData];
    [self initViews];
}

-(void)initData{
    [SVProgressHUD showWithStatus:@"加载中"];
    dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getUserInfoById:"];
    [dataProvider getUserInfo:_userID];
}

-(void)getUserInfoById:(id)dict{
    [SVProgressHUD dismiss];
    if ([dict[@"code"] intValue] == 200) {
        userInfoArray = dict[@"data"];
        NSLog(@"%@",userInfoArray);
        [_mainTableView reloadData];
    }
}

-(void)initViews
{
    _cellHeight = SCREEN_HEIGHT/12;
    _sectionNum = 2;
    
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height )];
    _mainTableView.backgroundColor = BACKGROUND_COLOR;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorColor =  Separator_Color;
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight*3)];
    
    UIButton *opBtn = [[UIButton alloc] initWithFrame:CGRectMake(GapToLeft, _cellHeight, SCREEN_WIDTH- 2*GapToLeft, _cellHeight)];
    opBtn.backgroundColor = [UIColor grayColor];
    [opBtn setTitle:@"取消关注" forState:UIControlStateNormal];
    [opBtn addTarget:self action:@selector(delFriendEvent) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:opBtn];
    _mainTableView.tableFooterView = tempView;
    //_mainTableView.scrollEnabled = NO;
    
    //  _mainTableView.contentSize = CGSizeMake(SCREEN_WIDTH, 15*_cellHeight);
    [self.view addSubview:_mainTableView];
    
}
#pragma mark - self data source 

-(void)ShieldFriendMessage{
    dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"ShieldFriendMessageCallBack:"];
    [dataProvider ShieldFriendMessage:[Toolkit getUserID] andFriendId:self.userID];
}

-(void)UnShieldFriendMessage{
    dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"ShieldFriendMessageCallBack:"];
    [dataProvider UnShieldFriendMessage:[Toolkit getUserID] andFriendId:self.userID];
}

-(void)ShieldFriendMessageCallBack:(id)dict
{
    [SVProgressHUD dismiss];
    DLog(@"%@",dict);
    
    if ([dict[@"code"] intValue] == 200) {
        
    }else{
        [SVProgressHUD showSuccessWithStatus:dict[@"data"]];
    }
}

-(void)ShieldFriendNew{
    dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"ShieldFriendNewCallBack:"];
    [dataProvider ShieldFriendNew:[Toolkit getUserID] andFriendid:_userID];
}

-(void)UnShieldFriendNew{
    dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"ShieldFriendNewCallBack:"];
    [dataProvider UnShieldFriend:[Toolkit getUserID] andFriendId:_userID];
}

-(void)ShieldFriendNewCallBack:(id)dict
{
    [SVProgressHUD dismiss];
    DLog(@"%@",dict);
    
    if ([dict[@"code"] intValue] == 200) {
        
    }else{
         [SVProgressHUD showSuccessWithStatus:dict[@"data"]];
    }
}

-(void)delFriendEvent{
    dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"delFriendCallBack:"];
    [dataProvider DeleteFriend:[userDefault valueForKey:@"id"] andfriendid:self.userID];
}

-(void)delFriendCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        [SVProgressHUD showSuccessWithStatus:@"取消成功~"];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"取消失败~"];
    }
}
#pragma mark - action
-(void)switchBtnAction:(UISwitch *)sender
{
    if(sender.tag == 0)
    {
        if([sender isOn])
        {
            [self UnShieldFriendNew];
            NSLog(@"Yes");
        }
        else
        {
            [self ShieldFriendNew];
            NSLog(@"No");
        }
    }
    else if(sender.tag == 3)
    {
        if([sender isOn])
        {
            [self ShieldFriendMessage];
            NSLog(@"Yes");
        }
        else
        {
            [self UnShieldFriendMessage];
            NSLog(@"No");
        }
    }
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
    
    if (section == 0) {
        return 1;
    }
    
    return 5;
    
}

#pragma mark - setting for cell
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    //    static NSString *identifier = @"wuguanCell";
    //    WuGuanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    //    if (cell == nil) {
    //        cell = [[WuGuanTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    //
    //    }
    //    cell.backgroundColor = ItemsBaseColor;
    
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight)];
    cell.backgroundColor = ItemsBaseColor;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    if(indexPath.section == 1)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        switch (indexPath.row) {
                
            case 0:
            {
                cell.textLabel.text = @"他的动态";
                cell.accessoryType = UITableViewCellAccessoryNone;

                UISwitch *switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width-(20+50), _cellHeight/3, 50, _cellHeight/3)];
                switchBtn.tag = indexPath.row;
                switchBtn.center = CGPointMake(self.view.frame.size.width-(20+50)+25, _cellHeight/2);
                
                [switchBtn addTarget:self action:@selector(switchBtnAction:) forControlEvents:UIControlEventValueChanged];//UIControlEventTouchUpInside
                [cell addSubview:switchBtn];
                
            }
                break;
            case 1:
            {
                
                cell.textLabel.text = @"设置备注名";
                
                UILabel *heightLab = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 50 -100), 0, 100, _cellHeight)];
                heightLab.text = @"龙的传人";
                heightLab.textColor = YellowBlock;
                heightLab.textAlignment = NSTextAlignmentRight;
                [cell addSubview:heightLab];
            }
                break;
            case 2:
            {
                
                cell.textLabel.text = @"举报";
            }
                break;
            case 3:
            {
                
                cell.textLabel.text = @"屏蔽消息";
                cell.accessoryType = UITableViewCellAccessoryNone;
                UISwitch *switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width-(20+50), _cellHeight/3, 50, _cellHeight/3)];
                switchBtn.tag = indexPath.row;
                switchBtn.center = CGPointMake(self.view.frame.size.width-(20+50)+25, _cellHeight/2);
                [cell addSubview:switchBtn];
                
                
            }
                break;
                
        case 4:
            {
                
                cell.textLabel.text = @"聊天记录";
                cell.accessoryType = UITableViewCellAccessoryNone;
               
                
                
            }
                break;

            default:
                break;
        }
        
    }
    else if(indexPath.section == 0)
    {
        NSString *photoPath = [userInfoArray valueForKey:@"PhotoPath"];
        NSString *url = [NSString stringWithFormat:@"%@%@",Url,photoPath];
        //UserHeadView *headView = [[UserHeadView alloc] initWithFrame:CGRectMake(GapToLeft, _cellHeight/2, 2*_cellHeight, 2*_cellHeight) andImgName:@"me"];
        UserHeadView *headView = [[UserHeadView alloc] initWithFrame:CGRectMake(GapToLeft, _cellHeight/2, 2*_cellHeight, 2*_cellHeight) andImg:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]]];
        [headView makeSelfRound];
        [cell addSubview:headView];
        
        
        
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake((headView.frame.origin.x+headView.frame.size.width)+5, _cellHeight/2+10, 200, (headView.frame.size.height)/3)];
        nameLab.text = [userInfoArray valueForKey:@"NicName"];//@"成龙";
        nameLab.textColor = YellowBlock;
        nameLab.font = [UIFont boldSystemFontOfSize:18];
        [cell addSubview:nameLab];
        
        UILabel *otherInfoLab = [[UILabel alloc] initWithFrame:CGRectMake((nameLab.frame.origin.x),
                                                                          (headView.frame.origin.y+headView.frame.size.height/2),
                                                                          (SCREEN_WIDTH - headView.frame.size.width - headView.frame.origin.x),
                                                                          (headView.frame.size.height)/3)];
        otherInfoLab.textColor = [UIColor whiteColor];
        otherInfoLab.font = [UIFont systemFontOfSize:18];
        
        NSString *birthday = [userInfoArray valueForKey:@"Birthday"];
        NSInteger mYear = [[birthday substringToIndex:4] intValue];
        NSDate *now = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
        NSInteger age = [dateComponent year] - mYear;
        otherInfoLab.text = [NSString stringWithFormat:@"%@－%d岁",[[NSString stringWithFormat:@"%@",[userInfoArray valueForKey:@"Sexuality"]] isEqual:@"0"]?@"男":@"女",(int)age];
        
        [cell addSubview:otherInfoLab];
        
    }
    
    return cell;
    
}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return  _cellHeight*3;
    }
    
    return _cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    if(indexPath.section == 1)
    {
        switch (indexPath.row) {
            case 4:
            {
                ChatContentViewController *chat = [[ChatContentViewController alloc]init];
                //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众账号等
                chat.conversationType = ConversationType_PRIVATE;
                //设置会话的目标会话ID。（单聊、客服、公众账号服务为对方的ID，讨论组、群聊、聊天室为会话的ID）
                chat.targetId = [NSString stringWithFormat:@"%@",self.userID];
//                chat.userName = @"";
                //设置聊天会话界面要显示的标题
                chat.mTitle = userInfoArray[@"NicName"];
                //显示聊天会话界面
                [self.navigationController pushViewController:chat animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor); CGContextFillRect(context, rect); //上分割线，
    
    CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1)); //下分割线
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(5, 10, 100, 10));
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

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *tempView = [[UIView alloc] init];
    
    
    return tempView;
}

//设置section header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
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