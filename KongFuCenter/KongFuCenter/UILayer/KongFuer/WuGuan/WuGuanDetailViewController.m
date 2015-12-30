//
//  WuGuanDetailViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/7.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "WuGuanDetailViewController.h"

#define WuGuanSection    0
#define WuGuanDetailSection  1
#define WuGuanShowSection   2


#define GapToLeft           20
#define TextColors          [UIColor whiteColor]

@interface WuGuanDetailViewController ()
{
#pragma mark - pram for tableView
    NSInteger _sectionNum;
    CGFloat _cellHeight;
    UITableView *_mainTableView;
        
    NSIndexPath *tempIndexPath;
}

@end

@implementation WuGuanDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"left"];
    showPicArr = [NSMutableArray array];
    [self initViews];
    // Do any additional setup after loading the view.
}


-(void)initViews
{
    _cellHeight = SCREEN_HEIGHT/12;
    _sectionNum = 3;
    
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height )];
    _mainTableView.backgroundColor = BACKGROUND_COLOR;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorColor = Separator_Color;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _mainTableView.tableFooterView = [[UIView alloc] init];
    //_mainTableView.scrollEnabled = NO;
    
    
    UIImageView *mainImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,3*_cellHeight )];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",Url,wuGuanDetailDict[@"ImagePath"]];
    [mainImg sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"wuguanimg"]];
    _mainTableView.tableHeaderView = mainImg;
//    [tempView addSubview:mainImg];

    
    
    _mainTableView.contentSize = CGSizeMake(SCREEN_HEIGHT, _sectionNum*(_cellHeight + 20));
    [self.view addSubview:_mainTableView];
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    _mainTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf getWuGuanDetail];
                [self getWuGuanPic];
        // 结束刷新
        [_mainTableView.mj_header endRefreshing];
    }];
    [_mainTableView.mj_header beginRefreshing];
    

    
}
#pragma mark - click actions



-(void)shareContentBuild
{
    NSArray* imageArray = @[[UIImage imageNamed:@"108"]];
    
    NSString *strurl=[NSString stringWithFormat:@"http://www.hewuzhe.com/"];
    if (imageArray) {
        @try {
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKSetupShareParamsByText:[[@"核武者上线啦！快来乐享" stringByAppendingString:@"降龙十八掌"] stringByAppendingString:strurl]
                                             images:imageArray
                                                url:[NSURL URLWithString:strurl]
                                              title:@"核武者"
                                               type:SSDKContentTypeAuto];
            
            
            [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                     items:nil
                               shareParams:shareParams
                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                           
                           switch (state) {
                               case SSDKResponseStateSuccess:
                               {
                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                       message:nil
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"确定"
                                                                             otherButtonTitles:nil];
                                   [alertView show];
                                   break;
                               }
                               case SSDKResponseStateFail:
                               {
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                   message:[NSString stringWithFormat:@"%@",error]
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"OK"
                                                                         otherButtonTitles:nil, nil];
                                   [alert show];
                                   break;
                               }
                               default:
                                   break;
                           }
                           
                       }];
            
        }
        @catch (NSException *exception) {
            NSLog(@"Crash");
        }
        @finally {
            
        }
        
    }
}

-(void)btnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    
    if(sender.tag == 3)
    {
        [self wuGuanRelay];
    }
}

- (void)btn_callAction:(UIButton  *)sender
{
    NSLog(@"打电话");
#if 0
    NSString *phoneNum = @"10086";//wuGuanDetailDict[@"TelePhone"];// 电话号码
    
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    
    
    UIWebView *phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];// 这个webView只是一个后台的容易 不需要add到页面上来  效果跟方法二一样 但是这个方法是合法的
    
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [self.view addSubview:phoneCallWebView];
    
#endif
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"10086"];
    //            NSLog(@"str======%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}

#pragma mark - self data source

-(void)wuGuanRelay
{
    [SVProgressHUD showWithStatus:@"	" maskType:SVProgressHUDMaskTypeBlack];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"wuguanRelayCallBack:"];
    [dataprovider voiceAction:self.wuGuanId andUserId:[Toolkit getUserID] andFlg:@"0"];
}

-(void)wuguanRelayCallBack:(id)dict
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
-(void)getWuGuanPic
{
    if(self.wuGuanId!=nil)
    {
        [SVProgressHUD showWithStatus:@"	" maskType:SVProgressHUDMaskTypeBlack];
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"getWuguanPicCallBack:"];
        [dataprovider getWuguanPic:self.wuGuanId];
    }
}

