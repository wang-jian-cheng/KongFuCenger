//
//  ShopDetailViewController.m
//  KongFuCenter
//
//  Created by Rain on 16/1/20.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "ShopDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "UserHeadView.h"
#import "SDCycleScrollView.h"
#import "PayOrderViewController.h"
#import "ShoppingCart/ShoppingCartViewController.h"
#import "VOTagList.h"
#import "YMShowImageView.h"
#import "WZLBadgeImport.h"
#import "UIView+Frame.h"

@interface ShopDetailViewController ()<SDCycleScrollViewDelegate>{
    UITableView *mTableView;
    UIButton *bg_view;
    UIView *mView;
    NSString *selectColorId;
    NSString *selectColor;
    NSString *selectSizeId;
    NSString *selectSize;
    NSString *selectSpec;
    DataProvider *dataProvider;
    NSDictionary *goodsInfoDict;
    NSArray *commentListArray;
    UILabel *mSelectSpecLbl;
    UILabel *mPriceLbl;
    UIImageView *mHeadIv;
    NSString *isFavorite;
    UIImageView *collectionIv;
    UILabel *collectionLbl;
    NSString *selectPriceId;
    NSString *selectPrice;
    int curpage;
    UILabel *goodsNum;
    UILabel *mName;
    NSString *selectImage;
    VOTagList *tagList1;
    VOTagList *tagList;
    int storeNum;
    int selectColorIndex;
    int selectSizeIndex;
    NSMutableArray *currentColorArray;
    NSMutableArray *currentSizeArray;
}

@end

@implementation ShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化参数
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self setBarTitle:@"商品详情"];
    [self addLeftButton:@"left"];
    [self addRightButton:@"shoppingcar_img"];
    
    dataProvider =[[DataProvider alloc] init];
    goodsInfoDict = [[NSDictionary alloc] init];
    commentListArray = [[NSArray alloc] init];
    currentColorArray = [[NSMutableArray alloc] init];
    currentSizeArray = [[NSMutableArray alloc] init];
    
    selectColor = @"";
    selectSize = @"";
    selectSpec = @"";
    isFavorite = @"0";
    selectPrice = @"";
    selectColorIndex = -1;
    
    //初始化购物车数量
    [self initShoppingCarNum];
    
    //初始化View
    [self initViews];
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

-(void)clickRightButton:(UIButton *)sender{
    ShoppingCartViewController *shoppingCart = [[ShoppingCartViewController alloc] init];
    shoppingCart.navtitle = @"购物车";
    [self.navigationController pushViewController:shoppingCart animated:YES];
}

#pragma mark 自定义方法
-(void)initShoppingCarNum{
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
    DataProvider *dataProvider1 = [[DataProvider alloc] init];
    [dataProvider1 setDelegateObject:self setBackFunctionName:@"getShoppingCarNumCallBack:"];
    [dataProvider1 getShoppingCartList:[Toolkit getUserID] andstartRowIndex:@"0" andmaximumRows:@"10000"];
}

-(void)getShoppingCarNumCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        @try {
            NSArray *shoppingCarNumArray = [[NSArray alloc] initWithArray:dict[@"data"]];
            [_btnRight showBadgeWithStyle:WBadgeStyleNumber value:shoppingCarNumArray.count animationType:WBadgeAnimTypeNone];
            _btnRight.badge.x = _btnRight.badge.x - 10;
            _btnRight.badge.y = 6;
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
}

-(void)initData{
    curpage = 0;
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getGoodsDetailCallBack:"];
    [dataProvider SelectProduct:_goodsId anduserid:get_sp(@"id") andmaximumRows:@"5"];
    
    
    [self getServerPhone];
}
#pragma mark - data source

-(void)getServerPhone
{
    DataProvider *dataprovider = [[DataProvider alloc] init];;
    [dataprovider setDelegateObject:self setBackFunctionName:@"getServerPhoneCallBack:"];
    [dataprovider getProductServerNum];
}
-(void)getServerPhoneCallBack:(id)dict
{
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue] == 200) {
        NSMutableArray *tempArr = [NSMutableArray array];
        
        for (int i = 0; i<[dict[@"data"] count]; i++) {
            [tempArr addObject:dict[@"data"][i][@"Phone"]];
        }
        phoneAlert = [[TelAlertView alloc] initWithPhones:tempArr andShowPoint:CGPointMake(10, SCREEN_HEIGHT - 50 -10 - ((tempArr.count+1)*30))];
    }else{
      
    }

    
    
}
-(void)getGoodsDetailCallBack:(id)dict{
    DLog(@"%@",dict);
    [SVProgressHUD dismiss];
    if ([dict[@"code"] intValue] == 200) {
        goodsInfoDict = dict[@"data"];
        NSArray *tags = [[NSArray alloc] initWithArray:[goodsInfoDict valueForKey:@"ColorList"]];
        [currentColorArray addObjectsFromArray:tags];
        NSArray *tags1 = [[NSArray alloc] initWithArray:[goodsInfoDict valueForKey:@"SizeList"]];
        [currentSizeArray addObjectsFromArray:tags1];
        
        commentListArray = [goodsInfoDict valueForKey:@"CommentList"];
        isFavorite = [Toolkit judgeIsNull:[goodsInfoDict valueForKey:@"isFavorite"]];
        collectionIv.image = [isFavorite isEqual:@"0"]?[UIImage imageNamed:@"store_nocollection"]:[UIImage imageNamed:@"store_collection"];
        collectionLbl.text = [isFavorite isEqual:@"0"]?@"收藏":@"已收藏";
        [mTableView reloadData];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该商品不存在~" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alertView show];
    }
}

