//
//  FriendInfoViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/14.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "FriendInfoViewController.h"
#import "ChatContentViewController.h"
#import "MyFriendViewController.h"
#import "NewConcernFriendViewController.h"
#import "KongFuPowerViewController.h"
#import "GrowHistoryViewController.h"
#import "YMShowImageView.h"

@interface FriendInfoViewController ()
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

@implementation FriendInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"left"];
   // [self addRightbuttontitle:@"聊天设置"];
    [self addRightButton:@"moreNoword"];
    self.view.backgroundColor = BACKGROUND_COLOR;
    userDefault = [NSUserDefaults standardUserDefaults];
    userInfoArray = [[NSDictionary alloc] init];
    
    [self initData];
}

-(void)initData{
    [SVProgressHUD showWithStatus:@"加载中"];
    dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getUserInfoById:"];
    [dataProvider getUserInfo:_userID];
}

-(void)getUserInfoById:(id)dict{
    [SVProgressHUD dismiss];
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue] == 200) {
        userInfoArray = dict[@"data"];
        NSLog(@"%@",userInfoArray);
        [self initViews];
    }
}

-(void)initViews
{
    _cellHeight = SCREEN_HEIGHT/12;
    _sectionNum = 1;
    
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT  )];
    _mainTableView.backgroundColor = BACKGROUND_COLOR;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorColor =  Separator_Color;
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight*3)];
    
    UIButton *opBtn = [[UIButton alloc] initWithFrame:CGRectMake(GapToLeft, _cellHeight-15, SCREEN_WIDTH- 2*GapToLeft, _cellHeight)];
    opBtn.backgroundColor = YellowBlock;
    [opBtn setTitle:@"发送消息" forState:UIControlStateNormal];
    [opBtn addTarget:self action:@selector(sendMessageEvent) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:opBtn];
    _mainTableView.tableFooterView = tempView;
    //_mainTableView.scrollEnabled = NO;
    
  //  _mainTableView.contentSize = CGSizeMake(SCREEN_WIDTH, 15*_cellHeight);
    [self.view addSubview:_mainTableView];
    [self.view sendSubviewToBack:_mainTableView];
}

-(void)sendMessageEvent{
    //新建一个聊天会话View Controller对象
    ChatContentViewController *chat = [[ChatContentViewController alloc]init];
    //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众账号等
    chat.conversationType = ConversationType_PRIVATE;
    //设置会话的目标会话ID。（单聊、客服、公众账号服务为对方的ID，讨论组、群聊、聊天室为会话的ID）
    chat.targetId = [NSString stringWithFormat:@"%@",_userID];
    chat.userName = @"nihao";
    //设置聊天会话界面要显示的标题
    chat.title = @"想显示的会话标题";
    chat.mTitle = [Toolkit judgeIsNull:[userInfoArray valueForKey:@"NicName"]];
    //显示聊天会话界面
    [self.navigationController pushViewController:chat animated:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

-(void)clickLeftButton:(UIButton *)sender{
    NSString *delFriendState = [userDefault valueForKey:@"addFriendState"];
    if ([delFriendState isEqual:@"1"]) {
        [userDefault setValue:@"0" forKey:@"addFriendState"];
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[MyFriendViewController class]] || [temp isKindOfClass:[KongFuPowerViewController class]]) {
                [self.navigationController popToViewController:temp animated:YES];
                return;
            }
        }
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)clickRightButton:(UIButton *)sender
{
    ChatSetViewController *chatSetViewCtl = [[ChatSetViewController alloc] init];
    chatSetViewCtl.navtitle =@"聊天设置";
    chatSetViewCtl.userID = self.userID;
    [self.navigationController pushViewController:chatSetViewCtl animated:YES];
}

-(void)headViewTap{
    UIView *maskview = [[UIView alloc] initWithFrame:self.view.bounds];
    maskview.backgroundColor = [UIColor blackColor];
    [self.view addSubview:maskview];
    NSMutableArray *imageViews = [[NSMutableArray alloc] init];
    NSString *PhotoPath = [userInfoArray valueForKey:@"PhotoPath"];
    NSString *url = [NSString stringWithFormat:@"%@%@",Url,PhotoPath];
    [imageViews addObject:url];
    YMShowImageView *ymImageV = [[YMShowImageView alloc] initWithFrame:self.view.bounds byClick:9999 appendArray:imageViews];
    [ymImageV show:maskview didFinish:^(){
        
        [UIView animateWithDuration:0.5f animations:^{
            
            ymImageV.alpha = 0.0f;
            maskview.alpha = 0.0f;
            
        } completion:^(BOOL finished) {
            [ymImageV removeFromSuperview];
            [maskview removeFromSuperview];
        }];
    }];
}


