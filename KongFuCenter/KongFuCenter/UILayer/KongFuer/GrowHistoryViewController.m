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
}
@end

@implementation GrowHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLeftButton:@"left"];
    [self addRightbuttontitle:@"编辑"];
    
    [self initViews];
    
    // Do any additional setup after loading the view.
}


-(void)initViews
{
    _cellHeight = 200;
    _sectionNum = 3;
    
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height )];
    _mainTableView.backgroundColor = BACKGROUND_COLOR;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorColor =  Separator_Color;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.tableFooterView = [[UIView alloc] init];
    //_mainTableView.scrollEnabled = NO;
    
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

#pragma mark - Btn click 
-(void)clickRightButton:(UIButton *)sender
{
    EnditMode = !EnditMode;
    [_mainTableView reloadData];
}

#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _sectionNum;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return section+1;
    
}

#pragma mark - setting for cell

#define ViewsGaptoLine 20
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight)];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = BACKGROUND_COLOR;
   // cell.selectionStyle = UITableViewCellSelectionStyleGray;
    UIView *roundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    roundView.center = CGPointMake(LineGap, 20);
    roundView.backgroundColor = ItemsBaseColor;
    [cell addSubview:roundView];
    
    
    UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(LineGap+ ViewsGaptoLine, 0, 100, 30)];
    timeLab.textAlignment = NSTextAlignmentLeft;
    timeLab.text = @"刚刚发布";
    timeLab.textColor = [UIColor grayColor];
    timeLab.font = [UIFont boldSystemFontOfSize:16];
    
//用backgroundColor设置背景色
//  UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"temp2"]];
//    historyContentLab.backgroundColor = color;
    UIImageView *backImg = [[UIImageView alloc] initWithImage:img(@"temp2")];
    backImg.frame = CGRectMake(LineGap+ ViewsGaptoLine, timeLab.frame.size.height, SCREEN_WIDTH - LineGap - 30, _cellHeight-timeLab.frame.size.height -10);
    backImg.layer.cornerRadius = 5;
    backImg.layer.masksToBounds  = YES;
    
    
    UILabel *historyTitleLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, backImg.frame.size.width -20, 30)];
    historyTitleLab.text = @"我最新学习咏春拳的招式";
    historyTitleLab.textAlignment = NSTextAlignmentLeft;
    historyTitleLab.textColor = [UIColor whiteColor];
    historyTitleLab.font = [UIFont boldSystemFontOfSize:16];
    
    UILabel *historyContentLab = [[UILabel alloc] initWithFrame:
                                  CGRectMake(10,
                                            (historyTitleLab.frame.size.height+historyTitleLab.frame.origin.y),
                                            backImg.frame.size.width -20,
                                            (backImg.frame.size.height - (historyTitleLab.frame.size.height+historyTitleLab.frame.origin.y)/*顶部*/ - 50/*底部*/))
                                  ];
    historyContentLab.text = @"咏春拳是中国的传统武术，是一门禁止侵袭的技术，是一个积极精简的防卫系统,是：撒旦活塞队你撒第三名那肯定马上看到美食卡牡丹卡少年夫妇被腹背受敌发布的是腹背受敌积分榜上大部分还是";
    historyContentLab.numberOfLines = 0;
    historyContentLab.textAlignment = NSTextAlignmentLeft;
    historyContentLab.textColor = [UIColor whiteColor];
    historyContentLab.font = [UIFont systemFontOfSize:16];
    
    UILabel *timeLabInImg = [[UILabel alloc] initWithFrame:CGRectMake((backImg.frame.size.width - 10 -60), (backImg.frame.size.height - 40), 60, 30)];
    timeLabInImg.text = @"5:00";
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
    
    
    //[cell setEditing:YES];
    
    if(EnditMode)
    {
        
        
//        for (int i =0 ; i<cell.contentView.subviews.count; i++) {
//            UIView *tempView ;
//            
//            
//            tempView = [cell.contentView.subviews objectAtIndex:i];
//            tempView.frame = CGRectMake(30, 0, 100, 100);
//            
//            
//            [cell layoutSubviews];
//            
//            //            [ [cell.subviews objectAtIndex:i] removeFromSuperview];//清空一下原来cell上面的view'防止cell的重用影响到后面section的显示
//        }
//        
        [cell setCellEditMode:YES andBtnCenter:CGPointMake(15, _cellHeight/2) ];
    }
    else
    {

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

    [tempView addSubview:lineView1];
    [tempView addSubview:dateLab];
    [tempView addSubview:lineView2];
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
