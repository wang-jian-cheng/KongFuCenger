//
//  GrowHistoryViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/5.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "GrowHistoryViewController.h"

#define LineGap 30

@interface GrowHistoryViewController ()
{
#pragma mark - pram for tableView
    NSInteger _sectionNum;
    NSInteger _cellNum;
    CGFloat _cellHeight;
    UITableView *_mainTableView;
    
    
    BOOL EnditMode;
    NSMutableArray *cellBtnArr;
    
    NSMutableArray *growArr;
    NSMutableArray *rebuildGrowArr;
}
@end

@implementation GrowHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLeftButton:@"left"];
    [self addRightbuttontitle:@"编辑"];
    growArr = [NSMutableArray array];
    rebuildGrowArr = [NSMutableArray array];
    cellBtnArr = [NSMutableArray array];
    delArr = [NSMutableArray array];
    [self initViews];
    
    [self getDatas];
    // Do any additional setup after loading the view.
}


-(void)initViews
{
    _cellHeight = 200;
    _sectionNum = 1;
    
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height )];
    _mainTableView.backgroundColor = BACKGROUND_COLOR;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorColor =  Separator_Color;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    //_mainTableView.scrollEnabled = NO;
    pageSize = 10;
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    _mainTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
//        if(EnditMode ==YES)
//            return ;
        pageNo=0;
        if(growArr != nil&&growArr.count>0)
        {
            [growArr removeAllObjects];
        }
        if(rebuildGrowArr != nil&&rebuildGrowArr.count>0)
        {
            [rebuildGrowArr removeAllObjects];
        }
        
            [weakSelf getGrowHistory];
        // 结束刷新
        [_mainTableView.mj_header endRefreshing];
    }];
    [_mainTableView.mj_header beginRefreshing];
    
    // 上拉刷新
    _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//       if(EnditMode ==YES)
//           return;
        if(growArr != nil&&growArr.count>0)
        {
            [growArr removeAllObjects];
        }
        
        [weakSelf FooterRefresh];
        [_mainTableView.mj_footer endRefreshing];
    }];

    
    
    _mainTableView.contentSize = CGSizeMake(SCREEN_HEIGHT, _sectionNum*(_cellHeight));
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(LineGap, Header_Height, 1, SCREEN_HEIGHT - Header_Height)];
    lineView.backgroundColor = ItemsBaseColor;
    
    
    [self.view addSubview:_mainTableView];
    [self.view addSubview:lineView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}
#pragma mark - self data source



-(void)delVideos
{
    if (delArr.count == 0) {
        return;
    }
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"deleVideosCallBack:"];
    [dataprovider delVideo:delArr[deleCount]];
}

-(void)deleVideosCallBack:(id)dict
{
    // [SVProgressHUD dismiss];
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try {
            deleCount ++;
            if(deleCount >= delArr.count)
            {
                [SVProgressHUD dismiss];
                //[_mainTableView reloadData];
                [_mainTableView.mj_header beginRefreshing];
                [delArr removeAllObjects];
                deleCount = 0;
                
            }
            else
            {
                [self delVideos];
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:[dict[@"data"] substringToIndex:4] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        
    }
    
}

-(void)FooterRefresh
{
    [self getGrowHistory];
}

-(void)getGrowHistory
{
    [SVProgressHUD showWithStatus:@"刷新" maskType:SVProgressHUDMaskTypeBlack];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"getGrowHistoryCallBack:"];
    [dataprovider getGrowHistory:[Toolkit getUserID]
                andstartRowIndex:[NSString stringWithFormat:@"%d",pageNo*pageSize]
                  andmaximumRows:[NSString stringWithFormat:@"%d",pageSize]];
}

