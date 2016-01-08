//
//  UnionNewsViewController.m
//  KongFuCenter
//
//  Created by Rain on 15/12/12.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "UnionNewsViewController.h"
#import "UnionNewsCell.h"
#import "model_UnionNew.h"


@interface UnionNewsViewController (){
    
    //datatable
    UITableView *mTableView;
    CGFloat mCellHeight;
    
    //data
    NSMutableArray *menuArray;
    
    //view
    UIImageView *menuImgView;
    
    NSMutableArray *newArr;
}

@property (nonatomic, strong) NSMutableArray * arr_title;


@end

@implementation UnionNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化参数
    //self.view.backgroundColor = BACKGROUND_COLOR;
    mCellHeight = SCREEN_HEIGHT / 6;
    newArr = [NSMutableArray array];
    [self setBarTitle:@"联盟动态"];
    [self addLeftButton:@"left"];

    
    [self getUnionCates];
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

#pragma mark 自定义方法
-(void)initDatas{
    
   // [self getUnionCates];
    
    menuArray = [[NSMutableArray alloc] init];
    NSMutableArray * title = [[NSMutableArray alloc] init];
    for (model_UnionNew * model in self.arr_title) {
        
        [title addObject:model.Name];
        
    }
    model_UnionNew *model = self.arr_title[0];
    [menuArray addObjectsFromArray:title];
  //  DLog(@"%@",self.arr_title);
     _cateId =[NSString stringWithFormat:@"%@",model.Id] ;
//    [menuArray addObjectsFromArray:@[@"公益慈善",@"交流活动",@"技术培训",@"全国巡演"]];
}

-(void)initViews{
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, 44)];
    menuImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btnFlag"]];
    pageSize = 10;
    menuImgView.contentMode = UIViewContentModeScaleAspectFit;
    menuView.backgroundColor = ItemsBaseColor;
    CGFloat everyMenuWidth = SCREEN_WIDTH / menuArray.count;
    for (int i = 0; i < menuArray.count; i++) {
        UIButton *btnMenu = [[UIButton alloc] initWithFrame:CGRectMake(i * everyMenuWidth, 0, everyMenuWidth , menuView.frame.size.height)];
        if (i == 0) {
            btnMenu.selected = YES;
            menuImgView.frame = CGRectMake((btnMenu.frame.size.width - 15) / 2, btnMenu.frame.size.height - 14, 15, 10);
            [btnMenu addSubview:menuImgView];
        }
        btnMenu.titleLabel.font = [UIFont systemFontOfSize:14];
        [btnMenu setTitle:menuArray[i] forState:UIControlStateNormal];
    //    btnMenu.titleLabel.font = [UIFont systemFontOfSize:16];
        [btnMenu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnMenu setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        btnMenu.tag = i;
        [btnMenu addTarget:self action:@selector(clickBtnMenuEvent:) forControlEvents:UIControlEventTouchUpInside];
        [menuView addSubview:btnMenu];
    }
    [self.view addSubview:menuView];
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height + 44, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height - 44)];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = BACKGROUND_COLOR;
    mTableView.separatorColor = Separator_Color;
    mTableView.tableFooterView = [[UIView alloc] init];
    
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    mTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageNo=0;
        
        if(newArr != nil && newArr.count)
        {
            [newArr removeAllObjects];
        }
        [weakSelf getUnionNewsDetail:_cateId];
        // 结束刷新
        [mTableView.mj_header endRefreshing];
    }];
    [mTableView.mj_header beginRefreshing];
    
    // 上拉刷新
    mTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf FooterRefresh];
        [mTableView.mj_footer endRefreshing];
    }];
    
    
    [self.view addSubview:mTableView];



}



-(void)clickBtnMenuEvent:(UIButton *)btnMenu{
    for (UIView *view in btnMenu.superview.subviews) {
        ((UIButton *)view).selected = NO;
    }
    menuImgView.frame = CGRectMake((btnMenu.frame.size.width - 15) / 2, btnMenu.frame.size.height - 14, 15, 10);
    [btnMenu addSubview:menuImgView];
    btnMenu.selected = YES;
    
    model_UnionNew * model = self.arr_title[btnMenu.tag];
    _cateId = model.Id;
    pageNo = 0;
    [mTableView.mj_header beginRefreshing];
    
}
#pragma mark - self data source


