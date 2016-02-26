//
//  MyCollectViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/4.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "MyCollectViewController.h"
#import "model_collect.h"
#import "UIImageView+WebCache.h"
@interface MyCollectViewController ()
{
    NSArray *cateArr;
    NSMutableArray *btnArr;
    //For views
    NSInteger _cellCollectionCount;
    UICollectionView *mainCollectionView;
    
    NSInteger _cellTableCount;
    CGFloat _cellTableHeight;
    UITableView *_mainTableView;
    
    UITableView *_mainGoodsTableView;
    
    NSMutableArray *ArticleArr;
    NSArray *goodsArray;
    int curpage;
}

@property (nonatomic, strong) NSMutableArray * arr_voiceData;

@property (nonatomic, strong) NSMutableArray * arr_TitleData;

@property (nonatomic, assign) BOOL isDelete;

@property (nonatomic, strong) NSMutableArray * arr_deleteVoice;

@end

#define _CELL  @"acell"

@implementation MyCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"left"];
    [self addRightbuttontitle:@"删除"];
    self.view.backgroundColor = BACKGROUND_COLOR;
    pageSize = 10;
    pageVideoSize  = 10;
    ArticleArr = [NSMutableArray array];
    goodsArray = [[NSArray alloc] init];
    
    [self initDatas];
    [self initViews];
    [self getDatas];
    
    // Do any additional setup after loading the view.
}

#pragma mark - 解析数据
-(void)getDatas
{
    //[self getUserInfo];
    
//    [self getCollectArticle];
}

-(void)getCollectVideo
{
    [SVProgressHUD showWithStatus:@"刷新中" maskType:SVProgressHUDMaskTypeBlack];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"getCollectVideoCallBack:"];
//    [dataprovider collectData:[Toolkit getUserID] andIsVideo:@"true" andStartRowIndex:@"1" andMaximumRows:@"6"];
    [dataprovider setCollect:[Toolkit getUserID] andIsVideo:@"true" andStartRowIndex:[NSString stringWithFormat:@"%d",pageVideoNo*pageVideoSize] andMaximumRowst:[NSString stringWithFormat:@"%d",pageVideoSize]];
    
}

-(void)getCollectVideoCallBack:(id)dict
{
    
     [mainCollectionView.mj_header endRefreshing];
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try
        {
            pageVideoNo ++;
            NSLog(@"%@",dict[@"data"]);
            NSArray * arr_ = dict[@"data"];
            
            for (NSDictionary * dic in arr_) {
                model_collect * model = [[model_collect alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.arr_voiceData addObject:model];
            }
            if(self.arr_voiceData.count >= [dict[@"recordcount"] intValue])
            {
                [mainCollectionView.mj_footer setState:MJRefreshStateNoMoreData];
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
            [mainCollectionView reloadData];
            [SVProgressHUD dismiss];
            NSLog(@"完成");
        }
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"data"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        
    }
}

-(void)getCollectArticle
{
    [SVProgressHUD showWithStatus:@"刷新中" maskType:SVProgressHUDMaskTypeBlack];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"getCollectArticleCallBack:"];
    //    [dataprovider collectData:[Toolkit getUserID] andIsVideo:@"true" andStartRowIndex:@"1" andMaximumRows:@"6"];
    [dataprovider setCollect:[Toolkit getUserID] andIsVideo:@"false" andStartRowIndex:[NSString stringWithFormat:@"%d",pageSize*pageNo] andMaximumRowst:[NSString stringWithFormat:@"%d",pageSize]];
}

-(void)getCollectArticleCallBack:(id)dict
{
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try
        {
            pageNo++;
      
            
            [ArticleArr addObjectsFromArray:dict[@"data"]];
           
            if(ArticleArr.count>=[dict[@"recordcount"] intValue])
            {
                [_mainTableView.mj_footer setState:MJRefreshStateNoMoreData];
            }
            [_mainTableView reloadData];
       
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
            [_mainTableView reloadData];
            [SVProgressHUD dismiss];
            NSLog(@"完成");
        }
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"data"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        
    }
}


-(void)delArticleCallBack:(id)dict
{
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try
        {

            [_mainTableView.mj_header beginRefreshing];
        }
        @catch (NSException *exception) {
            
        }
        @finally {

        }
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"data"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        
    }
}


-(void)GetVideoDetial:(NSString *)videoId
{
    [SVProgressHUD showWithStatus:@"加载..." maskType:SVProgressHUDMaskTypeBlack];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetVideoDetialCallBack:"];
    [dataprovider getStudyOnlineVideoDetial:videoId andUserId:[Toolkit getUserID]];
}
-(void)GetVideoDetialCallBack:(id)dict
{
    [SVProgressHUD dismiss];
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
//       if(!([dict[@"data"][@"UserId"] intValue] == 0))
//       {
//           VideoDetailViewController *viewDetailViewCtl = [[VideoDetailViewController alloc] init];
//           viewDetailViewCtl.videoID = [NSString stringWithFormat:@"%@",videoId];
//           [self.navigationController pushViewController:viewDetailViewCtl animated:YES];
//       }
//       else
//       {
           VideoDetialSecondViewController *viewDetailViewCtl = [[VideoDetialSecondViewController alloc] init];
           viewDetailViewCtl.videoID = [NSString stringWithFormat:@"%@",videoId];
           [self.navigationController pushViewController:viewDetailViewCtl animated:YES];
//       }
    }
}



