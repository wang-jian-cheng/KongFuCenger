//
//  ShopListViewController.m
//  KongFuCenter
//
//  Created by Rain on 16/1/22.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "ShopListViewController.h"
#import "ShopTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ShopDetailViewController.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"

@interface ShopListViewController (){
    UITableView *mTableView;
    DataProvider *dataProvider;
    int curpage;
    NSString *search;
    NSString *isPriceAsc;
    NSString *isSalesAsc;
    NSString *isCommentAsc;
    NSString *isNewAsc;
    NSString *isCredit;
//    NSString *isRecommend;
    NSArray *shopInfoArray;
    NSMutableArray *shopInfoArrayCopy;
    UITextField *searchTxt;
    //UIImageView *mIv1;
    UIImageView *mIvUp1;
    UIImageView *mIvDown1;
    UIImageView *mIvUp2;
    UIImageView *mIvDown2;
    UIImageView *mIv3;
    UIImageView *mIv4;
    BOOL searchFlag;
}

@end

@implementation ShopListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化参数
    self.view.backgroundColor = BACKGROUND_COLOR;
    if (_shopListType == Mode_NormalShop) {
        [self setBarTitle:@"商品列表"];
    }else{
        [self setBarTitle:@"推荐商品"];
    }
    [self addLeftButton:@"left"];
    
    dataProvider = [[DataProvider alloc] init];
    
    search = @"";
    isPriceAsc = @"0";
    isSalesAsc = @"2";
    isCommentAsc = @"0";
    isNewAsc = @"0";
    isCredit = @"0";
    
    //初始化View
    [self initViews];
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [searchTxt resignFirstResponder];
}

#pragma mark 自定义方法
-(void)initData{
    curpage = 0;
    searchFlag = NO;
    [dataProvider setDelegateObject:self setBackFunctionName:@"getShopListCallBack:"];
    [dataProvider SelectProductBySearch:@"0" andmaximumRows:@"10" andsearch:search andcategoryId:_categoryId andisPriceAsc:isPriceAsc andisSalesAsc:isSalesAsc andisCommentAsc:isCommentAsc andisNewAsc:isNewAsc andisCredit:isCredit andisRecommend:self.isRecommend];
}


//-(void)setIsRecommend:(NSString *)isRecommend
//{
//    _isRecommend = isRecommend;
//}

-(NSString*)isRecommend
{
    if(_isRecommend == nil || _isRecommend.length == 0)
    {
        _isRecommend = @"0";
    }
    return _isRecommend;
}


-(void)getShopListCallBack:(id)dict{
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue] == 200) {
        shopInfoArray = dict[@"data"];
        if(shopInfoArray.count >= [dict[@"recordcount"] intValue])
        {
            [mTableView.mj_footer setState:MJRefreshStateNoMoreData];
        }
        [mTableView reloadData];
    }
}

-(void)TeamFootRefresh{
    curpage++;
    searchFlag = NO;
//    searchTxt.text = @"";
    [dataProvider setDelegateObject:self setBackFunctionName:@"getShopListFootCallBack:"];
    [dataProvider SelectProductBySearch:[NSString stringWithFormat:@"%d",curpage * 10] andmaximumRows:@"10" andsearch:search andcategoryId:_categoryId andisPriceAsc:isPriceAsc andisSalesAsc:isSalesAsc andisCommentAsc:isCommentAsc andisNewAsc:isNewAsc andisCredit:isCredit andisRecommend:self.isRecommend];
}

-(void)getShopListFootCallBack:(id)dict{
    // 结束刷新
    [mTableView.mj_footer endRefreshing];
    NSMutableArray *itemarray=[[NSMutableArray alloc] initWithArray:shopInfoArray];
    if ([dict[@"code"] intValue] == 200) {
        NSArray * arrayitem=[[NSArray alloc] init];
        arrayitem=dict[@"data"];
        for (id item in arrayitem) {
            [itemarray addObject:item];
        }
        if(shopInfoArray.count >= [dict[@"recordcount"] intValue])
        {
            [mTableView.mj_footer setState:MJRefreshStateNoMoreData];
        }
        shopInfoArray=[[NSArray alloc] initWithArray:itemarray];
    }
    [mTableView reloadData];
}

