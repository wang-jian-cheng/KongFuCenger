//
//  WuGuanViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/4.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "WuGuanViewController.h"
#import "WuGuanTableViewCell.h"


@interface WuGuanViewController ()
{
    
    UILabel *label;
#pragma mark - pram for tableView
    NSInteger _sectionNum;
    CGFloat _cellHeight;
    UITableView *_mainTableView;
    
    UIButton *placeBtn;
    
    int pageNo;
    int pageSize;
    
    NSMutableArray *WuGuanListArr;
    NSString *cityID;
    NSString *onlyCityName;
    NSString *oldCity;
}
@end

@implementation WuGuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"left"];
    pageNo=0;
    pageSize=12;
    cityID =nil;
    WuGuanListArr = [NSMutableArray array];
    [self initViews];
    
    
    // Do any additional setup after loading the view.
}



-(void)initViews
{
    _cellHeight = 100;
    _sectionNum = 10;
    
    
   
//    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT-Header_Height+10  )];
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT-Header_Height+10  ) style:UITableViewStyleGrouped];
    _mainTableView.backgroundColor = BACKGROUND_COLOR;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorColor =  Separator_Color;
    _mainTableView.tableFooterView = [[UIView alloc] init];
    //_mainTableView.scrollEnabled = NO;
    
   // _mainTableView.contentSize = CGSizeMake(SCREEN_HEIGHT, _sectionNum*(_cellHeight + 20));
    [self.view addSubview:_mainTableView];
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 下拉刷新
    _mainTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageNo=0;
        if(WuGuanListArr != nil && WuGuanListArr.count>0)
        {
            [WuGuanListArr removeAllObjects];
        }
        [_mainTableView.mj_footer setState:MJRefreshStateIdle];
        [weakSelf loadWuguanList:cityID];
        // 结束刷新
        [_mainTableView.mj_header endRefreshing];
    }];
    [_mainTableView.mj_header beginRefreshing];
    
    // 上拉刷新
    _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf FooterRefresh];
        [_mainTableView.mj_footer endRefreshing];
    }];

    label = [[UILabel alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height)];
    [self.view addSubview:label];
    label.backgroundColor = BACKGROUND_COLOR;
    label.text = @"没有武馆(若无法定位请手动选择城市)";
    label.font = [UIFont systemFontOfSize:16];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    

    placeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, StatusBar_HEIGHT, 100, NavigationBar_HEIGHT)];
    [placeBtn setTitle:@"定位中" forState:UIControlStateNormal];
    [placeBtn addTarget:self action:@selector(LocationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    placeBtn.center = CGPointMake(SCREEN_WIDTH/2, NavigationBar_HEIGHT/2+StatusBar_HEIGHT);
    [_topView addSubview:placeBtn];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(placeBtn.frame.size.width - 15,
                                                                         (placeBtn.frame.size.height-15)/2, 15, 15)];
    imgView.image = [UIImage imageNamed:@"upsanjiao"];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [placeBtn addSubview:imgView];
    
//    [self loadWuguanList:cityID];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}
#pragma mark - self data source
-(void)loadWuguanList:(NSString*)cityId
{
    
    if(cityId ==nil)
    {
        
        
            [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        

                lng = [NSString stringWithFormat:@"%.02f",locationCorrrdinate.longitude];
                lat = [NSString stringWithFormat:@"%.02f",locationCorrrdinate.latitude];
                //[dataprovider GetcityInfoWithlng:[NSString stringWithFormat:@"%f",locationCorrrdinate.longitude] andlat:[NSString stringWithFormat:@"%f",locationCorrrdinate.latitude]];
        
                [[CCLocationManager shareLocation] getCity:^(NSString *addressString) {
                   // NSLog(@"City : %@",addressString);
                    cityName = [self getRealCityName:addressString];
                    onlyCityName =cityName;
                    [placeBtn setTitle:cityName forState:UIControlStateNormal];
                    DataProvider * dataprovider=[[DataProvider alloc] init];
                    [dataprovider setDelegateObject:self setBackFunctionName:@"getWuguanListCallBack:"];
                    [dataprovider getWuguanList:cityName
                                         andLat:lat
                                         andLng:lng
                               andStartRowIndex:[NSString stringWithFormat:@"%d",pageNo*pageSize]
                                 andMaximumRows:[NSString stringWithFormat:@"%d",pageSize]];
                    
                }];

            }];
    
    }
    
    [SVProgressHUD showWithStatus:@"请稍后。。。" maskType:SVProgressHUDMaskTypeBlack];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"getWuguanListCallBack:"];
    if([dataprovider getWuGuanList:cityId andStartRowIndex:[NSString stringWithFormat:@"%d",pageNo*pageSize] andMaximumRows:[NSString stringWithFormat:@"%d",pageSize]]!=OK)
    {
        [SVProgressHUD dismiss];
    }
}

-(NSString *)getRealCityName:(NSString *)address
{
    if(address==nil)
        return nil;
    NSRange tempRang;
    tempRang.location = 0;
    tempRang.length= 0;
    tempRang = [address rangeOfString:@"省"];
    if (tempRang.length == 0) {
        tempRang = [address rangeOfString:@"区" ];
    }
    
    return [address substringFromIndex:(tempRang.location+1)];
}



