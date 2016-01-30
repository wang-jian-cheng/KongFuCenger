//
//  SearchViewController.m
//  KongFuCenter
//
//  Created by Wangjc on 16/1/30.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()
{
    CGFloat _celHeight;
    
    UILabel *tipLab;
}

@property (nonatomic, strong) NSMutableArray *searchVideoArr;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
    
    // Do any additional setup after loading the view.
}


-(void)initViews
{
    pageSize = 16;
    self.view.backgroundColor = ItemsBaseColor;
    [self addLeftButton:@"left"];
    
    searchTxt = [[UITextField alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH ,50 )];
    searchTxt.delegate = self;
    searchTxt.returnKeyType = UIReturnKeySearch;
    searchTxt.textColor = [UIColor whiteColor];
    searchTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索视频名称" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.44 green:0.43 blue:0.44 alpha:1]}];
    
    UIButton *coverBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, searchTxt.frame.size.height)];
    [coverBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [coverBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    searchTxt.leftView = coverBtn;
    searchTxt.leftViewMode = UITextFieldViewModeAlways;
    
    [self.view addSubview:searchTxt];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:) ];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
   
    tipLab = [[UILabel alloc] initWithFrame:CGRectMake(0, searchTxt.frame.origin.y+searchTxt.frame.size.height, SCREEN_WIDTH,
                                                       (SCREEN_HEIGHT - (searchTxt.frame.origin.y+searchTxt.frame.size.height)))];
    
    
    tipLab.backgroundColor =BACKGROUND_COLOR;
    tipLab.textColor = [UIColor whiteColor];
    tipLab.text = @"嘛都没有～～";
    tipLab.textAlignment = NSTextAlignmentCenter;
    tipLab.font = [UIFont systemFontOfSize:18];
    
    [self initCollectionView];
    [self.view addSubview:tipLab];
}

-(void)initCollectionView
{
    UICollectionViewFlowLayout *layout=[[ UICollectionViewFlowLayout alloc ] init ];
    layout.minimumLineSpacing = 5.0;
    layout.minimumInteritemSpacing = 5.0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;//设置collection
    
    //  layout.itemSize = CGSizeMake(318, 286);
    
    // layout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0);

    layout.headerReferenceSize = CGSizeMake(320, 200);
    
    mainCollectionView = [[UICollectionView alloc]  initWithFrame:CGRectMake(0, (searchTxt.frame.origin.y+searchTxt.frame.size.height), SCREEN_WIDTH , SCREEN_HEIGHT-( searchTxt.frame.origin.y+searchTxt.frame.size.height)) collectionViewLayout:layout];
    
    [layout setHeaderReferenceSize:CGSizeMake(mainCollectionView.frame.size.width, 0)];//暂不现实时间
    
    [mainCollectionView registerClass :[ UICollectionViewCell class ] forCellWithReuseIdentifier : @"BaseVideoCell" ];
    
    mainCollectionView.delegate= self;
    mainCollectionView.dataSource =self;
    mainCollectionView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*2);
    mainCollectionView.showsHorizontalScrollIndicator = YES;
    mainCollectionView.showsVerticalScrollIndicator = NO;
    mainCollectionView.backgroundColor = BACKGROUND_COLOR;

    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 下拉刷新
    mainCollectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageNo=0;
        
        [self.searchVideoArr removeAllObjects];
        
        [weakSelf doSearchAction];
        // 结束刷新
        if(mainCollectionView.mj_footer !=nil)
        {
            [mainCollectionView.mj_footer setState:MJRefreshStateIdle];
        }
        
        
    }];
    
    // 上拉刷新
    mainCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf doSearchAction];
        [mainCollectionView.mj_footer endRefreshing];
    }];
    
    
    
    // 默认先隐藏footer
    mainCollectionView.mj_footer.hidden = YES;
    
    [self.view addSubview:mainCollectionView];

    
}


-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}


-(void)initTableView
{
    _cellTableHeight = 90;
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height + 10 +60+10, SCREEN_WIDTH, SCREEN_HEIGHT-( Header_Height + 10 +60+10))];
    _mainTableView.backgroundColor = BACKGROUND_COLOR;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorColor =  Separator_Color;
    _mainTableView.tableFooterView = [[UIView alloc] init];
    //_mainTableView.scrollEnabled = NO;
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    _mainTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //        if(EnditMode == YES)
        //            return ;
        pageNo=0;
   
        if( _mainTableView.mj_footer!=nil)
        {
            [_mainTableView.mj_footer setState:MJRefreshStateIdle];
        }
