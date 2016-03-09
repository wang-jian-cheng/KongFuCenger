//
//  KongFuStoreViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/7.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "KongFuStoreViewController.h"
#import "ShopTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ShopDetailViewController.h"
#import "ClassificationViewController.h"
#import "RecommendGoodsViewController.h"
#import "ShopListViewController.h"

@interface KongFuStoreViewController (){
    UITableView *mTableView;
    DataProvider *dataProvider;
    int curpage;
    NSMutableArray *shopInfoArray;
    int allGoodsNum;
    int downNum;
}
@property(nonatomic) NSMutableArray *LunboArr;

@end

@implementation KongFuStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化参数
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self setBarTitle:@"购物"];
    [self addRightButton:@"search"];
    
#if (!KONGFU_VER2)

    UIImageView * img_back=[[UIImageView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49)];
    
    img_back.image=[UIImage imageNamed:@"KongfuStore_0.png"];
    
    [self.view addSubview:img_back];
    
    UIView * fugai=[[UIView alloc] initWithFrame:img_back.frame];
    
    fugai.backgroundColor=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7];
    
    [self.view addSubview:fugai];
    
    UILabel * lbl_tishi=[[UILabel alloc] init];
    
    lbl_tishi.bounds=CGRectMake(0, 0, SCREEN_WIDTH, 30);
    
    lbl_tishi.text=@"敬请期待";
    
    lbl_tishi.textAlignment=NSTextAlignmentCenter;
    
    lbl_tishi.textColor=[UIColor whiteColor];
    
    lbl_tishi.center=CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    
    [self.view addSubview:lbl_tishi];
#else
    
    
    dataProvider = [[DataProvider alloc] init];
    allGoodsNum = 0;
    
    //初始化View
    [self initViews];
#endif
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showTabBar];
}

-(void)clickRightButton:(UIButton *)sender{
    ShopListViewController *shopListVC = [[ShopListViewController alloc] init];
    shopListVC.categoryId = @"0";
    [self.navigationController pushViewController:shopListVC animated:YES];
}

#pragma mark 自定义方法
-(void)initViews{
    
//    cycleScrollView = [[SDCycleScrollView  alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 170)];//cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 170) imagesGroup:images
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height - TabBar_HEIGHT)];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = BACKGROUND_COLOR;
    mTableView.separatorColor = Separator_Color;
    mTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:mTableView];
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    
    mTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        curpage = 0;
        allGoodsNum = 0;
        downNum = 1;
        shopInfoArray = [[NSMutableArray alloc] init];
        [self getIndexLunbo];
        [weakSelf initData];
    }];
    
    // 马上进入刷新状态
    [mTableView.mj_header beginRefreshing];
    
    // 上拉刷新
    mTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf initData];
        [mTableView.mj_footer endRefreshing];
    }];
    
    
    
}

//-(void)initData{
//    [dataProvider setDelegateObject:self setBackFunctionName:@"getShopListCallBack:"];
//    [dataProvider GetRecomendCategoryAndProduct:@"0" andmaximumRows:@"3" anduserId:get_sp(@"id") andproductNum:@"5"];
//}
//
//-(void)getShopListCallBack:(id)dict{
//    //[mTableView.mj_header endRefreshing];
//    if ([dict[@"code"] intValue] == 200) {
//        NSArray *tempGoodsArray = [[NSArray alloc] initWithArray:dict[@"data"]];
//        for (int i = 0; i < tempGoodsArray.count; i++) {
//            NSArray *goodsArrayList = [[NSArray alloc] initWithArray:[tempGoodsArray[i] valueForKey:@"ProductList"]];
//            if (goodsArrayList.count > 0) {
//                [shopInfoArray addObject:tempGoodsArray[i]];
//            }else{
//                allGoodsNum++;
//            }
//        }
//        [mTableView reloadData];
//    }
//}
-(void)initData{
    [dataProvider setDelegateObject:self setBackFunctionName:@"getShopListFootCallBack:"];
    [dataProvider GetRecomendCategoryAndProduct:[NSString stringWithFormat:@"%d",curpage * 3] andmaximumRows:@"3" anduserId:get_sp(@"id") andproductNum:@"5"];
    
    
}

