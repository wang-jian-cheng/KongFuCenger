//
//  KongFuerViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/3.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "KongFuerViewController.h"

@interface KongFuerViewController ()
{
    
#pragma mark - pram for tableView
    NSInteger _sectionNum;
    CGFloat _cellHeight;
    UITableView *_mainTableView;
#pragma mark - datas
    
    NSMutableArray *cateGoryH;//水平;
    
    NSMutableArray *cateGoryV;
    NSInteger categoryVIndex;
    
#pragma mark  - labs
    
    UILabel *lvLab;
    UILabel *isPayLab;
    UILabel *jiFenNumLab;
    
    UILabel *nickLab;
    UILabel *IdLab;

}
@end

@implementation KongFuerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    _sectionNum = 5;
    _cellHeight = SCREEN_HEIGHT / 12;
    [self setBarTitle:@"核武者"];
    
    [self initDatas];
    [self initViews];
    
    [self getDatas];
    // Do any additional setup after loading the view.
}

-(void)initDatas
{
    
    categoryVIndex = 0;
    
    cateGoryH = [NSMutableArray array];
    [cateGoryH addObjectsFromArray:@[@"放飞梦想",@"在线学习",@"武馆推荐",@"我的收藏"]];
    
    cateGoryV = [NSMutableArray array];
    [cateGoryV addObjectsFromArray:@[@[@"视频直播"],
                                     @[@"训练计划",@"成长记录"],
                                     @[@"我的积分"]]
                                    ];
}


-(void)initViews
{
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height - TabBar_HEIGHT)];
    _mainTableView.backgroundColor = BACKGROUND_COLOR;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//UITableViewCellSeparatorStyleSingleLine;
    _mainTableView.separatorInset = UIEdgeInsetsZero;
    _mainTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _mainTableView.separatorColor =  Separator_Color;
    _mainTableView.tableFooterView = [[UIView alloc] init];
    //设置cell分割线从最左边开始
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
    {
        if ([_mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_mainTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        
        if ([_mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_mainTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
    
    [self.view addSubview:_mainTableView];
    
    
    nickLab = [[UILabel alloc] init];
    nickLab.textColor = YellowBlock;
    nickLab.font = [UIFont systemFontOfSize:14];
    nickLab.textAlignment = NSTextAlignmentCenter;

    IdLab = [[UILabel alloc] init];
    IdLab.textColor = [UIColor whiteColor];
    IdLab.font = [UIFont systemFontOfSize:12];
    IdLab.textAlignment = NSTextAlignmentCenter;
    
    lvLab = [[UILabel alloc] init];
    lvLab.textColor = [UIColor whiteColor];
    lvLab.font = [UIFont systemFontOfSize:10];
    lvLab.textAlignment = NSTextAlignmentCenter;
    
    isPayLab = [[UILabel alloc] init];
    isPayLab.textColor = YellowBlock;
    isPayLab.font = [UIFont systemFontOfSize:10];
    isPayLab.textAlignment = NSTextAlignmentCenter;
    
    jiFenNumLab = [[UILabel alloc] init];
    jiFenNumLab.textColor = YellowBlock;
    jiFenNumLab.font = [UIFont systemFontOfSize:10];
    jiFenNumLab.textAlignment = NSTextAlignmentCenter;
}


-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showTabBar];
    [self getUserInfo];
}
#pragma mark - self data source



-(void)getDatas
{
    [self getUserInfo];
}

-(void)getUserInfo
{
    [SVProgressHUD showWithStatus:@"登录中" maskType:SVProgressHUDMaskTypeBlack];
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

            lvLab.text = [NSString stringWithFormat:@"lv%@",tempDict[@"Rank"]];
            if([tempDict[@"IsPay"] integerValue ] == 0)
            {
                isPayLab.text = @"成为会员";
            }
            else
            {
                isPayLab.text = @"付费会员";
            }
            
            jiFenNumLab.text = [NSString stringWithFormat:@"%@分",tempDict[@"Credit"]];
            nickLab.text = [NSString stringWithFormat:@"%@",tempDict[@"NicName"]];
            IdLab.text = [NSString stringWithFormat:@"ID:%@",tempDict[@"UserName"]];
            
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


#pragma mark - click Btns

-(void)vipClickBtn:(UIButton *)sender
{
    VipViewController *vipViewCtl = [[VipViewController alloc] init];
    vipViewCtl.navtitle = @"会员详情";
    [self.navigationController pushViewController:vipViewCtl animated:YES];
    
}

#define DreamBtn  0
#define StudyOnLineBtn  1
#define KongFuHomeSugBtn  2
#define MyCollectBtn  3
-(void)cateHBtnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case DreamBtn:
        {
            MyDreamViewController *myDreamViewCtl = [[MyDreamViewController alloc] init];
            myDreamViewCtl.navtitle= cateGoryH[DreamBtn];
            [self.navigationController pushViewController:myDreamViewCtl animated:YES];
            
        }
            break;
        case StudyOnLineBtn:
        {
            StudyOnLineViewController *studyOnlineViewCtl = [[StudyOnLineViewController alloc]init];
            studyOnlineViewCtl.navtitle = cateGoryH[StudyOnLineBtn];
            [self.navigationController pushViewController:studyOnlineViewCtl animated:YES];
        }
            break;
        case KongFuHomeSugBtn:
        {
            WuGuanViewController *wuGuanSugViewCtl= [[WuGuanViewController alloc]init];
            wuGuanSugViewCtl.navtitle = cateGoryH[KongFuHomeSugBtn];
            [self.navigationController pushViewController:wuGuanSugViewCtl animated:YES];
        }
            break;
        case MyCollectBtn:
        {
            MyCollectViewController *myCollectViewCtl= [[MyCollectViewController alloc]init];
            myCollectViewCtl.navtitle = cateGoryH[MyCollectBtn];
            [self.navigationController pushViewController:myCollectViewCtl animated:YES];
        }
            break;
        default:
            break;
    }
}
//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 2;
            break;
        case 4:
            return 1;
            break;
        default:
            return 1;
            break;
    }

}