-(void)getGrowHistoryCallBack:(id)dict
{
    [SVProgressHUD dismiss];
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try {
            // NSDictionary *tempDict = dict[@"data"];
            pageNo++;
            
            [growArr addObjectsFromArray:dict[@"data"]];
            
            
            BOOL ishave = NO;
            for (int i = 0; i < growArr.count; i++) {
                ishave = NO;
                NSDictionary *tempGrowDict = growArr[i];
                for (int j = 0; j<rebuildGrowArr.count; j++) {
                    NSDictionary *tempDict = rebuildGrowArr[j];
                    if([[tempGrowDict[@"PublishTime"] substringToIndex:10] isEqualToString:tempDict[@"date"]])//存在该日期则插入
                    {
                        ishave = YES;
                        NSMutableArray *tempArr = [NSMutableArray array];
                        [tempArr addObjectsFromArray:tempDict[@"growHistory"]];
                        [tempArr addObject:tempGrowDict];
                        [tempDict setValue:tempArr forKey:@"growHistory"];
                        [rebuildGrowArr/*使用arr是为了保证时间顺序*/ replaceObjectAtIndex:j withObject:tempDict];
                        break;
                        
                    }
                }
                
                if(ishave == NO)//不存在则新建
                {
                    NSMutableDictionary *tempMutDict = [NSMutableDictionary dictionary];
                    [tempMutDict setValue:[tempGrowDict[@"PublishTime"] substringToIndex:10] forKey:@"date"];
                    NSMutableArray *tempArr = [NSMutableArray array];
                    [tempArr addObject:tempGrowDict];//先将dict加入到数组 然后再将临时数组加入到rebuildarr
                    [tempMutDict setObject:tempArr forKey:@"growHistory"];
                    [rebuildGrowArr addObject:tempMutDict];
                    
                }
  
            }
            
            NSLog(@"rebuildGrowArr = %@",rebuildGrowArr);
            NSLog(@"rebuildGrowArr count = %ld",rebuildGrowArr.count);
            [_mainTableView reloadData];
            
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
#pragma mark - Btn click 
-(void)clickRightButton:(UIButton *)sender
{
    if(EnditMode == NO)
    {
        [self addRightbuttontitle:@"删除"];
        EnditMode = YES;
    }
    else{
        [self delVideos];
        [self addRightbuttontitle:@"编辑"];
        EnditMode = NO;
    }
    [_mainTableView reloadData];
}

-(void)roundBtnClick:(UIButton *)sender
{
    sender.selected = ! sender.selected;
    NSDictionary *tempDict;
    tempDict =rebuildGrowArr[(sender.tag & 0xf0)>>4][@"growHistory"][sender.tag&0x0f];
    if(sender.selected == YES)
        [delArr addObject:tempDict[@"Id"]];
    else
    {
        for (int i = 0; i <delArr.count; i++) {
            if([tempDict[@"Id"] isEqual:delArr[i]])
            {
                [delArr removeObjectAtIndex:i];
            }
        }
    }
    
}


#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return rebuildGrowArr.count;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger count = [rebuildGrowArr[section][@"growHistory"] count];
    
    return count;
    
}

#pragma mark - setting for cell

#define ViewsGaptoLine 20
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight)];
    cell.backgroundColor = BACKGROUND_COLOR;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    @try {
        
        if(rebuildGrowArr == nil || rebuildGrowArr.count ==0 ||rebuildGrowArr.count- 1< indexPath.row)
            return cell;
        
        NSDictionary *tempDict = rebuildGrowArr[indexPath.section][@"growHistory"][indexPath.row];
        
        // cell.selectionStyle = UITableViewCellSelectionStyleGray;
        UIView *roundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        roundView.center = CGPointMake(LineGap, 20);
        roundView.backgroundColor = ItemsBaseColor;
        [cell addSubview:roundView];
        
        
        UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(LineGap+ ViewsGaptoLine, 0, 100, 30)];
        timeLab.textAlignment = NSTextAlignmentLeft;
        timeLab.text = [tempDict[@"PublishTime"] substringFromIndex:11];//@"刚刚发布";
        timeLab.textColor = [UIColor grayColor];
        timeLab.font = [UIFont boldSystemFontOfSize:16];
        
        //用backgroundColor设置背景色
        //  UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"temp2"]];
        //    historyContentLab.backgroundColor = color;
        UIImageView *backImg = [[UIImageView alloc] initWithImage:img(@"temp2")];
        backImg.frame = CGRectMake(LineGap+ ViewsGaptoLine, timeLab.frame.size.height, SCREEN_WIDTH - LineGap - 30, _cellHeight-timeLab.frame.size.height -10);
        backImg.layer.cornerRadius = 5;
        backImg.layer.masksToBounds  = YES;
        NSString *url = [NSString stringWithFormat:@"%@%@",Kimg_path,tempDict[@"ImagePath"]];
        [backImg  sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"temp2"]];
        
        
        UILabel *historyTitleLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, backImg.frame.size.width -20, 30)];
        historyTitleLab.text = tempDict[@"Title"];
        historyTitleLab.textAlignment = NSTextAlignmentLeft;
        historyTitleLab.textColor = [UIColor whiteColor];
        historyTitleLab.font = [UIFont boldSystemFontOfSize:16];
        
        UILabel *historyContentLab = [[UILabel alloc] initWithFrame:
                                      CGRectMake(10,
                                                 (historyTitleLab.frame.size.height+historyTitleLab.frame.origin.y),
                                                 backImg.frame.size.width -20,
                                                 (backImg.frame.size.height - (historyTitleLab.frame.size.height+historyTitleLab.frame.origin.y)/*顶部*/ - 50/*底部*/))
                                      ];
        historyContentLab.text = tempDict[@"Content"];
        historyContentLab.numberOfLines = 0;
        historyContentLab.textAlignment = NSTextAlignmentLeft;
        historyContentLab.textColor = [UIColor whiteColor];
        historyContentLab.font = [UIFont systemFontOfSize:16];
        
        UILabel *timeLabInImg = [[UILabel alloc] initWithFrame:CGRectMake((backImg.frame.size.width - 10 -60), (backImg.frame.size.height - 40), 60, 30)];
        timeLabInImg.text = tempDict[@"VideoDuration"];
        timeLabInImg.textColor = [UIColor whiteColor];
        timeLabInImg.textAlignment = NSTextAlignmentCenter;
        timeLabInImg.backgroundColor = BACKGROUND_COLOR;
        timeLabInImg.alpha = 0.8;
        timeLabInImg.font = [UIFont boldSystemFontOfSize:14];
        timeLabInImg.layer.cornerRadius = 5;
        timeLabInImg.layer.masksToBounds = YES;
        
        [cell.contentView addSubview:timeLab];
        [cell.contentView addSubview:backImg];
        [backImg addSubview:historyContentLab];
        [backImg addSubview:historyTitleLab];
        [backImg addSubview:timeLabInImg];
        
        
        
        if(EnditMode)
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(indexPath.section ==0 && indexPath.row == 0)
            {
                if(cellBtnArr == nil)
                {
                    cellBtnArr = [NSMutableArray array];
                }
                if(cellBtnArr != nil&&cellBtnArr.count >0)
                {
                    [cellBtnArr removeAllObjects];
                }
            }
            
            SelectRoundBtn *roundBtn = [[SelectRoundBtn alloc] initWithCenter:CGPointMake(15, _cellHeight/2)];
            roundBtn.backgroundColor = Separator_Color;
            [roundBtn addTarget:self action:@selector(roundBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            roundBtn.tag = indexPath.row | (indexPath.section << 4);
            NSLog(@"0x%lx",roundBtn.tag);
            [cell addSubview:roundBtn];
            
            for (int i=0 ; i<delArr.count; i++) {
            
                if ([tempDict[@"Id"] isEqual:delArr[i]]) {
                    roundBtn.selected = YES;
                }
            }
            
            [cellBtnArr addObject:roundBtn];
            
            //        [cell setCellEditMode:YES andBtnCenter:CGPointMake(15, _cellHeight/2)];
        }
        else
        {
            //  cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    //[cell setEditing:YES];
    
    
    
    return cell;
    
}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return _cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
 
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    NSLog(@"click cell section : %ld row : %ld",(long)indexPath.section,(long)indexPath.row);
    if(EnditMode)
    {
//        UIButton *tempBtn = cellBtnArr[indexPath.row];
//  //      tempBtn.selected = !tempBtn.selected;
//        [self roundBtnClick:tempBtn];
        return;
    }
    
    @try {
        if(rebuildGrowArr == nil || rebuildGrowArr.count ==0 ||rebuildGrowArr.count- 1< indexPath.row)
            return;
        
        NSDictionary *tempDict = rebuildGrowArr[indexPath.section][@"growHistory"][indexPath.row];
        VideoDetailViewController *videoDetailViewCtl = [[VideoDetailViewController alloc] init];
        videoDetailViewCtl.videoID = tempDict[@"Id"];
        [self.navigationController pushViewController:videoDetailViewCtl animated:YES];
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}


//设置划动cell是否出现del按钮，可供删除数据里进行处理

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

- (UITableViewCellEditingStyle)tableView: (UITableView *)tableView editingStyleForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"111111111111111111");
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

