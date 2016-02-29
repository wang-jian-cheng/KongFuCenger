//
//  JiFenViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/8.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "JiFenViewController.h"

#define GapToLeft    20

@interface JiFenViewController ()
{
#pragma mark - pram for tableView
    NSInteger _sectionNum;
    CGFloat _cellHeight;
    UITableView *_mainTableView;
    
    NSMutableArray *jiFenArr;
}
@end

@implementation JiFenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"left"];
    jiFenArr = [NSMutableArray array];
    [self initViews];
    // Do any additional setup after loading the view.
}
-(void)initViews
{
    _cellHeight = SCREEN_HEIGHT/11;
    _sectionNum = 2;
    pageSize = 10;
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height )];
    _mainTableView.backgroundColor = BACKGROUND_COLOR;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorColor =  Separator_Color;
    _mainTableView.tableFooterView = [[UIView alloc] init];
    //_mainTableView.scrollEnabled = NO;
    
    _mainTableView.contentSize = CGSizeMake(SCREEN_HEIGHT, _sectionNum*(_cellHeight + 20));
    [self.view addSubview:_mainTableView];
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    _mainTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageNo=0;
        if(jiFenArr!=nil && jiFenArr.count > 0)
            [jiFenArr removeAllObjects];
        [_mainTableView.mj_footer setState:MJRefreshStateIdle];
        [self getUserInfo];
        [weakSelf getJiFenList];
        // 结束刷新
        [_mainTableView.mj_header endRefreshing];
    }];
    [_mainTableView.mj_header beginRefreshing];
    
    // 上拉刷新
    _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf FooterRefresh];
        [_mainTableView.mj_footer endRefreshing];
    }];

    
    headView = [[UserHeadView alloc] initWithFrame: CGRectMake(GapToLeft, 20,  2*_cellHeight - 20*2, 2*_cellHeight - 20*2) andImg:[UIImage imageNamed:@"headImg"] andNav:self.navigationController];
    userName = [[UILabel alloc] init];
    jiFenLab = [[UILabel alloc] init];
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

#pragma mark - self data source

-(void)FooterRefresh
{
    [self getJiFenList];
}


-(void)getUserInfo
{
    [SVProgressHUD showWithStatus:@"刷新中" maskType:SVProgressHUDMaskTypeBlack];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"getUserInfoCallBack:"];
    [dataprovider getUserInfo:[Toolkit getUserID]];
    
}


-(void)getUserInfoCallBack:(id)dict
{
    [SVProgressHUD dismiss];
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try {
            NSDictionary *tempDict = dict[@"data"];
            
            
            NSString * url=[NSString stringWithFormat:@"%@%@",Kimg_path,tempDict[@"PhotoPath"]];
            
            [headView.headImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"headImg"]];
            
            jiFenLab.text = [NSString stringWithFormat:@"积分：%@",tempDict[@"Credit"]];
            userName.text = [NSString stringWithFormat:@"%@",tempDict[@"NicName"]];
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
-(void)getJiFenList
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"getJiFenCallBack:"];
    [dataprovider getJiFenList:[Toolkit getUserID] andStartRow:[NSString stringWithFormat:@"%d",pageSize*pageNo] andMaxNumRows:[NSString stringWithFormat:@"%d",pageSize]];
}

