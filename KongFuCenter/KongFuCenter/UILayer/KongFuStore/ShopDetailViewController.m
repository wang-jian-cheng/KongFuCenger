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

@interface ShopDetailViewController (){
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
}

@end

@implementation ShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化参数
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self setBarTitle:@"商品详情"];
    [self addLeftButton:@"left"];
    
    dataProvider =[[DataProvider alloc] init];
    goodsInfoDict = [[NSDictionary alloc] init];
    commentListArray = [[NSArray alloc] init];
    
    selectColor = @"";
    selectSize = @"";
    selectSpec = @"";
    isFavorite = @"0";
    selectPrice = @"";
    
    //初始化View
    [self initViews];
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

#pragma mark 自定义方法
-(void)initData{
    curpage = 0;
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getGoodsDetailCallBack:"];
    [dataProvider SelectProduct:_goodsId anduserid:get_sp(@"id") andmaximumRows:@"10"];
}

-(void)getGoodsDetailCallBack:(id)dict{
    NSLog(@"%@",dict);
    [SVProgressHUD dismiss];
    if ([dict[@"code"] intValue] == 200) {
        goodsInfoDict = dict[@"data"];
        commentListArray = [goodsInfoDict valueForKey:@"CommentList"];
        isFavorite = [Toolkit judgeIsNull:[goodsInfoDict valueForKey:@"isFavorite"]];
        collectionIv.image = [isFavorite isEqual:@"0"]?[UIImage imageNamed:@"store_nocollection"]:[UIImage imageNamed:@"store_collection"];
        collectionLbl.text = [isFavorite isEqual:@"0"]?@"收藏":@"已收藏";
        [mTableView reloadData];
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
        commentListArray=[[NSArray alloc] initWithArray:itemarray];
        [mTableView reloadData];
    }
}