#pragma mark ----------------

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

-(void)initDatas
{

    
    cateArr = @[@"视频",
        #if COLLECT_GOODS
                @"商品",
        #endif
                @"文章"];

    btnArr  = [NSMutableArray array];
    EditMode = NO;
    _cellCollectionCount = self.arr_voiceData.count;
}

-(void)initViews
{
    for (int i = 0;i< cateArr.count; i++) {
        UIButton *cateBtn = [[UIButton alloc] initWithFrame:CGRectMake(0 + i*(SCREEN_WIDTH/cateArr.count), Header_Height + 10,(SCREEN_WIDTH/cateArr.count) , 60)];
        
        if(i != cateArr.count -1)
        {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/cateArr.count)-1, 5, 1, cateBtn.frame.size.height - 5*2)];
            lineView.backgroundColor = BACKGROUND_COLOR;
            [cateBtn addSubview:lineView];
        }
        if(i==0)
            cateBtn.selected = YES;
        
        [cateBtn setTitle:cateArr[i] forState:UIControlStateNormal];
        cateBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        cateBtn.backgroundColor = ItemsBaseColor;
        [cateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cateBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        cateBtn.tag = i;
        
        [cateBtn addTarget:self action:@selector(cateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:cateBtn];
        [btnArr addObject:cateBtn];
    }
    
    [self initCollectionView];
    [self initTableView];
    
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
    
    
    
    mainCollectionView = [[UICollectionView alloc]  initWithFrame:CGRectMake(0, Header_Height + 10 +60+10, SCREEN_WIDTH , SCREEN_HEIGHT-( Header_Height + 10 +60+10)) collectionViewLayout:layout];
    
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
        pageVideoNo=0;
        if(self.arr_voiceData !=nil)
            [self.arr_voiceData removeAllObjects];
        [weakSelf getCollectVideo];
        // 结束刷新
        if(mainCollectionView.mj_footer !=nil)
        {
            [mainCollectionView.mj_footer setState:MJRefreshStateIdle];
        }
        
       
    }];
    [mainCollectionView.mj_header beginRefreshing];
    
    // 上拉刷新
    mainCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf getCollectVideo];
        [mainCollectionView.mj_footer endRefreshing];
    }];
    
    
    
    // 默认先隐藏footer
    mainCollectionView.mj_footer.hidden = YES;
    
    
    [self.view addSubview:mainCollectionView];
}


-(void)initTableView
{
    _cellTableHeight = 90;
    _cellTableCount = 10;
    
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height + 10 +60+10, SCREEN_WIDTH, SCREEN_HEIGHT-( Header_Height + 10 +60+10))];
    _mainTableView.backgroundColor = BACKGROUND_COLOR;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorColor =  Separator_Color;
    _mainTableView.tableFooterView = [[UIView alloc] init];
    //_mainTableView.scrollEnabled = NO;
    _mainTableView.tag = ArticleTag;
    _mainTableView.contentSize = CGSizeMake(SCREEN_HEIGHT, _cellTableCount*(_cellTableHeight)+60);
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    _mainTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //        if(EnditMode == YES)
        //            return ;
        pageNo=0;
        
        if(ArticleArr !=nil&&ArticleArr.count > 0)
        {
            [ArticleArr removeAllObjects];
        }
        if( _mainTableView.mj_footer!=nil)
        {
            [_mainTableView.mj_footer setState:MJRefreshStateIdle];
        }
        [weakSelf getCollectArticle];
        // 结束刷新
        [_mainTableView.mj_header endRefreshing];
    }];
    [_mainTableView.mj_header beginRefreshing];
    
    // 上拉刷新
    _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //        if(EnditMode == YES)
        //            return;
        [weakSelf getCollectArticle];
        [_mainTableView.mj_footer endRefreshing];
    }];
    
    
    _mainGoodsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height + 10 +60+10, SCREEN_WIDTH, SCREEN_HEIGHT-( Header_Height + 10 +60+10))];
    _mainGoodsTableView.backgroundColor = BACKGROUND_COLOR;
    _mainGoodsTableView.tag = GoodsTag;
    _mainGoodsTableView.delegate = self;
    _mainGoodsTableView.dataSource = self;
    _mainGoodsTableView.separatorColor =  Separator_Color;
    _mainGoodsTableView.tableFooterView = [[UIView alloc] init];
    //_mainTableView.scrollEnabled = NO;
    
    _mainGoodsTableView.contentSize = CGSizeMake(SCREEN_HEIGHT, _cellTableCount*(_cellTableHeight)+60);
    
    
    _mainGoodsTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        pageNo=0;
        
        if(ArticleArr !=nil&&ArticleArr.count > 0)
        {
            [ArticleArr removeAllObjects];
        }
        if( _mainGoodsTableView.mj_footer!=nil)
        {
            [_mainGoodsTableView.mj_footer setState:MJRefreshStateIdle];
        }
        [weakSelf getGoodsData];
        // 结束刷新
        [_mainGoodsTableView.mj_header endRefreshing];
    }];
    [_mainGoodsTableView.mj_header beginRefreshing];
    
    // 上拉刷新
    _mainGoodsTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{

//        [weakSelf getCollectArticle];
        [_mainGoodsTableView.mj_footer endRefreshing];
    }];
    //[self.view addSubview:_mainTableView];
}