#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _sectionNum;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 7;
    
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
    switch (indexPath.row) {
        case 0:
        {
            UIImageView *backImg = [[UIImageView alloc]  initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight*3-0.5*_cellHeight)];
//            backImg.image = [UIImage imageNamed:@"head_bg"];
            backImg.backgroundColor = ItemsBaseColor;//[UIColor blackColor];
            [cell addSubview:backImg];
            NSString *PhotoPath = [userInfoArray valueForKey:@"PhotoPath"];
            NSString *url = [NSString stringWithFormat:@"%@%@",Url,PhotoPath];
            UserHeadView *headView = [[UserHeadView alloc] initWithFrame:CGRectMake(GapToLeft, 1.5*_cellHeight, 2*_cellHeight, 2*_cellHeight) andImg:[UIImage imageNamed:@"me"]];
            [headView.headImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"me"]];
            [headView makeSelfRound];
            headView.layer.borderWidth = 1;
            headView.layer.borderColor = [[UIColor blackColor] CGColor];
            [cell addSubview:headView];
            UIButton *headViewBtn = [[UIButton alloc] initWithFrame:headView.frame];
            [headViewBtn addTarget:self action:@selector(headViewTap) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:headViewBtn];
            
            
            
            UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake((headView.frame.origin.x+headView.frame.size.width),
                                                                         2.5*_cellHeight+5,
                                                                         SCREEN_WIDTH - (headView.frame.origin.x+headView.frame.size.width),
                                                                         _cellHeight/2)];
            nameLab.text =[NSString stringWithFormat:@"%@   %@",[userInfoArray valueForKey:@"NicName"],[userInfoArray valueForKey:@"Phone"]];
            nameLab.textColor = YellowBlock;
            nameLab.font = [UIFont boldSystemFontOfSize:16];
            [cell addSubview:nameLab];
            
            UILabel *otherInfoLab = [[UILabel alloc] initWithFrame:CGRectMake((nameLab.frame.origin.x),
                                                                             (nameLab.frame.origin.y+nameLab.frame.size.height+5),
                                                                             (SCREEN_WIDTH - headView.frame.size.width - headView.frame.origin.x),
                                                                              _cellHeight/2)];
            otherInfoLab.textColor = [UIColor whiteColor];
            otherInfoLab.font = [UIFont systemFontOfSize:14];
            NSString *sex = [NSString stringWithFormat:@"%@",[userInfoArray valueForKey:@"Sexuality"]];
            NSString *birthday = [userInfoArray valueForKey:@"Birthday"];
            NSInteger mYear = [[birthday substringToIndex:4] intValue];
            NSDate *now = [NSDate date];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
            NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
            NSInteger age = [dateComponent year] - mYear;
            NSString *address = [userInfoArray valueForKey:@"HomeAddress"];
            
            
            otherInfoLab.text = [NSString stringWithFormat:@"%@  %d岁  %@",[sex isEqual:@"1"]?@"男":@"女",(int)age,address];
            
            [cell addSubview:otherInfoLab];
            
            
            
        }
            break;
        case 1:{
            UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 0, 100, _cellHeight)];
            NSLog(@"%@",[userInfoArray valueForKey:@"Sexuality"]);
            if ([[Toolkit judgeIsNull:[userInfoArray valueForKey:@"Sexuality"]] isEqual:@"1"]) {
                titleLab.text = @"他的记录";
            }else{
                titleLab.text = @"她的记录";
            }
            titleLab.textColor = [UIColor whiteColor];
            titleLab.font = [UIFont systemFontOfSize:16];
            [cell addSubview:titleLab];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 2:
        {

            UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 0, 100, _cellHeight)];
            titleLab.text = @"好友动态";
            titleLab.textColor = [UIColor whiteColor];
            titleLab.font = [UIFont systemFontOfSize:16];
            [cell addSubview:titleLab];

            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 3:
        {

            UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 0, 100, _cellHeight)];
            titleLab.text = @"好友战队";
            titleLab.textColor = [UIColor whiteColor];
            titleLab.font = [UIFont systemFontOfSize:16];
            [cell addSubview:titleLab];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
            break;
        case 4:
        {

            UILabel *weightLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 0, (SCREEN_WIDTH-GapToLeft)/2, _cellHeight)];
            weightLab.textColor = [UIColor grayColor];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"体重： %@kg",[userInfoArray valueForKey:@"Weight"]]];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,3)];
            
            weightLab.attributedText =str;
            
            weightLab.font = [UIFont systemFontOfSize:16];
            [cell addSubview:weightLab];