-(void)TeamFootRefresh{
    curpage++;
    [dataProvider setDelegateObject:self setBackFunctionName:@"getShopListFootCallBack:"];
    [dataProvider SelectCommentByProductId:_goodsId andstartRowIndex:[NSString stringWithFormat:@"%d",curpage * 10] andmaximumRows:@"10"];
}

-(void)getShopListFootCallBack:(id)dict{
    // 结束刷新
    [mTableView.mj_footer endRefreshing];
    if ([dict[@"code"] intValue] == 200) {
        NSMutableArray *itemarray=[[NSMutableArray alloc] initWithArray:commentListArray];
        NSArray * arrayitem=[[NSArray alloc] init];
        arrayitem=dict[@"data"];
        for (id item in arrayitem) {
            [itemarray addObject:item];
        }
        if(commentListArray.count >= [dict[@"recordcount"] intValue])
        {
            [mTableView.mj_footer setState:MJRefreshStateNoMoreData];
        }
        commentListArray=[[NSArray alloc] initWithArray:itemarray];
        [mTableView reloadData];
    }
}

-(void)initViews{
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height - 50)];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = BACKGROUND_COLOR;
    mTableView.separatorColor = BACKGROUND_COLOR;
    mTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:mTableView];
    
    UIView *mFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
    
    UIButton *telBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [telBtn setImage:[UIImage imageNamed:@"kefutouxiang"] forState:UIControlStateNormal];
    telBtn.backgroundColor = BACKGROUND_COLOR;
    [telBtn addTarget:self action:@selector(telBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [mFooterView addSubview:telBtn];
    
    
    UILabel *kefuLab = [[UILabel alloc] initWithFrame:CGRectMake(telBtn.frame.origin.x,
                                                                (telBtn.frame.origin.y+telBtn.frame.size.height),
                                                                 telBtn.frame.size.width, 20)];
    kefuLab.text = @"客服";
    kefuLab.textAlignment = NSTextAlignmentCenter;
    kefuLab.textColor = [UIColor grayColor];
    kefuLab.font = [UIFont boldSystemFontOfSize:14];
    [mFooterView addSubview:kefuLab];
    
    UIButton *collectionBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 0,50, 50)];
    collectionBtn.backgroundColor = [UIColor colorWithRed:0.16 green:0.16 blue:0.18 alpha:1];
    [collectionBtn addTarget:self action:@selector(collectionEvent) forControlEvents:UIControlEventTouchUpInside];
    collectionIv = [[UIImageView alloc] initWithFrame:CGRectMake((50 - 25) / 2, 2, 25, 25)];
    CGPoint tempPoint =  collectionIv.center;
    tempPoint.x = collectionBtn.frame.size.width/2;
    collectionIv.center = tempPoint;
    [collectionBtn addSubview:collectionIv];
    collectionLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, collectionIv.frame.origin.y + collectionIv.frame.size.height + 2, 80, 21)];
    

    CGPoint tempPoint2 =  collectionLbl.center;
    tempPoint2.x = collectionBtn.frame.size.width/2;
    collectionLbl.center = tempPoint2;
    
    collectionLbl.font = [UIFont systemFontOfSize:14];
    collectionLbl.textColor = [UIColor whiteColor];
    collectionLbl.textAlignment = NSTextAlignmentCenter;
    [collectionBtn addSubview:collectionLbl];
    [mFooterView addSubview:collectionBtn];
    
    UIButton *joinShoppingCar = [[UIButton alloc] initWithFrame:CGRectMake(collectionBtn.frame.size.width+collectionBtn.frame.origin.x, 0, (SCREEN_WIDTH - 80) / 2, 50)];
    [joinShoppingCar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [joinShoppingCar setTitle:@"加入购物车" forState:UIControlStateNormal];
    [joinShoppingCar addTarget:self action:@selector(joinShoppingCarEvent) forControlEvents:UIControlEventTouchUpInside];
    [mFooterView addSubview:joinShoppingCar];
    
    UIButton *immediatelyBuyBtn = [[UIButton alloc] initWithFrame:CGRectMake(80 + (SCREEN_WIDTH - 80) / 2, 0, (SCREEN_WIDTH - 80) / 2, 50)];
    immediatelyBuyBtn.backgroundColor = YellowBlock;
    [immediatelyBuyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [immediatelyBuyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [immediatelyBuyBtn addTarget:self action:@selector(immediatelyBuyEvent) forControlEvents:UIControlEventTouchUpInside];
    [mFooterView addSubview:immediatelyBuyBtn];
    [self.view addSubview:mFooterView];
    

    [self initData];
//    
//    __unsafe_unretained __typeof(self) weakSelf = self;
//    __weak typeof(UITableView *) weakTv = mTableView;
//    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
//    
//    mTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf initData];
//        [weakTv.mj_header endRefreshing];
//    }];
//    
//    // 马上进入刷新状态
//    [mTableView.mj_header beginRefreshing];
//    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
//    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(TeamFootRefresh)];
//    // 禁止自动加载
//    footer.automaticallyRefresh = NO;
//    // 设置footer
//    mTableView.mj_footer = footer;

}
-(void)telBtnClick:(UIButton *)sender
{
    [phoneAlert show];
}


-(void)showCustomView{
    if (bg_view) {
        bg_view.hidden = NO;
        mView.hidden = NO;
    }else{
        bg_view = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50)];
        bg_view.backgroundColor = [UIColor grayColor];
        bg_view.alpha = 0.6;
        [bg_view addTarget:self action:@selector(backViewEvent) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:bg_view];
        
        mView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_HEIGHT - 100 - 50)];
        mView.backgroundColor = ItemsBaseColor;
        [self.view addSubview:mView];
        
        mHeadIv = [[UIImageView alloc] initWithFrame:CGRectMake(14, -(SCREEN_WIDTH / 3 / 2), SCREEN_WIDTH / 3, SCREEN_WIDTH / 3)];
        NSArray *sliderArray = [[NSArray alloc] initWithArray:[goodsInfoDict valueForKey:@"PicList"]];
        NSString *url;
        if (sliderArray && sliderArray.count > 0) {
            NSString *imgpath = [sliderArray[0] valueForKey:@"Path"];
            url = [NSString stringWithFormat:@"%@%@",Url,imgpath];
            UITapGestureRecognizer *headIvTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headViewTap)];
            mHeadIv.userInteractionEnabled = YES;
            [mHeadIv addGestureRecognizer:headIvTap];
        }
        [mHeadIv sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"store_head_bg"]];
        [mView addSubview:mHeadIv];
        
        mPriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(mHeadIv.frame.origin.x + mHeadIv.frame.size.width + 5, 5, 200, 21)];
        mPriceLbl.textColor = YellowBlock;
        mPriceLbl.text = [NSString stringWithFormat:@"¥%@",selectPrice];
        [mView addSubview:mPriceLbl];
        
        mSelectSpecLbl = [[UILabel alloc] initWithFrame:CGRectMake(mPriceLbl.frame.origin.x, mPriceLbl.frame.origin.y + mPriceLbl.frame.size.height + 5, 200, 21)];
        mSelectSpecLbl.font = [UIFont systemFontOfSize:14];
        mSelectSpecLbl.textColor = [UIColor grayColor];
        mSelectSpecLbl.text = @"请选择规格";
        [mView addSubview:mSelectSpecLbl];

        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(14, mHeadIv.frame.origin.y + mHeadIv.frame.size.height + 10, SCREEN_WIDTH - 28, 100)];
        //scrollView.backgroundColor = [UIColor whiteColor];
        
        [mView addSubview:scrollView];
        
        UILabel *mColorLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, scrollView.frame.size.width, 21)];
        mColorLbl.textColor = [UIColor grayColor];
        mColorLbl.text = [Toolkit judgeIsNull:[goodsInfoDict valueForKey:@"ProductColorName"]];
        [scrollView addSubview:mColorLbl];
        
        NSArray *tags = [[NSArray alloc] initWithArray:[goodsInfoDict valueForKey:@"ColorList"]];
        tagList = [[VOTagList alloc] initWithTags:[tags valueForKey:@"Name"]];
        
        tagList.frame = CGRectMake(10, mColorLbl.frame.size.height + 5, scrollView.frame.size.width - 10, [self getHeight:[tags valueForKey:@"Name"] andHoriWidth:scrollView.frame.size.width - 10]);
        tagList.multiLine = YES;
        tagList.multiSelect = NO;
        tagList.allowNoSelection = NO;
        tagList.vertSpacing = 10;
        tagList.horiSpacing = 10;
        tagList.font = [UIFont systemFontOfSize:13];
        tagList.textColor = [UIColor whiteColor];
        tagList.selectedTextColor = [UIColor whiteColor];
        tagList.tagBackgroundColor = [UIColor colorWithRed:0.24 green:0.24 blue:0.25 alpha:1];
        tagList.selectedTagBackgroundColor = [UIColor colorWithRed:0.94 green:0.61 blue:0 alpha:1];
        tagList.tagCornerRadius = 3;
        tagList.tagEdge = UIEdgeInsetsMake(8, 8, 8, 8);
        [tagList addTarget:self action:@selector(selectColorSpecEvent:) forControlEvents:UIControlEventValueChanged];
        [scrollView addSubview:tagList];
        
        UILabel *mSizeLbl = [[UILabel alloc] initWithFrame:CGRectMake(14, tagList.frame.origin.y + tagList.frame.size.height + 5, scrollView.frame.size.width, 21)];
        mSizeLbl.textColor = [UIColor grayColor];
        mSizeLbl.text = [Toolkit judgeIsNull:[goodsInfoDict valueForKey:@"ProductSizeName"]];
        [scrollView addSubview:mSizeLbl];

        NSArray *tags1 = [[NSArray alloc] initWithArray:[goodsInfoDict valueForKey:@"SizeList"]];
        tagList1 = [[VOTagList alloc] initWithTags:[tags1 valueForKey:@"Name"]];
        
        tagList1.frame = CGRectMake(10, mSizeLbl.frame.origin.y + mSizeLbl.frame.size.height + 5, scrollView.frame.size.width - 10, [self getHeight:[tags1 valueForKey:@"Name"] andHoriWidth:scrollView.frame.size.width - 10]);
        tagList1.multiLine = YES;
        tagList1.multiSelect = NO;
        tagList1.allowNoSelection = NO;
        tagList1.vertSpacing = 10;
        tagList1.horiSpacing = 10;
        tagList1.font = [UIFont systemFontOfSize:13];
        tagList1.textColor = [UIColor whiteColor];
        tagList1.selectedTextColor = [UIColor whiteColor];
        tagList1.tagBackgroundColor = [UIColor colorWithRed:0.24 green:0.24 blue:0.25 alpha:1];
        tagList1.selectedTagBackgroundColor = [UIColor colorWithRed:0.94 green:0.61 blue:0 alpha:1];
        tagList1.tagCornerRadius = 3;
        tagList1.tagEdge = UIEdgeInsetsMake(8, 8, 8, 8);
        [tagList1 addTarget:self action:@selector(selectSizeSpecEvent:) forControlEvents:UIControlEventValueChanged];
        [scrollView addSubview:tagList1];
        
        UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(scrollView.frame.size.width - 50, tagList1.frame.origin.y + tagList1.frame.size.height + 15, 35, 35)];
        [addBtn addTarget:self action:@selector(addBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        [addBtn setImage:[UIImage imageNamed:@"KongFuStoreAdd"] forState:UIControlStateNormal];
        [scrollView addSubview:addBtn];
        
        goodsNum = [[UILabel alloc] initWithFrame:CGRectMake(scrollView.frame.size.width - (35 + 22 + 20), tagList1.frame.origin.y + tagList1.frame.size.height + 20, 35, 25)];
        goodsNum.text = [NSString stringWithFormat:@"%@",@"×1"];
        goodsNum.textColor = [UIColor whiteColor];
        [scrollView addSubview:goodsNum];
        
        UIButton *delBtn = [[UIButton alloc] initWithFrame:CGRectMake(scrollView.frame.size.width - (35 + 5 + 20 + 20 + 35), tagList1.frame.origin.y + tagList1.frame.size.height + 15, 35, 35)];
        [delBtn addTarget:self action:@selector(delBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        [delBtn setImage:[UIImage imageNamed:@"KongFuStoreDel"] forState:UIControlStateNormal];
        [scrollView addSubview:delBtn];
        
        CGFloat mScrollHeight = mView.frame.size.height - (SCREEN_WIDTH / 3 / 2) - 50;
        scrollView.frame = CGRectMake(14, mHeadIv.frame.origin.y + mHeadIv.frame.size.height + 10, SCREEN_WIDTH - 28, (mColorLbl.frame.size.height + tagList.frame.size.height + mSizeLbl.frame.size.height + 10) > mScrollHeight ?mScrollHeight:(mColorLbl.frame.size.height + tagList.frame.size.height + mSizeLbl.frame.size.height + 10 + tagList1.frame.size.height + addBtn.frame.size.height + 20));
        scrollView.contentSize = CGSizeMake(0, mColorLbl.frame.size.height + tagList.frame.size.height + mSizeLbl.frame.size.height + 10 + tagList1.frame.size.height + addBtn.frame.size.height + 20);
        mView.frame = CGRectMake(0, SCREEN_HEIGHT - (SCREEN_WIDTH / 3 / 2 + 5 + scrollView.frame.size.height + 20 + 50), SCREEN_WIDTH, SCREEN_WIDTH / 3 / 2 + 5 + scrollView.frame.size.height + 20);
    }
}

-(CGFloat)getHeight:(NSArray *) mArray andHoriWidth:(CGFloat) horiWith{
    CGFloat mWidth = 0.0;
    for (int i = 0; i < mArray.count; i++) {
        CGSize size = [mArray[i] sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13.0f]}];
        mWidth += (size.width > horiWith?horiWith:size.width + 16 + 10);
    }
    int lineNum = ceil(mWidth / horiWith);
    return 5 + lineNum * (10 + 27);
}