-(void)getGoodsData{
    
    [_mainGoodsTableView.mj_footer setState:MJRefreshStateIdle];
    curpage = 0;
    goodsArray = [[NSArray alloc] init];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getGoodsDataCallBack:"];
    [dataProvider SelectFavoriteByUserIdAndSearch:@"0" andmaximumRows:@"10" anduserId:get_sp(@"id") andsearch:@""];
}

-(void)getGoodsDataCallBack:(id)dict{
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue] == 200) {
        goodsArray = dict[@"data"];
        

        if(goodsArray.count>=[dict[@"recordcount"] intValue])
        {
            [_mainGoodsTableView.mj_footer setState:MJRefreshStateNoMoreData];
        }

        [_mainGoodsTableView reloadData];
    }
}

-(void)TeamFootRefresh{
    curpage++;
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getShopListFootCallBack:"];
    [dataProvider SelectFavoriteByUserIdAndSearch:[NSString stringWithFormat:@"%d",curpage * 10] andmaximumRows:@"10" anduserId:get_sp(@"id") andsearch:@""];
}

-(void)getShopListFootCallBack:(id)dict{
    // 结束刷新
    [_mainTableView.mj_footer endRefreshing];
    NSMutableArray *itemarray=[[NSMutableArray alloc] initWithArray:goodsArray];
    if ([dict[@"code"] intValue] == 200) {
        NSArray * arrayitem=[[NSArray alloc] init];
        arrayitem=dict[@"data"];
        for (id item in arrayitem) {
            [itemarray addObject:item];
        }
        goodsArray=[[NSArray alloc] initWithArray:itemarray];
        
        
        if(goodsArray.count>=[dict[@"recordcount"] intValue])
        {
            [_mainGoodsTableView.mj_footer setState:MJRefreshStateNoMoreData];
        }
    }
    [_mainTableView reloadData];
}

#pragma mark - btn Click

-(void)clickRightButton:(UIButton *)sender
{
    
    if(mode == CollectionViewMode)
    {
        if(self.isDelete == 0)
        {
            [self addRightbuttontitle:@"确定"];
            self.isDelete = 1;
            EditMode = YES;
            
            [mainCollectionView reloadData];
//            for (int i = 0 ; i < self.arr_voiceData.count; i ++) {
//                UIButton * btn_select = [mainCollectionView viewWithTag:(i + 1) * 1000];
//                btn_select.hidden = NO;
//                btn_select.selected = NO;
//            }
        }
        else
        {
            if(self.arr_deleteVoice.count==0)
            {
                [self addRightbuttontitle:@"删除"];
                self.isDelete = 0;
                EditMode = NO;
                
                [mainCollectionView reloadData];
//                for (int i = 0 ; i < self.arr_voiceData.count; i ++) {
//                    UIButton * btn_select = [mainCollectionView viewWithTag:(i + 1) * 1000];
//                    btn_select.hidden = YES;
//                }
                return;
            }
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认删除？" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
            alertView.tag = 2016+0;
            [alertView show];
            NSLog(@"%ld",(unsigned long)self.arr_voiceData.count);
            
        }
    }
    else
    {
    
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0&&alertView.tag == 2016+0)//确认
    {
//        [self addRightbuttontitle:@"删除"];
//        self.isDelete = 0;
        for (int i = 0 ; i < self.arr_voiceData.count; i ++) {
            UIButton * btn_select = [mainCollectionView viewWithTag:(i + 1) * 1000];
            btn_select.hidden = YES;
        }
        

        for (int i = 0 ; i < self.arr_voiceData.count; i ++) {
            UIButton * btn_select = [mainCollectionView viewWithTag:(i + 1) * 1000];
            btn_select.hidden = YES;
        }
        delcount = 0;
//        
//        NSString *str =self.arr_deleteVoice[delcount];
//        model_collect * model = [self.arr_voiceData objectAtIndex:[str integerValue]];
        [SVProgressHUD showWithStatus:@"删除中"];
        
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider voicedelete:self.arr_deleteVoice[delcount]
                        andUserId:[Toolkit getUserID]
                           andFlg:@"1"];
        [dataprovider setDelegateObject:self setBackFunctionName:@"delCollectionCallBack:"];
            

    }
    else if(buttonIndex == 0)
    {
        DataProvider * dataprovider=[[DataProvider alloc] init];
        if (alertView.tag == 2016 + 1) {
            [dataprovider voicedelete:ArticleArr[alertView.tag - 2016-1][@"MessageId"] andUserId:[Toolkit getUserID] andFlg:@"1"];
            [dataprovider setDelegateObject:self setBackFunctionName:@"delArticleCallBack:"];
        }else{
            [dataprovider setDelegateObject:self setBackFunctionName:@"CancelCollectionCallBack:"];
            [dataprovider CancleFavoriteProduct:get_sp(@"id") andproductId:[goodsArray[alertView.tag - 2016 - 2] valueForKey:@"ProductId"]];
        }
    }
}

