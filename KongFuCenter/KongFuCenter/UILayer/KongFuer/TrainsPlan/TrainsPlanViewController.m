//
//  TrainsPlanViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/9.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "TrainsPlanViewController.h"

#define LineGap 30

#define NEW_BtnTag  (2015+1)
#define DEL_BtnTag  (2015+2)

@interface TrainsPlanViewController ()
{
    
    UIImageView *btnImgView;
    UIButton *delBtn;
    UIButton *newBtn;
#pragma mark - pram for tableView
    NSInteger _sectionNum;
    NSInteger _cellNum;
    CGFloat _cellHeight;
    UITableView *_mainTableView;
        
        
    BOOL EnditMode;
    NSMutableArray *studyCateArr;
    NSMutableArray *btnArr;
    NSMutableArray *cellBtnArr;
    NSMutableArray *planInfoArr;
    
    BOOL moreSettingBackViewFlag;
    
    NSInteger cateId;
    NSMutableArray *delArr;
    NSInteger deleCount;
    NSString *planMode;
}
@end

@implementation TrainsPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"left"];
    [self addRightButton:@"moreNoword"];
    [self initDatas];
    [self initViews];
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    // Do any additional setup after loading the view.
}
-(void)initDatas
{
    
    studyCateArr = [NSMutableArray array];
    [studyCateArr addObjectsFromArray:@[@"周计划",@"月计划",@"季计划",@"年计划"]];
    
    btnArr = [NSMutableArray array];
    cellBtnArr = [NSMutableArray array];
    planArr = [NSMutableArray array];
    delArr  = [NSMutableArray array];
    cateId = 51;
    planMode= @"周计划";
}

-(void)initViews
{
    UIView *viewForBtns = [[UIView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, 44)];
    btnImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btnFlag"]];
    btnImgView.contentMode = UIViewContentModeScaleAspectFit;
    for (int i = 0;i< studyCateArr.count; i++) {
        UIButton *cateBtn = [[UIButton alloc] initWithFrame:CGRectMake(0 + i*(SCREEN_WIDTH/studyCateArr.count), 0,(SCREEN_WIDTH/studyCateArr.count) , viewForBtns.frame.size.height)];
        
        if(i == 0)
        {
            cateBtn.selected = YES;
            btnImgView.frame = CGRectMake((cateBtn.frame.size.width - 15)/2, (cateBtn.frame.size.height - 15), 15, 15);
            [cateBtn addSubview:btnImgView];
        }
        
        [cateBtn setTitle:studyCateArr[i] forState:UIControlStateNormal];
        cateBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        cateBtn.backgroundColor = ItemsBaseColor;
        [cateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cateBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        cateBtn.tag = WeekPlan - i;
        
        [cateBtn addTarget:self action:@selector(cateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [viewForBtns addSubview:cateBtn];
        [btnArr addObject:cateBtn];
    }
    
    [self.view addSubview:viewForBtns];
    
    
    
    
    _cellHeight = 200;
    _sectionNum = 1;
    pageSize = 10;
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height+44, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height )];
    _mainTableView.backgroundColor = BACKGROUND_COLOR;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorColor =  Separator_Color;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.tableFooterView = [[UIView alloc] init];
    //_mainTableView.scrollEnabled = NO;

    __unsafe_unretained __typeof(self) weakSelf = self;

    _mainTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        if(EnditMode == YES)
//            return ;
        pageNo=0;
        [weakSelf getPlans];
        // 结束刷新
        [_mainTableView.mj_header endRefreshing];
    }];
    [_mainTableView.mj_header beginRefreshing];
    
    // 上拉刷新
    _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        if(EnditMode == YES)
//            return;
        [weakSelf FooterRefresh];
        [_mainTableView.mj_footer endRefreshing];
    }];
    
    
    _mainTableView.contentSize = CGSizeMake(SCREEN_HEIGHT, _sectionNum*(_cellHeight));
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(LineGap, Header_Height, 1, SCREEN_HEIGHT - Header_Height)];
    lineView.backgroundColor = ItemsBaseColor;
    
    
    [self.view addSubview:_mainTableView];
    [self.view addSubview:lineView];
    
    
    moreSettingBackView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100 -10), Header_Height, 100, 88)];
    moreSettingBackView.backgroundColor = ItemsBaseColor;
    newBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, moreSettingBackView.frame.size.width,  moreSettingBackView.frame.size.height/2)];
    [newBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newBtn setTitle:@"发布" forState:UIControlStateNormal];
    newBtn.tag = NEW_BtnTag;
    [newBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView2 =[[UIView alloc] initWithFrame:CGRectMake(0, moreSettingBackView.frame.size.height/2, moreSettingBackView.frame.size.width - 2, 1)];
    lineView2.backgroundColor = Separator_Color;
    delBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, moreSettingBackView.frame.size.height/2, moreSettingBackView.frame.size.width,  moreSettingBackView.frame.size.height/2)];
    [delBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [delBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    delBtn.tag = DEL_BtnTag;
    
    
    
    [moreSettingBackView addSubview:newBtn];
    [moreSettingBackView addSubview:delBtn];
    [moreSettingBackView addSubview:lineView2];
    
    [self.view addSubview:moreSettingBackView];
    moreSettingBackView.hidden = YES;
    
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:) ];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
}

