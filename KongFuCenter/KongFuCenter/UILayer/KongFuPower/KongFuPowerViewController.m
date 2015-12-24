//
//  KongFuPowerViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/3.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "KongFuPowerViewController.h"
#import "WechatShortVideoController.h"
#import "UploadVideoViewController.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"

@interface KongFuPowerViewController ()<WechatShortVideoDelegate>
{
    UIImageView *btnImgView;
#pragma mark - pram for tableView
    NSInteger _sectionNum;
    CGFloat _cellHeight;
    UITableView *_mainTableView;
    
    NSArray *dataArr;
    NSMutableArray *studyCateArr;
    NSMutableArray *btnArr;
    
    int videoType;
    
    int dataPage;
    
    int pageSize;
    
    
}
@end

#define GapToLeft   20

#define Local_BtnTag  (2015+1)
#define Take_BtnTag  (2015+2)

@implementation KongFuPowerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.view.backgroundColor = BACKGROUND_COLOR;
    
    [self setBarTitle:@"核动力"];
    
    [self addRightButton:@"plus@2x.png"];
    
    videoType=0;
    
    dataPage=0;
    
    pageSize=6;
    
    dataArr=[[NSArray alloc] init];
    
    [self initDatas];
    
    [self initViews];
    
    
    // Do any additional setup after loading the view.
}



#define NEWEST_BTN      0
#define HOST_BTN        1
#define RECOMMEND_BTN   2
#define ORIGINAL_BTN      3
#define CHANNEL_BTN      4
-(void)initDatas
{
    
    studyCateArr = [NSMutableArray array];
    [studyCateArr addObjectsFromArray:@[@"最新",@"热门",@"推荐",@"原创",@"频道"]];
    
    btnArr = [NSMutableArray array];
    
}

-(void)initViews
{
    
    
    UIView *viewForBtns = [[UIView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, 44)];
    btnImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btnFlag"]];
    btnImgView.contentMode = UIViewContentModeScaleAspectFit;
    for (int i = 0;i< studyCateArr.count; i++) {
        UIButton *cateBtn = [[UIButton alloc] initWithFrame:CGRectMake(0 + i*(SCREEN_WIDTH/studyCateArr.count), 0,(SCREEN_WIDTH/studyCateArr.count) , viewForBtns.frame.size.height)];
        
        if(i == 0)
        {
            cateBtn.selected = YES;
            btnImgView.frame = CGRectMake((cateBtn.frame.size.width - 15)/2, (cateBtn.frame.size.height - 15), 15, 15);
            [cateBtn addSubview:btnImgView];
        }
        
        [cateBtn setTitle:studyCateArr[i] forState:UIControlStateNormal];
        cateBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        cateBtn.backgroundColor = ItemsBaseColor;
        [cateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cateBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        cateBtn.tag = i;
        
        [cateBtn addTarget:self action:@selector(cateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [viewForBtns addSubview:cateBtn];
        [btnArr addObject:cateBtn];
    }
    
    [self.view addSubview:viewForBtns];
    
    _cellHeight = (SCREEN_HEIGHT - Header_Height - TabBar_HEIGHT)/2;
    _sectionNum = 3;
    
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height+44, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height  - TabBar_HEIGHT+6)];
    _mainTableView.backgroundColor = BACKGROUND_COLOR;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorColor =  Separator_Color;
    //_mainTableView.scrollEnabled = NO;
    
//    _mainTableView.contentSize = CGSizeMake(SCREEN_HEIGHT, dataArr.count*(_cellHeight + 20));
    
    
    
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
    
    [self.view addSubview:_mainTableView];
    
    
    
    moreSettingBackView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100 -10), Header_Height, 100, 88)];
    moreSettingBackView.backgroundColor = ItemsBaseColor;
    UIButton *newBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, moreSettingBackView.frame.size.width,  moreSettingBackView.frame.size.height/2)];
    [newBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newBtn setTitle:@"本地视频" forState:UIControlStateNormal];
    newBtn.tag = Local_BtnTag;
    [newBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView2 =[[UIView alloc] initWithFrame:CGRectMake(0, moreSettingBackView.frame.size.height/2, moreSettingBackView.frame.size.width - 2, 1)];
    lineView2.backgroundColor = Separator_Color;
    UIButton *delBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, moreSettingBackView.frame.size.height/2, moreSettingBackView.frame.size.width,  moreSettingBackView.frame.size.height/2)];
    [delBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [delBtn setTitle:@"拍摄视频" forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    delBtn.tag = Take_BtnTag;
    
    
    [moreSettingBackView addSubview:newBtn];
    [moreSettingBackView addSubview:delBtn];
    [moreSettingBackView addSubview:lineView2];
    
    [self.view addSubview:moreSettingBackView];
    moreSettingBackView.hidden = YES;

    
}


-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showTabBar];
}

#pragma mark - Btn click

-(void)cateBtnClick:(UIButton *)sender
{
    sender.selected = YES;
    [btnImgView removeFromSuperview];
    btnImgView.frame = CGRectMake((sender.frame.size.width-15)/2, (sender.frame.size.height - 15), 15, 15);
    [sender addSubview:btnImgView];
    
    for(int i =0;i<btnArr.count;i++)
    {
        if(i != sender.tag)
        {
            ((UIButton *)btnArr[i]).selected = NO;
        }
    }
    NSInteger tag = sender.tag;
    
    videoType=(int)tag;
    
    switch (tag) {
            
        case CHANNEL_BTN:
        {
            ChannelViewController *channelViewCtl = [[ChannelViewController alloc] init];
            channelViewCtl.navtitle = @"频道";
            [self.navigationController pushViewController:channelViewCtl animated:YES];
        }
            break;
            
        default:
            [_mainTableView.mj_header beginRefreshing];
            break;
    }
    
}

