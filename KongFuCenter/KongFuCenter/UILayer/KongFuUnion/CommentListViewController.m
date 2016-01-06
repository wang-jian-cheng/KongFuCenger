//
//  CommentListViewController.m
//  KongFuCenter
//
//  Created by Rain on 16/1/4.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "CommentListViewController.h"
#import "CommentTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "OneShuoshuoViewController.h"
#import "MJRefresh.h"

@interface CommentListViewController (){
    UITableView *mTableView;
    CGFloat mCellHeight;
    NSUserDefaults *userDefault;
    NSArray *commentArray;
    int curpage;
}

@end

@implementation CommentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化参数
    self.view.backgroundColor = BACKGROUND_COLOR;
    mCellHeight = 70;
    [self setBarTitle:@"朋友圈的评论提示"];
    [self addLeftButton:@"left"];
    
    userDefault = [NSUserDefaults standardUserDefaults];
    commentArray = [[NSArray alloc] init];
    
    [self initViews];
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

#pragma mark 自定义方法

-(void)TeamTopRefresh{
    curpage = 0;
    [SVProgressHUD showWithStatus:@"正在加载中..."];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getCommentInfoCallBack:"];
    [dataProvider GetMyDongtaiPage:[userDefault valueForKey:@"id"] andstartRowIndex:@"0" andmaximumRows:@"10"];
}

-(void)TeamFootRefresh
{
    curpage++;
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"FootRefireshBackCall:"];
    [dataProvider GetMyDongtaiPage:[userDefault valueForKey:@"id"] andstartRowIndex:[NSString stringWithFormat:@"%d",curpage * 10] andmaximumRows:@"10"];
}

-(void)getCommentInfoCallBack:(id)dict{
    [SVProgressHUD dismiss];
    NSLog(@"%@",dict);
    if ([dict[@"code"] intValue] == 200) {
        commentArray = dict[@"data"];
        [mTableView reloadData];
    }
}

-(void)FootRefireshBackCall:(id)dict
{
    NSLog(@"上拉刷新");
    // 结束刷新
    [mTableView.mj_footer endRefreshing];
    NSMutableArray *itemarray=[[NSMutableArray alloc] initWithArray:commentArray];
    if ([dict[@"code"] intValue] == 200) {
        NSArray * arrayitem=[[NSArray alloc] init];
        arrayitem=dict[@"data"];
        for (id item in arrayitem) {
            [itemarray addObject:item];
        }
        commentArray=[[NSArray alloc] initWithArray:itemarray];
        [mTableView reloadData];
    }
}

-(void)initViews{
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height)];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = BACKGROUND_COLOR;
    mTableView.separatorColor = Separator_Color;
    mTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:mTableView];
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    __weak typeof(UITableView *) weakTv = mTableView;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    
    mTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf TeamTopRefresh];
        [weakTv.mj_header endRefreshing];
    }];
    
    // 马上进入刷新状态
    [mTableView.mj_header beginRefreshing];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(TeamFootRefresh)];
    // 禁止自动加载
    footer.automaticallyRefresh = NO;
    // 设置footer
    mTableView.mj_footer = footer;
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return commentArray.count;
}

#pragma mark setting for section

#pragma mark setting for cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"CommentCellIdentifier";
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.backgroundColor = ItemsBaseColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    @try {
        NSString *PhotoPath = [commentArray[indexPath.row] valueForKey:@"PhotoPath"];
        NSString *url = [NSString stringWithFormat:@"%@%@",Url,PhotoPath];
        [cell.mImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"me"]];
        cell.mName.text = [[NSString stringWithFormat:@"%@",[commentArray[indexPath.row] valueForKey:@"NicName"]] isEqual:@""]?@"":[commentArray[indexPath.row] valueForKey:@"NicName"];
        cell.mContent.text = [[NSString stringWithFormat:@"%@",[commentArray[indexPath.row] valueForKey:@"Content"]] isEqual:@""]?@"":[commentArray[indexPath.row] valueForKey:@"Content"];
        NSString *mDate = [[NSString stringWithFormat:@"%@",[commentArray[indexPath.row] valueForKey:@"PublishTime"]] isEqual:@""]?@"":[commentArray[indexPath.row] valueForKey:@"PublishTime"];
        NSString *month = [mDate substringWithRange:NSMakeRange(5, 2)];
        NSString *day = [mDate substringWithRange:NSMakeRange(8, 2)];
        cell.mDate.text = [NSString stringWithFormat:@"%@月%@日",month,day];
        
        NSString *ImagePath = [[NSString stringWithFormat:@"%@",[commentArray[indexPath.row] valueForKey:@"ImagePath"]] isEqual:@""]?@"":[commentArray[indexPath.row] valueForKey:@"ImagePath"];
        if([ImagePath isEqual:@""]){
            NSArray *picList = [[NSArray alloc] initWithArray:[commentArray[indexPath.row] valueForKey:@"PicList"]];
            if (picList.count == 0) {
                UITextView *mTv = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, cell.mDetail.frame.size.width, cell.mDetail.frame.size.height)];
                mTv.backgroundColor = [UIColor colorWithRed:0.24 green:0.24 blue:0.25 alpha:1];
                mTv.textColor = [UIColor whiteColor];
                mTv.text = [[NSString stringWithFormat:@"%@",[commentArray[indexPath.row] valueForKey:@"MessageAndVideoContent"]] isEqual:@""]?@"":[commentArray[indexPath.row] valueForKey:@"MessageAndVideoContent"];
                [cell.mDetail addSubview:mTv];
            }else{
                ImagePath = [picList[0] valueForKey:@"ImagePath"];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.mDetail.frame.size.width, cell.mDetail.frame.size.height)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Url,ImagePath]] placeholderImage:[UIImage imageNamed:@"me"]];
                [cell.mDetail addSubview:imageView];
            }
        }else{
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.mDetail.frame.size.width, cell.mDetail.frame.size.height)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Url,ImagePath]] placeholderImage:[UIImage imageNamed:@"me"]];
            
            UIImageView *play = [[UIImageView alloc] initWithFrame:CGRectMake((imageView.frame.size.width - 15) / 2, (imageView.frame.size.height - 15) / 2, 15, 15)];
            play.image = [UIImage imageNamed:@"play"];
            [imageView addSubview:play];
            
            [cell.mDetail addSubview:imageView];
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return mCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [mTableView deselectRowAtIndexPath:indexPath animated:YES];
    OneShuoshuoViewController *oneShuoshuoVC = [[OneShuoshuoViewController alloc] init];
    oneShuoshuoVC.shuoshuoID = [commentArray[indexPath.row] valueForKey:@"MessageId"];
    [self.navigationController pushViewController:oneShuoshuoVC animated:YES];
}

@end