#pragma mark - 手势
-(void)tapViewAction:(id)sender
{
    [self positionDismissView:moreSettingBackView];
}

//设置点在某个view时部触发事件
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"-%@", NSStringFromClass([touch.view class]));
    
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"])
    {
        return NO;
    }
    //  NSLog(@"return YES");
    return  YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
    
    if(_mainTableView !=nil)
    {
        [_mainTableView.mj_header beginRefreshing];
    }
}

#pragma mark - self data source

-(void)FooterRefresh
{
    [SVProgressHUD showWithStatus:@"	" maskType:SVProgressHUDMaskTypeBlack];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"FootergetPlansCallBack:"];
    [dataprovider getPlanInfo:[Toolkit getUserID]
                    andCateId:[NSString stringWithFormat:@"%ld",cateId]
                  andStartRow:[NSString stringWithFormat:@"%d",pageNo*pageSize]
                andMaxNumRows:[NSString stringWithFormat:@"%d",pageSize]];
    
}

-(void)FootergetPlansCallBack:(id)dict
{
    
    [SVProgressHUD dismiss];
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try {
            pageNo ++;
            
            [planArr addObjectsFromArray:dict[@"data"]];
            [_mainTableView reloadData];
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

-(void)getPlans
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"getPlansCallBack:"];
    [dataprovider getPlanInfo:[Toolkit getUserID]
                    andCateId:[NSString stringWithFormat:@"%ld",cateId]
                  andStartRow:[NSString stringWithFormat:@"%d",pageNo*pageSize]
                andMaxNumRows:[NSString stringWithFormat:@"%d",pageSize]];
}

