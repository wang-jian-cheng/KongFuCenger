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


#define GapToLeft   20

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
    [self addRightButton:@"search"];
    pageNo=0;
    pageSize=12;
    
    // Do any additional setup after loading the view.
}



-(void)viewWillAppear:(BOOL)animated
{
    [self showFloatBtn];    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [self hiddenFloatnBtn];
}


-(void)GetVideoList
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    
    [dataprovider setDelegateObject:self setBackFunctionName:@"TopRefreshCallBack:"];
    
    [dataprovider getStudyOnlineVideoList:_categoryid andstartRowIndex:[NSString stringWithFormat:@"%d",pageNo*pageSize] andmaximumRows:[NSString stringWithFormat:@"%d",pageSize] andSearch:@""];
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
    
//    layout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
    
    
    layout.headerReferenceSize = CGSizeMake(320, 200);
    
    
    
    mainCollectionView = [[UICollectionView alloc]  initWithFrame:CGRectMake(0, Header_Height , SCREEN_WIDTH , SCREEN_HEIGHT-( Header_Height)) collectionViewLayout:layout];
    
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
-(void)clickRightButton:(UIButton *)sender
{
    SearchViewController *searchViewCtl = [[SearchViewController alloc] init];
    searchViewCtl.searchCate = StudyOnline_Search;
    searchViewCtl.subIDs = @[self.categoryid];
    [self.navigationController pushViewController:searchViewCtl animated:YES];
    
}

-(void)clickFloatBtn:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if(layoutType == DoubleRowMode)
    {
        layoutType = OneRowMode;
    }
    else
    {
        layoutType = DoubleRowMode;
    }
    [mainCollectionView reloadData];
    
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
    
    [dataprovider getStudyOnlineVideoList:_categoryid andstartRowIndex:[NSString stringWithFormat:@"%d",pageNo*pageSize] andmaximumRows:[NSString stringWithFormat:@"%d",pageSize] andSearch:@""];
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
    
#if 0
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

    
    