//        [weakSelf getCollectArticle];
        // 结束刷新
        [_mainTableView.mj_header endRefreshing];
    }];
    [_mainTableView.mj_header beginRefreshing];
    
    // 上拉刷新
    _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //        if(EnditMode == YES)
        //            return;
//        [weakSelf getCollectArticle];
        [_mainTableView.mj_footer endRefreshing];
    }];
}

#pragma mark - self property

-(NSMutableArray *)searchVideoArr
{
    if(_searchVideoArr == nil)
    {
        _searchVideoArr = [NSMutableArray array];
    }
    
    return _searchVideoArr;
}

#pragma mark  -  click action

-(void)videoDetailBtnClick:(UIButton *)sender
{
    VideoDetialSecondViewController *videoDetailViewCtl = [[VideoDetialSecondViewController alloc] init];
    videoDetailViewCtl.navtitle =@"视频";
    videoDetailViewCtl.videoID=[NSString stringWithFormat:@"%@" ,self.searchVideoArr[sender.tag][@"Id"]];
    [self.navigationController pushViewController:videoDetailViewCtl animated:YES];
}

-(void)searchBtnClick:(UIButton *)sender
{
    [mainCollectionView.mj_header beginRefreshing];
}

-(void)tapViewAction:(id)sender
{
    [self.view endEditing:YES];
}



//设置点在某个view时部触发事件
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"-%@", NSStringFromClass([touch.view class]));

    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]||[NSStringFromClass([touch.view class]) isEqualToString:@"UIButton"])
    {
        return NO;
    }
    //  NSLog(@"return YES");
    return  YES;
}


#pragma mark - textfield delegate

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    [mainCollectionView.mj_header beginRefreshing];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}



#pragma mark - self datasource

-(void)doSearchAction
{
    
    if(searchTxt.text.length == 0)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入搜索内容" maskType:SVProgressHUDMaskTypeBlack];
        
        [mainCollectionView.mj_header endRefreshing];
        [mainCollectionView.mj_footer endRefreshing];
        return;
    }
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"searchResultCallBack:"];
    
    switch (self.searchCate) {
        case StudyOnline_Search:
        {
            if(self.subIDs!=nil&&self.subIDs.count > 0)
            {
                [dataProvider getStudyOnlineVideoList:self.subIDs[0] andstartRowIndex:[NSString stringWithFormat:@"%d",pageNo*pageSize] andmaximumRows:[NSString stringWithFormat:@"%d",pageSize] andSearch:searchTxt.text];
            }
        }
            break;
            
        case NewsCate_Search:
        {
            [dataProvider GetNewVideoList:[NSString stringWithFormat:@"%d",pageNo*pageSize] andmaximumRows:[NSString stringWithFormat:@"%d",pageSize] andSearch:searchTxt.text];
        }
            break;
            
        case Hottest_Search:
        {
            [dataProvider GetHotVideoList:[NSString stringWithFormat:@"%d",pageNo*pageSize] andmaximumRows:[NSString stringWithFormat:@"%d",pageSize] andSearch:searchTxt.text];
        }
            break;
        case Suggest_Search:
        {
            [dataProvider GetTuiJianVideoList:[NSString stringWithFormat:@"%d",pageNo*pageSize] andmaximumRows:[NSString stringWithFormat:@"%d",pageSize] andSearch:searchTxt.text];
        }
            break;
        case YuanChuang_Search:
        {
            [dataProvider GetYuanChuangVideoList:[NSString stringWithFormat:@"%d",pageNo*pageSize] andmaximumRows:[NSString stringWithFormat:@"%d",pageSize] andSearch:searchTxt.text];
        }
            break;
        case Channel_Search:
        {
            if(self.subIDs!=nil&&self.subIDs.count > 0)
            {
                [dataProvider GetVideoByCategory:[NSString stringWithFormat:@"%d",pageNo*pageSize] andmaximumRows:[NSString stringWithFormat:@"%d",pageSize] andcateid:self.subIDs[0] andSearch:searchTxt.text];
            }
        }
            break;
        default:
            break;
    }
}