-(void)getPlansCallBack:(id)dict
{

    [SVProgressHUD dismiss];
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try {
            pageNo ++;
            if(planArr !=nil&&planArr.count>0)
              [planArr removeAllObjects];
            
            [planArr addObjectsFromArray:dict[@"data"]];
            [_mainTableView reloadData];
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

-(void)delPlans
{
    if (delArr.count == 0) {
        return;
    }
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"delePlansCallBack:"];
    [dataprovider delePlan:delArr[deleCount]];
}

-(void)delePlansCallBack:(id)dict
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
                [self delPlans];
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
#pragma mark - Btn click

-(void)cateBtnClick:(UIButton *)sender
{
    sender.selected = YES;
    [btnImgView removeFromSuperview];
    btnImgView.frame = CGRectMake((sender.frame.size.width-15)/2, (sender.frame.size.height - 15), 15, 15);
    [sender addSubview:btnImgView];
    for(int i =0;i<btnArr.count;i++)
    {
        if(i != sender.tag)
        {
            ((UIButton *)btnArr[i]).selected = NO;
        }
    }
    //更新数据
    cateId = sender.tag;
    planMode = sender.titleLabel.text;
    [_mainTableView.mj_header beginRefreshing];
    
    EnditMode = NO;
    [delBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [newBtn setTitle:@"发布" forState:UIControlStateNormal];
    [_mainTableView reloadData];

    [self positionDismissView:moreSettingBackView];
}

-(void)roundBtnClick:(UIButton *)sender
{
    sender.selected = ! sender.selected;
    
    
    if(sender.selected == YES)
        [delArr addObject:planArr[sender.tag][@"Id"]];
    else
    {
        for (int i = 0; i <delArr.count; i++) {
            if([planArr[sender.tag][@"Id"] isEqual:delArr[i]])
            {
                [delArr removeObjectAtIndex:i];
            }
        }
    }
}

-(void)btnClick:(UIButton *)sender
{
    if(sender.tag == DEL_BtnTag)
    {
    
        if([sender.titleLabel.text isEqualToString:@"编辑"])
        {
            EnditMode = YES;
            [delBtn setTitle:@"删除" forState:UIControlStateNormal];
            [newBtn setTitle:@"取消" forState:UIControlStateNormal];
        }
        else if([sender.titleLabel.text isEqualToString:@"删除"])
        {
            [self delPlans];
        }
        [_mainTableView reloadData];

    }
    else  if(sender.tag == NEW_BtnTag)
    {
        if([sender.titleLabel.text isEqualToString:@"取消"])
        {
            EnditMode = NO;
            [delBtn setTitle:@"编辑" forState:UIControlStateNormal];
            [newBtn setTitle:@"发布" forState:UIControlStateNormal];
            [_mainTableView reloadData];

        }
        else if([sender.titleLabel.text isEqualToString:@"发布"])
        {
            [self positionDismissView:moreSettingBackView];
            NewPlanViewController *newPlanViewCtl = [[NewPlanViewController alloc] init];
            newPlanViewCtl.navtitle = @"发布训练计划";
            newPlanViewCtl.planMode = planMode;
            [self.navigationController pushViewController:newPlanViewCtl animated:YES];
        }
    }
}


-(void)clickRightButton:(UIButton *)sender
{

    
    if(moreSettingBackView.hidden == YES)
    {
        moreSettingBackView.hidden = NO;
        [self positionShowView:moreSettingBackView];
    }
    else
    {

       [self positionDismissView:moreSettingBackView];
    }
    
    
}

#define SHOW_ANIM_KEY   @"showSettingView"
#define DISMISS_ANIM_KEY   @"dismissSettingView"
-(void)positionShowView:(UIView *)tempView
{
    
    
    CABasicAnimation *scale=[CABasicAnimation animationWithKeyPath:@"transform"];
    [scale setFromValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 0, 1.0)]];
    [scale setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
   
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake((moreSettingBackView.frame.origin.x+moreSettingBackView.frame.size.width/2), Header_Height)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake((moreSettingBackView.frame.origin.x+moreSettingBackView.frame.size.width/2),
                                                              (moreSettingBackView.frame.size.height/2 + moreSettingBackView.frame.origin.y))];
    //动画执行后保持显示状态 但是属性值不会改变 只会保持显示状态
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    
//    animation.autoreverses = YES;//动画返回
    
    CAAnimationGroup *group=[CAAnimationGroup animation];
    [group setAnimations:[NSArray arrayWithObjects:scale,animation, nil]];
    [group setDuration:0.5];
//    animation.repeatCount = MAXFLOAT;//重复
    //tempView.layer.delegate = self;
    group.delegate= self;
    [moreSettingBackView.layer addAnimation:group forKey:SHOW_ANIM_KEY];
}


-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"anim stop");
//    if([moreSettingBackView.layer  animationForKey:SHOW_ANIM_KEY] ==anim)//不好用！！！
//    {
//        CGRect tempRect =  moreSettingBackView.frame;
//        tempRect.size.height = 88;
//        moreSettingBackView.frame = tempRect;
//        
//    }
//    else if ([moreSettingBackView.layer  animationForKey:DISMISS_ANIM_KEY]==anim)
//    {
//        CGRect tempRect =  moreSettingBackView.frame;
//        tempRect.size.height = 0;
//        moreSettingBackView.frame = tempRect;
//    }
////    
//    if(moreSettingBackViewFlag == NO)
//    {
//   //     moreSettingBackView.alpha = 0;
//        [moreSettingBackView removeFromSuperview];
//    }
//
}

-(void)positionDismissView:(UIView *)tempView
{
    
    
    CABasicAnimation *scale=[CABasicAnimation animationWithKeyPath:@"transform"];
    [scale setFromValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1, 1.0)]];
    [scale setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 0.0, 1.0)]];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake((moreSettingBackView.frame.origin.x+moreSettingBackView.frame.size.width/2),
                                                                (moreSettingBackView.frame.size.height/2 + moreSettingBackView.frame.origin.y))];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake((moreSettingBackView.frame.origin.x+moreSettingBackView.frame.size.width/2),
                                                              Header_Height)];
    //动画执行后保持显示状态 但是属性值不会改变 只会保持显示状态
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    
    //    animation.autoreverses = YES;//动画返回
    
    CAAnimationGroup *group=[CAAnimationGroup animation];
    [group setAnimations:[NSArray arrayWithObjects:scale,animation, nil]];
    [group setDuration:0.5];
    //    animation.repeatCount = MAXFLOAT;//重复
    group.delegate= self;
    [tempView.layer addAnimation:group forKey:DISMISS_ANIM_KEY];
    
    [self performSelector:@selector(viewSetHidden:) withObject:[NSNumber numberWithBool:YES] afterDelay:0.5 - 0.1];
}
-(void)viewSetHidden:(id)info
{
    moreSettingBackView.hidden = YES;
}

