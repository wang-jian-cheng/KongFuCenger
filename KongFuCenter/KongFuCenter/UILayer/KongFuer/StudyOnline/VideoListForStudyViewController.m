//
//  VideoListForStudyViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/7.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "VideoListForStudyViewController.h"
#import "BaseVideoCollectionViewCell.h"
#import "VideoDetailViewController.h"
#import "DataProvider.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"


@interface VideoListForStudyViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSInteger _cellCollectionCount;
    UICollectionView *mainCollectionView;
    int pageNo;
    int pageSize;
    
    NSArray * videoArray;
}
@end

@implementation VideoListForStudyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
    videoArray=[[NSArray alloc] init];
    [self initViews];
    [self addLeftButton:@"left"];
    pageNo=0;
    pageSize=12;
    
    // Do any additional setup after loading the view.
}
-(void)GetVideoList
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    
    [dataprovider setDelegateObject:self setBackFunctionName:@"TopRefreshCallBack:"];
    
    [dataprovider getStudyOnlineVideoList:_categoryid andstartRowIndex:[NSString stringWithFormat:@"%d",pageNo*pageSize] andmaximumRows:[NSString stringWithFormat:@"%d",pageSize]];
}

-(void)initViews
{
     _cellCollectionCount = 6;
    [self initCollectionView];
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
    
    
    
    mainCollectionView = [[UICollectionView alloc]  initWithFrame:CGRectMake(0, Header_Height + 10, SCREEN_WIDTH , SCREEN_HEIGHT-( Header_Height + 10+10)) collectionViewLayout:layout];
    
    [layout setHeaderReferenceSize:CGSizeMake(mainCollectionView.frame.size.width, 0)];//暂不现实时间
    
    [mainCollectionView registerClass :[ UICollectionViewCell class ] forCellWithReuseIdentifier : @"BaseVideoCell" ];
    
    mainCollectionView.delegate= self;
    mainCollectionView.dataSource =self;
    mainCollectionView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*2);
    mainCollectionView.showsHorizontalScrollIndicator = YES;
    mainCollectionView.showsVerticalScrollIndicator = NO;
    mainCollectionView.backgroundColor = BACKGROUND_COLOR;
    
    [self.view addSubview:mainCollectionView];
    
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 下拉刷新
    mainCollectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageNo=0;
        [weakSelf GetVideoList];
        // 结束刷新
        [mainCollectionView.mj_header endRefreshing];
    }];
    [mainCollectionView.mj_header beginRefreshing];
    
    // 上拉刷新
    mainCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf FooterRefresh];
        [mainCollectionView.mj_footer endRefreshing];
    }];
    
    
    
    // 默认先隐藏footer
    mainCollectionView.mj_footer.hidden = YES;
    
//    mainCollectionView.mj_footer.automaticallyRefresh=NO;
    
}

-(void)TopRefreshCallBack:(id)dict
{
    NSLog(@"%@",dict);
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try {
            pageNo=1;
             videoArray= dict[@"data"];
            
            [mainCollectionView reloadData];
            
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
-(void)FooterRefresh
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    
    [dataprovider setDelegateObject:self setBackFunctionName:@"FooterRefreshCallBack:"];
    
    [dataprovider getStudyOnlineVideoList:_categoryid andstartRowIndex:[NSString stringWithFormat:@"%d",pageNo*pageSize] andmaximumRows:[NSString stringWithFormat:@"%d",pageSize]];
}

-(void)FooterRefreshCallBack:(id)dict
{
    NSLog(@"%@",dict);
    
    if ([dict[@"code"] intValue]==200) {
        @try {
            ++pageNo;
//            videoArray= dict[@"data"];
            NSArray * itemArray=[[NSArray alloc] initWithArray:dict[@"data"]];
            NSMutableArray * mutableArray=[[NSMutableArray alloc] initWithArray:videoArray];
            for (int i=0; i<itemArray.count; i++) {
                [mutableArray addObject:itemArray[i]];
            }
            videoArray=[[NSArray alloc] initWithArray:mutableArray];
            [mainCollectionView reloadData];
            
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


#pragma mark - UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数

-( NSInteger )collectionView:( UICollectionView *)collectionView numberOfItemsInSection:( NSInteger )section
{
    return videoArray.count;
    
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
    cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"BaseVideoCell"
                                                     forIndexPath:indexPath];

    
    
    @try {
        
        if(videoArray == nil || videoArray.count == 0 || videoArray.count - 1 < indexPath.row)
            return cell;
        
        if([videoArray[indexPath.row][@"isPay"] intValue ]==1)
            cell.free.hidden = YES;
        
        // Set up the reuse identifier
        
        [cell.img_logo sd_setImageWithURL:[NSURL URLWithString:[videoArray[indexPath.row][@"ImagePath"] isEqual:[NSNull null]]?@"":[NSString stringWithFormat:@"%@%@",Url,videoArray[indexPath.row][@"ImagePath"]]] placeholderImage:[UIImage imageNamed:@""]];
        [cell.btn_first setTitle:[NSString stringWithFormat:@"%@",[videoArray[indexPath.row][@"LikeNum"] isEqual:[NSNull null]]?@"":videoArray[indexPath.row][@"LikeNum"]] forState:UIControlStateNormal];
        [cell.btn_first setImage:[UIImage imageNamed:@"support"] forState:(UIControlStateNormal)];
        
        [cell.btn_second setTitle:[NSString stringWithFormat:@"%@",[videoArray[indexPath.row][@"FavoriteNum"] isEqual:[NSNull null]]?@"":videoArray[indexPath.row][@"FavoriteNum"]] forState:UIControlStateNormal];
        [cell.btn_second setImage:[UIImage imageNamed:@"collect"] forState:(UIControlStateNormal)];
        
        cell.lbl_title.text=[NSString stringWithFormat:@"%@",[videoArray[indexPath.row][@"Title"] isEqual:[NSNull null]]?@"":videoArray[indexPath.row][@"Title"]];
        cell.lbl_content.text=[NSString stringWithFormat:@"%@",[videoArray[indexPath.row][@"Content"] isEqual:[NSNull null]]?@"":videoArray[indexPath.row][@"Content"]];
        cell.backgroundColor = ItemsBaseColor;
        
        
        cell.select.hidden = YES;
        cell.btn_thrid.hidden = YES;
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        return cell;
  
    }

    
    
    
    
}



#pragma mark - UICollectionViewDelegate

//UICollectionView被选中时调用的方法

-( void )collectionView:( UICollectionView *)collectionView didSelectItemAtIndexPath:( NSIndexPath *)indexPath
{
    
 
    if([videoArray[indexPath.row][@"isFree"] intValue] == 0)
    {
        if([Toolkit isVip] == NO)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"会员才可观看" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
           return;
        }
    }
    VideoDetailViewController *viewDetailViewCtl = [[VideoDetailViewController alloc] init];
    viewDetailViewCtl.videoID=videoArray[indexPath.row][@"Id"];
//    NSLog(@"%@",videoArray[indexPath.row][@"Id"]);
    [self.navigationController pushViewController:viewDetailViewCtl animated:YES];
    
    
    NSLog(@"click cell");
    
    
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
-(NSString *)GettitleForDate:(NSString *)dateStr
{
    NSString * resultStr=@"";
    
    return resultStr;
}

@end
