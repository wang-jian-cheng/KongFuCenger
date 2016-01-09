//
//  PlayerForMatchViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/12.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "PlayerForMatchViewController.h"
#import "MJRefresh.h"
#import "IntroduceViewController.h"

@interface PlayerForMatchViewController ()<UISearchBarDelegate,UISearchDisplayDelegate,UITextFieldDelegate>
{
#pragma mark - pram for tableView
    NSInteger _sectionNum;
    CGFloat _cellHeight;
    UITableView *_mainTableView;
    UITextField *searchTxt;
    NSArray *PlayerArray;
    int curpage;
}
@end

#define GapToLeft   20

@implementation PlayerForMatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
 
    [self addLeftButton:@"left"];
    [self initViews];
}

-(void)initViews
{
    _cellHeight = SCREEN_HEIGHT/10;
    _sectionNum = 2;
    
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height+5, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height )];
    _mainTableView.backgroundColor = BACKGROUND_COLOR;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorColor =  Separator_Color;
    _mainTableView.tableFooterView = [[UIView alloc] init];
    //_mainTableView.scrollEnabled = NO;
    
    _mainTableView.contentSize = CGSizeMake(SCREEN_HEIGHT, _sectionNum*(_cellHeight + 20));
    [self.view addSubview:_mainTableView];
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    __weak typeof(UITableView *) weakTv = _mainTableView;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf TeamTopRefresh];
        [weakTv.mj_header endRefreshing];
    }];
    
    // 马上进入刷新状态
    [_mainTableView.mj_header beginRefreshing];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(TeamFootRefresh)];
    // 禁止自动加载
    footer.automaticallyRefresh = NO;
    // 设置footer
    _mainTableView.mj_footer = footer;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:) ];
    [self.view addGestureRecognizer:tapGesture];
}

-(void)TeamTopRefresh{
    curpage = 0;
    PlayerArray = [[NSArray alloc] init];
    [SVProgressHUD showWithStatus:@"加载中..."];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"SelectMatchMemberByPersonCallBack:"];
    //_matchId = @"3";
    if(![searchTxt.text isEqual:@""] && [self isPureInt:searchTxt.text]){
        if (_playerForMatchMode == Mode_MushaPlayer) {
            [dataProvider SelectAllMatchMemberBySearch:@"0" andmaximumRows:@"10" andmatchId:_matchId andmembercode:searchTxt.text andnicname:@"" andflg:@"0"];
        }else{
            [dataProvider SelectAllMatchTeamBySearch:@"0" andmaximumRows:@"10" andmatchId:_matchId andmembercode:searchTxt.text andnicname:@"" andflg:@"0"];
        }
    }else{
        if (_playerForMatchMode == Mode_MushaPlayer) {
            [dataProvider SelectAllMatchMemberBySearch:@"0" andmaximumRows:@"10" andmatchId:_matchId andmembercode:@"0" andnicname:searchTxt.text andflg:@"0"];
        }else{
            [dataProvider SelectAllMatchTeamBySearch:@"0" andmaximumRows:@"10" andmatchId:_matchId andmembercode:@"0" andnicname:searchTxt.text andflg:@"0"];
        }
    }
}
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}
-(void)SelectMatchMemberByPersonCallBack:(id)dict{
    [SVProgressHUD dismiss];
    if ([dict[@"code"] intValue] == 200) {
        NSLog(@"%@",dict);
        PlayerArray = [[NSArray alloc] initWithArray:dict[@"data"]];
        [_mainTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(void)TeamFootRefresh
{
    curpage++;
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"FootRefireshCallBack:"];
    if(![searchTxt.text isEqual:@""] && [self isPureInt:searchTxt.text]){
        if (_playerForMatchMode == Mode_MushaPlayer) {
            [dataProvider SelectAllMatchMemberBySearch:@"0" andmaximumRows:@"10" andmatchId:_matchId andmembercode:searchTxt.text andnicname:@"" andflg:@"0"];
        }else{
            [dataProvider SelectAllMatchTeamBySearch:@"0" andmaximumRows:@"10" andmatchId:_matchId andmembercode:searchTxt.text andnicname:@"" andflg:@"0"];
        }
    }else{
        if (_playerForMatchMode == Mode_MushaPlayer) {
            [dataProvider SelectAllMatchMemberBySearch:[NSString stringWithFormat:@"%d",curpage * 10] andmaximumRows:@"10" andmatchId:_matchId andmembercode:@"0" andnicname:searchTxt.text andflg:@"0"];
        }else{
            [dataProvider SelectAllMatchTeamBySearch:[NSString stringWithFormat:@"%d",curpage * 10] andmaximumRows:@"10" andmatchId:_matchId andmembercode:@"0" andnicname:searchTxt.text andflg:@"0"];
        }
    }
}

-(void)FootRefireshCallBack:(id)dict
{
    NSLog(@"上拉刷新");
    // 结束刷新
    [_mainTableView.mj_footer endRefreshing];
    NSMutableArray *itemarray=[[NSMutableArray alloc] initWithArray:PlayerArray];
    if ([dict[@"code"] intValue] == 200) {
        NSArray * arrayitem=[[NSArray alloc] init];
        arrayitem=dict[@"data"];
        for (id item in arrayitem) {
            [itemarray addObject:item];
        }
        PlayerArray=[[NSArray alloc] initWithArray:itemarray];
    }
    [_mainTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)clickTeamPhotoEvent{
    IntroduceViewController * introduceViewController = [[IntroduceViewController alloc] init];
    introduceViewController.teamId = get_sp(@"TeamId");
    [self.navigationController pushViewController:introduceViewController animated:YES];
}

#pragma click actions
-(void)tapViewAction:(id)sender
{
    [self.view endEditing:YES];
}

#pragma mark - search delegate
-(void) viewWillLayoutSubviews
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void) keyboardWillHide:(NSNotification *)aNotification

{
    
    NSDictionary* info = [aNotification userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    
    
    UITableView *tableView = [_searchDisplayController searchResultsTableView];
    
    [tableView setContentInset:UIEdgeInsetsMake(300, 0, kbSize.height, 0)];
    
    [tableView setScrollIndicatorInsets:UIEdgeInsetsMake(300, 0, kbSize.height, 0)];
    
}
- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}



- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
    
    //   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //    [tableView setContentInset:UIEdgeInsetsZero];
    //    [tableView setScrollIndicatorInsets:UIEdgeInsetsZero];
    //
    tableView.frame = CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - 108);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //
    //    [tableView setContentInset:UIEdgeInsetsMake(300, 0, 0, 0)];
    //
    //    [tableView setScrollIndicatorInsets:UIEdgeInsetsMake(300, 0, 0, 0)];
    
}


