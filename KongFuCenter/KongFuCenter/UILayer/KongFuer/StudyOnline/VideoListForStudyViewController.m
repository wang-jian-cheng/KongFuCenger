//
//  VideoListForStudyViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/7.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "VideoListForStudyViewController.h"
#import "BaseVideoCollectionViewCell.h"
#import "VideoDetialSecondViewController.h"
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
    layout.minimumLineSpacing = 10.0;
    layout.minimumInteritemSpacing = 5.0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;//设置collection
    
    //  layout.itemSize = CGSizeMake(318, 286);
    
//    layout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
    
    
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
        [mainCollectionView.mj_footer setState:MJRefreshStateIdle];
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
    
    
    if([get_sp(@"IsPay") isEqualToString:@"1"])
    {
        [self getVipTime];
    }
//    mainCollectionView.mj_footer.automaticallyRefresh=NO;
    
}

#pragma mark - self data source


-(void)getVipTime
{
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getVipTimeCallBack:"];
    [dataProvider getVipTime:[Toolkit getUserID]];
}
-(void)getVipTimeCallBack:(id)dict
{
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try {
            if([dict[@"data"][@"IsPay"] intValue] == 0)
            {
                set_sp(@"IsPay", @"0");
            }
            else
            {
                set_sp(@"IsPay", @"1");
                overTime = dict[@"data"][@"OverTime"];
                ServerTime= dict[@"data"][@"ServerTime"];
                
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *overdate = [formatter dateFromString:overTime];
                NSDate *ServerTimeDate = [formatter dateFromString:ServerTime];
                
                NSTimeInterval over = [overdate timeIntervalSince1970];
                NSTimeInterval server = [ServerTimeDate timeIntervalSince1970];
                
                if(server > over)
                {
                    set_sp(@"IsPay", @"0");
//                    isPayLab.text= @"成为会员";
                    DataProvider *dataProvider = [[DataProvider alloc] init];
                    [dataProvider setDelegateObject:self setBackFunctionName:@"closeVipCallBack:"];
                    [dataProvider closeVip:[Toolkit getUserID]];
                    return;
                }
                
            }
            
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

-(void)closeVipCallBack:(id)dict
{
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
    DLog(@"%@",dict);
    
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
            
            if(videoArray.count >= [dict[@"recordcount"] intValue])
            {
                [mainCollectionView.mj_footer setState:MJRefreshStateNoMoreData];
            }
            
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
        
        cell.date.text=[self GettitleForDate:[videoArray[indexPath.row][@"PublishTime"] isEqual:[NSNull null]]?@"":videoArray[indexPath.row][@"PublishTime"]];
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
    
 
//    if([videoArray[indexPath.row][@"isFree"] intValue] == 0)
//    {
//        if([Toolkit isVip] == NO)
//        {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"会员才可观看" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alertView show];
//           return;
//        }
//    }
//    if (videoArray[indexPath.row][@"UserId"]) {
//        <#statements#>
//    }
    VideoDetialSecondViewController *viewDetailViewCtl = [[VideoDetialSecondViewController alloc] init];
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
    
    return UIEdgeInsetsMake ( 0 , 0 , 0 , 0 );
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString *)GettitleForDate:(NSString *)dateStr
{
    @try {
        NSString * resultStr=@"";
        
        if (dateStr.length>0) {
            
            NSDate * nowDate=[NSDate date];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            NSDate *date = [dateFormatter dateFromString:dateStr];
            
            NSTimeInterval a_hour = 60*60;
            
            NSDate *other = [date addTimeInterval: a_hour];
            
            
            
            if ([nowDate compare:other]==NSOrderedDescending) {
                
                NSTimeInterval a_day = 24*60*60;
                
                NSDate *othersecond = [[self extractDate:date] addTimeInterval: a_day];
                if ([nowDate compare:othersecond]==NSOrderedDescending) {
                    if ([nowDate compare:[othersecond addTimeInterval:a_day]]==NSOrderedDescending) {
                        if ([nowDate compare:[[othersecond addTimeInterval:a_day] addTimeInterval:a_day] ]==NSOrderedDescending) {
                            [dateFormatter setDateFormat:@"MM月dd日"];
                            NSString *strHour = [dateFormatter stringFromDate:date];
                            return [NSString stringWithFormat:@"%@发布",strHour];
                        }
                        else
                        {
                            return @"前天发布";
                        }
                    }
                    else
                    {
                        return @"昨天发布";
                    }
                }
                else
                {
                    [dateFormatter setDateFormat:@"HH:mm"];
                    NSString *strHour = [dateFormatter stringFromDate:date];
                    return [NSString stringWithFormat:@"%@发布",strHour];
                }
            }
            else
            {
                return @"刚刚发布";
            }
        }
        
        return resultStr;
    }
    @catch (NSException *exception) {
        return @"";
    }
    @finally {
        
    }
}

- (NSDate *)extractDate:(NSDate *)date {
    if (!date) {
        date=[NSDate date];
    }
    //get seconds since 1970
    NSTimeInterval interval = [date timeIntervalSince1970];
    int daySeconds = 24 * 60 * 60;
    //calculate integer type of days
    NSInteger allDays = interval / daySeconds;

    return [NSDate dateWithTimeIntervalSince1970:allDays * daySeconds];
}

@end