-(void)addBtnEvent{
    int mNum = [[goodsNum.text substringFromIndex:1] intValue];
    goodsNum.text = [NSString stringWithFormat:@"×%d",++mNum];
}

-(void)delBtnEvent{
    int mNum = [[goodsNum.text substringFromIndex:1] intValue];
    if (mNum <= 1) {
        return;
    }
    goodsNum.text = [NSString stringWithFormat:@"×%d",--mNum];
}

-(void)hideCustomView{
    bg_view.hidden = YES;
    mView.hidden = YES;
}

-(void)backViewEvent{
    [self hideCustomView];
    [mTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [mTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)selectColorSpecEvent:(VOTagList *)tagListTemp{
    if ((int)tagListTemp.selectedIndexSet.firstIndex == -1) {
        return;
    }
    selectColorIndex = (int)tagListTemp.selectedIndexSet.firstIndex;
    //NSArray *colorArray = [[NSArray alloc] initWithArray:[goodsInfoDict valueForKey:@"ColorList"]];
    selectColorId = [NSString stringWithFormat:@"%@",[currentColorArray[tagListTemp.selectedIndexSet.firstIndex] valueForKey:@"Id"]];
    selectColor = [NSString stringWithFormat:@"%@",[currentColorArray[tagListTemp.selectedIndexSet.firstIndex] valueForKey:@"Name"]];
    
    selectSpec = selectColor;
    if (![selectSize isEqual:@""]) {
        selectSpec = [NSString stringWithFormat:@"%@/%@",selectSpec,selectSize];
    }
    mSelectSpecLbl.text = selectSpec;
    
    [self updateImgAndPrice];
    
    [currentSizeArray removeAllObjects];
    NSArray *tags1 = [[NSArray alloc] initWithArray:[goodsInfoDict valueForKey:@"SizeList"]];
    [tagList1 setTags:[tags1 valueForKey:@"Name"]];
    [currentSizeArray addObjectsFromArray:tags1];
    NSArray *priceListArray = [[NSArray alloc] initWithArray:[goodsInfoDict valueForKey:@"PriceList"]];
    for (NSDictionary *dict in priceListArray) {
        if ([[Toolkit judgeIsNull:[dict valueForKey:@"ColorId"]] isEqual:selectColorId] && ([[Toolkit judgeIsNull:[dict valueForKey:@"StockNum"]] intValue] == 0 || [[Toolkit judgeIsNull:[dict valueForKey:@"StockNum"]] isEqual:@""])) {
            int tagsNum = (int)tags1.count;
            for (int i = 0; i < tagsNum; i++) {
                if ([[Toolkit judgeIsNull:[tags1[i] valueForKey:@"Id"]] isEqual:[Toolkit judgeIsNull:[dict valueForKey:@"SizeId"]]]) {
                    [tagList1 removeTags:[[NSArray alloc] initWithObjects:[tags1[i] valueForKey:@"Name"],
                    nil]];
                    [tagList1 deSelectIndex:selectSizeIndex];
                    [currentSizeArray removeObject:tags1[i]];
                    break;
                }
            }
        }
    }
}

-(void)selectSizeSpecEvent:(VOTagList *)tagListTemp{
    if ((int)tagListTemp.selectedIndexSet.firstIndex == -1) {
        return;
    }
    selectSizeIndex = (int)tagListTemp.selectedIndexSet.firstIndex;
    //NSArray *sizeArray = [[NSArray alloc] initWithArray:[goodsInfoDict valueForKey:@"SizeList"]];
    selectSizeId = [NSString stringWithFormat:@"%@",[currentSizeArray[tagListTemp.selectedIndexSet.firstIndex] valueForKey:@"Id"]];
    selectSize = [NSString stringWithFormat:@"%@",[currentSizeArray[tagListTemp.selectedIndexSet.firstIndex] valueForKey:@"Name"]];
    
    if (![selectColor isEqual:@""]) {
        selectSpec = [NSString stringWithFormat:@"%@/%@",selectColor,selectSize];
    }else{
        selectSpec = selectSize;
    }
    mSelectSpecLbl.text = selectSpec;
    
    [self updateImgAndPrice];
    
    [currentColorArray removeAllObjects];
    NSArray *tags = [[NSArray alloc] initWithArray:[goodsInfoDict valueForKey:@"ColorList"]];
    [tagList setTags:[tags valueForKey:@"Name"]];
    [currentColorArray addObjectsFromArray:tags];
    NSArray *priceListArray = [[NSArray alloc] initWithArray:[goodsInfoDict valueForKey:@"PriceList"]];
    for (NSDictionary *dict in priceListArray) {
        if ([[Toolkit judgeIsNull:[dict valueForKey:@"SizeId"]] isEqual:selectSizeId] && ([[Toolkit judgeIsNull:[dict valueForKey:@"StockNum"]] intValue] == 0 || [[Toolkit judgeIsNull:[dict valueForKey:@"StockNum"]] isEqual:@""])) {
            int tagsNum = (int)tags.count;
            for (int i = 0; i < tagsNum; i++) {
                if ([[Toolkit judgeIsNull:[tags[i] valueForKey:@"Id"]] isEqual:[Toolkit judgeIsNull:[dict valueForKey:@"ColorId"]]]) {
                    [tagList removeTags:[[NSArray alloc] initWithObjects:[tags[i] valueForKey:@"Name"],
                                          nil]];
                    [tagList deSelectIndex:selectColorIndex];
                    [currentColorArray removeObject:tags[i]];
                    break;
                }
            }
        }
    }
}

-(void)updateImgAndPrice{
    if (![selectColor isEqual:@""]) {
        NSArray *priceListArray = [[NSArray alloc] initWithArray:[goodsInfoDict valueForKey:@"PriceList"]];
        for (NSDictionary *dict in priceListArray) {
            if ([[Toolkit judgeIsNull:[dict valueForKey:@"ColorId"]] isEqual:selectColorId]) {
                selectImage = [Toolkit judgeIsNull:[dict valueForKey:@"ImagePath"]];
                NSString *url = [NSString stringWithFormat:@"%@%@",Url,selectImage];
                [mHeadIv sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"store_head_bg"]];
            }
            if ([[Toolkit judgeIsNull:[dict valueForKey:@"ColorId"]] isEqual:selectColorId] && [[Toolkit judgeIsNull:[dict valueForKey:@"SizeId"]] isEqual:selectSizeId]) {
                mPriceLbl.text = [NSString stringWithFormat:@"¥%@",[dict valueForKey:@"Price"]];
                selectPriceId = [Toolkit judgeIsNull:[dict valueForKey:@"Id"]];
                selectPrice = [Toolkit judgeIsNull:[dict valueForKey:@"Price"]];
                storeNum = [[Toolkit judgeIsNull:[dict valueForKey:@"StockNum"]] intValue];
                break;
            }
        }
    }
}

-(void)collectionEvent{
    if ([isFavorite isEqual:@"0"]) {
        [dataProvider setDelegateObject:self setBackFunctionName:@"collectionCallBack:"];
        [dataProvider FavoriteProduct:get_sp(@"id") andproductId:_goodsId];
    }else{
        [dataProvider setDelegateObject:self setBackFunctionName:@"CancelCollectionCallBack:"];
        [dataProvider CancleFavoriteProduct:get_sp(@"id") andproductId:_goodsId];
    }
}

-(void)collectionCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        [SVProgressHUD showSuccessWithStatus:@"收藏成功~" maskType:SVProgressHUDMaskTypeBlack];
        isFavorite = @"1";
        collectionIv.image = [UIImage imageNamed:@"store_collection"];
        collectionLbl.text = @"已收藏";
    }
}