-(void)getJiFenCallBack:(id)dict
{
    [SVProgressHUD dismiss];
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try {
            
            pageNo++;
            [jiFenArr addObjectsFromArray:dict[@"data"]];
            if(jiFenArr.count >= [dict[@"recordcount"] intValue])
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


#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _sectionNum;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section == 0)
        return 1;
    else
    {
        return jiFenArr.count;
    }
}

#pragma mark - setting for cell
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if(indexPath.section == 0)
    {
        @try {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight*2)];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [headView makeSelfRound];
            
            userName.frame = CGRectMake((headView.frame.origin.x + headView.frame.size.width +10),
                                        (headView.frame.origin.y + 10),
                                        100,
                                        ((headView.frame.size.height)/2 -10) );
            //    userName.text = @"成龙";
            userName.textColor = [UIColor whiteColor];
            userName.font = [UIFont systemFontOfSize:14];
            [cell addSubview:userName];
            
            jiFenLab.frame = CGRectMake((headView.frame.origin.x + headView.frame.size.width +10),
                                        (userName.frame.origin.y+userName.frame.size.height), 200,
                                        userName.frame.size.height);
            //  jiFenLab.text = @"积分：1000个";
            jiFenLab.textColor = [UIColor whiteColor];
            jiFenLab.font = [UIFont systemFontOfSize:14];
            [cell addSubview:jiFenLab];
            
            
            [cell addSubview:headView];
            
            cell.backgroundColor = ItemsBaseColor;
            return cell;

        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    else
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight)];

        @try {
            NSDictionary *tempDict = jiFenArr[indexPath.row];
            
            //
            //        static NSString *CellIdentifier = @"jiFenCell";
            //        JiFenTableViewCell *cell = (JiFenTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            //        cell.contentView.backgroundColor=ItemsBaseColor;
            //        cell.layer.masksToBounds=YES;
            //        cell.layer.cornerRadius=5;
            //        cell.bounds=CGRectMake(0, 0, SCREEN_WIDTH-50, cell.frame.size.height);
            //        cell  = [[[NSBundle mainBundle] loadNibNamed:@"JiFenTableViewCell" owner:self options:nil] lastObject];
            //        cell.layer.masksToBounds=YES;
            //        cell.frame=CGRectMake(cell.frame.origin.x, cell.frame.origin.y, SCREEN_WIDTH, _cellHeight);
            //        cell.backgroundColor = ItemsBaseColor;。
            UIImageView *tipImgView = [[UIImageView alloc ] initWithFrame:CGRectMake(GapToLeft, 10, _cellHeight/2, _cellHeight/2)];
            tipImgView.image = [UIImage imageNamed:@"tip"];
            tipImgView.contentMode = UIViewContentModeScaleAspectFit;
            
            UILabel *dateLab = [[UILabel alloc] initWithFrame:CGRectMake((tipImgView.frame.size.width+tipImgView.frame.origin.x+10),
                                                                         5,(SCREEN_WIDTH - (tipImgView.frame.size.width+tipImgView.frame.origin.x+10)) , (_cellHeight -10)/2)];
            dateLab.textColor = [UIColor grayColor];
            dateLab.text = tempDict[@"CreditTime"];
            dateLab.font = [UIFont systemFontOfSize:14];
            UILabel *contentLab = [[UILabel alloc] initWithFrame:CGRectMake((tipImgView.frame.size.width+tipImgView.frame.origin.x+10),
                                                                            (dateLab.frame.origin.y+dateLab.frame.size.height), 200, (_cellHeight -10)/2)];
            contentLab.text = tempDict[@"CreditCome"];
            contentLab.textColor= [UIColor whiteColor];
            contentLab.font = [UIFont systemFontOfSize:14];
            UILabel *countLab = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH -10 -50),
                                                                          (dateLab.frame.origin.y+dateLab.frame.size.height),
                                                                          50,
                                                                          ((_cellHeight -10)/2))];
            
            if([tempDict[@"CreditType"] intValue] == 0)
            {
                countLab.text = [NSString stringWithFormat:@"+%@个",tempDict[@"CreditNum"]];
            }
            else
            {
                countLab.text = [NSString stringWithFormat:@"-%@个",tempDict[@"CreditNum"]];
            }
            countLab.textColor= [UIColor whiteColor];
            countLab.font = [UIFont systemFontOfSize:14];
            cell.backgroundColor = ItemsBaseColor;
            
            [cell addSubview:tipImgView];
            [cell addSubview:dateLab];
            [cell addSubview:contentLab];
            [cell addSubview:countLab];

        }
        @catch (NSException *exception) {
            
        }
        @finally {
            return cell;

        }
        
        
    }

}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0)
    {
        return 2*_cellHeight;
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
    
    if(section == 1)
    {
        tempView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight);
        tempView.backgroundColor = ItemsBaseColor;
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 0, (SCREEN_WIDTH - GapToLeft), _cellHeight)];
        lab.text = @"积分领取记录";
        lab.textColor = [UIColor whiteColor];
        lab.textAlignment = NSTextAlignmentLeft;
        
        UIView *LineView = [[UIView alloc] initWithFrame:CGRectMake(0, _cellHeight -1, SCREEN_WIDTH, 1)];
        LineView.backgroundColor = Separator_Color;
        [tempView addSubview:LineView];
        [tempView addSubview:lab];
    }
    
    return tempView;
}

//设置section header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1)
    {
        return _cellHeight;
    }
    return 0;
}

//设置section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section ==0)
        return 10;
    else
        return 0;
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