//
//            UILabel *weightLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 200, _cellHeight)];
//            weightLab.text = [NSString stringWithFormat:@"%@kg",[userInfoArray valueForKey:@"Weight"]];//@"8kg";
//            weightLab.textColor = [UIColor grayColor];
//            weightLab.textAlignment = NSTextAlignmentRight;
//            [cell addSubview:weightLab];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(weightLab.frame.origin.x+weightLab.frame.size.width,
                                                                        2, 1, _cellHeight-2*2)];
            lineView.backgroundColor = Separator_Color;
            [cell addSubview:lineView];
            
            UILabel *heightLab = [[UILabel alloc] initWithFrame:CGRectMake(((SCREEN_WIDTH-GapToLeft)/2+GapToLeft)+5, 0, (SCREEN_WIDTH-GapToLeft)/2, _cellHeight)];
            NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"身高： %@Cm",[userInfoArray valueForKey:@"Height"]]];
            [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,3)];
            heightLab.textColor = [UIColor grayColor];
            heightLab.attributedText = str2;//@"180Cm";
            
            heightLab.textAlignment = NSTextAlignmentLeft;
            [cell addSubview:heightLab];

        }
            break;
        case 5:
        {
           
            UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 0, 100, _cellHeight)];
            titleLab.text = @"习武时间：";
            titleLab.textColor = [UIColor whiteColor];
            titleLab.font = [UIFont systemFontOfSize:16];
            [cell addSubview:titleLab];

            
            UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 20 -200), 0, 200, _cellHeight)];
            timeLab.text = [NSString stringWithFormat:@"%@年",[userInfoArray valueForKey:@"Experience"]];//@"3年";
            timeLab.textColor = [UIColor grayColor];
            timeLab.textAlignment = NSTextAlignmentRight;
            [cell addSubview:timeLab];
        }
            break;
        case 6:
        {

            UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 0, SCREEN_WIDTH-cell.textLabel.frame.origin.x, _cellHeight)];
            titleLab.text = @"个人简历:";
            titleLab.textColor = [UIColor whiteColor];
            titleLab.font = [UIFont systemFontOfSize:16];
            [cell addSubview:titleLab];
            NSString *contentStr = [userInfoArray valueForKey:@"Description"];
            CGFloat contentWidth = (SCREEN_WIDTH -GapToLeft - 20);
            CGFloat contentHeight = [Toolkit heightWithString:contentStr fontSize:16 width:contentWidth]+10;
            contentHeight = contentHeight > (_cellHeight*1)?(_cellHeight*1):contentHeight;
            
            UITextView *contentLan = [[UITextView alloc] initWithFrame:CGRectMake(GapToLeft, _cellHeight-10, contentWidth, contentHeight)];
            contentLan.font = [UIFont systemFontOfSize:16];
            contentLan.textColor = [UIColor grayColor];
            contentLan.text = contentStr;
            contentLan.editable = NO;
            contentLan.backgroundColor = ItemsBaseColor;

            [cell addSubview:contentLan];
          
        }
            break;
        default:
            break;
    }
    
    return cell;
    
}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return _cellHeight*5-_cellHeight;
            break;
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
            return _cellHeight;
            break;
        case 6:
            return 2*_cellHeight;
            break;
        default:
            break;
    }
    return _cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失

    
    switch (indexPath.row) {
        case 1:{
            GrowHistoryViewController *growHistoryVC = [[GrowHistoryViewController alloc] init];
            growHistoryVC.navtitle = @"记录";
            growHistoryVC.userId = userInfoArray[@"Id"];
            [self.navigationController pushViewController:growHistoryVC animated:YES];
        }
            break;
        case 2:
        {
            MyNewsViewController *friendNews = [[MyNewsViewController alloc] init];
            friendNews.UserID = userInfoArray[@"Id"];
//            NSString *ssName = [Toolkit judgeIsNull:userInfoArray[@"NicName"]];
//            if ([ssName isEqual:@""]) {
//                friendNews.navtitle = @"好友的动态";
//            }else{
//                friendNews.navtitle = [NSString stringWithFormat:@"%@的动态",ssName];
//            }
            friendNews.navtitle = @"好友的动态";
            [self.navigationController pushViewController:friendNews animated:YES];
        }
        break;
        case 3:
        {
            if(!([[NSString stringWithFormat:@"%@",userInfoArray[@"TeamId"]] isEqualToString:@""] || userInfoArray[@"TeamId"] ==nil||[[NSString stringWithFormat:@"%@",userInfoArray[@"TeamId"]] isEqualToString:@"0"]))
            {
                TeamNewsViewController *teamNewsViewCtl = [[TeamNewsViewController alloc] init];
                teamNewsViewCtl.teamId =[NSString stringWithFormat:@"%@",userInfoArray[@"TeamId"]];
                //    unionNewsViewCtl.navtitle
                [self.navigationController pushViewController:teamNewsViewCtl animated:YES];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"他还未加入战队" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
                [alertView show];
            }
        }
        break;
            
        default:
            break;
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
