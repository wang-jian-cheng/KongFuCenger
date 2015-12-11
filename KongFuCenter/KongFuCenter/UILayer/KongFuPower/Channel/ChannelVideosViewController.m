//
//  ChannelVideosViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/10.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "ChannelVideosViewController.h"
#define GapToLeft   20
@interface ChannelVideosViewController ()
{
    UIImageView *btnImgView;
#pragma mark - pram for tableView
    NSInteger _sectionNum;
    CGFloat _cellHeight;
    UITableView *_mainTableView;
    
    NSArray *dataArr;
    NSMutableArray *studyCateArr;
    NSMutableArray *btnArr;
    
}
@end

@implementation ChannelVideosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self addLeftButton:@"left"];
    
    [self initViews];
    // Do any additional setup after loading the view.
}
-(void)initViews
{
    
    
    
    _cellHeight = (SCREEN_HEIGHT - Header_Height - TabBar_HEIGHT)/2;
    _sectionNum = 3;
    
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height  )];
    _mainTableView.backgroundColor = BACKGROUND_COLOR;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorColor =  Separator_Color;
    _mainTableView.tableFooterView = [[UIView alloc] init];
    //_mainTableView.scrollEnabled = NO;
    
    _mainTableView.contentSize = CGSizeMake(SCREEN_HEIGHT, _sectionNum*(_cellHeight + 20));
    
    dataArr = @[@"zhenzidan",@"lixiaolong",@"chenglong"];
    [self.view addSubview:_mainTableView];
    
    
    
    
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
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight)];
    backgroundView.image = [UIImage imageNamed:dataArr[indexPath.section]];
    cell.backgroundView = backgroundView;
    {
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(GapToLeft, (_cellHeight - 50), (SCREEN_WIDTH - GapToLeft), 1)];
        lineView.backgroundColor = Separator_Color;
        [cell addSubview:lineView];
        
        
        //线上
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, (lineView.frame.origin.y - 30), 200, 30)];
        titleLab.text = @"降龙十八掌真传演示仅供参考";
        titleLab.textColor = [UIColor whiteColor];
        titleLab.font = [UIFont boldSystemFontOfSize:16];
        [cell addSubview:titleLab];
        
        UIButton *relayBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 30 -20), (lineView.frame.origin.y - 30), 30, 30)];
        [relayBtn setImage:[UIImage imageNamed:@"relay"] forState:UIControlStateNormal];
        [cell addSubview:relayBtn];
        
        //under line
        UserHeadView *headView = [[UserHeadView alloc] initWithFrame:CGRectMake(GapToLeft, lineView.frame.origin.y+(50 - 35)/2, 35, 35) andImgName:@"me" andNav:(self.navigationController)];
        [headView makeSelfRound];
        [cell addSubview:headView];
        
        
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake((headView.frame.origin.x+headView.frame.size.width + 5),
                                                                     (headView.frame.size.height/4+headView.frame.origin.y), 60, headView.frame.size.height/2)];
        
        nameLab.textColor = [UIColor whiteColor];
        nameLab.text = @"鹿晗鹿丸梅花鹿";
        nameLab.font = [UIFont systemFontOfSize:14];
        [cell addSubview:nameLab];
        
        
        UIButton *commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(((nameLab.frame.origin.x+nameLab.frame.size.width + 10)),
                                                                          (headView.frame.size.height/4+headView.frame.origin.y),
                                                                          (SCREEN_WIDTH - (nameLab.frame.origin.x+nameLab.frame.size.width + 10) -10)/2,
                                                                          headView.frame.size.height/2)];
        [commentBtn setImage:[UIImage imageNamed:@"chat"] forState:UIControlStateNormal];
        [commentBtn setTitle:@"100条评论" forState:UIControlStateNormal];
        commentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [cell addSubview:commentBtn];
        
        UIButton *timeBtn = [[UIButton alloc] initWithFrame:CGRectMake(((commentBtn.frame.origin.x+commentBtn.frame.size.width + 5)),
                                                                       (headView.frame.size.height/4+headView.frame.origin.y),
                                                                       commentBtn.frame.size.width,//(SCREEN_WIDTH - (nameLab.frame.origin.x+nameLab.frame.size.width + 10) -10)/2,
                                                                       headView.frame.size.height/2)];
        [timeBtn setImage:[UIImage imageNamed:@"clock"] forState:UIControlStateNormal];
        [timeBtn setTitle:@"10:00之前" forState:UIControlStateNormal];
        timeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [cell addSubview:timeBtn];
        
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
    
    VideoDetailViewController *videoDetailViewCtl = [[VideoDetailViewController alloc] init];
    videoDetailViewCtl.navtitle =@"视频";
    [self.navigationController pushViewController:videoDetailViewCtl animated:YES];
    
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