-(void)searchResultCallBack:(id)dict
{
    DLog(@"%@",dict);
    [SVProgressHUD dismiss];
    
    [mainCollectionView.mj_header endRefreshing];
    [mainCollectionView.mj_footer endRefreshing];
    
    [self.view endEditing:YES];
    if([dict[@"code"] intValue] == 200)
    {
        
        
        pageNo++;
        
        [self.searchVideoArr addObjectsFromArray:dict[@"data"]];
        
        if(self.searchVideoArr.count >= [dict[@"recordcount"] intValue])
        {
            [mainCollectionView.mj_footer setState:MJRefreshStateNoMoreData];
            
        }
    
        if(self.searchVideoArr.count > 0)
        {
            tipLab.hidden = YES;
        }
        else
        {
            tipLab.text = @"T_T什么都没找到";
            tipLab.hidden = NO;
        }
        
        [mainCollectionView reloadData];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"data"] delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alertView show];
    }
}


#pragma mark - UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数

-( NSInteger )collectionView:( UICollectionView *)collectionView numberOfItemsInSection:( NSInteger )section
{
    return self.searchVideoArr.count;
}

//定义展示的Section的个数

-( NSInteger )numberOfSectionsInCollectionView:( UICollectionView *)collectionView
{
    return 1 ;
}

//每个UICollectionView展示的内容

-( UICollectionViewCell *)collectionView:( UICollectionView *)collectionView cellForItemAtIndexPath:( NSIndexPath *)indexPath
{
    
    
    UINib *nib = [UINib nibWithNibName:@"BaseVideoCollectionViewCell"
                                bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"BaseVideoCell"];
    BaseVideoCollectionViewCell *cell = [[BaseVideoCollectionViewCell alloc]init];
    
    // Set up the reuse identifier
    cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"BaseVideoCell"
                                                     forIndexPath:indexPath];
    cell.backgroundColor = ItemsBaseColor;
    cell.select.hidden = YES;
    
    @try {
        
        NSDictionary *tempDict = self.searchVideoArr[indexPath.row];
        
        NSString *url = [NSString stringWithFormat:@"%@%@",Kimg_path,tempDict[@"ImagePath"]];
        
        [cell.img_logo sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"temp2"]];
        cell.lbl_title.text = tempDict[@"Title"];
        cell.lbl_content.text = tempDict[@"Content"];
        cell.date.text = [Toolkit GettitleForDate:tempDict[@"PublishTime"]];
        
        NSString *str = tempDict[@"IsFree"];
        
        if(str !=nil)
        {
            cell.free.hidden = [tempDict[@"IsFree"] intValue];
        }
        else
        {
            cell.free.hidden = YES;
        }
        cell.btn_thrid.hidden = YES;
        
        
        [cell.btn_first setTitle:[NSString stringWithFormat:@"%@",[tempDict[@"LikeNum"] isEqual:[NSNull null]]?@"":tempDict[@"LikeNum"]] forState:UIControlStateNormal];
        [cell.btn_first setImage:[UIImage imageNamed:@"support"] forState:(UIControlStateNormal)];
        
        [cell.btn_second setTitle:[NSString stringWithFormat:@"%@",[tempDict[@"FavoriteNum"] isEqual:[NSNull null]]?@"":tempDict[@"FavoriteNum"]] forState:UIControlStateNormal];
        [cell.btn_second setImage:[UIImage imageNamed:@"collect"] forState:(UIControlStateNormal)];
        
        
        UIButton *coverBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        coverBtn.tag = indexPath.row;
        [coverBtn addTarget:self action:@selector(videoDetailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:coverBtn];
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
    
    return cell;
}



#pragma mark - UICollectionViewDelegate

//UICollectionView被选中时调用的方法

-( void )collectionView:( UICollectionView *)collectionView didSelectItemAtIndexPath:( NSIndexPath *)indexPath
{
   
}

//返回这个UICollectionViewCell是否可以被选择

-( BOOL )collectionView:( UICollectionView *)collectionView shouldSelectItemAtIndexPath:( NSIndexPath *)indexPath
{
    return YES ;
}

#pragma mark - UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小

- ( CGSize )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath
{
    
    return CGSizeMake ( SCREEN_WIDTH/2-5 ,  SCREEN_WIDTH/2-5);
    
}

//定义每个UICollectionView 的边距

-( UIEdgeInsets )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section
{
    //if()
    
    return UIEdgeInsetsMake ( 0 , 0 , 10 , 1 );
    
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