#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionNum;
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return PlayerArray.count;
    }
}

#pragma mark - setting for cell
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight)];
    cell.backgroundColor = ItemsBaseColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        searchTxt = [[UITextField alloc] initWithFrame:CGRectMake(14, 0, SCREEN_WIDTH - 28, cell.frame.size.height)];
        searchTxt.returnKeyType = UIReturnKeySearch;
        searchTxt.delegate = self;
        searchTxt.textColor = [UIColor whiteColor];
        searchTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索用户昵称、编号" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.44 green:0.43 blue:0.44 alpha:1]}];
        UIImageView *searchIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 20)];
        searchIv.contentMode = UIViewContentModeScaleAspectFit;
        searchIv.image = [UIImage imageNamed:@"search"];
        searchTxt.leftView = searchIv;
        searchTxt.leftViewMode = UITextFieldViewModeAlways;
        [cell addSubview:searchTxt];
        return cell;
    }else{
        NSString *PhotoPath = [Toolkit judgeIsNull:[PlayerArray[indexPath.row] valueForKey:@"PhotoPath"]];
        NSString *url = [NSString stringWithFormat:@"%@%@",Url,PhotoPath];
        UserHeadView *headView = nil;
        if (_playerForMatchMode == Mode_MushaPlayer) {
            headView = [[UserHeadView alloc] initWithFrame:CGRectMake(GapToLeft, 5, _cellHeight-5*2, _cellHeight-5*2) andUrl:url andNav:self.navigationController];
            headView.userId = [Toolkit judgeIsNull:[PlayerArray[indexPath.row] valueForKey:@"UserId"]];
        }else{
            headView = [[UserHeadView alloc] initWithFrame:CGRectMake(GapToLeft, 5, _cellHeight-5*2, _cellHeight-5*2) andurl:url];
            UIButton *tempBtn = [[UIButton alloc] initWithFrame:headView.frame];
            [tempBtn addTarget:self action:@selector(clickTeamPhotoEvent) forControlEvents:UIControlEventTouchUpInside];
            [headView addSubview:tempBtn];
            headView.userId = [Toolkit judgeIsNull:[PlayerArray[indexPath.row] valueForKey:@"TeamId"]];
        }
        [headView makeSelfRound];
        [cell addSubview:headView];
        
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake((headView.frame.size.width + headView.frame.origin.x + 10),
                                                                      5,
                                                                      SCREEN_WIDTH -(headView.frame.size.width + headView.frame.origin.x + 10),
                                                                      _cellHeight/2-5)];
        titleLab.textColor = [UIColor whiteColor];
        titleLab.text = [Toolkit judgeIsNull:[PlayerArray[indexPath.row] valueForKey:@"NicName"]];
        titleLab.font = [UIFont systemFontOfSize:14];
        [cell addSubview:titleLab];
        
        UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake((headView.frame.size.width + headView.frame.origin.x + 10),
                                                                     _cellHeight/2,
                                                                     SCREEN_WIDTH -(headView.frame.size.width + headView.frame.origin.x + 10)-70,
                                                                     _cellHeight/2)];
        timeLab.textColor = [UIColor whiteColor];
        NSString *joinTime = [[Toolkit judgeIsNull:[PlayerArray[indexPath.row] valueForKey:@"JoinTime"]] substringToIndex:10];
        NSString *mYear = @"";
        NSString *mMonth = @"";
        NSString *mDay = @"";
        if (![joinTime isEqual:@""]) {
            mYear = [joinTime substringToIndex:4];
            mMonth = [joinTime substringWithRange:NSMakeRange(5, 2)];
            mDay = [joinTime substringWithRange:NSMakeRange(8, 2)];
        }
        timeLab.text = [NSString stringWithFormat:@"报名时间:%@年%@月%@日",mYear,mMonth,mDay];//@"报名时间:2015年10月20日";
        timeLab.font = [UIFont systemFontOfSize:14];
        [cell addSubview:timeLab];
        
        
        UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 70),
                                                                    _cellHeight/2,
                                                                    100,
                                                                    _cellHeight/2)];
        numLab.textColor = [UIColor whiteColor];
        numLab.text = [NSString stringWithFormat:@"编号:%04d",[[Toolkit judgeIsNull:[PlayerArray[indexPath.row] valueForKey:@"MatchCode"]] intValue]];
        numLab.font = [UIFont systemFontOfSize:14];
        [cell addSubview:numLab];
    }
    return cell;
    
}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 45;
    }else{
        return _cellHeight;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    NSLog(@"click cell section : %ld row : %ld",(long)indexPath.section,(long)indexPath.row);
    
    
    
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
    tempView.backgroundColor = BACKGROUND_COLOR;
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

#pragma mark UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [_mainTableView.mj_header beginRefreshing];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [searchTxt resignFirstResponder];
    return YES;
}

@end