-(void)FooterRefresh
{
    [self getUnionNewsDetail:_cateId];
}
-(void)getUnionNewsDetail:(NSString *)cateId
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider growCateid:cateId andStartRowIndex:[NSString stringWithFormat:@"%d",pageSize*pageNo] andMaximumRows:[NSString stringWithFormat:@"%d",pageSize]];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetUnionNewDetailCallBack:"];
}

-(void)GetUnionNewDetailCallBack:(id)dict
{
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try
        {
            pageNo ++;
            [newArr addObjectsFromArray:dict[@"data"]];
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
            [mTableView reloadData];
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


-(void)getUnionCates
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"getUnionNewsCateCallback:"];
    [dataprovider getUnionNewsCate];
}

-(void)getUnionNewsCateCallback:(id)dict
{
    [SVProgressHUD dismiss];
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try {
            
            NSArray * arr_1 = dict[@"data"];
            for (NSDictionary * dict in arr_1) {
                
                model_UnionNew * model = [[model_UnionNew alloc] init];
                
                [model setValuesForKeysWithDictionary:dict];
                
                [self.arr_title addObject:model];
            }
        }
        @catch (NSException *exception) {
           
    
        }
        @finally {
            [mTableView reloadData];
            //初始化数据
            [self initDatas];
            //初始化View
            [self initViews];
            
//            model_UnionNew * model = self.arr_title.firstObject;
//            
//            DataProvider * dataprovider=[[DataProvider alloc] init];
//            [dataprovider setDelegateObject:self setBackFunctionName:@"GetUnionNewDetailCallBack:"];
//            [dataprovider growCateid:model.Id andStartRowIndex:@"0" andMaximumRows:@"66"];
//            
            [SVProgressHUD dismiss];
        }
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"data"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        
    }

}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return newArr.count;
}

#pragma mark setting for section
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 2;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BACKGROUND_COLOR;
    return view;
}

#pragma mark setting for cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"UnionNewsCellIdentifier";
    UnionNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UnionNewsCell" owner:self options:nil] objectAtIndex:0];
        cell.backgroundColor = ItemsBaseColor;
    }
    
    
    @try {
        
        if(newArr == nil || newArr.count == 0 || newArr.count - 1 < indexPath.row)
        {
            return cell;
        }
        NSDictionary *tempDict = newArr[indexPath.row];
        
        cell.mImageView.image = [UIImage imageNamed:@"jhstory"];
        
        NSString *url = [NSString stringWithFormat:@"%@%@",Kimg_path,tempDict[@"ImagePath"]];
        [cell.mImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"jhstory"]];
        
        cell.mName.text = tempDict[@"Title"];
        cell.mDetail.text = tempDict[@"Content"];
        cell.mDate.text = [tempDict[@"PublishTime"] substringToIndex:10];
        cell.mReadNum.text = [NSString stringWithFormat:@"%@",tempDict[@"LikeNum"]];
        cell.mCollectionNum.text = [NSString stringWithFormat:@"%@",tempDict[@"FavoriteNum"]];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return mCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [mTableView deselectRowAtIndexPath:indexPath animated:YES];
    UnionNewsDetailViewController  *unionNew = [[UnionNewsDetailViewController alloc] init];
    unionNew.navtitle = @"联盟详情";
    unionNew.webId =[ NSString stringWithFormat:@"%@",newArr[indexPath.row][@"Id"]];
    unionNew.collectNum =[ NSString stringWithFormat:@"%@",newArr[indexPath.row][@"FavoriteNum"]];
    [self.navigationController pushViewController:unionNew animated:YES];
    
    
}

#pragma mark - 懒加载
- (NSMutableArray *)arr_title
{
    if(_arr_title == nil)
    {
        self.arr_title = [NSMutableArray array];
    }
    return _arr_title;
}

@end
