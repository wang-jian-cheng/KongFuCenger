//
//  MushaMatchDetailViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/12.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "MushaMatchDetailViewController.h"

@interface MushaMatchDetailViewController ()
{
#pragma mark - pram for tableView
    NSInteger _sectionNum;
    CGFloat _cellHeight;
    UITableView *_mainTableView;
}
@end
#define GapToLeft   20

@implementation MushaMatchDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self setBarTitle:@"更多"];
    [self addLeftButton:@"left"];
    [self initViews];
    // Do any additional setup after loading the view.
}
-(void)initViews
{
    _cellHeight = SCREEN_HEIGHT/12;
    _sectionNum = 5;
    
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height )];
    _mainTableView.backgroundColor = BACKGROUND_COLOR;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorColor =  Separator_Color;
    _mainTableView.tableFooterView = [[UIView alloc] init];
    //_mainTableView.scrollEnabled = NO;
    
    _mainTableView.contentSize = CGSizeMake(SCREEN_HEIGHT, _sectionNum*(_cellHeight + 20));
    [self.view addSubview:_mainTableView];
    

    
}

#pragma mark - Click actions
-(void)actionBtnClick:(UIButton*)sender
{
    if([sender.titleLabel.text isEqualToString:@"我要报名"])
    {
        ApplyForMatchViewController *applyForMatchViewCtl = [[ApplyForMatchViewController alloc] init];
        applyForMatchViewCtl.navtitle = @"武者大赛报名";
        [self.navigationController pushViewController:applyForMatchViewCtl animated:YES];
    }
}

#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _sectionNum;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}