-(void)CancelCollectionCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        [SVProgressHUD showSuccessWithStatus:@"取消收藏成功~" maskType:SVProgressHUDMaskTypeBlack];
        isFavorite = @"0";
        collectionIv.image = [UIImage imageNamed:@"store_nocollection"];
        collectionLbl.text = @"收藏";
    }
}

-(void)joinShoppingCarEvent{
    if ([selectColor isEqual:@""] || [selectSize isEqual:@""]) {
        [self showCustomView];
    }else{
        if ([[goodsNum.text substringFromIndex:1] intValue] <= storeNum) {
            [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
            [dataProvider setDelegateObject:self setBackFunctionName:@"joinShoppingCarCallBack:"];
            [dataProvider InsertBasket:_goodsId andnum:[goodsNum.text substringFromIndex:1] andpriceId:selectPriceId anduserId:get_sp(@"id") andprice:[mPriceLbl.text substringFromIndex:1]];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"超出库存" delegate:self cancelButtonTitle:@"知道了~" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
}

-(void)joinShoppingCarCallBack:(id)dict{
    [SVProgressHUD dismiss];
    if ([dict[@"code"] intValue] == 200) {
        [self initShoppingCarNum];
        [SVProgressHUD showSuccessWithStatus:@"加入购物车成功~" maskType:SVProgressHUDMaskTypeBlack];
        [self backViewEvent];
    }else{
        [SVProgressHUD showSuccessWithStatus:dict[@"data"] maskType:SVProgressHUDMaskTypeBlack];
    }
}

-(void)immediatelyBuyEvent{
    if ([selectColor isEqual:@""] || [selectSize isEqual:@""]) {
        [self showCustomView];
    }else{
        if ([[goodsNum.text substringFromIndex:1] intValue] <= storeNum) {
            [self backViewEvent];
            PayOrderViewController *payOrderVC = [[PayOrderViewController alloc] init];
            payOrderVC.navtitle = @"确认订单";
            payOrderVC.paytype = PayByImmediately;
            CartModel *tempModel = [[CartModel alloc] init];
            tempModel.ProductId = _goodsId;
            tempModel.ProductName = mName.text;
            tempModel.MiddleImagePath = selectImage;
            tempModel.Number = [goodsNum.text substringFromIndex:1];
            tempModel.ProductPriceId = selectPriceId;
            tempModel.ProductPriceTotalPrice = [mPriceLbl.text substringFromIndex:1];
            tempModel.ProductColorName = selectColor;
            tempModel.ProductSizeName = selectSize;
            NSMutableArray *goodsArray = [[NSMutableArray alloc] init];
            [goodsArray addObject:tempModel];
            payOrderVC.goodsArr = goodsArray;
            payOrderVC.postage = [[Toolkit judgeIsNull:[goodsInfoDict valueForKey:@"LiveryPrice"]] floatValue];
            [self.navigationController pushViewController:payOrderVC animated:YES];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"超出库存" delegate:self cancelButtonTitle:@"知道了~" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
}

-(void)headViewTap{
    UIView *maskview = [[UIView alloc] initWithFrame:self.view.bounds];
    maskview.backgroundColor = [UIColor blackColor];
    [self.view addSubview:maskview];
    NSMutableArray *imageViews = [[NSMutableArray alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@%@",Url,selectImage];
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

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 2;
    }else if (section == 1){
        return 1;
    }else if(section == 2){
        return 2;
    }else{
        return 1 + commentListArray.count;
    }
}

#pragma mark setting for section
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1 || section == 2 || section == 3) {
        return 4;
    }else{
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    return view;
}
#pragma mark - 轮播图代理

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    DLog(@"index = %ld",(long)index);
    
    UIView *maskview = [[UIView alloc] initWithFrame:self.view.bounds];
    maskview.backgroundColor = [UIColor blackColor];
    [self.view addSubview:maskview];
    NSMutableArray *imageViews = [[NSMutableArray alloc] init];
    
    NSArray *sliderArray = [[NSArray alloc] initWithArray:[goodsInfoDict valueForKey:@"PicList"]];
    
    for (int i = 0 ; i < sliderArray.count; i++) {
        NSString *url = [NSString stringWithFormat:@"%@%@",Url,sliderArray[i][@"Path"]];
        [imageViews addObject:url];
    }
    
    
    
    YMShowImageView *ymImageV = [[YMShowImageView alloc] initWithFrame:self.view.bounds byClick:9999 + index appendArray:imageViews];
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

#pragma mark setting for cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *cellIdentifier = @"cellIdentifier";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//        cell.backgroundColor = ItemsBaseColor;
//    }else{
//        for (UIView *view in cell.subviews) {
//            if ([view isKindOfClass:[UILabel class]] || [view isKindOfClass:[SDCycleScrollView class]]) {
//                [view removeFromSuperview];
//            }
//        }
//    }
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    cell.backgroundColor = ItemsBaseColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSMutableArray *images = [[NSMutableArray alloc] init];
            NSArray *sliderArray = [[NSArray alloc] initWithArray:[goodsInfoDict valueForKey:@"PicList"]];
            if (sliderArray.count > 0) {
                for (int i=0; i<sliderArray.count; i++) {
                    UIImageView * img=[[UIImageView alloc] init];
                    NSString *imgpath = [sliderArray[i] valueForKey:@"Path"];
                    NSString *url = [NSString stringWithFormat:@"%@%@",Url,imgpath];
                    [img sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"store_head_bg"]];
                    [images addObject:img];
                }
            }else{
                UIImageView * img=[[UIImageView alloc] init];
                img.image = [UIImage imageNamed:@"store_head_bg"];
                [images addObject:img];
            }
            //创建带标题的图片轮播器
            SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 170) imagesGroup:images ];
            cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
            cycleScrollView.autoScrollTimeInterval = 5;
            cycleScrollView.delegate = self;
            [cell addSubview:cycleScrollView];
            
            mName = [[UILabel alloc] initWithFrame:CGRectMake(14, cycleScrollView.frame.origin.y + cycleScrollView.frame.size.height + (45 - 21) / 2, 200, 21)];
            mName.textColor = [UIColor whiteColor];
            mName.text = [Toolkit judgeIsNull:[goodsInfoDict valueForKey:@"Name"]];
            [cell addSubview:mName];
        }else{
            if ([selectPrice isEqual:@""]) {
                selectPrice = [Toolkit judgeIsNull:[goodsInfoDict valueForKey:@"Price"]];
            }
            NSString *priceStr = [NSString stringWithFormat:@"¥%@",selectPrice];
            CGSize priceSize = [priceStr sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17.0f]}];
            UILabel *priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(14, 5, priceSize.width, 21)];
            priceLbl.textColor = YellowBlock;
            priceLbl.text = priceStr;
            [cell addSubview:priceLbl];
            
            UILabel *byLbl = [[UILabel alloc] initWithFrame:CGRectMake(14, priceLbl.frame.origin.y + priceLbl.frame.size.height + 5, SCREEN_WIDTH / 3, 21)];
            byLbl.font = [UIFont systemFontOfSize:15];
            byLbl.textColor = [UIColor colorWithRed:0.45 green:0.45 blue:0.45 alpha:1];
            NSString *LiveryPrice= [Toolkit judgeIsNull:[goodsInfoDict valueForKey:@"LiveryPrice"]];
            if([LiveryPrice isEqual:@"-1"]){
                byLbl.text = [NSString stringWithFormat:@"邮费:%@",@"到付"];
            }else if([LiveryPrice isEqual:@"0"]){
                byLbl.text = [NSString stringWithFormat:@"邮费:%@",@"卖家包邮"];
            }else{
                byLbl.text = [NSString stringWithFormat:@"邮费:%@",[Toolkit judgeIsNull:[goodsInfoDict valueForKey:@"LiveryPrice"]]];
            }
            [cell addSubview:byLbl];
            
            UILabel *browseNum = [[UILabel alloc] initWithFrame:CGRectMake(byLbl.frame.origin.x + byLbl.frame.size.width, priceLbl.frame.origin.y + priceLbl.frame.size.height + 5, SCREEN_WIDTH / 3, 21)];
            browseNum.font = [UIFont systemFontOfSize:15];
            browseNum.textColor = [UIColor colorWithRed:0.45 green:0.45 blue:0.45 alpha:1];
            browseNum.text = [NSString stringWithFormat:@"浏览量:%@",[Toolkit judgeIsNull:[goodsInfoDict valueForKey:@"VisitNum"]]];
            [cell addSubview:browseNum];
            
            UILabel *Sales = [[UILabel alloc] initWithFrame:CGRectMake(browseNum.frame.origin.x + browseNum.frame.size.width, priceLbl.frame.origin.y + priceLbl.frame.size.height + 5, SCREEN_WIDTH / 3, 21)];
            Sales.font = [UIFont systemFontOfSize:15];
            Sales.textColor = [UIColor colorWithRed:0.45 green:0.45 blue:0.45 alpha:1];
            Sales.text = [NSString stringWithFormat:@"销量:%@",[Toolkit judgeIsNull:[goodsInfoDict valueForKey:@"SaleNum"]]];
            [cell addSubview:Sales];
        }
        return cell;
    }else if (indexPath.section == 1){
        UILabel *mSpecLbl = [[UILabel alloc] initWithFrame:CGRectMake(14, (45 - 21) / 2, SCREEN_WIDTH - 14, 21)];
        mSpecLbl.font = [UIFont systemFontOfSize:14];
        mSpecLbl.textColor = [UIColor whiteColor];
        mSpecLbl.text = [selectSpec isEqual:@""]?@"请选择规格":[NSString stringWithFormat:@"规格:%@",selectSpec];
        [cell addSubview:mSpecLbl];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            UILabel *userCommentTitle = [[UILabel alloc] initWithFrame:CGRectMake(14, (45 - 21) / 2, 150, 21)];
            userCommentTitle.font = [UIFont systemFontOfSize:16];
            userCommentTitle.textColor = [UIColor whiteColor];
            userCommentTitle.text = @"产品介绍";
            [cell addSubview:userCommentTitle];
        }else{
            NSString *mContentStr = [Toolkit judgeIsNull:[goodsInfoDict valueForKey:@"Content"]];
            CGFloat contentHeight = [Toolkit heightWithString:mContentStr fontSize:14 width:SCREEN_WIDTH-28]+10;
            UITextView *mContent = [[UITextView alloc] initWithFrame:CGRectMake(14, 2, SCREEN_WIDTH - 28, contentHeight)];
            mContent.textColor = [UIColor whiteColor];
            mContent.editable = NO;
            mContent.scrollEnabled = NO;
            mContent.font = [UIFont systemFontOfSize:12];
            mContent.backgroundColor = ItemsBaseColor;
            mContent.text = mContentStr;
            [cell addSubview:mContent];
        }
    }else{
        if (indexPath.row == 0) {
            UILabel *userCommentTitle = [[UILabel alloc] initWithFrame:CGRectMake(14, (45 - 21) / 2, 150, 21)];
            userCommentTitle.font = [UIFont systemFontOfSize:16];
            userCommentTitle.textColor = [UIColor whiteColor];
            userCommentTitle.text = @"用户评价";
            [cell addSubview:userCommentTitle];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 65, 5, 1, 35)];
            lineView.backgroundColor = [UIColor colorWithRed:0.25 green:0.26 blue:0.27 alpha:1];
            [cell addSubview:lineView];
            
            UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(lineView.frame.origin.x - 150, lineView.frame.origin.y, 145, lineView.frame.size.height)];
            tipLab.text = @"点击查看更多";
            tipLab.textColor = [UIColor whiteColor];
            tipLab.font = [UIFont systemFontOfSize:14];
            tipLab.textAlignment = NSTextAlignmentRight;
            [cell addSubview:tipLab];
            
            UILabel *userCommentNum = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, (45 - 21) / 2, 60, 21)];
            userCommentNum.font = [UIFont systemFontOfSize:14];
            userCommentNum.textColor = [UIColor whiteColor];
            userCommentNum.text = [NSString stringWithFormat:@"共%@条",[Toolkit judgeIsNull:[goodsInfoDict valueForKey:@"CommentNum"]]];
            [cell addSubview:userCommentNum];
        }else{
            NSString *url = [NSString stringWithFormat:@"%@%@",Url,[Toolkit judgeIsNull:[commentListArray[indexPath.row - 1] valueForKey:@"PhotoPath"]]];
            UserHeadView *userHeadView = [[UserHeadView alloc] initWithFrame:CGRectMake(14, 5, 40, 40) andUrl:url andNav:self.navigationController];
            [userHeadView makeSelfRound];
            [cell addSubview:userHeadView];
            
            mName = [[UILabel alloc] initWithFrame:CGRectMake(userHeadView.frame.origin.x + userHeadView.frame.size.width + 5, 5 + (40 - 21) / 2, 150, 21)];
            mName.font = [UIFont systemFontOfSize:15];
            mName.textColor = [UIColor whiteColor];
            mName.text = [commentListArray[indexPath.row - 1] valueForKey:@"NicName"];
            [cell addSubview:mName];
            
            NSString *mContentStr = [Toolkit judgeIsNull:[commentListArray[indexPath.row - 1] valueForKey:@"Content"]];//@"东西不错，用着很好，很喜欢.东西不错，用着很好，很喜欢.东西不错，用着很好，很喜欢.东西不错，用着很好，很喜欢.东西不错，用着很好，很喜欢.";
            CGFloat contentHeight = [Toolkit heightWithString:mContentStr fontSize:14 width:SCREEN_WIDTH-28]+10;
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
            mDate.text = [Toolkit judgeIsNull:[commentListArray[indexPath.row - 1] valueForKey:@"PublishTime"]];
            mDate.textColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1];
            [cell addSubview:mDate];
            
            NSString *mSpecStr = [NSString stringWithFormat:@"规格:%@",[Toolkit judgeIsNull:[commentListArray[indexPath.row - 1] valueForKey:@"ColorAndSize"]]];
            CGFloat specHeight = [Toolkit heightWithString:mSpecStr fontSize:12 width:SCREEN_WIDTH-(14 + 40 + 5 + 5)]+10;
            UITextView *mSpecLbl = [[UITextView alloc] initWithFrame:CGRectMake(mDate.frame.origin.x, mDate.frame.origin.y + mDate.frame.size.height, SCREEN_WIDTH - mDate.frame.origin.x, specHeight)];
            mSpecLbl.font = [UIFont systemFontOfSize:12];
            mSpecLbl.backgroundColor = ItemsBaseColor;
            mSpecLbl.text = mSpecStr;
            mSpecLbl.textColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1];
            [cell addSubview:mSpecLbl];
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if (indexPath.row == 0) {
            return 170 + 45;
        }else{
            return 60;
        }
    }else if (indexPath.section == 1){
        return 45;
    }else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            return 45;
        }else{
            NSString *mContentStr = [Toolkit judgeIsNull:[goodsInfoDict valueForKey:@"Content"]];
            CGFloat contentHeight = [Toolkit heightWithString:mContentStr fontSize:14 width:SCREEN_WIDTH-28]+10;
            return 5 + contentHeight;
        }
    }else{
        if (indexPath.row == 0) {
            return 45;
        }else{
            NSString *mContentStr = [Toolkit judgeIsNull:[commentListArray[indexPath.row - 1] valueForKey:@"Content"]];//@"东西不错，用着很好，很喜欢.东西不错，用着很好，很喜欢.东西不错，用着很好，很喜欢.东西不错，用着很好，很喜欢.东西不错，用着很好，很喜欢.";
            CGFloat contentHeight = [Toolkit heightWithString:mContentStr fontSize:14 width:SCREEN_WIDTH-28]+10;
            
            NSString *mSpecStr = [NSString stringWithFormat:@"规格:%@",[Toolkit judgeIsNull:[commentListArray[indexPath.row - 1] valueForKey:@"ColorAndSize"]]];
            CGFloat specHeight = [Toolkit heightWithString:mSpecStr fontSize:12 width:SCREEN_WIDTH-(14 + 40 + 5 + 5)]+10;
            return 5 + (40 - 21) / 2 + 23 + contentHeight + 25 + specHeight + 5;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [mTableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 1){
        [self showCustomView];
    }
    else if(indexPath.section >= 3)
    {
        GoodsCommentViewController *goodsCommentViewCtl = [[GoodsCommentViewController alloc] init];
        goodsCommentViewCtl.goodId = self.goodsId;
        [self.navigationController pushViewController:goodsCommentViewCtl animated:YES];
    }
}

@end