#define SectionHeight  30

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView = [[UIView alloc] init];
    
    UILabel *dateLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, SectionHeight)];
    dateLab.center = CGPointMake(LineGap+(SCREEN_WIDTH - LineGap)/2 , SectionHeight/2);
    dateLab.textAlignment = NSTextAlignmentCenter;
    dateLab.textColor = [UIColor grayColor];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(LineGap+1, SectionHeight/2,(SCREEN_WIDTH - 30 - dateLab.frame.size.width)/2 ,1)];
    lineView1.backgroundColor = [UIColor whiteColor];
    lineView1.alpha = 0.1;
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(dateLab.frame.origin.x+dateLab.frame.size.width, SectionHeight/2,(SCREEN_WIDTH - 30 - dateLab.frame.size.width)/2,1)];
    lineView2.backgroundColor = [UIColor whiteColor];
    lineView2.alpha = 0.1;

    [tempView addSubview:lineView1];
    [tempView addSubview:dateLab];
    [tempView addSubview:lineView2];
    
    
    NSDate *now = [NSDate date];
    NSString *nowStr = [NSString stringWithFormat:@"%@",now];
    @try {
        if([[nowStr substringToIndex:10] isEqualToString:[rebuildGrowArr[section][@"date"] substringToIndex:10]])
        {
            dateLab.text = @"今天";
        }
        else
        {
            dateLab.text = [rebuildGrowArr[section][@"date"] substringToIndex:10];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    return tempView;
}

//设置section header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SectionHeight;
}

//设置section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 解析数据
-(void)getDatas
{
    [self getUserInfo];
}

-(void)getUserInfo
{
    [SVProgressHUD showWithStatus:@"刷新中" maskType:SVProgressHUDMaskTypeBlack];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"getUserInfoCallBack:"];
    [dataprovider growUserId:[Toolkit getUserID] andStartRowIndex:@"0" andMaximumRows:@"30"];
    
}

-(void)getUserInfoCallBack:(id)dict
{
        DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try
        {
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


@end