#pragma mark - setting for cell
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight)];
    cell.backgroundColor = ItemsBaseColor;
    switch (indexPath.section) {
        case 0:
        {
//            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight*5)];
//            cell.backgroundColor = ItemsBaseColor;
            UIImageView *mainImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, _cellHeight*4)];
            mainImgView.image = [UIImage imageNamed:@"yewenback"];
            [cell addSubview:mainImgView];
            
            UILabel *titlelab = [[UILabel alloc ]initWithFrame:CGRectMake(GapToLeft, mainImgView.frame.size.height+5, SCREEN_WIDTH-GapToLeft, _cellHeight/2-5)];
            titlelab.text = @"临沂第一届国际武术大赛";
            titlelab.textColor = [UIColor whiteColor];
            titlelab.font = [UIFont systemFontOfSize:14];
            [cell addSubview:titlelab];
            
            UIButton *placeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, _cellHeight/2-5)];
            [placeBtn setImage:[UIImage imageNamed:@"dingwei"] forState:UIControlStateNormal];
            UIView *backView = [[UIView alloc] initWithFrame:placeBtn.frame];
            
            UITextField *placeLab = [[UITextField alloc] initWithFrame:CGRectMake(GapToLeft,(titlelab.frame.size.height+titlelab.frame.origin.y) , SCREEN_WIDTH-GapToLeft, _cellHeight/2-5)];
            placeLab.leftView =backView;
            placeLab.leftViewMode = UITextFieldViewModeAlways;
            placeLab.text = @"临沂市兰山区沂蒙路和上海路交汇处朗润大厦18楼";
            placeLab.textColor = [UIColor whiteColor];
            placeLab.font = [UIFont systemFontOfSize:14];
            
            placeLab.enabled = NO;
            [placeLab addSubview:placeBtn];
            [cell addSubview:placeLab];

            
        }
            break;
        case 1:
        {
            UILabel *titlelab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 0, SCREEN_WIDTH, _cellHeight/2)];
            titlelab.text = @"活动详情：";
            titlelab.textColor = [UIColor whiteColor];
            titlelab.font = [UIFont systemFontOfSize:16];
            [cell addSubview:titlelab];
            
            NSString *str = @"武林大会是蜗牛以旗下广受好评的真武侠游戏《九阴真经》为平台举办的网游竞赛活动，";
            
            CGFloat height = [Toolkit heightWithString:str fontSize:14 width:(SCREEN_WIDTH-GapToLeft)]+10;
            height = height > (_cellHeight*3 -  (titlelab.frame.size.height+titlelab.frame.origin.y))?(_cellHeight*3 -  (titlelab.frame.size.height+titlelab.frame.origin.y)):height;
            UITextView *contentView = [[UITextView alloc] initWithFrame:CGRectMake(GapToLeft, (titlelab.frame.size.height+titlelab.frame.origin.y), SCREEN_WIDTH-GapToLeft, height)];
            contentView.editable = NO;
            contentView.textColor = [UIColor whiteColor];
            contentView.font = [UIFont systemFontOfSize:14];
            contentView.text = str;
            contentView.backgroundColor = ItemsBaseColor;
            [cell addSubview:contentView];
        }
            break;
        case 2:
        {
            UILabel *sendTimetip = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, (SCREEN_WIDTH-60)/2 -20, _cellHeight/2)];
            sendTimetip.text = @"公布时间:";
            sendTimetip.textColor = [UIColor whiteColor];
            sendTimetip.font = [UIFont systemFontOfSize:14];
            [cell addSubview:sendTimetip];
            
            UILabel *sendTime = [[UILabel alloc] initWithFrame:CGRectMake(30, _cellHeight/2, (SCREEN_WIDTH-60)/2-20, _cellHeight/2)];
            sendTime.text = @"2016.2.10";
            sendTime.textColor = YellowBlock;
            sendTime.font = [UIFont systemFontOfSize:14];
            [cell addSubview:sendTime];
            
            [Toolkit drawLine:SCREEN_WIDTH/2 +20 andSY:0 andEX:SCREEN_WIDTH/2-20 andEY:_cellHeight andLW:1 andColor:Separator_Color andView:cell];
            
            UILabel *startTimetip = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 +23, 0, (SCREEN_WIDTH-60)/2 , _cellHeight/2)];
            startTimetip.text = @"开始时间:";
            startTimetip.textColor = [UIColor whiteColor];
            startTimetip.font = [UIFont systemFontOfSize:14];
            [cell addSubview:startTimetip];
            
            UILabel *startTime = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 +23, _cellHeight/2, (SCREEN_WIDTH-60)/2, _cellHeight/2)];
            startTime.text = @"2016.2.10 12:00:00";
            startTime.textColor = YellowBlock;
            startTime.font = [UIFont systemFontOfSize:14];
            [cell addSubview:startTime];
            
        }
            break;
        case 3:
        {
            UILabel *endTimetip = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, (SCREEN_WIDTH-60)/2-20, _cellHeight/2)];
            endTimetip.text = @"结束时间:";
            endTimetip.textColor = [UIColor whiteColor];
            endTimetip.font = [UIFont systemFontOfSize:14];
            [cell addSubview:endTimetip];
            
            UILabel *endTime = [[UILabel alloc] initWithFrame:CGRectMake(30, _cellHeight/2, (SCREEN_WIDTH-60)/2-20, _cellHeight/2)];
            endTime.text = @"2016.2.10";
            endTime.textColor = YellowBlock;
            endTime.font = [UIFont systemFontOfSize:14];
            [cell addSubview:endTime];
            
            [Toolkit drawLine:SCREEN_WIDTH/2 -20 andSY:0 andEX:SCREEN_WIDTH/2+20 andEY:_cellHeight andLW:1 andColor:Separator_Color andView:cell];
            
            UILabel *deadlineTimetip = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 +20+3, 0, (SCREEN_WIDTH-60)/2, _cellHeight/2)];
            deadlineTimetip.text = @"报名截止:";
            deadlineTimetip.textColor = [UIColor whiteColor];
            deadlineTimetip.font = [UIFont systemFontOfSize:14];
            [cell addSubview:deadlineTimetip];
            
            UILabel *deadlineTime = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 +20+3, _cellHeight/2, (SCREEN_WIDTH-60)/2, _cellHeight/2)];
            deadlineTime.text = @"2016.2.10 12:00:00";
            deadlineTime.textColor = YellowBlock;
            deadlineTime.font = [UIFont systemFontOfSize:14];
            [cell addSubview:deadlineTime];
        }
            break;
        case 4:
        {
            UILabel *titlelab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 0, SCREEN_WIDTH-GapToLeft, _cellHeight/2)];
            titlelab.text = @"赛事要求：";
            titlelab.textColor = [UIColor whiteColor];
            titlelab.font = [UIFont systemFontOfSize:16];
            [cell addSubview:titlelab];
            
            
            NSString *str = @"让全球玩家通过形神兼备的武功招式、手脑并用的立体激斗，领略到一个融视、听、感为一体的武侠江湖，让所有参与者在精彩的世界电竞盛会中感受武侠和武术文化的独特魅力，最终将武侠这一独特的东方文化发扬、传播至全球";
            
            CGFloat height = [Toolkit heightWithString:str fontSize:14 width:SCREEN_WIDTH-GapToLeft]+10;
            height = height > (_cellHeight*3 -  (titlelab.frame.size.height+titlelab.frame.origin.y - _cellHeight))?(_cellHeight*3 -  (titlelab.frame.size.height+titlelab.frame.origin.y)- _cellHeight):height;
            UITextView *contentView = [[UITextView alloc] initWithFrame:CGRectMake(GapToLeft, (titlelab.frame.size.height+titlelab.frame.origin.y), SCREEN_WIDTH-GapToLeft, height)];
            contentView.editable = NO;
            contentView.textColor = [UIColor whiteColor];
            contentView.font = [UIFont systemFontOfSize:14];
            contentView.text = str;
            contentView.backgroundColor = ItemsBaseColor;
            [cell addSubview:contentView];
            
            UIButton *actionBtn =[[UIButton alloc] initWithFrame:CGRectMake(GapToLeft, (contentView.frame.size.height + contentView.frame.origin.y + 10), (SCREEN_WIDTH -GapToLeft*2 -50)/2, _cellHeight )];
            actionBtn.backgroundColor = BACKGROUND_COLOR;
            [actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [actionBtn setTitle:@"我要报名" forState:UIControlStateNormal];
            actionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [actionBtn addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:actionBtn];
            
            
            UIButton *checkBtn =[[UIButton alloc] initWithFrame:CGRectMake((actionBtn.frame.size.width+actionBtn.frame.origin.x +50), (contentView.frame.size.height + contentView.frame.origin.y + 10), (SCREEN_WIDTH -GapToLeft*2 -50)/2, _cellHeight)];
            checkBtn.backgroundColor = BACKGROUND_COLOR;
            [checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [checkBtn setTitle:@"查看报名选手" forState:UIControlStateNormal];
            checkBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [cell addSubview:checkBtn];
            
        }
            break;
        default:
            break;
    }
    return cell;
    
}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            return _cellHeight*5;
            break;
        case 1:
            return _cellHeight*3;
            break;
        case 2:
            return _cellHeight;
            break;
        case 3:
            return _cellHeight;
            break;
        case 4:
            return _cellHeight*4;
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
    return 10;
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