-(void)btnClick:(UIButton *)sender
{
    if(sender.tag == Local_BtnTag)
    {
        

    }
    else  if(sender.tag == Take_BtnTag)
    {
        WechatShortVideoController *wechatShortVideoController = [[WechatShortVideoController alloc] init];
        
        wechatShortVideoController.delegate = self;
        
        [self presentViewController:wechatShortVideoController animated:YES completion:^{}];
    }
}



-(void)clickRightButton:(UIButton *)sender
{
    
    
    if(moreSettingBackView.hidden == YES)
    {
        moreSettingBackView.hidden = NO;
        [self positionShowView:moreSettingBackView];
    }
    else
    {
        
        [self positionDismissView:moreSettingBackView];
    }
    
    
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
    
    switch (videoType) {
        case NEWEST_BTN:
        {
            [dataprovider GetNewVideoList:[NSString stringWithFormat:@"%d",dataPage*pageSize] andmaximumRows:[NSString stringWithFormat:@"%d",pageSize]];
        }
            break;
            
        case HOST_BTN:
        {
            [dataprovider GetHotVideoList:[NSString stringWithFormat:@"%d",dataPage*pageSize] andmaximumRows:[NSString stringWithFormat:@"%d",pageSize]];
        }
            break;
        case RECOMMEND_BTN:
        {
            [dataprovider GetTuiJianVideoList:[NSString stringWithFormat:@"%d",dataPage*pageSize] andmaximumRows:[NSString stringWithFormat:@"%d",pageSize]];
        }
            break;
        case ORIGINAL_BTN:
        {
            [dataprovider GetYuanChuangVideoList:[NSString stringWithFormat:@"%d",dataPage*pageSize] andmaximumRows:[NSString stringWithFormat:@"%d",pageSize]];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark -animation
#define SHOW_ANIM_KEY   @"showSettingView"
#define DISMISS_ANIM_KEY   @"dismissSettingView"
-(void)positionShowView:(UIView *)tempView
{
    
    
    CABasicAnimation *scale=[CABasicAnimation animationWithKeyPath:@"transform"];
    [scale setFromValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 0, 1.0)]];
    [scale setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake((moreSettingBackView.frame.origin.x+moreSettingBackView.frame.size.width/2), Header_Height)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake((moreSettingBackView.frame.origin.x+moreSettingBackView.frame.size.width/2),
                                                              (moreSettingBackView.frame.size.height/2 + moreSettingBackView.frame.origin.y))];
    //动画执行后保持显示状态 但是属性值不会改变 只会保持显示状态
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    
    //    animation.autoreverses = YES;//动画返回
    
    CAAnimationGroup *group=[CAAnimationGroup animation];
    [group setAnimations:[NSArray arrayWithObjects:scale,animation, nil]];
    [group setDuration:0.5];
    //    animation.repeatCount = MAXFLOAT;//重复
    //tempView.layer.delegate = self;
    group.delegate= self;
    [moreSettingBackView.layer addAnimation:group forKey:SHOW_ANIM_KEY];
}


-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"anim stop");

}

-(void)positionDismissView:(UIView *)tempView
{
    
    
    CABasicAnimation *scale=[CABasicAnimation animationWithKeyPath:@"transform"];
    [scale setFromValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1, 1.0)]];
    [scale setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 0.0, 1.0)]];
    
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake((moreSettingBackView.frame.origin.x+moreSettingBackView.frame.size.width/2),
                                                                (moreSettingBackView.frame.size.height/2 + moreSettingBackView.frame.origin.y))];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake((moreSettingBackView.frame.origin.x+moreSettingBackView.frame.size.width/2),
                                                              Header_Height)];
    //动画执行后保持显示状态 但是属性值不会改变 只会保持显示状态
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    
    //    animation.autoreverses = YES;//动画返回
    
    CAAnimationGroup *group=[CAAnimationGroup animation];
    [group setAnimations:[NSArray arrayWithObjects:scale,animation, nil]];
    [group setDuration:0.5];
    //    animation.repeatCount = MAXFLOAT;//重复
    group.delegate= self;
    [tempView.layer addAnimation:group forKey:DISMISS_ANIM_KEY];
    
    [self performSelector:@selector(viewSetHidden:) withObject:[NSNumber numberWithBool:YES] afterDelay:0.5 - 0.1];
}
-(void)viewSetHidden:(id)info
{
    moreSettingBackView.hidden = YES;
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



#pragma mark - setting for section

//设置section header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

//设置section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - WechatShortVideoDelegate
- (void)finishWechatShortVideoCapture:(NSURL *)filePath {
    NSLog(@"filePath is %@", filePath);
    
    
    UploadVideoViewController * uploadVideoVC=[[UploadVideoViewController alloc] initWithNibName:@"UploadVideoViewController" bundle:[NSBundle mainBundle]];
    
    uploadVideoVC.VideoFilePath=filePath;
    
    [self.navigationController pushViewController:uploadVideoVC animated:YES];
}

@end