-(void)getWuguanPicCallBack:(id)dict
{
    [SVProgressHUD dismiss];
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try {
            
            if(showPicArr != nil && showPicArr.count > 0)
            {
                [showPicArr removeAllObjects];
            }
            
            [showPicArr addObjectsFromArray:dict[@"data"]];
            
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

-(void)getWuGuanDetail
{
    if(self.wuGuanId!=nil)
    {
        [SVProgressHUD showWithStatus:@"	" maskType:SVProgressHUDMaskTypeBlack];
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"getWuguanDetailCallBack:"];
        [dataprovider getWuguanDetail:self.wuGuanId];
    }
}


-(void)getWuguanDetailCallBack:(id)dict
{
    [SVProgressHUD dismiss];
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try {
            wuGuanDetailDict = dict[@"data"];
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
#pragma mark -  tableview  Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _sectionNum;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case WuGuanSection:
            return 2;
            break;
        case WuGuanDetailSection:
            return 2;
            break;
        case WuGuanShowSection:
            return 2;
            break;
        default:
            break;
    }
    return 1;
    
}

#pragma mark - setting for cell
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight)];
    cell.backgroundColor = ItemsBaseColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.section) {
            
        case WuGuanSection:
        {
            if(indexPath.row == 0)
            {
                CGFloat FontSize = 12;
                @try {
                    if(wuGuanDetailDict ==nil)
                        return cell;
                    
                    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 5, SCREEN_WIDTH/2 , _cellHeight - 10)];
                    nameLab.text = wuGuanDetailDict[@"Title"];
                    nameLab.textColor = [UIColor whiteColor];
                    [cell addSubview:nameLab];
                    
                    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/2 ), 0, SCREEN_WIDTH/2 , _cellHeight)];
                    backView.backgroundColor = cell.backgroundColor;
                    [cell addSubview:backView];
                    CGFloat btnW = backView.frame.size.width/4 - 5;
                    CGFloat btnGap = 5;
                    
                    
                    CustomButton *shareBtn = [[CustomButton alloc] initWithFrame:CGRectMake((btnW+btnGap)*2, 5, btnW, backView.frame.size.height-10)];
                    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
                    shareBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize];
                    
                    [shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
                    shareBtn.imageView.contentMode = UIViewContentModeCenter;
                    shareBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
                    shareBtn.tag = 2;
                    [shareBtn addTarget:self action:@selector(shareContentBuild) forControlEvents:UIControlEventTouchUpInside];
                    
                    [backView addSubview:shareBtn];
                    
                    CustomButton *relayBtn = [[CustomButton alloc] initWithFrame:CGRectMake((btnW+btnGap)*3, 5, btnW, backView.frame.size.height-10)];
                    [relayBtn setTitle:@"转发" forState:UIControlStateNormal];
                    relayBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize];
                    [relayBtn setImage:[UIImage imageNamed:@"relay"] forState:UIControlStateNormal];
                    relayBtn.imageView.contentMode = UIViewContentModeCenter;
                    relayBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
                    relayBtn.tag = 3;
                    [relayBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [backView addSubview:relayBtn];
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
            }
            else if (indexPath.row == 1)
            {
                UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(GapToLeft, 15, cell.frame.size.height - 30 , cell.frame.size.height - 30)];
                image.image = [UIImage imageNamed:@"dingwei@2x"];
                [cell addSubview:image];
                
                UILabel * address = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(image.frame) + 5, 5, self.view.frame.size.width - CGRectGetMaxX(image.frame) - 15 - 60, cell.frame.size.height - 10)];
                address.textColor = Separator_Color;
                address.text =wuGuanDetailDict[@"Address"];
                address.font = [UIFont systemFontOfSize:15];
                [cell addSubview:address];
                
                UIView * line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(address.frame) + 5, 3, 1, cell.frame.size.height - 6)];
                line.backgroundColor = Separator_Color;
                [cell addSubview:line];
                
                UIButton * btn_call = [UIButton buttonWithType:(UIButtonTypeSystem)];
                btn_call.frame = CGRectMake(CGRectGetMaxX(line.frame) + 15, 10, 25 ,25);
                [btn_call addTarget:self action:@selector(btn_callAction:) forControlEvents:(UIControlEventTouchUpInside)];
                [btn_call setImage:[UIImage imageNamed:@"电话"] forState:(UIControlStateNormal)];
                [btn_call setTintColor:Separator_Color];
                [cell addSubview:btn_call];
                
            }

        }
            break;
        case WuGuanDetailSection:
        {
            if(indexPath.row == 0)
            {
                UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 5, SCREEN_WIDTH/2, _cellHeight -10)];
                titleLab.textColor = TextColors;
                titleLab.text = @"武馆介绍";
                [cell addSubview:titleLab];
                
                
            }
            
            if(indexPath.row == 1)
            {

                
                NSString *detailStr = wuGuanDetailDict[@"Content"];
                CGFloat detailWidth = SCREEN_WIDTH-GapToLeft*2;
                CGFloat detailHeight = [Toolkit heightWithString:detailStr fontSize:12 width:detailWidth] +20;
                
                UILabel *detailLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft,
                                                                               5,
                                                                               detailWidth, detailHeight)];
                detailLab.textColor = TextColors;
                detailLab.text = detailStr;
                detailLab.numberOfLines = 0;
                detailLab.font = [UIFont boldSystemFontOfSize:12];
                [cell addSubview:detailLab];
                
            }
        }
            break;
        case WuGuanShowSection:
        {
            if(indexPath.row == 0)
            {
                UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 0, 150, _cellHeight)];
                titleLab.text = @"武馆展示";
                titleLab.font = [UIFont systemFontOfSize:14];
                titleLab.textColor = TextColors;
                [cell addSubview:titleLab];
                
                
                UILabel *numLab = [[UILabel alloc ] initWithFrame:CGRectMake((SCREEN_WIDTH -80 ), 0, 80, _cellHeight)];
                numLab.text = [NSString stringWithFormat:@"共%ld张",showPicArr.count];
                numLab.font = [UIFont systemFontOfSize:12];
                numLab.textColor = TextColors;
                [cell addSubview:numLab];
                
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(numLab.frame.origin.x - 10, 5, 1, _cellHeight-10)];
                lineView.backgroundColor = Separator_Color;
                [cell addSubview:lineView];
                
            }
            
            if(indexPath.row == 1)
            {
                
                if (!_collectionView) {
                    
                    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
                    layout.minimumLineSpacing = 5.0;
                    layout.minimumInteritemSpacing = 5.0;
                    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
                    
                    
                    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-2*_cellHeight, _cellHeight) collectionViewLayout:layout];
                    _collectionView.backgroundColor = [UIColor clearColor];
                    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:_CELL];
                    _collectionView.delegate = self;
                    _collectionView.dataSource = self;
                    _collectionView.showsHorizontalScrollIndicator = NO;
                    _collectionView.showsVerticalScrollIndicator = NO;
                    
                    
                    _collectionView.frame = CGRectMake(GapToLeft,15, SCREEN_WIDTH-2*GapToLeft,  2*_cellHeight -30);
                    
                    [cell addSubview:_collectionView];
                    
                    
                    
                }
                else
                {
                    [cell addSubview:_collectionView];
                }
                