#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _sectionNum;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return planArr.count;
    
}

#pragma mark - setting for cell

#define ViewsGaptoLine 20
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight)];;
    
    @try {
        
        if(planArr == nil || planArr.count == 0 || indexPath.row > planArr.count -1)
            return cell;
        
        NSDictionary *tempDict = planArr[indexPath.row];
        
        
        cell.backgroundColor = BACKGROUND_COLOR;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *roundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        roundView.center = CGPointMake(LineGap, 20);
        roundView.backgroundColor = ItemsBaseColor;
        [cell addSubview:roundView];
        
        
        UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(LineGap+ ViewsGaptoLine, 0, SCREEN_WIDTH - (LineGap+ ViewsGaptoLine), 30)];
        timeLab.textAlignment = NSTextAlignmentLeft;
        timeLab.text = [NSString stringWithFormat:@"%@~%@",
                        [tempDict[@"StartTime"] substringToIndex:10],
                        [tempDict[@"EndTime"] substringToIndex:10]];
        timeLab.textColor = [UIColor grayColor];
        timeLab.font = [UIFont boldSystemFontOfSize:16];
        
        //用backgroundColor设置背景色
        //  UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"temp2"]];
        //    historyContentLab.backgroundColor = color;
        UIImageView *backImg = [[UIImageView alloc] init];//[[UIImageView alloc] initWithImage:img(@"temp2")];
        backImg.frame = CGRectMake(LineGap+ ViewsGaptoLine, timeLab.frame.size.height, SCREEN_WIDTH - LineGap - 30, _cellHeight-timeLab.frame.size.height -10);
        backImg.layer.cornerRadius = 5;
        backImg.backgroundColor = ItemsBaseColor;
        backImg.layer.masksToBounds  = YES;
        
        
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
        
        NSRange tempRange;
        tempRange.length = 5;
        tempRange.location = 11;
        timeLabInImg.text = [tempDict[@"PublishTime"] substringWithRange:tempRange];
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
        
        
        [cell setEditing:YES];
        
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
            roundBtn.tag = indexPath.row;
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
        
      //  tempBtn.selected = !tempBtn.selected;
        
//        for(int i =0;i < cellBtnArr.count;i++)
//        {
//            UIButton *tempBtn = cellBtnArr[indexPath.row];
//            
//            if(tempBtn.tag == indexPath.row)
//              [ self roundBtnClick:tempBtn];
//        }
        return;
    }
    TrainsPlanDetailViewController *trainPlanDetailViewCtl = [[TrainsPlanDetailViewController alloc] init];
    switch (cateId) {
        case WeekPlan:
            trainPlanDetailViewCtl.navtitle = @"周计划";
            break;
        case MonthPlan:
            trainPlanDetailViewCtl.navtitle = @"月计划";
            break;
        case SeasonPlan:
            trainPlanDetailViewCtl.navtitle = @"季计划";
            break;
        case YearPlan:
            trainPlanDetailViewCtl.navtitle = @"年计划";
            break;
        default:
            break;
    }
    trainPlanDetailViewCtl.planInfo = planArr[indexPath.row];
    
    [self.navigationController pushViewController:trainPlanDetailViewCtl animated:YES];
    
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

#define SectionHeight  0

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView = [[UIView alloc] init];
    
    UILabel *dateLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, SectionHeight)];
    dateLab.center = CGPointMake(LineGap+(SCREEN_WIDTH - LineGap)/2 , SectionHeight/2);
    dateLab.textAlignment = NSTextAlignmentCenter;
    dateLab.textColor = [UIColor grayColor];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(LineGap+1, SectionHeight/2,(SCREEN_WIDTH - 30 - dateLab.frame.size.width)/2 ,1)];
    lineView1.backgroundColor = [UIColor whiteColor];
    lineView1.alpha = 0.1;
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(dateLab.frame.origin.x+dateLab.frame.size.width, SectionHeight/2,(SCREEN_WIDTH - 30 - dateLab.frame.size.width)/2,1)];
    lineView2.backgroundColor = [UIColor whiteColor];
    lineView2.alpha = 0.1;
//    
//    [tempView addSubview:lineView1];
//    [tempView addSubview:dateLab];
//    [tempView addSubview:lineView2];
    switch (section) {
        case 0:
        {
            dateLab.text = @"今天";
        }
            break;
        case 1:
        {
            dateLab.text = @"昨天";
        }
            break;
        case 2:
        {
            dateLab.text = @"前天";
        }
            break;
        default:
            break;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