-(void)getIndexLunbo
{
    [self.LunboArr removeAllObjects];
    DataProvider *dataprovide = [[DataProvider alloc] init];
    [dataprovide setDelegateObject:self setBackFunctionName:@"getindexLunboCallback:"];
    [dataprovide getIndexLunbo];
}

-(void)getindexLunboCallback:(id)dict
{
    DLog(@"%@",dict);
    
    if([dict[@"code"] intValue] == 200)
    {
        [self.LunboArr addObjectsFromArray:dict[@"data"]];
        
        
        NSMutableArray *images = [[NSMutableArray alloc] init];
        if (self.LunboArr.count > 0) {
            for (int i=0; i<self.LunboArr.count; i++) {
                UIImageView * img=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 170)];
                NSString *imgpath = [self.LunboArr[i] valueForKey:@"Path"];
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
        cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 170) imagesGroup:images ];
//        cycleScrollView.imagesGroup = images;
        
        [mTableView reloadData];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"轮播图获取失败"];
    }
}


-(void)getShopListFootCallBack:(id)dict{
    // 结束刷新
    [mTableView.mj_header endRefreshing];
    [mTableView.mj_footer endRefreshing];
    if ([dict[@"code"] intValue] == 200) {
        NSArray * arrayitem=[[NSArray alloc] init];
        arrayitem=dict[@"data"];
        for (id item in arrayitem) {
            NSArray *goodsArrayList = [[NSArray alloc] initWithArray:[item valueForKey:@"ProductList"]];
            if (goodsArrayList.count > 0) {
                [shopInfoArray addObject:item];
            }else{
                allGoodsNum++;
            }
        }
        if(shopInfoArray.count >= ([dict[@"recordcount"] intValue] - allGoodsNum) )
        {
            [mTableView.mj_footer setState:MJRefreshStateNoMoreData];
        }else{
            if (shopInfoArray.count < 3 * downNum) {
                [mTableView.mj_footer beginRefreshing];
            }else{
                downNum++;
            }
        }
    }
    curpage++;
    [mTableView reloadData];
}

-(void)jumpPage:(UIButton *)btn{
    switch (btn.tag) {
        case 1:{
            ClassificationViewController *classificationVC = [[ClassificationViewController alloc] init];
            [self.navigationController pushViewController:classificationVC animated:YES];
        }
            break;
        case 2:{
//            RecommendGoodsViewController *recommendGoodsVC = [[RecommendGoodsViewController alloc] init];
//            [self.navigationController pushViewController:recommendGoodsVC animated:YES];
            ShopListViewController *shopListVC = [[ShopListViewController alloc] init];
            [shopListVC setShopListType:Mode_RecommendShop];
            shopListVC.categoryId = @"0";
            shopListVC.isRecommend = @"1";
            [self.navigationController pushViewController:shopListVC animated:YES];
        }
            break;
        case 3:{
            OrderMainViewController *orderViewCtl = [[OrderMainViewController alloc] init];
            orderViewCtl.navtitle = @"我的订单";
            [orderViewCtl setBillType:Mode_Normal];
            [self.navigationController pushViewController:orderViewCtl animated:YES];
        }
            break;
        case 4:{
            ShoppingCartViewController *shoppingCart = [[ShoppingCartViewController alloc] init];
            shoppingCart.navtitle = @"购物车";
            [self.navigationController pushViewController:shoppingCart animated:YES];
        }
            break;
        default:
            break;
    }
}
#pragma mark -  self property

-(NSMutableArray*)LunboArr
{
    if (_LunboArr == nil) {
        _LunboArr = [NSMutableArray array];
    }
    
    return _LunboArr;
}

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"%@",self.LunboArr);
    ShopDetailViewController *shopDetailVC = [[ShopDetailViewController alloc] init];
    shopDetailVC.goodsId = self.LunboArr[index][@"ProductId"];
    [self.navigationController pushViewController:shopDetailVC animated:YES];
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 + shopInfoArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }else{
        return 1 + [[NSArray alloc] initWithArray:[shopInfoArray[section - 1] valueForKey:@"ProductList"]].count;
    }
}