-(void)CancelCollectionCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        [_mainGoodsTableView.mj_header beginRefreshing];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"data"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alertView show];
    }
}

- (void)delCollectionCallBack:(id)dict
{
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        
        @try
        {
            delcount++;
//            if(self.arr_deleteVoice.count == 1)
//            {
//                
//            }
//            else
//            {
//                
//                for(int i = 0; i < self.arr_deleteVoice.count ; i ++)
//                {
//                    for (int j = 0; j < self.arr_deleteVoice.count - 1 - i; j ++)
//                    {
//                        if([self.arr_deleteVoice[j] integerValue] < [self.arr_deleteVoice[j + 1] integerValue])
//                        {
//                            [self.arr_deleteVoice exchangeObjectAtIndex:j withObjectAtIndex:j+1];
//                        }
//                    }
//                }
//            }
//            
 
            
            
            if(delcount >=self.arr_deleteVoice.count)
            {
//                for (NSString * str in self.arr_deleteVoice) {
////                    [self.arr_voiceData removeObjectAtIndex:[str integerValue]];
//                    [mainCollectionView reloadData];
//                    [mainCollectionView.mj_header beginRefreshing];
//                }
                
                [SVProgressHUD showSuccessWithStatus:@"删除完成"];
                [mainCollectionView.mj_header beginRefreshing];
                self.arr_deleteVoice = nil;
//                [mainCollectionView reloadData];
            }
            else
            {
//                NSString *str =self.arr_deleteVoice[delcount];
//                model_collect * model = [self.arr_voiceData objectAtIndex:[str integerValue]];
                
                DataProvider * dataprovider=[[DataProvider alloc] init];
                [dataprovider voicedelete:self.arr_deleteVoice[delcount]
                                andUserId:[Toolkit getUserID]
                                   andFlg:@"1"];
                [dataprovider setDelegateObject:self setBackFunctionName:@"delCollectionCallBack:"];

            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
//            [_mainTableView reloadData];
//            [SVProgressHUD dismiss];
            NSLog(@"完成");
        }
    }
    else
    {
        
        [SVProgressHUD showSuccessWithStatus:dict[@"data"]];
//        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"data"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
//        [alert show];
        
    }

}

-(void)cateBtnClick:(UIButton *)sender
{
    sender.selected = YES;
    
    if( [sender.titleLabel.text isEqualToString:@"视频"])
    {
        if(_mainTableView.superview != nil)
        {
            [_mainTableView removeFromSuperview];
        }
        
        if(_mainGoodsTableView.superview != nil)
        {
            [_mainTableView removeFromSuperview];
        }
        
        if(mainCollectionView.superview == nil)
        {
            [self.view addSubview:mainCollectionView];
        }
        _lblRight.hidden = NO;
        mode = CollectionViewMode;
    }
    else if([sender.titleLabel.text isEqualToString:@"文章"])
    {
        mode = TableViewMode;
        if(mainCollectionView.superview != nil)
        {
            [mainCollectionView removeFromSuperview];
            
        }

        if(_mainGoodsTableView.superview != nil)
        {
            [_mainGoodsTableView removeFromSuperview];
        }
        
        if(_mainTableView.superview == nil)
        {
            [self.view addSubview:_mainTableView];
        }
        
        _lblRight.hidden = YES;
    }
    else if([sender.titleLabel.text isEqualToString:@"商品"])
    {
        mode = TableViewMode;
        if(mainCollectionView.superview != nil)
        {
            [mainCollectionView removeFromSuperview];
            
        }
        
        if(_mainTableView.superview != nil)
        {
            [_mainTableView removeFromSuperview];
        }
        
        if(_mainGoodsTableView.superview == nil)
        {
            [self.view addSubview:_mainGoodsTableView];
        }
        
        _lblRight.hidden = YES;
    }
    
    for(int i =0;i<btnArr.count;i++)
    {
        if(i != sender.tag)
        {
            ((UIButton *)btnArr[i]).selected = NO;
        }
    }
}