-(void)getWuguanListCallBack:(id)dict
{
    [SVProgressHUD dismiss];
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try {
            ++pageNo;
            
            
            [WuGuanListArr addObjectsFromArray:dict[@"data"]];
            if(WuGuanListArr.count >= [dict[@"recordcount"] intValue])
            {
                [_mainTableView.mj_footer setState:MJRefreshStateNoMoreData];
            }
            [_mainTableView reloadData];
            
            if (WuGuanListArr.count ==0) {
                label.hidden = NO;
            }
            else
            {
                label.hidden = YES;
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

-(void)FooterRefresh
{
//    [SVProgressHUD showWithStatus:@"	" maskType:SVProgressHUDMaskTypeBlack];
//    DataProvider * dataprovider=[[DataProvider alloc] init];
//    [dataprovider setDelegateObject:self setBackFunctionName:@"FooterRefreshCallBack:"];
//    [dataprovider getWuGuanList:cityID andStartRowIndex:[NSString stringWithFormat:@"%d",pageNo*pageSize] andMaximumRows:[NSString stringWithFormat:@"%d",pageSize]];
    
    [self loadWuguanList:cityID];
}

-(void)FooterRefreshCallBack:(id)dict
{
    [SVProgressHUD dismiss];
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try {
            ++pageNo;
//            if(WuGuanListArr != nil && WuGuanListArr.count>0)
//            {
//                [WuGuanListArr removeAllObjects];
//            }
//            
            [WuGuanListArr addObjectsFromArray:dict[@"data"]];
            
            if(WuGuanListArr.count >= [dict[@"recordcount"] intValue])
            {
                [_mainTableView.mj_footer setState:MJRefreshStateNoMoreData];
            }
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


#pragma mark - AutoLocationViewController delegate

-(void)outCitySetting:(NSString *)City andID:(NSString *)cityId
{
    [placeBtn setTitle:City forState:UIControlStateNormal];
    cityID = cityId;
    onlyCityName = City;
    [_mainTableView.mj_header beginRefreshing];
}

#pragma mark - click actions

-(void)LocationBtnClick:(UIButton *)sender
{
    AutoLocationViewController *autoLocationViewCtl = [[AutoLocationViewController alloc] init];
    autoLocationViewCtl.navtitle = @"城市推荐";
    autoLocationViewCtl.delegate = self;
    [self.navigationController pushViewController:autoLocationViewCtl animated:YES];
}

#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return WuGuanListArr.count;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;

}

#pragma mark - setting for cell
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    

//    static NSString *identifier = @"wuguanCell";
//    WuGuanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (cell == nil) {
//        cell = [[WuGuanTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//
//    }
//    cell.backgroundColor = ItemsBaseColor;
    
    
    
    static NSString *CellIdentifier = @"wuguanCell";
    WuGuanTableViewCell *cell = (WuGuanTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.contentView.backgroundColor=ItemsBaseColor;
    cell.layer.masksToBounds=YES;
    cell.layer.cornerRadius=5;
    cell.bounds=CGRectMake(0, 0, SCREEN_WIDTH-50, cell.frame.size.height);
    cell  = [[[NSBundle mainBundle] loadNibNamed:@"WuGuanTableViewCell" owner:self options:nil] lastObject];
    cell.layer.masksToBounds=YES;
    cell.frame=CGRectMake(cell.frame.origin.x, cell.frame.origin.y, SCREEN_WIDTH, cell.frame.size.height);
    
    
    @try {
        if(WuGuanListArr ==nil || WuGuanListArr.count == 0 || indexPath.section > WuGuanListArr.count - 1)
            return cell;
        
        NSDictionary *tempDict = [WuGuanListArr objectAtIndex:indexPath.section];
        
        cell.describeLab.text = tempDict[@"Content"];
        cell.titleLab.text = tempDict[@"Title"];
        cell.phoneLab.text = [NSString stringWithFormat:@"电话:%@",tempDict[@"TelePhone"]];
        cell.addressLab.text = [NSString stringWithFormat:@"地址:%@",[onlyCityName substringToIndex:(onlyCityName.length-2)]];
        
        NSString *url = [NSString stringWithFormat:@"%@%@",Url,tempDict[@"ImagePath"]];
        [cell.mainImg sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"wuguanimg"]];
    }
    @catch (NSException *exception) {
    
    }
    @finally {
        
    }
    
    
    return cell;
    
}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return _cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    NSLog(@"click cell section : %ld row : %ld",(long)indexPath.section,(long)indexPath.row);
    @try {
        WuGuanDetailViewController *wuGuanDetailViewCtl = [[WuGuanDetailViewController alloc] init];
        wuGuanDetailViewCtl.wuGuanId = WuGuanListArr[indexPath.section][@"Id"];
        wuGuanDetailViewCtl.navtitle = @"武馆详情";
        [self.navigationController pushViewController:wuGuanDetailViewCtl animated:YES];
        

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor); CGContextFillRect(context, rect); //上分割线，
    
    CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1)); //下分割线
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(5, 10, 100, 10));
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

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView = [[UIView alloc] init];
    tempView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1) ;
    return tempView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *tempView = [[UIView alloc] init];
    tempView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 10) ;
    return tempView;
   
}

//设置section header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

//设置section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