-(void)initViews{
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height - 50)];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = BACKGROUND_COLOR;
    mTableView.separatorColor = Separator_Color;
    mTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:mTableView];
    
    UIView *mFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
    
    UIButton *collectionBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    collectionBtn.backgroundColor = [UIColor colorWithRed:0.16 green:0.16 blue:0.18 alpha:1];
    [collectionBtn addTarget:self action:@selector(collectionEvent) forControlEvents:UIControlEventTouchUpInside];
    collectionIv = [[UIImageView alloc] initWithFrame:CGRectMake((80 - 25) / 2, 2, 25, 25)];
    [collectionBtn addSubview:collectionIv];
    collectionLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, collectionIv.frame.origin.y + collectionIv.frame.size.height + 2, 80, 21)];
    collectionLbl.font = [UIFont systemFontOfSize:14];
    collectionLbl.textColor = [UIColor whiteColor];
    collectionLbl.textAlignment = NSTextAlignmentCenter;
    [collectionBtn addSubview:collectionLbl];
    [mFooterView addSubview:collectionBtn];
    
    UIButton *joinShoppingCar = [[UIButton alloc] initWithFrame:CGRectMake(80, 0, (SCREEN_WIDTH - 80) / 2, 50)];
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
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    __weak typeof(UITableView *) weakTv = mTableView;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    
    mTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf initData];
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
        
        NSArray *mColorArray = [[NSArray alloc] initWithArray:[goodsInfoDict valueForKey:@"ColorList"]];//[[NSArray alloc] initWithObjects:@"黑色",@"红色",@"蓝色",@"白色",@"紫色", nil];
        NSArray *mSizeArray = [[NSArray alloc] initWithArray:[goodsInfoDict valueForKey:@"SizeList"]];//[[NSArray alloc] initWithObjects:@"S",@"M",@"L",@"H",@"I", nil];
        int colorRowNum = 0;
        if (mColorArray.count == 0) {
            colorRowNum = 0;
        }else if (mColorArray.count <= 3) {
            colorRowNum = 1;
        }else if (mColorArray.count <= 6){
            colorRowNum = 2;
        }
        int sizeRowNum = 0;
        if (mColorArray.count == 0) {
            sizeRowNum = 0;
        }else if (mColorArray.count <= 3) {
            sizeRowNum = 1;
        }else if (mColorArray.count <= 6){
            sizeRowNum = 2;
        }
        
        CGFloat customViewHeight = 240 + (colorRowNum + sizeRowNum) * 35;
        mView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - customViewHeight, SCREEN_WIDTH, customViewHeight - 50)];
        mView.backgroundColor = ItemsBaseColor;
        [self.view addSubview:mView];
        
        mHeadIv = [[UIImageView alloc] initWithFrame:CGRectMake(14, -(SCREEN_WIDTH / 3 / 2), SCREEN_WIDTH / 3, SCREEN_WIDTH / 3)];
        [mHeadIv sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"store_head_bg"]];
        [mView addSubview:mHeadIv];
        
        mPriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(mHeadIv.frame.origin.x + mHeadIv.frame.size.width + 5, 5, 200, 21)];
        mPriceLbl.textColor = YellowBlock;
        mPriceLbl.text = [NSString stringWithFormat:@"¥%@",selectPrice];
        [mView addSubview:mPriceLbl];
        
        mSelectSpecLbl = [[UILabel alloc] initWithFrame:CGRectMake(mPriceLbl.frame.origin.x, mPriceLbl.frame.origin.y + mPriceLbl.frame.size.height + 5, 200, 21)];
        mSelectSpecLbl.textColor = [UIColor grayColor];
        mSelectSpecLbl.text = @"请选择规格";
        [mView addSubview:mSelectSpecLbl];
        
        UILabel *mColorLbl = [[UILabel alloc] initWithFrame:CGRectMake(14, mHeadIv.frame.origin.y + mHeadIv.frame.size.height + 10, 100, 21)];
        mColorLbl.textColor = [UIColor grayColor];
        mColorLbl.text = [Toolkit judgeIsNull:[goodsInfoDict valueForKey:@"ProductColorName"]];
        [mView addSubview:mColorLbl];
        
        UIView *mColorView = [[UIView alloc] initWithFrame:CGRectMake(14, mColorLbl.frame.origin.y + mColorLbl.frame.size.height + 5, SCREEN_WIDTH - 28, colorRowNum * 35)];
        CGFloat mColorWidth = (SCREEN_WIDTH - 28 - 10) / 3;
        
        for (int i = 0; i < mColorArray.count; i++) {
            UIButton *mColorBtn = [[UIButton alloc] initWithFrame:CGRectMake((mColorWidth + 5) * (i % 3), (i / 3) * (35 + 5), mColorWidth, 35)];
            mColorBtn.titleLabel.font = [UIFont systemFontOfSize:18];
            mColorBtn.backgroundColor = [UIColor colorWithRed:0.24 green:0.24 blue:0.25 alpha:1];
            [mColorBtn setTitle:[mColorArray[i] valueForKey:@"Name"] forState:UIControlStateNormal];
            mColorBtn.tag = [[Toolkit judgeIsNull:[mColorArray[i] valueForKey:@"Id"]] intValue];
            [mColorBtn addTarget:self action:@selector(selectColorSpecEvent:) forControlEvents:UIControlEventTouchUpInside];
            [mColorView addSubview:mColorBtn];
        }
        [mView addSubview:mColorView];
        
        UILabel *mSizeLbl = [[UILabel alloc] initWithFrame:CGRectMake(14, mColorView.frame.origin.y + mColorView.frame.size.height + 10, 100, 21)];
        mSizeLbl.textColor = [UIColor grayColor];
        mSizeLbl.text = [Toolkit judgeIsNull:[goodsInfoDict valueForKey:@"ProductSizeName"]];
        [mView addSubview:mSizeLbl];
        
        UIView *mSizeView = [[UIView alloc] initWithFrame:CGRectMake(14, mSizeLbl.frame.origin.y + mSizeLbl.frame.size.height + 5, SCREEN_WIDTH - 28, sizeRowNum * 35)];
        CGFloat mSizeWidth = (SCREEN_WIDTH - 28 - 10) / 3;
        
        for (int i = 0; i < mSizeArray.count; i++) {
            UIButton *mSizeBtn = [[UIButton alloc] initWithFrame:CGRectMake((mSizeWidth + 5) * (i % 3), (i / 3) * (35 + 5), mSizeWidth, 35)];
            mSizeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
            mSizeBtn.backgroundColor = [UIColor colorWithRed:0.24 green:0.24 blue:0.25 alpha:1];
            [mSizeBtn setTitle:[mSizeArray[i] valueForKey:@"Name"] forState:UIControlStateNormal];
            mSizeBtn.tag = [[Toolkit judgeIsNull:[mSizeArray[i] valueForKey:@"Id"]] intValue];
            [mSizeBtn addTarget:self action:@selector(selectSizeSpecEvent:) forControlEvents:UIControlEventTouchUpInside];
            [mSizeView addSubview:mSizeBtn];
        }
        [mView addSubview:mSizeView];
    }
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