#pragma mark - btn_1 btn_2
- (void)btn_1Action:(UIButton *)sender
{
//    model_collect * model = self.arr_TitleData[sender.tag / 100];
    NSDictionary *tempDict = ArticleArr[sender.tag/100];
    
    if (sender.selected == 0)
    {
        sender.selected = 1;
        [sender setImage:[UIImage imageNamed:@"support_h"] forState:(UIControlStateNormal)];
        
        int x = [tempDict[@"LikeNum"] intValue] + 1;
        //model.LikeNum = [NSString stringWithFormat:@"%d",x];
        [sender setTitle:[NSString stringWithFormat:@"%d",x]forState:(UIControlStateNormal)];
        
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider voiceAction:tempDict[@"MessageId"] andUserId:[Toolkit getUserID] andFlg:@"2" andDescription:nil];
        
    }
    else
    {
        sender.selected = 0;
        [sender setImage:[UIImage imageNamed:@"support"] forState:(UIControlStateNormal)];
        
        int x = [tempDict[@"LikeNum"] intValue] - 1;
//        model.LikeNum = [NSString stringWithFormat:@"%d",x];
        [sender setTitle:[NSString stringWithFormat:@"%d",x] forState:(UIControlStateNormal)];
        
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider voicedelete:tempDict[@"MessageId"] andUserId:[Toolkit getUserID] andFlg:@"2"];
    }
}

- (void)collectBtnClick:(UIButton *)sender
{
    NSDictionary *tempDict = ArticleArr[sender.tag/100];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"MakeActionCallBack:"];
    
    if (sender.selected == 0)
    {
        sender.selected = 1;
        [sender setImage:[UIImage imageNamed:@"collect_h"] forState:(UIControlStateNormal)];
        
        int x = [sender.titleLabel.text intValue] + 1;

        [sender setTitle:[NSString stringWithFormat:@"%d",x] forState:(UIControlStateNormal)];
        [sender setTitle:[NSString stringWithFormat:@"%d",x] forState:(UIControlStateSelected)];
        
        
        [dataprovider voiceAction:[NSString stringWithFormat:@"%@",ArticleArr[sender.tag][@"MessageId"]] andUserId:[Toolkit getUserID] andFlg:@"1" andDescription:nil];
    }
    else
    {
        sender.selected = 0;
        [sender setImage:[UIImage imageNamed:@"collect"] forState:(UIControlStateNormal)];
        
        int x =  [sender.titleLabel.text intValue];
        
        if(x>0)
        {
            x--;
        }
        else
        {
            x=0;
        }

        [sender setTitle:[NSString stringWithFormat:@"%d",x] forState:(UIControlStateNormal)];
        [sender setTitle:[NSString stringWithFormat:@"%d",x] forState:(UIControlStateSelected)];
        [dataprovider voicedelete:[NSString stringWithFormat:@"%@",ArticleArr[sender.tag][@"MessageId"]] andUserId:[Toolkit getUserID] andFlg:@"1"];
    }
}

-(void)MakeActionCallBack:(id)dict
{
    if ([dict[@"code"] intValue]==200) {
        [SVProgressHUD showSuccessWithStatus:@"操作成功" maskType:SVProgressHUDMaskTypeBlack];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"操作失败" maskType:SVProgressHUDMaskTypeBlack];
    }
}

- (void)btn_firstAction:(UIButton *)sender
{
    
    model_collect * model = self.arr_voiceData[sender.tag / 10];
    
    if (sender.selected == 0)
    {
        sender.selected = 1;
        [sender setImage:[UIImage imageNamed:@"support_h"] forState:(UIControlStateNormal)];
        
        int x = [model.LikeNum intValue] + 1;
        model.LikeNum = [NSString stringWithFormat:@"%d",x];
        [sender setTitle:model.LikeNum forState:(UIControlStateNormal)];
        
        
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider voiceAction:model.MessageId andUserId:model.UserId andFlg:@"2" andDescription:nil];
        [dataprovider setDelegateObject:self setBackFunctionName:@"actionCallBack:"];

    }
    else
    {
        sender.selected = 0;
        [sender setImage:[UIImage imageNamed:@"support"] forState:(UIControlStateNormal)];
        int x = [model.LikeNum intValue] - 1;
        model.LikeNum = [NSString stringWithFormat:@"%d",x];
        [sender setTitle:model.LikeNum forState:(UIControlStateNormal)];
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider voicedelete:model.MessageId andUserId:model.UserId andFlg:@"2"];
        [dataprovider setDelegateObject:self setBackFunctionName:@"actionCallBack:"];
    }
    
//    [mainCollectionView reloadData];
}

-(void)actionCallBack:(id)dict
{
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try
        {
            pageNo++;
            if(ArticleArr !=nil&&ArticleArr.count > 0)
            {
                [ArticleArr removeAllObjects];
            }
            
            [ArticleArr addObjectsFromArray:dict[@"data"]];
            
            [_mainTableView reloadData];
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
            [_mainTableView reloadData];
            [SVProgressHUD dismiss];
            NSLog(@"完成");
        }
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"data"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        
    }
}


