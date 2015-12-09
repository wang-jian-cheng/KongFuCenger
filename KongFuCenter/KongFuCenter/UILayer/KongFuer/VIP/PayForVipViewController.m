//
//  PayForVipViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/9.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "PayForVipViewController.h"

#define GapToLeft   20

@interface PayForVipViewController ()
{
    NSArray *taocanArr;
    NSMutableArray *selectBtnArr;
    NSMutableArray *roundBtnArr;
#pragma mark - pram for tableView
    NSInteger _sectionNum;
    CGFloat _cellHeight;
    UITableView *_mainTableView;
    
    
    
}
@end

@implementation PayForVipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    taocanArr = @[@"一个月20元",
                  @"两个月40元",
                  @"三个月60元"];
    selectBtnArr = [NSMutableArray array];
    roundBtnArr = [NSMutableArray array];

    [self addLeftButton:@"left"];
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self initViews];
    // Do any additional setup after loading the view.
}

-(void)initViews
{
    _cellHeight = SCREEN_HEIGHT /12;
    _sectionNum = 2;
    for(int i =0;i<3;i++)
    {
        UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 60 -20), 10, 60, _cellHeight-20)];
        [selectBtn setTitle:@"开通" forState:UIControlStateNormal];
        selectBtn.layer.masksToBounds = YES;
        selectBtn.layer.cornerRadius = selectBtn.frame.size.height / 2;
        [selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        selectBtn.tag = i;
        selectBtn.backgroundColor = [UIColor grayColor];
        
        [selectBtnArr addObject:selectBtn];
    }
    
    for(int i = 0;i<2;i++)
    {
        SelectRoundBtn *roundBtn = [[SelectRoundBtn alloc] initWithCenter:CGPointMake((SCREEN_WIDTH - 60), _cellHeight/2)];
        roundBtn.backgroundColor = BACKGROUND_COLOR;
        [roundBtn addTarget:self action:@selector(roundBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [roundBtnArr addObject:roundBtn];
    }
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, 8*_cellHeight)];
    _mainTableView.backgroundColor = BACKGROUND_COLOR;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorColor =  Separator_Color;
    _mainTableView.tableFooterView = [[UIView alloc] init];
    //_mainTableView.scrollEnabled = NO;
    
    _mainTableView.contentSize = CGSizeMake(SCREEN_HEIGHT, _sectionNum*(_cellHeight + 20));
    [self.view addSubview:_mainTableView];
    
    UIButton *payBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, (_mainTableView.frame.origin.y + _mainTableView.frame.size.height), SCREEN_WIDTH-20*2, 44)];
    payBtn.backgroundColor  = YellowBlock;
    [payBtn setTitle:@"确定" forState:UIControlStateNormal];
}


-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

#pragma mark - click action

-(void)selectBtnClick:(UIButton *)sender
{
    sender.backgroundColor = YellowBlock;
    sender.selected = YES;
    
    for(UIButton *tempBtn in selectBtnArr)
    {
        if(tempBtn != sender)
        {
            tempBtn.backgroundColor = [UIColor grayColor];
            tempBtn.selected = NO;
        }
    }
}


-(void)roundBtnClick:(UIButton *)sender
{
    sender.selected = YES;
    
    for(UIButton *tempBtn in roundBtnArr)
    {
        if(tempBtn != sender)
        {
            tempBtn.selected = NO;
        }
    }
}

#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _sectionNum;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section == 0)
    {
        return 4;
    }
    else if(section == 1)
    {
        return 3;
    }
    
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
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight)];
    cell.backgroundColor = ItemsBaseColor;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.section) {
        case 0:
            {
                switch (indexPath.row) {
                    case 0:
                    {
                        cell.textLabel.text = @"会员套餐";
                        cell.textLabel.textColor = [UIColor whiteColor];
                        cell.textLabel.font = [UIFont systemFontOfSize:16];
//                        UILabel * titlLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 0, 60, _cellHeight)];
//                        titlLab.text =@"会员套餐:";
//                        titlLab.textColor = [UIColor whiteColor];
//                        titlLab.font = [UIFont systemFontOfSize:16];
//
                       
                        
                        UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 10 - 100), 0, 100, _cellHeight)];
                        tipLab.text = @"已同意服务协议";
                        tipLab.textColor = [UIColor whiteColor];
                        tipLab.font = [UIFont systemFontOfSize:12];
                        
                        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake((tipLab.frame.origin.x- 10), 5, 1, _cellHeight - 10)];
                        
                        lineView.backgroundColor = Separator_Color;
                        [cell addSubview:lineView];
                        [cell addSubview:tipLab];
                    }
                        break;
                        
                    default:
                    {

                        cell.textLabel.textColor = [UIColor whiteColor];
                        
                        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:taocanArr[indexPath.row - 1]];
                        [str addAttribute:NSForegroundColorAttributeName value:YellowBlock range:NSMakeRange(3,2)];
                        cell.textLabel.attributedText = str;
                        cell.textLabel.font = [UIFont systemFontOfSize:14];

                        
                        if(selectBtnArr == nil || indexPath.row - 1 >selectBtnArr.count -1||selectBtnArr.count == 0 )
                        {
                            break;
                        }
                        
                        UIButton *tempBtn = [selectBtnArr objectAtIndex:(indexPath.row - 1)];
                       
                        [cell addSubview:tempBtn];
                        
                    }
                        break;
                }
            }
            break;
        case 1:
        {
            if(indexPath.row == 0)
            {
                cell.textLabel.text = @"支付方式";
                cell.textLabel.textColor = [UIColor whiteColor];
                cell.textLabel.font = [UIFont systemFontOfSize:16];
            }
            else if(indexPath.row == 1)
            {
                cell.imageView.image = [UIImage imageNamed:@"zhifubao"];
                cell.textLabel.text = @"支付宝支付";
                cell.textLabel.textColor = [UIColor whiteColor];
                cell.textLabel.font = [UIFont systemFontOfSize:14];

                [cell addSubview:roundBtnArr[indexPath.row - 1]];
                
                
            }
            else if(indexPath.row == 2)
            {
                cell.imageView.image = [UIImage imageNamed:@"weixin"];
                cell.textLabel.text = @"微信支付";
                cell.textLabel.textColor = [UIColor whiteColor];
                cell.textLabel.font = [UIFont systemFontOfSize:14];
                
                [cell addSubview:roundBtnArr[indexPath.row - 1]];
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