-(void)selectColorSpecEvent:(UIButton *)btn{
    for (UIButton *item in btn.superview.subviews) {
        item.backgroundColor = [UIColor colorWithRed:0.24 green:0.24 blue:0.25 alpha:1];
    }
    btn.backgroundColor = YellowBlock;
    
    selectColorId = [NSString stringWithFormat:@"%d",(int)btn.tag];
    selectColor = btn.titleLabel.text;
    
    selectSpec = selectColor;
    if (![selectSize isEqual:@""]) {
        selectSpec = [NSString stringWithFormat:@"%@/%@",selectSpec,selectSize];
    }
    mSelectSpecLbl.text = selectSpec;
    
    [self updateImgAndPrice];
}

-(void)selectSizeSpecEvent:(UIButton *)btn{
    for (UIButton *item in btn.superview.subviews) {
        item.backgroundColor = [UIColor colorWithRed:0.24 green:0.24 blue:0.25 alpha:1];
    }
    btn.backgroundColor = YellowBlock;
    
    selectSizeId = [NSString stringWithFormat:@"%d",(int)btn.tag];
    selectSize = btn.titleLabel.text;
    
    if (![selectColor isEqual:@""]) {
        selectSpec = [NSString stringWithFormat:@"%@/%@",selectColor,selectSize];
    }else{
        selectSpec = selectSize;
    }
    mSelectSpecLbl.text = selectSpec;
    
    [self updateImgAndPrice];
}

-(void)updateImgAndPrice{
    if (![selectColor isEqual:@""] && ![selectSize isEqual:@""]) {
        NSArray *priceListArray = [[NSArray alloc] initWithArray:[goodsInfoDict valueForKey:@"PriceList"]];
        for (NSDictionary *dict in priceListArray) {
            if ([[Toolkit judgeIsNull:[dict valueForKey:@"ColorId"]] isEqual:selectColorId] && [[Toolkit judgeIsNull:[dict valueForKey:@"SizeId"]] isEqual:selectColorId]) {
                NSString *url = [NSString stringWithFormat:@"%@%@",Url,[Toolkit judgeIsNull:[dict valueForKey:@"ImagePath"]]];
                [mHeadIv sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"store_head_bg"]];
                NSLog(@"%@",dict);
                mPriceLbl.text = [NSString stringWithFormat:@"¥%@",[dict valueForKey:@"Price"]];
                selectPriceId = [Toolkit judgeIsNull:[dict valueForKey:@"Id"]];
                selectPrice = [Toolkit judgeIsNull:[dict valueForKey:@"Price"]];
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
        [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
        [dataProvider setDelegateObject:self setBackFunctionName:@"joinShoppingCarCallBack:"];
        [dataProvider InsertBasket:_goodsId andnum:@"1" andpriceId:selectPriceId anduserId:get_sp(@"id") andprice:[mPriceLbl.text substringFromIndex:1]];
    }
}

-(void)joinShoppingCarCallBack:(id)dict{
    [SVProgressHUD dismiss];
    if ([dict[@"code"] intValue] == 200) {
        [SVProgressHUD showSuccessWithStatus:@"加入购物车成功~" maskType:SVProgressHUDMaskTypeBlack];
    }else{
        [SVProgressHUD showSuccessWithStatus:dict[@"data"] maskType:SVProgressHUDMaskTypeBlack];
    }
}

-(void)immediatelyBuyEvent{
    if ([selectColor isEqual:@""] || [selectSize isEqual:@""]) {
        [self showCustomView];
    }else{
        PayOrderViewController *payOrderVC = [[PayOrderViewController alloc] init];
        payOrderVC.navtitle = @"确认订单";
        [self.navigationController pushViewController:payOrderVC animated:YES];
    }
    
//    [dataProvider setDelegateObject:self setBackFunctionName:@"immediatelyBuyCallBack:"];
//    [dataProvider BuyNow:_goodsId andnum:@"1" andpriceId:selectPriceId anduserId:get_sp(@"id") andprice:mPriceLbl.text anddeliveryId:@""];
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 2;
    }else if (section == 1){
        return 1;
    }else{
        return 1 + commentListArray.count;
    }
}

#pragma mark setting for section
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1 || section == 2) {
        return 4;
    }else{
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    return view;
}