- (void)btn_secondAction:(UIButton *)sender
{
    
    model_collect * model = self.arr_voiceData[sender.tag / 10];
    
    if (sender.selected == 0)
    {
        sender.selected = 1;
        [sender setImage:[UIImage imageNamed:@"collect_h"] forState:(UIControlStateNormal)];
        
        int x = [model.FavoriteNum intValue] + 1;
        model.FavoriteNum = [NSString stringWithFormat:@"%d",x];
        [sender setTitle:model.FavoriteNum forState:(UIControlStateNormal)];
        
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider voiceAction:model.MessageId andUserId:model.UserId andFlg:@"1" andDescription:nil];
    }
    else
    {
        sender.selected = 0;
        [sender setImage:[UIImage imageNamed:@"collect"] forState:(UIControlStateNormal)];
        
        int x = [model.FavoriteNum intValue] - 1;
        model.FavoriteNum = [NSString stringWithFormat:@"%d",x];
        [sender setTitle:model.FavoriteNum forState:(UIControlStateNormal)];

        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider voicedelete:model.MessageId andUserId:model.UserId andFlg:@"1"];
        
    }
    
//    [mainCollectionView reloadData];
}

//
- (void)btn_thridAction:(UIButton *)sender
{
    model_collect * model = self.arr_voiceData[sender.tag / 10];
    
    if (sender.selected == 0)
    {
        sender.selected = 1;
        
        int x = [model.RepeatNum intValue] + 1;
        model.RepeatNum = [NSString stringWithFormat:@"%d",x];
        [sender setTitle:model.RepeatNum forState:(UIControlStateNormal)];
        
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider voiceAction:model.MessageId andUserId:model.UserId andFlg:@"0" andDescription:nil];
    }
    else
    {
        sender.selected = 0;
        
        int x = [model.RepeatNum intValue] - 1;
        model.RepeatNum = [NSString stringWithFormat:@"%d",x];
        [sender setTitle:model.RepeatNum forState:(UIControlStateNormal)];
        
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider voicedelete:model.MessageId andUserId:model.UserId andFlg:@"0"];
    }
}
//
- (void)cell_selectAction:(UIButton *)sender
{
    if (sender.selected == NO)
    {
        sender.selected = 1;
        [sender setImage:[UIImage imageNamed:@"selectRound"] forState:(UIControlStateNormal)];
        
        long x = sender.tag / 1000 - 1;
        model_collect * model = self.arr_voiceData[x];
//        NSString * str = [NSString stringWithFormat:@"%ld",x];
        
        [self.arr_deleteVoice addObject:model.MessageId];
        
//        NSLog(@"%ld",self.arr_deleteVoice.count);
        
        
    }
    else
    {
        sender.selected = 0;
        [sender setImage:[UIImage imageNamed:@"point"] forState:(UIControlStateNormal)];
        
        long x = sender.tag / 1000 - 1;

        for(int i = 0 ; i < self.arr_deleteVoice.count ; i ++)
        {
            if([self.arr_deleteVoice[i] isEqualToString:[NSString stringWithFormat:@"%ld",x]])
            {
                [self.arr_deleteVoice removeObjectAtIndex:i];
                break;
            }
        }
        
//        NSLog(@"%ld",self.arr_deleteVoice.count);

        
    }
}

#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag == ArticleTag) {
       return ArticleArr.count;
    }
    else if (tableView.tag == GoodsTag)
    {
        return goodsArray.count;
    }
    else
    {
        return 0;
    }
    
}

