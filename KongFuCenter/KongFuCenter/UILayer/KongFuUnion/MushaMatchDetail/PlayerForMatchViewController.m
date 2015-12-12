//
//  PlayerForMatchViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/12.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "PlayerForMatchViewController.h"

@interface PlayerForMatchViewController ()<UISearchBarDelegate,UISearchDisplayDelegate>
{
#pragma mark - pram for tableView
    NSInteger _sectionNum;
    CGFloat _cellHeight;
    UITableView *_mainTableView;
    
}
@end

#define GapToLeft   20

@implementation PlayerForMatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
 
    [self addLeftButton:@"left"];
    [self addRightbuttontitle:@"确定"];
    [self initViews];
    // Do any additional setup after loading the view.
}
-(void)initViews
{
    _cellHeight = SCREEN_HEIGHT/12;
    _sectionNum = 1;
    
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height+10, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height )];
    _mainTableView.backgroundColor = BACKGROUND_COLOR;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorColor =  Separator_Color;
    _mainTableView.tableFooterView = [[UIView alloc] init];
    //_mainTableView.scrollEnabled = NO;
    
    _mainTableView.contentSize = CGSizeMake(SCREEN_HEIGHT, _sectionNum*(_cellHeight + 20));
    [self.view addSubview:_mainTableView];
    
    
    
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH
                                                               , _cellHeight)];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"搜索战队昵称、id号";
    _mainTableView.tableHeaderView = _searchBar;
    _searchBar.backgroundColor = ItemsBaseColor;
    
    
    _searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
    _searchDisplayController.active = NO;
    _searchDisplayController.searchResultsDataSource = self;
    _searchDisplayController.searchResultsDelegate = self;
    _searchDisplayController.delegate = self;
    
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:) ];
    [self.view addGestureRecognizer:tapGesture];

    
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
    
    
        return 6;

}

#pragma mark - setting for cell
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight)];
    cell.backgroundColor = ItemsBaseColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.section) {
     
        case 0:
        {
            UserHeadView *headView = [[UserHeadView alloc] initWithFrame:CGRectMake(GapToLeft, 5, _cellHeight-5*2, _cellHeight-5*2) andImgName:@"me" andNav:self.navigationController];
            [headView makeSelfRound];
            [cell addSubview:headView];
            
            
            UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake((headView.frame.size.width + headView.frame.origin.x + 10),
                                                                         5,
                                                                         SCREEN_WIDTH -(headView.frame.size.width + headView.frame.origin.x + 10),
                                                                         _cellHeight/2-5)];
            titleLab.textColor = [UIColor whiteColor];
            titleLab.text = @"李小龙";
            titleLab.font = [UIFont systemFontOfSize:14];
            [cell addSubview:titleLab];
            
            UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake((headView.frame.size.width + headView.frame.origin.x + 10),
                                                                          _cellHeight/2,
                                                                          SCREEN_WIDTH -(headView.frame.size.width + headView.frame.origin.x + 10)-100,
                                                                          _cellHeight/2)];
            timeLab.textColor = [UIColor whiteColor];
            timeLab.text = @"报名时间：2015年10月20日";
            timeLab.font = [UIFont systemFontOfSize:14];
            [cell addSubview:timeLab];
            
            
            UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100),
                                                                         _cellHeight/2,
                                                                         100,
                                                                         _cellHeight/2)];
            numLab.textColor = [UIColor whiteColor];
            numLab.text = @"编号：005";
            numLab.font = [UIFont systemFontOfSize:14];
            [cell addSubview:numLab];
            
        }
            break;
        case 2:
        {

            
        }
            break;
            
        default:
            break;
    }
    return cell;
    
}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    return _cellHeight;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
