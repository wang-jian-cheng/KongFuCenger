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
}

@property (nonatomic, strong) NSMutableArray * arr_title;


@end

@implementation UnionNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化参数
    //self.view.backgroundColor = BACKGROUND_COLOR;
    mCellHeight = SCREEN_HEIGHT / 6;
    [self setBarTitle:@"联盟动态"];
    [self addLeftButton:@"left"];

    
    [self GetVideoDetial1];
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

#pragma mark - 解析数据
-(void)GetVideoDetialCallBack:(id)dict
{
    NSLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try
        {
            
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

//2--------2
-(void)GetVideoDetial1
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider getlianmengdongtai];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetVideoDetialCallBack1:"];
}
-(void)GetVideoDetialCallBack1:(id)dict
{
    NSLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try
        {
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
            
            model_UnionNew * model = self.arr_title.firstObject;
            
            DataProvider * dataprovider=[[DataProvider alloc] init];
            [dataprovider growCateid:model.Id andStartRowIndex:@"0" andMaximumRows:@"66"];
            [dataprovider setDelegateObject:self setBackFunctionName:@"GetVideoDetialCallBack:"];
            
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

#pragma mark 自定义方法
-(void)initDatas{
    
    [self getUnionCates];
    
    menuArray = [[NSMutableArray alloc] init];
    NSMutableArray * title = [[NSMutableArray alloc] init];
    for (model_UnionNew * model in self.arr_title) {
        
        [title addObject:model.Name];
        
    }
    [menuArray addObjectsFromArray:title];
//    [menuArray addObjectsFromArray:@[@"公益慈善",@"交流活动",@"技术培训",@"全国巡演"]];
}

-(void)initViews{
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, 44)];
    menuImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btnFlag"]];
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
        
        [btnMenu setTitle:menuArray[i] forState:UIControlStateNormal];
        btnMenu.titleLabel.font = [UIFont systemFontOfSize:16];
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
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider growCateid:model.Id andStartRowIndex:@"0" andMaximumRows:@"66"];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetVideoDetialCallBack:"];
    
}
#pragma mark - self data source

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

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
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
    cell.mImageView.image = [UIImage imageNamed:@"jhstory"];
    cell.mName.text = @"咏春拳公益巡回演出";
    cell.mDetail.text = @"咏春拳是最快的制敌拳法,公益巡回演出,让大家更好的理解咏春拳";
    cell.mDate.text = @"4月20日";
    cell.mReadNum.text = @"200";
    cell.mCollectionNum.text = @"100";
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return mCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [mTableView deselectRowAtIndexPath:indexPath animated:YES];
    UnionNewsDetailViewController  *unionNew = [[UnionNewsDetailViewController alloc] init];
    unionNew.navtitle = @"联盟详情";
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
