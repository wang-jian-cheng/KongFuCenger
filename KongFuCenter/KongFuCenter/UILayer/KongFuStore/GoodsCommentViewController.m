//
//  GoodsCommentViewController.m
//  KongFuCenter
//
//  Created by Wangjc on 16/2/16.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "GoodsCommentViewController.h"

@interface GoodsCommentViewController ()
{
    CGFloat _cellHeight;
    int pageNo;
    int pageSize;
    UITableView *_mainTableView;
    
}
@property(nonatomic) NSMutableArray *commentArr;

@end

@implementation GoodsCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"left"];
    self.navtitle = @"商品评论";
    [self initViews];
    // Do any additional setup after loading the view.
}


-(void)initViews
{
    
    _cellHeight = 100;
    pageSize = 15;
    
    //    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height+44, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height )];
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height ) style:UITableViewStyleGrouped];
    _mainTableView.backgroundColor = BACKGROUND_COLOR;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorColor =  Separator_Color;
    //    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.tableFooterView = [[UIView alloc] init];
    //_mainTableView.scrollEnabled = NO;
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    _mainTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        pageNo=0;
        // 结束刷新
        [self.commentArr removeAllObjects];
        [_mainTableView.mj_footer setState:MJRefreshStateIdle];
        [weakSelf getGoodComment];
        
    }];
    [_mainTableView.mj_header beginRefreshing];
    
    // 上拉刷新
    _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf getGoodComment];
    }];
    
    [self.view addSubview:_mainTableView];
    
}
#pragma mark - self property

-(void)setGoodId:(NSString *)goodId
{
    _goodId = ZY_NSStringFromFormat(@"%@",goodId);
}

-(NSMutableArray *)commentArr
{
    if(_commentArr ==nil)
    {
        _commentArr = [NSMutableArray array];
    }
    
    return _commentArr;
}

#pragma mark - self data source

-(void)getGoodComment{
    
    [SVProgressHUD showWithStatus:@"刷新中"];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getGoodCommentCallBack:"];
    [dataProvider SelectCommentByProductId:self.goodId andstartRowIndex:[NSString stringWithFormat:@"%d",pageNo * pageSize] andmaximumRows:ZY_NSStringFromFormat(@"%d",pageSize)];
}

-(void)getGoodCommentCallBack:(id)dict{
    // 结束刷新
    
    DLog(@"%@",dict);
    [_mainTableView.mj_header endRefreshing];
    [_mainTableView.mj_footer endRefreshing];
    if ([dict[@"code"] intValue] == 200) {
        [SVProgressHUD dismiss];
        pageNo ++;
        
        [self.commentArr addObjectsFromArray:dict[@"data"]];
        
        [_mainTableView reloadData];
        
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:dict[@"data"]];
    }
}


#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.commentArr.count;
    
}

#pragma mark - setting for cell

