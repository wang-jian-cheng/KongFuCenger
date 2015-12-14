//
//  FriendInfoViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/14.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "FriendInfoViewController.h"

@interface FriendInfoViewController ()
{
#pragma mark - pram for tableView
    NSInteger _sectionNum;
    CGFloat _cellHeight;
    UITableView *_mainTableView;
}
@end
#define GapToLeft   20//(cell.textLabel.frame.origin.x)

@implementation FriendInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"left"];
    [self initViews];
    // Do any additional setup after loading the view.
}

-(void)initViews
{
    _cellHeight = SCREEN_HEIGHT/12;
    _sectionNum = 1;
    
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height )];
    _mainTableView.backgroundColor = BACKGROUND_COLOR;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorColor =  Separator_Color;
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight*3)];
    
    UIButton *opBtn = [[UIButton alloc] initWithFrame:CGRectMake(GapToLeft, _cellHeight, SCREEN_WIDTH- 2*GapToLeft, _cellHeight)];
    opBtn.backgroundColor = YellowBlock;
    [opBtn setTitle:@"发送消息" forState:UIControlStateNormal];
    [tempView addSubview:opBtn];
    _mainTableView.tableFooterView = tempView;
    //_mainTableView.scrollEnabled = NO;
    
  //  _mainTableView.contentSize = CGSizeMake(SCREEN_WIDTH, 15*_cellHeight);
    [self.view addSubview:_mainTableView];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}


#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _sectionNum;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 6;
    
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
    
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight)];
    cell.backgroundColor = ItemsBaseColor;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    switch (indexPath.row) {
        case 0:
        {
            UIImageView *backImg = [[UIImageView alloc]  initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight*4)];
            backImg.image = [UIImage imageNamed:@"head_bg"];
            [cell addSubview:backImg];
            
            UserHeadView *headView = [[UserHeadView alloc] initWithFrame:CGRectMake(GapToLeft, 3*_cellHeight, 2*_cellHeight, 2*_cellHeight) andImgName:@"me"];
            [headView makeSelfRound];
            headView.layer.borderWidth = 1;
            headView.layer.borderColor = [[UIColor blackColor] CGColor];
            [cell addSubview:headView];
            
            
            
            UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake((headView.frame.origin.x+headView.frame.size.width), 4*_cellHeight+5, 200, _cellHeight/2)];
            nameLab.text = @"成龙";
            nameLab.textColor = YellowBlock;
            nameLab.font = [UIFont boldSystemFontOfSize:16];
            [cell addSubview:nameLab];
            
            UILabel *otherInfoLab = [[UILabel alloc] initWithFrame:CGRectMake((nameLab.frame.origin.x),
                                                                             (nameLab.frame.origin.y+nameLab.frame.size.height+5),
                                                                             (SCREEN_WIDTH - headView.frame.size.width - headView.frame.origin.x),
                                                                              _cellHeight/2)];
            otherInfoLab.textColor = [UIColor whiteColor];
            otherInfoLab.font = [UIFont systemFontOfSize:14];
            otherInfoLab.text = [NSString stringWithFormat:@"%@  %d岁  %@",@"男",26,@"山东 临沂 兰山区"];
            
            [cell addSubview:otherInfoLab];
            
            
            
        }
            break;
        case 1:
        {

            UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 0, 100, _cellHeight)];
            titleLab.text = @"账号信息：";
            titleLab.textColor = [UIColor whiteColor];
            titleLab.font = [UIFont systemFontOfSize:16];
            [cell addSubview:titleLab];

            UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 20 -200), 0, 200, _cellHeight)];
            numLab.text = @"18810375555";
            numLab.textColor = [UIColor grayColor];
            numLab.textAlignment = NSTextAlignmentRight;
            [cell addSubview:numLab];
        }
            break;
        case 2:
        {

            UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 0, 100, _cellHeight)];
            titleLab.text = @"身高：";
            titleLab.textColor = [UIColor whiteColor];
            titleLab.font = [UIFont systemFontOfSize:16];
            [cell addSubview:titleLab];

            UILabel *heightLab = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 20 -200), 0, 200, _cellHeight)];
            heightLab.text = @"180Cm";
            heightLab.textColor = [UIColor grayColor];
            heightLab.textAlignment = NSTextAlignmentRight;
            [cell addSubview:heightLab];
        }
            break;
        case 3:
        {

            UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 0, 100, _cellHeight)];
            titleLab.text = @"体重：";
            titleLab.textColor = [UIColor whiteColor];
            titleLab.font = [UIFont systemFontOfSize:16];
            [cell addSubview:titleLab];

            UILabel *weightLab = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 20 -200), 0, 200, _cellHeight)];
            weightLab.text = @"8kg";
            weightLab.textColor = [UIColor grayColor];
            weightLab.textAlignment = NSTextAlignmentRight;
            [cell addSubview:weightLab];
        }
            break;
        case 4:
        {
           
            UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 0, 100, _cellHeight)];
            titleLab.text = @"习武时间：";
            titleLab.textColor = [UIColor whiteColor];
            titleLab.font = [UIFont systemFontOfSize:16];
            [cell addSubview:titleLab];

            
            UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 20 -200), 0, 200, _cellHeight)];
            timeLab.text = @"3年";
            timeLab.textColor = [UIColor grayColor];
            timeLab.textAlignment = NSTextAlignmentRight;
            [cell addSubview:timeLab];
        }
            break;
        case 5:
        {

            UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 0, SCREEN_WIDTH-cell.textLabel.frame.origin.x, _cellHeight)];
            titleLab.text = @"个人简历:";
            titleLab.textColor = [UIColor whiteColor];
            titleLab.font = [UIFont systemFontOfSize:16];
            [cell addSubview:titleLab];
            
            NSString *contentStr = @"666 很好 很好 很好，666 很好 很好 很好，666 很好 很好 很好，666 很好 很好 很好，666 很好 很好 很好";
            CGFloat contentWidth = (SCREEN_WIDTH -GapToLeft - 20);
            CGFloat contentHeight = [Toolkit heightWithString:contentStr fontSize:16 width:contentWidth]+10;
            contentHeight = contentHeight > (_cellHeight*3)?(_cellHeight*3):contentHeight;
            
            UITextView *contentLan = [[UITextView alloc] initWithFrame:CGRectMake(GapToLeft, _cellHeight-10, contentWidth, _cellHeight*3)];
            contentLan.font = [UIFont systemFontOfSize:16];
            contentLan.textColor = [UIColor grayColor];
            contentLan.text = contentStr;
            contentLan.editable = NO;
            contentLan.backgroundColor = ItemsBaseColor;

            [cell addSubview:contentLan];
          
        }
            break;
        default:
            break;
    }
    
    return cell;
    
}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return _cellHeight*6;
            break;
        case 1:
        case 2:
        case 3:
        case 4:
            return _cellHeight;
            break;
        case 5:
            return 4*_cellHeight;
            break;
        default:
            break;
    }
    return _cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失

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
