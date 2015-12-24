//
//  ChannelVideosViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/10.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "ChannelVideosViewController.h"
#import "DataProvider.h"
#import "MJRefresh.h"

#define GapToLeft   20
#define PageSize 6

@interface ChannelVideosViewController ()
{
    UIImageView *btnImgView;
#pragma mark - pram for tableView
    NSInteger _sectionNum;
    CGFloat _cellHeight;
    UITableView *_mainTableView;
    
    NSArray *dataArr;
    NSMutableArray *studyCateArr;
    NSMutableArray *btnArr;
    
    int dataPage;
    
}
@end

@implementation ChannelVideosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self addLeftButton:@"left"];
    
    
    [self initViews];
}
-(void)initViews
{
    _cellHeight = (SCREEN_HEIGHT - Header_Height - TabBar_HEIGHT)/2;
    
    _sectionNum = 3;
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height+50  )];
    
    _mainTableView.backgroundColor = BACKGROUND_COLOR;
    
    _mainTableView.delegate = self;
    
    _mainTableView.dataSource = self;
    
    _mainTableView.separatorColor =  Separator_Color;
    
    //_mainTableView.scrollEnabled = NO;
    
    dataArr =[[NSArray alloc] init];
    
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
    
    
    
    
}

-(void)TeamTopRefresh
{
    dataPage=0;
    [self RequestData];
}

-(void)TeamFootRefresh
{
    ++dataPage;
    [self RequestData];
}

-(void)TopRefreshCallBack:(id)dict
{
    NSLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        dataArr=dict[@"data"];
        if (!_mainTableView) {
            [self initViews];
        }
    }
    else
    {
        dataArr=[[NSArray alloc] init];
    }
    [_mainTableView reloadData];
}
-(void)FooterRefreshCallBack:(id)dict
{
    NSLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        NSMutableArray * itemMutableArray=[[NSMutableArray alloc] initWithArray:dataArr];
        NSArray * itemarr=[[NSArray alloc] initWithArray:dict[@"data"]];
        for (id item in itemarr) {
            [itemMutableArray addObject:item];
        }
        dataArr=[[NSArray alloc] initWithArray:itemMutableArray];
        
        [_mainTableView reloadData];
    }
    [_mainTableView.mj_footer endRefreshing];
}


-(void)RequestData
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    
    [dataprovider setDelegateObject:self setBackFunctionName:dataPage==0?@"TopRefreshCallBack:":@"FooterRefreshCallBack:"];
    
    [dataprovider GetVideoByCategory:[NSString stringWithFormat:@"%d",dataPage*PageSize] andmaximumRows:[NSString stringWithFormat:@"%d",PageSize] andcateid:_cateid];
}


#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return dataArr.count;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}

#pragma mark - setting for cell
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight)];
    cell.backgroundColor = ItemsBaseColor;
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight)];
    
    [backgroundView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Url,dataArr[indexPath.section][@"ImagePath"]]] placeholderImage:[UIImage imageNamed:@""]];
    
    //    backgroundView.image = [UIImage imageNamed:dataArr[indexPath.section][@""]];
    cell.backgroundView = backgroundView;
    {
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(GapToLeft, (_cellHeight - 50), (SCREEN_WIDTH - GapToLeft), 1)];
        lineView.backgroundColor = Separator_Color;
        [cell addSubview:lineView];
        
        
        //线上
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, (lineView.frame.origin.y - 30), 200, 30)];
        titleLab.text = dataArr[indexPath.section][@"Title"];
        titleLab.textColor = [UIColor whiteColor];
        titleLab.font = [UIFont boldSystemFontOfSize:16];
        [cell addSubview:titleLab];
        
        UIButton *relayBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 30 -20), (lineView.frame.origin.y - 30), 30, 30)];
        [relayBtn setImage:[UIImage imageNamed:@"relay"] forState:UIControlStateNormal];
        [cell addSubview:relayBtn];
        
        //under line
        UserHeadView *headView = [[UserHeadView alloc] initWithFrame:CGRectMake(GapToLeft, lineView.frame.origin.y+(50 - 35)/2, 35, 35) andImgName:@"me" andNav:(self.navigationController)];
        [headView.headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Url,dataArr[indexPath.section][@"PhotoPath"]]] placeholderImage:[UIImage imageNamed:@""]];
        [headView makeSelfRound];
        [cell addSubview:headView];
        
        
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake((headView.frame.origin.x+headView.frame.size.width + 5),
                                                                     (headView.frame.size.height/4+headView.frame.origin.y), 60, headView.frame.size.height/2)];
        
        nameLab.textColor = [UIColor whiteColor];
        nameLab.text = [dataArr[indexPath.section][@"NicName"] isEqual:[NSNull null]]?@"":dataArr[indexPath.section][@"NicName"];
        nameLab.font = [UIFont systemFontOfSize:14];
        [cell addSubview:nameLab];
        
        
        UIButton *commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(((nameLab.frame.origin.x+nameLab.frame.size.width + 10)),
                                                                          (headView.frame.size.height/4+headView.frame.origin.y),
                                                                          (SCREEN_WIDTH - (nameLab.frame.origin.x+nameLab.frame.size.width + 10) -10)/2,
                                                                          headView.frame.size.height/2)];
        [commentBtn setImage:[UIImage imageNamed:@"chat"] forState:UIControlStateNormal];
        [commentBtn setTitle:[NSString stringWithFormat:@"%@条评论",[dataArr[indexPath.section][@"CommentNum"] isEqual:[NSNull null]]?@"0":dataArr[indexPath.section][@"CommentNum"]] forState:UIControlStateNormal];
        commentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [cell addSubview:commentBtn];
        
        UIButton *timeBtn = [[UIButton alloc] initWithFrame:CGRectMake(((commentBtn.frame.origin.x+commentBtn.frame.size.width + 5)),
                                                                       (headView.frame.size.height/4+headView.frame.origin.y),
                                                                       commentBtn.frame.size.width,//(SCREEN_WIDTH - (nameLab.frame.origin.x+nameLab.frame.size.width + 10) -10)/2,
                                                                       headView.frame.size.height/2)];
        [timeBtn setImage:[UIImage imageNamed:@"clock"] forState:UIControlStateNormal];
        [timeBtn setTitle:[dataArr[indexPath.section][@"PublishTime"] isEqual:[NSNull null]]?@"0":dataArr[indexPath.section][@"PublishTime"] forState:UIControlStateNormal];
        timeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [cell addSubview:timeBtn];
        
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
    
    VideoDetailViewController *videoDetailViewCtl = [[VideoDetailViewController alloc] init];
    videoDetailViewCtl.navtitle =@"视频";
    videoDetailViewCtl.videoID=dataArr[indexPath.section][@"Id"];
    [self.navigationController pushViewController:videoDetailViewCtl animated:YES];
    
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