#pragma mark - setting for cell
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellTableHeight)];
    cell.backgroundColor = ItemsBaseColor;
    
    if(tableView.tag == ArticleTag)
    {
    
//        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellTableHeight)];
//        cell.backgroundColor = ItemsBaseColor;
        
        if(ArticleArr == nil || ArticleArr.count == 0 || ArticleArr.count  - 1 < indexPath.row)
        {
            return cell;
        }
        
        @try {
            NSDictionary * tempDict = ArticleArr[indexPath.row];
            
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, _cellTableHeight,_cellTableHeight -20 )];
            [cell.contentView addSubview:imgView];
            NSString * url=[NSString stringWithFormat:@"%@%@",Kimg_path,tempDict[@"ImagePath"]];
            [imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"jhstory"]];
            
            
            UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 80), 5,60 , 20)];
            [cell.contentView addSubview:timeLab];
            timeLab.font = [UIFont systemFontOfSize:14];
            timeLab.textColor = [UIColor whiteColor];
            timeLab.textAlignment = NSTextAlignmentRight;
            NSRange x = NSMakeRange(5, 5);

            timeLab.text = [tempDict[@"OperateTime"] substringWithRange:x];

            UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake((imgView.frame.origin.x + imgView.frame.size.width+10),
                                                                          5, (timeLab.frame.origin.x - (imgView.frame.origin.x + imgView.frame.size.width+10)), 20)];
            
            [cell.contentView addSubview:titleLab];
            titleLab.textColor = [UIColor whiteColor];
            titleLab.font = [UIFont systemFontOfSize:14];
            titleLab.text = tempDict[@"Title"];
            
            
            UILabel *contentLab = [[UILabel alloc] initWithFrame:CGRectMake(titleLab.frame.origin.x,
                                                                           (titleLab.frame.origin.y+titleLab.frame.size.height),
                                                                            (SCREEN_WIDTH - titleLab.frame.origin.x), _cellTableHeight- 20 -10 -20)];
            [cell.contentView addSubview:contentLab];
            
            contentLab.text = tempDict[@"Content"];
            contentLab.textColor = [UIColor whiteColor];
            contentLab.numberOfLines = 0;
            contentLab.font = [UIFont systemFontOfSize:14];
            
            UIButton *collectBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 80),
                                                                              (contentLab.frame.origin.y+contentLab.frame.size.height), 60, 20)];
            [collectBtn setImage:[UIImage imageNamed:@"collect_h"] forState:UIControlStateNormal];
            collectBtn.selected = YES;
            [collectBtn addTarget:self action:@selector(collectBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
            [cell.contentView addSubview:collectBtn];
            [collectBtn setTitle:[NSString stringWithFormat:@"%@",tempDict[@"FavoriteNum"]] forState:(UIControlStateNormal)];
            collectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            collectBtn.tag = indexPath.row;
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            return cell;

        }
        
    }
    else if (tableView.tag == GoodsTag)
    {
        NSLog(@"%@",goodsArray);
        NSString *CellIdentifier = @"ShopCellIdentifier";
        
        ShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ShopTableViewCell" owner:self options:nil] objectAtIndex:0];
            cell.backgroundColor = ItemsBaseColor;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSString *url = [NSString stringWithFormat:@"%@%@",Url,[Toolkit judgeIsNull:[goodsArray[indexPath.row] valueForKey:@"MiddleImagePath"]]];
        [cell.mImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"KongFuStoreProduct"]];
        cell.mName.text = [Toolkit judgeIsNull:[goodsArray[indexPath.row] valueForKey:@"ProductName"]];
        cell.mPrice.text = [NSString stringWithFormat:@"¥%@",[Toolkit judgeIsNull:[goodsArray[indexPath.row] valueForKey:@"Price"]]];
        cell.watchNum.text = [NSString stringWithFormat:@"%@人",[Toolkit judgeIsNull:[goodsArray[indexPath.row] valueForKey:@"VisitNum"]]];
        cell.salesNum.text = [NSString stringWithFormat:@"销量:%@",[Toolkit judgeIsNull:[goodsArray[indexPath.row] valueForKey:@"SaleNum"]]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }

    return cell;

}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView.tag == GoodsTag)
        return 70;
    
    return _cellTableHeight ;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    NSLog(@"click cell section : %ld row : %ld",(long)indexPath.section,(long)indexPath.row);
    
    if (tableView.tag == ArticleTag) {
        UnionNewsDetailViewController *unionNewsDetailViewCtl = [[UnionNewsDetailViewController alloc] init];
        unionNewsDetailViewCtl.navtitle = [NSString stringWithFormat:@"%@", ArticleArr[indexPath.row][@"MessageCame"]];
        unionNewsDetailViewCtl.webId = [NSString stringWithFormat:@"%@", ArticleArr[indexPath.row][@"MessageId"]];
        unionNewsDetailViewCtl.collectNum =[NSString stringWithFormat:@"%@", ArticleArr[indexPath.row][@"FavoriteNum"]];
        unionNewsDetailViewCtl.isFavorite = [NSString stringWithFormat:@"%@", ArticleArr[indexPath.row][@"IsFavorite"]];
        [self.navigationController pushViewController:unionNewsDetailViewCtl animated:YES];
    }
    
    if(tableView.tag == GoodsTag)
    {
        ShopDetailViewController *shopDetailViewCtl = [[ShopDetailViewController alloc] init];
        shopDetailViewCtl.goodsId = [goodsArray[indexPath.row] valueForKey:@"ProductId"];
        [self.navigationController pushViewController:shopDetailViewCtl animated:YES];
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
    
    return YES;
}

- (UITableViewCellEditingStyle)tableView: (UITableView *)tableView editingStyleForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//
//        [self.arr_TitleData removeObject:self.arr_TitleData[indexPath.row]];
//        //删除多行,单行UI,刷新数据
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationLeft)];
//        //            [tableView reloadData];
//
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否删除？" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
    if(tableView == _mainGoodsTableView){
        alertView.tag = 2016 + 2 + indexPath.row;
    }else{
        alertView.tag = 2016 + 1 + indexPath.row;
    }
    [alertView show];
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
    return 0;
}

//设置section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
    
}


#pragma mark - UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数