#pragma mark setting for cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = ItemsBaseColor;
    }else{
        for (UIView *view in cell.subviews) {
            [view removeFromSuperview];
        }
    }
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
            [cell addSubview:cycleScrollView];
            
            UILabel *mName = [[UILabel alloc] initWithFrame:CGRectMake(14, cycleScrollView.frame.origin.y + cycleScrollView.frame.size.height + (45 - 21) / 2, 200, 21)];
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
            byLbl.text = [[Toolkit judgeIsNull:[goodsInfoDict valueForKey:@"LiveryPrice"]] isEqual:@"0"]?@"包邮":[NSString stringWithFormat:@"邮费:%@",[Toolkit judgeIsNull:[goodsInfoDict valueForKey:@"LiveryPrice"]]];
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
        UILabel *mSpecLbl = [[UILabel alloc] initWithFrame:CGRectMake(14, (45 - 21) / 2, 150, 21)];
        mSpecLbl.textColor = [UIColor whiteColor];
        mSpecLbl.text = [selectSpec isEqual:@""]?@"请选择规格":[NSString stringWithFormat:@"规格:%@",selectSpec];
        [cell addSubview:mSpecLbl];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
            
            UILabel *mName = [[UILabel alloc] initWithFrame:CGRectMake(userHeadView.frame.origin.x + userHeadView.frame.size.width + 5, 5 + (40 - 21) / 2, 150, 21)];
            mName.font = [UIFont systemFontOfSize:15];
            mName.textColor = [UIColor whiteColor];
            mName.text = [commentListArray[indexPath.row - 1] valueForKey:@"UserName"];
            [cell addSubview:mName];
            
            NSString *mContentStr = [Toolkit judgeIsNull:[commentListArray[indexPath.row - 1] valueForKey:@"Content"]];//@"东西不错，用着很好，很喜欢.东西不错，用着很好，很喜欢.东西不错，用着很好，很喜欢.东西不错，用着很好，很喜欢.东西不错，用着很好，很喜欢.";
            CGFloat contentHeight = [Toolkit heightWithString:mContentStr fontSize:14 width:SCREEN_WIDTH-64]+10;
            UITextView *mContent = [[UITextView alloc] initWithFrame:CGRectMake(mName.frame.origin.x, mName.frame.origin.y + mName.frame.size.height + 2, SCREEN_WIDTH - mName.frame.origin.x - 10, contentHeight)];
            mContent.textColor = [UIColor whiteColor];
            mContent.editable = NO;
            mContent.scrollEnabled = NO;
            mContent.font = [UIFont systemFontOfSize:12];
            mContent.backgroundColor = ItemsBaseColor;
            mContent.text = mContentStr;
            [cell addSubview:mContent];
            
            UILabel *mDate = [[UILabel alloc] initWithFrame:CGRectMake(mName.frame.origin.x, mName.frame.origin.y + mName.frame.size.height + 2 + contentHeight + 5, 150, 21)];
            mDate.font = [UIFont systemFontOfSize:12];
            mDate.text = [Toolkit judgeIsNull:[commentListArray[indexPath.row - 1] valueForKey:@"PublishTime"]];
            mDate.textColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1];
            [cell addSubview:mDate];
            
            UILabel *mSpecLbl = [[UILabel alloc] initWithFrame:CGRectMake(mDate.frame.origin.x + mDate.frame.size.width, mName.frame.origin.y + mName.frame.size.height + 2 + contentHeight + 5, 200, 21)];
            mSpecLbl.font = [UIFont systemFontOfSize:12];
            mSpecLbl.text = [NSString stringWithFormat:@"规格:%@",[Toolkit judgeIsNull:[commentListArray[indexPath.row - 1] valueForKey:@"ColorAndSize"]]];
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
    }else{
        if (indexPath.row == 0) {
            return 45;
        }else{
            NSString *mContentStr = [Toolkit judgeIsNull:[commentListArray[indexPath.row - 1] valueForKey:@"Content"]];//@"东西不错，用着很好，很喜欢.东西不错，用着很好，很喜欢.东西不错，用着很好，很喜欢.东西不错，用着很好，很喜欢.东西不错，用着很好，很喜欢.";
            CGFloat contentHeight = [Toolkit heightWithString:mContentStr fontSize:14 width:SCREEN_WIDTH-64]+5;
            return 5 + (40 - 21) / 2 + 23 + contentHeight + 31;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [mTableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 1){
        [self showCustomView];
    }
}

@end