-(void)initViews{
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + 8, SCREEN_WIDTH, 45)];
    searchView.backgroundColor = ItemsBaseColor;
    [self.view addSubview:searchView];
    searchTxt = [[UITextField alloc] initWithFrame:CGRectMake(14, 0, SCREEN_WIDTH - 28, 45)];
    searchTxt.returnKeyType = UIReturnKeySearch;
    searchTxt.delegate = self;
    searchTxt.textColor = [UIColor whiteColor];
    searchTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入产品名称" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.44 green:0.43 blue:0.44 alpha:1]}];
    UIImageView *searchIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 20)];
    searchIv.contentMode = UIViewContentModeScaleAspectFit;
    searchIv.image = [UIImage imageNamed:@"search"];
    searchTxt.leftView = searchIv;
    searchTxt.leftViewMode = UITextFieldViewModeAlways;
    [searchView addSubview:searchTxt];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, searchView.frame.origin.y + searchView.frame.size.height + 5, SCREEN_WIDTH, 45)];
    headView.backgroundColor = ItemsBaseColor;
    CGFloat mWidth = SCREEN_WIDTH / 4 - 5;
    UIButton *mBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, mWidth, 45)];
    mBtn1.titleLabel.font = [UIFont systemFontOfSize:16];
    [mBtn1 setTitle:@"销量" forState:UIControlStateNormal];
    [mBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    mBtn1.tag = 1;
    [mBtn1 addTarget:self action:@selector(sortReloadDataEvent:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:mBtn1];
    
    UIView *mIvView1 = [[UIView alloc] initWithFrame:CGRectMake(mWidth - 17, (45 - 17) / 2, 15, 17)];
    [headView addSubview:mIvView1];
    mIvUp1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 8)];
    mIvUp1.image = [UIImage imageNamed:@"store_shop_up"];
    [mIvView1 addSubview:mIvUp1];
    
    mIvDown1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 9, 15, 8)];
    mIvDown1.image = [UIImage imageNamed:@"store_shop_selectdown"];
    [mIvView1 addSubview:mIvDown1];
    UIButton *mIv1Btn = [[UIButton alloc] initWithFrame:mIvView1.frame];
    mIv1Btn.tag = 1;
    [mIv1Btn addTarget:self action:@selector(sortReloadDataEvent:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:mIv1Btn];
    
//    mIv1 = [[UIImageView alloc] initWithFrame:CGRectMake(mWidth - 17, (45 - 8) / 2, 15, 8)];
//    mIv1.image = [UIImage imageNamed:@"store_shop_selectdown"];
//    [headView addSubview:mIv1];
//    UIButton *mIv1Btn = [[UIButton alloc] initWithFrame:mIv1.frame];
//    mIv1Btn.tag = 1;
//    [mIv1Btn addTarget:self action:@selector(sortReloadDataEvent:) forControlEvents:UIControlEventTouchUpInside];
//    [headView addSubview:mIv1Btn];
    
    //------------------------------------------------------------
    
    UIButton *mBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(mWidth, 0, mWidth, 45)];
    mBtn2.titleLabel.font = [UIFont systemFontOfSize:16];
    [mBtn2 setTitle:@"价格" forState:UIControlStateNormal];
    [mBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    mBtn2.tag = 2;
    [mBtn2 addTarget:self action:@selector(sortReloadDataEvent:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:mBtn2];
//    mIv2 = [[UIImageView alloc] initWithFrame:CGRectMake(mWidth * 2 - 17, (45 - 8) / 2, 15, 8)];
//    mIv2.image = [UIImage imageNamed:@"store_shop_down"];
//    [headView addSubview:mIv2];
//    UIButton *mIv2Btn = [[UIButton alloc] initWithFrame:mIv2.frame];
//    mIv2Btn.tag = 2;
//    [mIv2Btn addTarget:self action:@selector(sortReloadDataEvent:) forControlEvents:UIControlEventTouchUpInside];
//    [headView addSubview:mIv2Btn];
    UIView *mIvView = [[UIView alloc] initWithFrame:CGRectMake(mWidth * 2 - 17, (45 - 17) / 2, 15, 17)];
    [headView addSubview:mIvView];
    mIvUp2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 8)];
    mIvUp2.image = [UIImage imageNamed:@"store_shop_up"];
    [mIvView addSubview:mIvUp2];
    mIvDown2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 9, 15, 8)];
    mIvDown2.image = [UIImage imageNamed:@"store_shop_down"];
    [mIvView addSubview:mIvDown2];
    UIButton *mIv2Btn = [[UIButton alloc] initWithFrame:mIvView.frame];
    mIv2Btn.tag = 2;
    [mIv2Btn addTarget:self action:@selector(sortReloadDataEvent:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:mIv2Btn];
    
    UIButton *mBtn3 = [[UIButton alloc] initWithFrame:CGRectMake(mWidth * 2, 0, mWidth, 45)];
    mBtn3.titleLabel.font = [UIFont systemFontOfSize:16];
    [mBtn3 setTitle:@"好评" forState:UIControlStateNormal];
    [mBtn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    mBtn3.tag = 3;
    [mBtn3 addTarget:self action:@selector(sortReloadDataEvent:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:mBtn3];
    mIv3 = [[UIImageView alloc] initWithFrame:CGRectMake(mWidth * 3 - 17, (45 - 8) / 2, 15, 8)];
    mIv3.image = [UIImage imageNamed:@"store_shop_down"];
    [headView addSubview:mIv3];
    UIButton *mIv3Btn = [[UIButton alloc] initWithFrame:mIv3.frame];
    mIv3Btn.tag = 3;
    [mIv3Btn addTarget:self action:@selector(sortReloadDataEvent:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:mIv3Btn];
    UIButton *mBtn4 = [[UIButton alloc] initWithFrame:CGRectMake(mWidth * 3, 0, mWidth, 45)];
    mBtn4.titleLabel.font = [UIFont systemFontOfSize:16];
    [mBtn4 setTitle:@"最新" forState:UIControlStateNormal];
    [mBtn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    mBtn4.tag = 4;
    [mBtn4 addTarget:self action:@selector(sortReloadDataEvent:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:mBtn4];
    mIv4 = [[UIImageView alloc] initWithFrame:CGRectMake(mWidth * 4 - 17, (45 - 8) / 2, 15, 8)];
    mIv4.image = [UIImage imageNamed:@"store_shop_down"];
    [headView addSubview:mIv4];
    UIButton *mIv4Btn = [[UIButton alloc] initWithFrame:mIv4.frame];
    mIv4Btn.tag = 4;
    [mIv4Btn addTarget:self action:@selector(sortReloadDataEvent:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:mIv4Btn];
    
    [self.view addSubview:headView];
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headView.frame.origin.y + headView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - (headView.frame.origin.y + headView.frame.size.height))];
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
        [weakSelf initData];
        [weakTv.mj_header endRefreshing];
    }];
    
    // 马上进入刷新状态
    [mTableView.mj_header beginRefreshing];
    
    // 上拉刷新
    mTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf TeamFootRefresh];
        [mTableView.mj_footer endRefreshing];
    }];
}