//                for(int i = 0;i< 3;i++)
//                {
//                    
//                    CGFloat gapWidth;
//                    gapWidth =(SCREEN_WIDTH - GapToLeft*2)/3 - (2*_cellHeight -30);
//                    
//                    UIImageView *tempView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"temp"]];
//                    
//                    tempView.frame = CGRectMake(GapToLeft+i*(2*_cellHeight -30 + gapWidth), 10, 2*_cellHeight -30,(2*_cellHeight -30) );
//                    
//                    [cell addSubview:tempView];
////                    UILabel *templab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft+i*(2*_cellHeight -30 + gapWidth),
////                                                                                 (tempView.frame.origin.y+tempView.frame.size.height+2),
////                                                                                 2*_cellHeight -30,
////                                                                                 2*_cellHeight - (tempView.frame.origin.y+tempView.frame.size.height+2) )];
////                    templab.text = @"咏春拳";
////                    templab.textColor = TextColors;
////                    templab.font = [UIFont systemFontOfSize:14];
////                    templab.textAlignment = NSTextAlignmentCenter;
////                    [cell addSubview:templab];
//                    
//                }
            }
        }
            
            break;
        default:
            break;
    }
    
    
    
    
    return cell;
    
}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section != 0)
    {
        if(indexPath.row == 0)
        {
            return _cellHeight;
        }
    }
    
    switch (indexPath.section) {
        case WuGuanSection:
            return _cellHeight;
            break;
        case WuGuanDetailSection:
        {
            NSString *detailStr = wuGuanDetailDict[@"Content"];
            CGFloat detailWidth = SCREEN_WIDTH-GapToLeft*2;
            return [Toolkit heightWithString:detailStr fontSize:12 width:detailWidth]+20;
        }
            break;
        case WuGuanShowSection:
            return 2*_cellHeight;
            break;
            
        default:
            break;
    }
    
    return _cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    NSLog(@"click cell section : %ld row : %ld",(long)indexPath.section,(long)indexPath.row);
    
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
    
    return tempView;
}

//设置section header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
//    if(section == 0)
//        return 3*_cellHeight;
//    else
    return 0;
}

//设置section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
    
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return showPicArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:_CELL forIndexPath:indexPath];
    
    if( showPicArr!= nil&&showPicArr.count > 0&&indexPath.row < showPicArr.count)
    {
        UIImageView *showImg =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        
        NSString *url = [NSString stringWithFormat:@"%@%@",Url,showPicArr[indexPath.row][@"ImagePath"]];
        [showImg sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"wuguanimg"]];
        [cell addSubview:showImg];
    }
    
    UIButton *imgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,  cell.frame.size.width,  cell.frame.size.height)];
    [imgBtn addTarget:self action:@selector(imgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    imgBtn.tag = indexPath.row;
    // imgBtn.backgroundColor = [UIColor redColor];
    [cell bringSubviewToFront:imgBtn];
    [cell addSubview:imgBtn];
    
    return cell;
    
}

-(void)imgBtnClick:(UIButton *)sender
{
    
    NSLog(@"sender .tag = %ld",sender.tag);
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(40, 40);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)[indexPath row]);
    
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