#else
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BaseVideoCell" forIndexPath:indexPath];
    
    if(cell != nil)
    {
        for (UIView *view in cell.subviews) {
            [view removeFromSuperview];
        }
    }
    UIView *lineView = [[UIView alloc] init];
    UILabel *titleLab = [[UILabel alloc] init] ;
    UIButton *relayBtn = [[UIButton alloc] init];
    UserHeadView *headView;
    
    UILabel *nameLab = [[UILabel alloc] init];
    UIButton *commentBtn = [[UIButton alloc] init];
    UIButton *timeBtn = [[UIButton alloc] init];
    
    UILabel *isFreeLab = [[UILabel alloc] init];
    isFreeLab.backgroundColor = YellowBlock;
    isFreeLab.frame = CGRectMake((cell.frame.size.width - 40 - 10), 5, 40, 20);
    isFreeLab.text = @"会员";
    isFreeLab.textAlignment = NSTextAlignmentCenter;
    isFreeLab.textColor = [UIColor whiteColor];
    [cell addSubview:isFreeLab];
    
    CGFloat fontsize;
    CGFloat lineHeight;
    if (layoutType == DoubleRowMode) {
        fontsize = 10;
        lineHeight = 30;
        
        
        isFreeLab.font = [UIFont systemFontOfSize:fontsize];
        lineView.frame =  CGRectMake(GapToLeft/2, (cell.frame.size.height - lineHeight), (cell.frame.size.width - GapToLeft/2), 1);
        lineView.backgroundColor = Separator_Color;
        [cell addSubview:lineView];
        //线上
        titleLab.frame = CGRectMake(GapToLeft/2, (lineView.frame.origin.y - 20), cell.frame.size.width - GapToLeft/2,20);
        
        titleLab.textColor = [UIColor whiteColor];
        titleLab.font = [UIFont boldSystemFontOfSize:(fontsize)];
        [cell addSubview:titleLab];
        
        //        relayBtn.frame = CGRectMake((cell.frame.size.width - 30 -10), (lineView.frame.origin.y - 30), 30, 30);
        
        //        [cell addSubview:relayBtn];
        
        //under line
        headView = [[UserHeadView alloc] initWithFrame:CGRectMake(5, lineView.frame.origin.y+(lineHeight - 25)/2, 25, 25) andImgName:@"me" andNav:(self.navigationController)];
        
        
        
        commentBtn.frame = CGRectMake((headView.frame.origin.x+headView.frame.size.width + 5),
                                      (headView.frame.size.height/4+headView.frame.origin.y),
                                      (cell.frame.size.width - (headView.frame.origin.x+headView.frame.size.width + 5))/2,
                                      headView.frame.size.height/2);
        commentBtn.titleLabel.font = [UIFont systemFontOfSize:fontsize];
        
        timeBtn.frame = CGRectMake((commentBtn.frame.origin.x+commentBtn.frame.size.width + 5),
                            (commentBtn.frame.origin.y),
                            (cell.frame.size.width - (headView.frame.origin.x+headView.frame.size.width + 5))/2,
                            commentBtn.frame.size.height);
        timeBtn.titleLabel.font = [UIFont systemFontOfSize:fontsize];
        
        [cell addSubview:commentBtn];
        [cell addSubview:timeBtn];
        
    }
    else
    {
        fontsize = 14;
        lineHeight = 50;
        lineView.frame =  CGRectMake(GapToLeft/2, (cell.frame.size.height - lineHeight), (SCREEN_WIDTH - GapToLeft/2), 1);
        lineView.backgroundColor = Separator_Color;
        [cell addSubview:lineView];
        //线上
        titleLab.frame = CGRectMake(GapToLeft, (lineView.frame.origin.y - 30), 200, 30);
        
        titleLab.textColor = [UIColor whiteColor];
        titleLab.font = [UIFont boldSystemFontOfSize:(fontsize+2)];
        [cell addSubview:titleLab];
        
        relayBtn.frame = CGRectMake((SCREEN_WIDTH - 30 -20), (lineView.frame.origin.y - 30), 30, 30);
        
        [cell addSubview:relayBtn];
        
        //under line
        headView = [[UserHeadView alloc] initWithFrame:CGRectMake(5, lineView.frame.origin.y+(lineHeight - 35)/2, 35, 35) andImgName:@"80" andNav:(self.navigationController)];
        
        nameLab.frame = CGRectMake((headView.frame.origin.x+headView.frame.size.width + 5),
                                   (headView.frame.size.height/4+headView.frame.origin.y), 100, headView.frame.size.height/2);
        
        nameLab.textColor = [UIColor whiteColor];
        nameLab.font = [UIFont systemFontOfSize:fontsize];
        
        commentBtn.frame = CGRectMake(((nameLab.frame.origin.x+nameLab.frame.size.width)),
                                      (headView.frame.size.height/4+headView.frame.origin.y),
                                      (SCREEN_WIDTH - (nameLab.frame.origin.x+nameLab.frame.size.width + 10) -10)/2,
                                      headView.frame.size.height/2);
        
        commentBtn.titleLabel.font = [UIFont systemFontOfSize:fontsize];
        
        timeBtn = [[UIButton alloc] initWithFrame:CGRectMake(((commentBtn.frame.origin.x+commentBtn.frame.size.width + 5)),
                                                             (headView.frame.size.height/4+headView.frame.origin.y),
                                                             commentBtn.frame.size.width+15,//(SCREEN_WIDTH - (nameLab.frame.origin.x+nameLab.frame.size.width + 10) -10)/2,
                                                             headView.frame.size.height/2)];
        timeBtn.titleLabel.font = [UIFont systemFontOfSize:fontsize];
        
        [cell addSubview:commentBtn];
        [cell addSubview:timeBtn];
        
        
    }
    
    //    NSLog(@"")
    
    NSDictionary *tempDict = videoArray[indexPath.row];
    cell.backgroundColor = ItemsBaseColor;
    UIImageView *backgroundView;
    
    if(layoutType == DoubleRowMode)
    {
        backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width , cell.frame.size.height - 50)];
    }
    else
    {
        backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width , cell.frame.size.height)];
    }
    
    [backgroundView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Url,tempDict[@"ImagePath"]]] placeholderImage:[UIImage imageNamed:@"temp2"]];
    
    //    backgroundView.image = [UIImage imageNamed:dataArr[indexPath.section][@""]];
    UIView *BackView = [[UIView alloc] initWithFrame:backgroundView.frame];
    [BackView addSubview:backgroundView];
    BackView.backgroundColor = ItemsBaseColor;
    
    cell.backgroundView = BackView;
    
    
    isFreeLab.hidden = [tempDict[@"IsFree"] intValue];
    
    {
        
        titleLab.text = tempDict[@"Title"];
        [relayBtn setImage:[UIImage imageNamed:@"relay"] forState:UIControlStateNormal];
        
        //under line
        headView.userId =[NSString stringWithFormat:@"%@",tempDict[@"UserId"]];
        if([headView.userId isEqualToString:@"0"])
        {
            [headView.headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Url,tempDict[@"PhotoPath"]]] placeholderImage:[UIImage imageNamed:@"80"]];
        }else
        {
            [headView.headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Url,tempDict[@"PhotoPath"]]] placeholderImage:[UIImage imageNamed:@"80"]];
        }
        [headView makeSelfRound];
        
        [cell addSubview:headView];
        
        
        
        
        nameLab.text = [tempDict[@"NicName"] isEqual:[NSNull null]]?@"":tempDict[@"NicName"];
        [cell addSubview:nameLab];
        
        
        
        
        [commentBtn setImage:[UIImage imageNamed:@"support"] forState:UIControlStateNormal];
        [commentBtn setImage:[UIImage imageNamed:@"support_h"] forState:UIControlStateSelected];
        [commentBtn setTitle:[NSString stringWithFormat:@"%@",[tempDict[@"LikeNum"] isEqual:[NSNull null]]?@"0":tempDict[@"LikeNum"]] forState:UIControlStateNormal];
        
        
        
        [timeBtn setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
        [timeBtn setImage:[UIImage imageNamed:@"collect_h"] forState:UIControlStateSelected];
        [timeBtn setTitle:NSStringFromFormat(@"%@",tempDict[@"FavoriteNum"]) forState:UIControlStateNormal];
        
    }

    return cell;
#endif
    
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
    
    if(layoutType == DoubleRowMode)
    {
        return CGSizeMake ( SCREEN_WIDTH/2-7.5 ,  SCREEN_WIDTH/2+10);
    }
    else
    {
        return CGSizeMake(SCREEN_WIDTH,(SCREEN_HEIGHT - Header_Height - TabBar_HEIGHT)/2 );
    }
    
}

//定义每个UICollectionView 的边距

-( UIEdgeInsets )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section
{
    //if()
    
    return UIEdgeInsetsMake ( 5 , 5 , 5 , 5 );
    
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