-( NSInteger )collectionView:( UICollectionView *)collectionView numberOfItemsInSection:( NSInteger )section
{
    

    return self.arr_voiceData.count;
    
    
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
    
    model_collect * model = self.arr_voiceData[indexPath.row];
    
    cell.lbl_title.text = model.Title;
    cell.lbl_content.text = model.Content;
//    cell.img_logo.image = [UIImage imageNamed:model.ImagePath];
    NSString * url=[NSString stringWithFormat:@"%@%@",Kimg_path,model.ImagePath];
    [cell.img_logo sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"temp2"]];
    
    NSRange x = NSMakeRange(5, 5);
//    [model.OperateTime substringWithRange:x];
    cell.date.text = [model.OperateTime substringWithRange:x];
    
    [cell.img_logo sd_setImageWithURL:[NSURL URLWithString:url]];
    
    
    NSString * str_free = [NSString stringWithFormat:@"%@",model.IsFree];
    if([str_free isEqualToString:@"1"])
    {
        cell.free.hidden = YES;
    }
    else
    {
        cell.free.hidden = NO;
        cell.btn_thrid.hidden = YES;
    }
//    cell.select.layer.cornerRadius = 8;
//    cell.select.backgroundColor = [UIColor orangeColor];
    
    
    cell.select.tag = (indexPath.item + 1) * 1000;
    [cell.select addTarget:self action:@selector(cell_selectAction:) forControlEvents:(UIControlEventTouchUpInside)];

    if(EditMode == YES)
    {
        cell.select.hidden = NO;
    }
    else
    {
        cell.select.hidden = YES;
    }
    
    [cell.btn_first setTitle:[NSString stringWithFormat:@"%@",model.LikeNum] forState:(UIControlStateNormal)];
    [cell.btn_first setImage:[UIImage imageNamed:@"support"] forState:(UIControlStateNormal)];
    [cell.btn_first addTarget:self action:@selector(btn_firstAction:) forControlEvents:(UIControlEventTouchUpInside)];
    cell.btn_first.tag = indexPath.item * 10;
    
    NSString * str_IsLike = [NSString stringWithFormat:@"%@",model.IsLike];
    if([str_IsLike isEqualToString:@"1"])
    {
        [cell.btn_first setSelected:YES];
        [cell.btn_first setImage:[UIImage imageNamed:@"support_h"] forState:(UIControlStateNormal)];
    }
    else
    {
        [cell.btn_first setSelected:NO];
        [cell.btn_first setImage:[UIImage imageNamed:@"support"] forState:(UIControlStateNormal)];
    }
    
    
    
    
    [cell.btn_second setTitle:[NSString stringWithFormat:@"%@",model.FavoriteNum] forState:(UIControlStateNormal)];
    [cell.btn_second setImage:[UIImage imageNamed:@"collect_h"] forState:(UIControlStateNormal)];
    [cell.btn_second addTarget:self action:@selector(btn_secondAction:) forControlEvents:(UIControlEventTouchUpInside)];
    cell.btn_second.tag = indexPath.item * 10;
    cell.btn_second.userInteractionEnabled = NO;
    
    [cell.btn_thrid setTitle:[NSString stringWithFormat:@"%@",model.RepeatNum] forState:(UIControlStateNormal)];
    [cell.btn_thrid setImage:[UIImage imageNamed:@"relay"] forState:(UIControlStateNormal)];
    [cell.btn_thrid addTarget:self action:@selector(btn_thridAction:) forControlEvents:(UIControlEventTouchUpInside)];
    cell.btn_thrid.tag = indexPath.item * 10;
//    cell.btn_thrid.enabled = NO;
    
    
    return cell;
}



#pragma mark - UICollectionViewDelegate

//UICollectionView被选中时调用的方法

-( void )collectionView:( UICollectionView *)collectionView didSelectItemAtIndexPath:( NSIndexPath *)indexPath
{
    if(self.isDelete ==1)
        return;
    
    model_collect * model = self.arr_voiceData[indexPath.item];
//    NSLog(@"%@",model.MessageId);
    videoId = [NSString stringWithFormat:@"%@", model.MessageId];
//    VideoDetailViewController *viewDetailViewCtl = [[VideoDetailViewController alloc] init];
//    viewDetailViewCtl.videoID = [NSString stringWithFormat:@"%@", model.MessageId];
//    [self.navigationController pushViewController:viewDetailViewCtl animated:YES];
//    

    
    [self GetVideoDetial:[NSString stringWithFormat:@"%@", model.MessageId]];
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

#pragma mark - 懒加载
- (NSMutableArray *)arr_voiceData
{
    if(_arr_voiceData == nil)
    {
        self.arr_voiceData = [NSMutableArray array];
    }
    return _arr_voiceData;
}

- (NSMutableArray *)arr_TitleData
{
    if(_arr_TitleData == nil)
    {
        self.arr_TitleData = [NSMutableArray array];
    }
    return _arr_TitleData;
}

- (NSMutableArray *)arr_deleteVoice
{
    if(_arr_deleteVoice == nil)
    {
        self.arr_deleteVoice = [NSMutableArray array];
    }
    return _arr_deleteVoice;
}


@end