#pragma mark setting for section
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section > 0) {
        UIView *mView = [[UIView alloc] init];
        mView.backgroundColor = BACKGROUND_COLOR;
        return mView;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section > 0) {
        return 4;
    }else{
        return 0;
    }
}


#pragma mark setting for cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        cell.backgroundColor = ItemsBaseColor;
//        UIImageView *mIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 170)];
//        [mIv sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"store_head_bg"]];
//        [cell addSubview:mIv];

       
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        cycleScrollView.autoScrollTimeInterval = 5;
        cycleScrollView.delegate = self;
        cycleScrollView.tag = indexPath.row;
        [cell addSubview:cycleScrollView];
        
        //menu
        CGFloat mWidth = SCREEN_WIDTH / 4;
        CGFloat mOriginY =(0+170);// mIv.frame.origin.y + mIv.frame.size.height;
        
        UIButton *allClassBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, mOriginY, mWidth, 60)];
        allClassBtn1.tag = 1;
        [allClassBtn1 addTarget:self action:@selector(jumpPage:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:allClassBtn1];
        
        UIImageView *allClassIv = [[UIImageView alloc] initWithFrame:CGRectMake((mWidth - 30) / 2, 5, 30, 30)];
        allClassIv.image = [UIImage imageNamed:@"allclass"];
        [allClassBtn1 addSubview:allClassIv];
        
        UILabel *allClassLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, allClassIv.frame.origin.y + allClassIv.frame.size.height + 2, mWidth, 21)];
        allClassLbl.textAlignment = NSTextAlignmentCenter;
        allClassLbl.textColor = [UIColor whiteColor];
        allClassLbl.font = [UIFont systemFontOfSize:14];
        allClassLbl.text = @"全部分类";
        [allClassBtn1 addSubview:allClassLbl];
        
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(mWidth, 5, 1, 50)];
        lineView1.backgroundColor = [UIColor colorWithRed:0.25 green:0.26 blue:0.27 alpha:1];
        [allClassBtn1 addSubview:lineView1];
        
        UIButton *recommendGoodsBtn = [[UIButton alloc] initWithFrame:CGRectMake(mWidth, mOriginY, mWidth, 60)];
        recommendGoodsBtn.tag = 2;
        [recommendGoodsBtn addTarget:self action:@selector(jumpPage:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:recommendGoodsBtn];
        
        UIImageView *recommendGoodsIv = [[UIImageView alloc] initWithFrame:CGRectMake((mWidth - 30) / 2, 5, 30, 30)];
        recommendGoodsIv.image = [UIImage imageNamed:@"recommend_goods"];
        [recommendGoodsBtn addSubview:recommendGoodsIv];
        
        UILabel *recommendGoodsLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, allClassIv.frame.origin.y + allClassIv.frame.size.height + 2, mWidth, 21)];
        recommendGoodsLbl.textAlignment = NSTextAlignmentCenter;
        recommendGoodsLbl.textColor = [UIColor whiteColor];
        recommendGoodsLbl.font = [UIFont systemFontOfSize:14];
        recommendGoodsLbl.text = @"推荐商品";
        [recommendGoodsBtn addSubview:recommendGoodsLbl];
        
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(mWidth, 5, 1, 50)];
        lineView2.backgroundColor = [UIColor colorWithRed:0.25 green:0.26 blue:0.27 alpha:1];
        [recommendGoodsBtn addSubview:lineView2];
        
        UIButton *myOrderBtn = [[UIButton alloc] initWithFrame:CGRectMake(mWidth * 2, mOriginY, mWidth, 60)];
        myOrderBtn.tag = 3;
        [myOrderBtn addTarget:self action:@selector(jumpPage:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:myOrderBtn];
        
        UIImageView *myOrderIv = [[UIImageView alloc] initWithFrame:CGRectMake((mWidth - 30) / 2, 5, 30, 30)];
        myOrderIv.image = [UIImage imageNamed:@"myorder"];
        [myOrderBtn addSubview:myOrderIv];
        
        UILabel *myOrderLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, allClassIv.frame.origin.y + allClassIv.frame.size.height + 2, mWidth, 21)];
        myOrderLbl.textAlignment = NSTextAlignmentCenter;
        myOrderLbl.textColor = [UIColor whiteColor];
        myOrderLbl.font = [UIFont systemFontOfSize:14];
        myOrderLbl.text = @"我的订单";
        [myOrderBtn addSubview:myOrderLbl];
        
        UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(mWidth, 5, 1, 50)];
        lineView3.backgroundColor = [UIColor colorWithRed:0.25 green:0.26 blue:0.27 alpha:1];
        [myOrderBtn addSubview:lineView3];
        
        UIButton *shoppingCarBtn = [[UIButton alloc] initWithFrame:CGRectMake(mWidth * 3, mOriginY, mWidth, 60)];
        shoppingCarBtn.tag = 4;
        [shoppingCarBtn addTarget:self action:@selector(jumpPage:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:shoppingCarBtn];
        
        UIImageView *shoppingCarIv = [[UIImageView alloc] initWithFrame:CGRectMake((mWidth - 30) / 2, 5, 30, 30)];
        shoppingCarIv.image = [UIImage imageNamed:@"shopping_car"];
        [shoppingCarBtn addSubview:shoppingCarIv];
        
        UILabel *shoppingCarLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, allClassIv.frame.origin.y + allClassIv.frame.size.height + 2, mWidth, 21)];
        shoppingCarLbl.textAlignment = NSTextAlignmentCenter;
        shoppingCarLbl.textColor = [UIColor whiteColor];
        shoppingCarLbl.font = [UIFont systemFontOfSize:14];
        shoppingCarLbl.text = @"购物车";
        [shoppingCarBtn addSubview:shoppingCarLbl];
        
        return cell;
    }else{
        NSLog(@"%@",shopInfoArray);
        if (!shopInfoArray || shopInfoArray.count <= 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
            return cell;
        }
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
            cell.backgroundColor = ItemsBaseColor;
            UILabel *mLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, cell.frame.size.width, cell.frame.size.height)];
            mLabel.textAlignment = NSTextAlignmentLeft;
            mLabel.font = [UIFont systemFontOfSize:14];
            mLabel.textColor = [UIColor whiteColor];
            mLabel.text = [Toolkit judgeIsNull:[shopInfoArray[indexPath.section - 1] valueForKey:@"Name"]];
            [cell addSubview:mLabel];
            return cell;
        }else{
            NSString *CellIdentifier = @"ShopCellIdentifier";
            ShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ShopTableViewCell" owner:self options:nil] objectAtIndex:0];
                cell.backgroundColor = ItemsBaseColor;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            NSArray *productListArray = [shopInfoArray[indexPath.section - 1] valueForKey:@"ProductList"];
            NSString *url = [NSString stringWithFormat:@"%@%@",Url,[productListArray[indexPath.row - 1] valueForKey:@"ImagePath"]];
            [cell.mImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"KongFuStoreProduct"]];
            cell.mName.text = [Toolkit judgeIsNull:[productListArray[indexPath.row - 1] valueForKey:@"Name"]];
            cell.mPrice.text = [NSString stringWithFormat:@"¥%@",[Toolkit judgeIsNull:[productListArray[indexPath.row - 1] valueForKey:@"Price"]]];
            cell.watchNum.text = [NSString stringWithFormat:@"%@人",[Toolkit judgeIsNull:[productListArray[indexPath.row - 1] valueForKey:@"VisitNum"]]];
            cell.salesNum.text = [NSString stringWithFormat:@"销量:%@",[Toolkit judgeIsNull:[productListArray[indexPath.row - 1] valueForKey:@"SaleNum"]]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 170 + 60;
    }else{
        if (indexPath.row == 0) {
            return 45;
        }else{
            return 70;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [mTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section > 0 && indexPath.row > 0) {
        [mTableView deselectRowAtIndexPath:indexPath animated:YES];
        ShopDetailViewController *shopDetailVC = [[ShopDetailViewController alloc] init];
        shopDetailVC.goodsId = [[shopInfoArray[indexPath.section - 1] valueForKey:@"ProductList"][indexPath.row - 1] valueForKey:@"Id"];
        [self.navigationController pushViewController:shopDetailVC animated:YES];
    }
}

@end