#define GapToLeft 20
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight)];
    cell.backgroundColor = ItemsBaseColor;
    @try {
        
        NSString *url = [NSString stringWithFormat:@"%@%@",Url,[Toolkit judgeIsNull:[self.commentArr[indexPath.row] valueForKey:@"PhotoPath"]]];
        UserHeadView *userHeadView = [[UserHeadView alloc] initWithFrame:CGRectMake(14, 5, 40, 40) andUrl:url andNav:self.navigationController];
        [userHeadView makeSelfRound];
        [cell addSubview:userHeadView];
        
        UILabel *mName = [[UILabel alloc] initWithFrame:CGRectMake(userHeadView.frame.origin.x + userHeadView.frame.size.width + 5, 5 + (40 - 21) / 2, 150, 21)];
        mName.font = [UIFont systemFontOfSize:15];
        mName.textColor = [UIColor whiteColor];
        mName.text = [self.commentArr[indexPath.row] valueForKey:@"UserName"];
        [cell addSubview:mName];
        
        NSString *mContentStr = [Toolkit judgeIsNull:[self.commentArr[indexPath.row] valueForKey:@"Content"]];//@"东西不错，用着很好，很喜欢.东西不错，用着很好，很喜欢.东西不错，用着很好，很喜欢.东西不错，用着很好，很喜欢.东西不错，用着很好，很喜欢.";
        CGFloat contentHeight = [Toolkit heightWithString:mContentStr fontSize:14 width:SCREEN_WIDTH-64]+10;
        UITextView *mContent = [[UITextView alloc] initWithFrame:CGRectMake(mName.frame.origin.x, mName.frame.origin.y + mName.frame.size.height + 2, SCREEN_WIDTH - mName.frame.origin.x - 10, contentHeight)];
        mContent.textColor = [UIColor whiteColor];
        mContent.editable = NO;
        mContent.scrollEnabled = NO;
        mContent.font = [UIFont systemFontOfSize:12];
        mContent.backgroundColor = ItemsBaseColor;
        mContent.text = mContentStr;
        [cell addSubview:mContent];
        
        UILabel *mDate = [[UILabel alloc] initWithFrame:CGRectMake(mName.frame.origin.x, mName.frame.origin.y + mName.frame.size.height + 2 + contentHeight + 5, 150, 17)];
        mDate.font = [UIFont systemFontOfSize:12];
        mDate.text = [Toolkit judgeIsNull:[self.commentArr[indexPath.row] valueForKey:@"PublishTime"]];
        mDate.textColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1];
        [cell addSubview:mDate];
        
        NSString *mSpecStr = [NSString stringWithFormat:@"规格:%@",[Toolkit judgeIsNull:[self.commentArr[indexPath.row] valueForKey:@"ColorAndSize"]]];
        CGFloat specHeight = [Toolkit heightWithString:mSpecStr fontSize:12 width:SCREEN_WIDTH-(14 + 40 + 5 + 5)]+10;
        UITextView *mSpecLbl = [[UITextView alloc] initWithFrame:CGRectMake(mDate.frame.origin.x, mDate.frame.origin.y + mDate.frame.size.height, SCREEN_WIDTH - (14 + 40 + 5 + 5), specHeight)];
        mSpecLbl.backgroundColor = ItemsBaseColor;
        mSpecLbl.font = [UIFont systemFontOfSize:12];
        mSpecLbl.text = [NSString stringWithFormat:@"规格:%@",[Toolkit judgeIsNull:[self.commentArr[indexPath.row] valueForKey:@"ColorAndSize"]]];
        mSpecLbl.textColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1];
        [cell addSubview:mSpecLbl];
        

    }
    @catch (NSException *exception) {
        
    }
    @finally {
         return cell;
    }
    
}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    NSString *mContentStr = [Toolkit judgeIsNull:[self.commentArr[indexPath.row] valueForKey:@"Content"]];//@"东西不错，用着很好，很喜欢.东西不错，用着很好，很喜欢.东西不错，用着很好，很喜欢.东西不错，用着很好，很喜欢.东西不错，用着很好，很喜欢.";
    CGFloat contentHeight = [Toolkit heightWithString:mContentStr fontSize:14 width:SCREEN_WIDTH-64]+5;
    
    NSString *mSpecStr = [NSString stringWithFormat:@"规格:%@",[Toolkit judgeIsNull:[self.commentArr[indexPath.row] valueForKey:@"ColorAndSize"]]];
    CGFloat specHeight = [Toolkit heightWithString:mSpecStr fontSize:12 width:SCREEN_WIDTH-(14 + 40 + 5 + 5)]+10;
    
    return 5 + (40 - 21) / 2 + 23 + contentHeight + 25 + specHeight + 5;
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
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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

#define SectionHeight  0

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView = [[UIView alloc] init];
    tempView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
    return tempView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *tempView = [[UIView alloc] init];
    tempView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 10);
    return tempView;
}

//设置section header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

//设置section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
    
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