-(void)sortReloadDataEvent:(UIButton *)btn{
    switch (btn.tag) {
        case 1:{
            isPriceAsc = @"0";
            mIvUp2.image = [UIImage imageNamed:@"store_shop_up"];
            mIvDown2.image = [UIImage imageNamed:@"store_shop_down"];
            
            isCommentAsc = @"0";
            mIv3.image = [UIImage imageNamed:@"store_shop_down"];
            
            isNewAsc = @"0";
            mIv4.image = [UIImage imageNamed:@"store_shop_down"];
            if ([isSalesAsc isEqual:@"2"]) {
                isSalesAsc = @"1";
                mIvUp1.image = [UIImage imageNamed:@"store_shop_selectup"];
                mIvDown1.image = [UIImage imageNamed:@"store_shop_down"];
            }else{
                isSalesAsc = @"2";
                mIvUp1.image = [UIImage imageNamed:@"store_shop_up"];
                mIvDown1.image = [UIImage imageNamed:@"store_shop_selectdown"];
            }
        }
            break;
        case 2:{
            isSalesAsc = @"0";
            mIvUp1.image = [UIImage imageNamed:@"store_shop_up"];
            mIvDown1.image = [UIImage imageNamed:@"store_shop_down"];
            
            isCommentAsc = @"0";
            mIv3.image = [UIImage imageNamed:@"store_shop_down"];
            
            isNewAsc = @"0";
            mIv4.image = [UIImage imageNamed:@"store_shop_down"];
            if ([isPriceAsc isEqual:@"2"]) {
                isPriceAsc = @"1";
                mIvUp2.image = [UIImage imageNamed:@"store_shop_selectup"];
                mIvDown2.image = [UIImage imageNamed:@"store_shop_down"];
            }else{
                isPriceAsc = @"2";
                mIvUp2.image = [UIImage imageNamed:@"store_shop_up"];
                mIvDown2.image = [UIImage imageNamed:@"store_shop_selectdown"];
            }
        }
            break;
        case 3:{
            isSalesAsc = @"0";
            mIvUp1.image = [UIImage imageNamed:@"store_shop_up"];
            mIvDown1.image = [UIImage imageNamed:@"store_shop_down"];
            
            isPriceAsc = @"0";
            mIvUp2.image = [UIImage imageNamed:@"store_shop_up"];
            mIvDown2.image = [UIImage imageNamed:@"store_shop_down"];
            
            isNewAsc = @"0";
            mIv4.image = [UIImage imageNamed:@"store_shop_down"];
            if ([isCommentAsc isEqual:@"2"]) {
                isCommentAsc = @"1";
                mIv3.image = [UIImage imageNamed:@"store_shop_down"];
            }else{
                isCommentAsc = @"2";
                mIv3.image = [UIImage imageNamed:@"store_shop_selectdown"];
            }
        }
            break;
        case 4:{
            isSalesAsc = @"0";
            mIvUp1.image = [UIImage imageNamed:@"store_shop_up"];
            mIvDown1.image = [UIImage imageNamed:@"store_shop_down"];
            
            isPriceAsc = @"0";
            mIvUp2.image = [UIImage imageNamed:@"store_shop_up"];
            mIvDown2.image = [UIImage imageNamed:@"store_shop_down"];
            
            isCommentAsc = @"0";
            mIv3.image = [UIImage imageNamed:@"store_shop_down"];
            if ([isNewAsc isEqual:@"2"]) {
                isNewAsc = @"1";
                mIv4.image = [UIImage imageNamed:@"store_shop_down"];
            }else{
                isNewAsc = @"2";
                mIv4.image = [UIImage imageNamed:@"store_shop_selectdown"];
            }
        }
            break;
            
        default:
            break;
    }
    [mTableView.mj_header beginRefreshing];
}