#pragma mark - setting for cell
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _cellHeight)];
    
    cell.backgroundColor = ItemsBaseColor;
    
    if(indexPath.section == 0)
    {
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if(indexPath.row == 1)
        {
            for(int i = 0;i < cateGoryH.count;i++)
            {
                UIButton *cateHBtn = [[UIButton alloc] initWithFrame:CGRectMake(0 + i*(SCREEN_WIDTH/cateGoryH.count), 0,(SCREEN_WIDTH/cateGoryH.count) , _cellHeight)];
                [cateHBtn setTitle:cateGoryH[i] forState:UIControlStateNormal];
                cateHBtn.titleLabel.font = [UIFont systemFontOfSize:16];
                cateHBtn.tag = i;
                if(i!=cateGoryH.count - 1)
                {
                    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake((1+i)*(SCREEN_WIDTH/cateGoryH.count), 10, 1, _cellHeight - 20)];
                    lineView.backgroundColor = BACKGROUND_COLOR;
                    [cell addSubview:lineView];
                }
                
                [cateHBtn addTarget:self action:@selector(cateHBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:cateHBtn];
            }
        }
        if(indexPath.row == 0)
        {
            {//天气
            
            }
            
            {//账号
                //head
                UserHeadView *headView = [[UserHeadView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH -80)/2 ,_cellHeight/2, 80, 80)
                                                                  andImgName:@"headImg"
                                                                      andNav:self.navigationController];
                [headView makeSelfRound];
                headView.center = CGPointMake(SCREEN_WIDTH/2, _cellHeight*1.5);
                [cell addSubview:headView];
               
                
                nickLab.frame = CGRectMake(0, 0, 100, 20) ;
                nickLab.center = CGPointMake(SCREEN_WIDTH/2,(headView.frame.size.height+headView.frame.origin.y+13));
               // nickLab.backgroundColor = [UIColor blueColor];
                [cell addSubview:nickLab];
                
                IdLab.frame = CGRectMake(0, 0, 100,
                                         20) ;//>(3*_cellHeight -(nickLab.frame.size.height+nickLab.frame.origin.y))?(3*_cellHeight - (nickLab.frame.size.height+nickLab.frame.origin.y)):20
                IdLab.center = CGPointMake(SCREEN_WIDTH/2,(nickLab.frame.size.height+nickLab.frame.origin.y+10));
                [cell addSubview:IdLab];
                
                
                //vip
//                UIImageView *vipImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"liubianxing"]];
//                vipImgView.frame = CGRectMake( 20 , 1.5*_cellHeight , 60, 1.5*_cellHeight - 20);
//                vipImgView.contentMode = UIViewContentModeScaleAspectFit;
//                [cell addSubview:vipImgView];
                UIButton *vipBtnView = [[UIButton alloc] init];
                vipBtnView.frame = CGRectMake( 20 , 1.5*_cellHeight , 60, 1.5*_cellHeight - 20);
                vipBtnView.contentMode = UIViewContentModeScaleAspectFit;
                [vipBtnView setImage:[UIImage imageNamed:@"liubianxing"] forState:UIControlStateNormal];
                [vipBtnView addTarget:self action:@selector(vipClickBtn:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:vipBtnView];
                
 
                
                lvLab.frame = CGRectMake(0, 0, 40, 20);
                lvLab.center = CGPointMake(vipBtnView.frame.size.width/2, vipBtnView.frame.size.height/4+8);
                [vipBtnView addSubview:lvLab];
                
                isPayLab.frame = CGRectMake(0, 0, vipBtnView.frame.size.width - 18, 20);
                isPayLab.center = CGPointMake(vipBtnView.frame.size.width/2, vipBtnView.frame.size.height/4*3-7);
                [vipBtnView addSubview:isPayLab];
                
                
                UIImageView *jiFenImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"liubianxing"]];
                jiFenImgView.frame = CGRectMake( (SCREEN_WIDTH -60 - 20) , 1.5*_cellHeight , 60, 1.5*_cellHeight - 20);
                jiFenImgView.contentMode = UIViewContentModeScaleAspectFit;
                [cell addSubview:jiFenImgView];
                
                UILabel *jiFenTitlelab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
                jiFenTitlelab.center = CGPointMake(jiFenImgView.frame.size.width/2, jiFenImgView.frame.size.height/4+8);
                jiFenTitlelab.textColor = [UIColor whiteColor];
                jiFenTitlelab.font = [UIFont systemFontOfSize:10];
                jiFenTitlelab.textAlignment = NSTextAlignmentCenter;
                jiFenTitlelab.text = @"积分";
                [jiFenImgView addSubview:jiFenTitlelab];
                
                jiFenNumLab.frame = CGRectMake(0, 0, vipBtnView.frame.size.width - 18, 20);
                jiFenNumLab.center = CGPointMake(vipBtnView.frame.size.width/2, vipBtnView.frame.size.height/4*3-7);
                [jiFenImgView addSubview:jiFenNumLab];
                
            }
        }
    }
    if(indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight)];
            imgView.image = [UIImage imageNamed:@"showimg"];
            [cell addSubview:imgView];
        }
    }
    
    if(indexPath.section >1)
    {
        if(categoryVIndex > cateGoryV.count - 1)
            return cell;
        
        UILabel *gategoryNameLab = [[UILabel alloc ] initWithFrame:CGRectMake(10, 0, 100, _cellHeight)];
        gategoryNameLab.text =cateGoryV[indexPath.section-2][indexPath.row];
        gategoryNameLab.textColor  = [UIColor whiteColor];
        
        gategoryNameLab.font = [UIFont systemFontOfSize:16];
        [cell addSubview:gategoryNameLab];
        
        UIImageView *rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right"]];
        rightView.frame = CGRectMake((SCREEN_WIDTH - 20 -20), 0, 15, 15);
        rightView.center = CGPointMake((SCREEN_WIDTH - 15 -10), _cellHeight/2);
        rightView.contentMode = UIViewContentModeScaleAspectFit;
        [cell addSubview:rightView];
    }
    
    return cell;
    
}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0&&indexPath.row ==0)
    {
        return _cellHeight*3+20;
    }
    return _cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    NSLog(@"click cell section : %ld row : %ld",(long)indexPath.section,(long)indexPath.row);
    
    
    switch (indexPath.section - 2) {
        case 0:
        {
            ZhiBoViewController *zhiboViewCtl = [[ZhiBoViewController alloc] init];
            zhiboViewCtl.navtitle = cateGoryV[indexPath.section-2][indexPath.row];
            [self.navigationController pushViewController:zhiboViewCtl animated:YES];
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0://训练计划
                {
                    TrainsPlanViewController *trainsPlanViewCtl = [[TrainsPlanViewController alloc] init];
                    trainsPlanViewCtl.navtitle = cateGoryV[indexPath.section-2][indexPath.row];
                    [self.navigationController pushViewController:trainsPlanViewCtl animated:YES];
                }
                    break;
                case 1://成长记录
                {
                    GrowHistoryViewController *growHistoryViewCtl= [[GrowHistoryViewController alloc] init];
                    growHistoryViewCtl.navtitle = cateGoryV[indexPath.section-2][indexPath.row];
                    [self.navigationController pushViewController:growHistoryViewCtl animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 2://积分
        {
            JiFenViewController *jiFenViewCtl = [[JiFenViewController alloc] init];
            jiFenViewCtl.navtitle = cateGoryV[indexPath.section-2][indexPath.row];
            [self.navigationController pushViewController:jiFenViewCtl animated:YES];
            
        }
            break;
        default:
            break;
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
    
    
    tempView.backgroundColor = [UIColor grayColor];
    return tempView;
}

//设置section的footer view
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *tempView = [[UIView alloc] init];
    
    
    
    return tempView;
    
}


//设置section header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0;
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