-(void)searchData:(NSString *)searchStr{
//    DLog(@"%@",shopInfoArray);
//    shopInfoArrayCopy = [[NSMutableArray alloc] init];
//    if (![searchStr isEqual:@""]) {
//        searchFlag = YES;
//        for (int i = 0; i < shopInfoArray.count; i++) {
//            NSString *name = shopInfoArray[i][@"Name"];
//            
//            if ([name containsString:searchStr]) {
//                [shopInfoArrayCopy addObject:shopInfoArray[i]];
//            }
//        }
//    }else{
//        searchFlag = YES;
//        shopInfoArrayCopy = [[NSMutableArray alloc] initWithArray:shopInfoArray];
//    }
//    [mTableView reloadData];
    search = searchStr;
    [mTableView.mj_header beginRefreshing];
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (!searchFlag) {
//        return shopInfoArray.count;
//    }else{
//        return shopInfoArrayCopy.count;
//    }
    
    return shopInfoArray.count;
}

#pragma mark setting for section
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    return view;
}

#pragma mark setting for cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"ShopCellIdentifier";
    ShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ShopTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.backgroundColor = ItemsBaseColor;
    }
    if (!searchFlag) {
        NSString *url = [NSString stringWithFormat:@"%@%@",Url,[Toolkit judgeIsNull:[shopInfoArray[indexPath.row] valueForKey:@"ImagePath"]]];
        [cell.mImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"KongFuStoreProduct"]];
        cell.mName.text = [Toolkit judgeIsNull:[shopInfoArray[indexPath.row] valueForKey:@"Name"]];
        cell.mPrice.text = [NSString stringWithFormat:@"¥%.02f",[[Toolkit judgeIsNull:[shopInfoArray[indexPath.row] valueForKey:@"Price"]] floatValue]];
        cell.watchNum.text = [NSString stringWithFormat:@"%@人",[Toolkit judgeIsNull:[shopInfoArray[indexPath.row] valueForKey:@"VisitNum"]]];
        cell.salesNum.text = [NSString stringWithFormat:@"销量:%@",[Toolkit judgeIsNull:[shopInfoArray[indexPath.row] valueForKey:@"SaleNum"]]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
//        NSString *url = [NSString stringWithFormat:@"%@%@",Url,[Toolkit judgeIsNull:[shopInfoArrayCopy[indexPath.row] valueForKey:@"ImagePath"]]];
//        [cell.mImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"KongFuStoreProduct"]];
//        cell.mName.text = [Toolkit judgeIsNull:[shopInfoArrayCopy[indexPath.row] valueForKey:@"Name"]];
//        cell.mPrice.text = [NSString stringWithFormat:@"¥%.02f",[[Toolkit judgeIsNull:[shopInfoArrayCopy[indexPath.row] valueForKey:@"Price"]] floatValue]];
//        cell.watchNum.text = [NSString stringWithFormat:@"%@人",[Toolkit judgeIsNull:[shopInfoArrayCopy[indexPath.row] valueForKey:@"VisitNum"]]];
//        cell.salesNum.text = [NSString stringWithFormat:@"销量:%@",[Toolkit judgeIsNull:[shopInfoArrayCopy[indexPath.row] valueForKey:@"SaleNum"]]];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [mTableView deselectRowAtIndexPath:indexPath animated:YES];
    ShopDetailViewController *shopDetailVC = [[ShopDetailViewController alloc] init];
    shopDetailVC.goodsId = [Toolkit judgeIsNull:[shopInfoArray[indexPath.row] valueForKey:@"Id"]];
    [self.navigationController pushViewController:shopDetailVC animated:YES];
}

#pragma mark - textfield delegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
//    provinceCode = @"0";
//    cityCode = @"0";
//    countryCode = @"0";
//    selectAge = 0;
//    selectSex = 0;
//    [self TeamTopRefresh];
    [self searchData:searchTxt.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
