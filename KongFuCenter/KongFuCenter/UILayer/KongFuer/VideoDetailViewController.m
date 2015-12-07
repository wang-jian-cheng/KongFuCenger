//
//  VideoDetailViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/7.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "VideoDetailViewController.h"
#import "UserHeadView.h"

#define VideoPlaySection    0
#define VideoDetailSection  1
#define OtherVideoSection   2
#define CommentSection      3

#define GapToLeft           10
#define TextColors          [UIColor whiteColor]

@interface VideoDetailViewController ()
{
#pragma mark - pram for tableView
    NSInteger _sectionNum;
    CGFloat _cellHeight;
    UITableView *_mainTableView;
}
@end

@implementation VideoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
    // Do any additional setup after loading the view.
}



-(void)initViews
{
    _cellHeight = SCREEN_HEIGHT/12;
    _sectionNum = 4;
    
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height )];
    _mainTableView.backgroundColor = BACKGROUND_COLOR;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorColor = Separator_Color;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _mainTableView.tableFooterView = [[UIView alloc] init];
    //_mainTableView.scrollEnabled = NO;
    
    _mainTableView.contentSize = CGSizeMake(SCREEN_HEIGHT, _sectionNum*(_cellHeight + 20));
    [self.view addSubview:_mainTableView];
    
}


#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _sectionNum;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case VideoDetailSection:
            return 2;
            break;
        case OtherVideoSection:
            return 2;
            break;
        case CommentSection:
            return 3;
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
    
    
    switch (indexPath.section) {
        case VideoDetailSection:
        {
            if(indexPath.row == 0)
            {
                
                CGFloat FontSize = 12;
                
                /*head */
                UserHeadView *headView = [[UserHeadView alloc] initWithFrame:CGRectMake(GapToLeft, 10, 44, 44) andImgName:@"me"];
                [headView makeSelfRound];
                [cell addSubview:headView];
                
                /*name*/
                UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake((headView.frame.origin.x +headView.frame.size.width + 10),
                                                                             10, 60, 20)];
                nameLab.text = @"鹿晗";
                nameLab.textColor = TextColors;
                nameLab.font = [UIFont systemFontOfSize:FontSize];
                [cell addSubview:nameLab];
                
                
                /*举报*/
                UIButton *jubaoBtn = [[UIButton alloc] initWithFrame:CGRectMake((nameLab.frame.origin.x +nameLab.frame.size.width + 10),
                                                                                10, 40, 20)];
                [jubaoBtn setTitle:@"举报" forState:UIControlStateNormal];
                jubaoBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize];
                [cell addSubview:jubaoBtn];
                
                /*date*/
                UILabel *dateLab = [[UILabel alloc] initWithFrame:CGRectMake(nameLab.frame.origin.x,
                                                                            (nameLab.frame.origin.y + nameLab.frame.size.height + 2),
                                                                             100, 20)];
                dateLab.text = @"发布于2015年04月20日";
                dateLab.textColor = TextColors;
                dateLab.font = [UIFont systemFontOfSize:FontSize];
                [cell addSubview:dateLab];
                
                /* 四个点击图标 放到一个新的view上方便计算位置*/
                
                UIView *backView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 200 ), 0, 200 , _cellHeight)];
                backView.backgroundColor = cell.backgroundColor;
                [cell addSubview:backView];
                CGFloat btnW = 44;
                CGFloat btnGap = 5;
                CustomButton *SupportBtn = [[CustomButton alloc] initWithFrame:CGRectMake(0, 0, btnW, backView.frame.size.height)];
                [SupportBtn setTitle:@"点赞" forState:UIControlStateNormal];
                SupportBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize];
                [backView addSubview:SupportBtn];
                
                CustomButton *collectBtn = [[CustomButton alloc] initWithFrame:CGRectMake(btnW+btnGap, 0, btnW, backView.frame.size.height)];
                [collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
                collectBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize];
                [backView addSubview:collectBtn];
                
                CustomButton *shareBtn = [[CustomButton alloc] initWithFrame:CGRectMake((btnW+btnGap)*2, 0, btnW, backView.frame.size.height)];
                [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
                shareBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize];
                [backView addSubview:shareBtn];
                
                CustomButton *relayBtn = [[CustomButton alloc] initWithFrame:CGRectMake((btnW+btnGap)*3, 0, btnW, backView.frame.size.height)];
                [relayBtn setTitle:@"转发" forState:UIControlStateNormal];
                relayBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize];
                [backView addSubview:relayBtn];
                
            }
            
            if(indexPath.row == 1)
            {
                UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 10, SCREEN_WIDTH, 30)];
                titleLab.textColor = TextColors;
                titleLab.text = @"名字：咏春拳最快制敌方法";
                titleLab.font = [UIFont boldSystemFontOfSize:14];
                [cell addSubview:titleLab];
                
                
                UILabel *detailLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft,
                                                                               (titleLab.frame.origin.y+titleLab.frame.size.height+5),
                                                                               SCREEN_WIDTH, 3*_cellHeight - 30)];
                detailLab.textColor = TextColors;
                detailLab.text = @"简介：咏春拳是一门传统的中国武术，是一门禁止侵袭技术，是一个积极、精简的正当防卫系统";
                detailLab.numberOfLines = 0;
                [cell addSubview:detailLab];
                
            }
        }
            break;
        case OtherVideoSection:
        {
            if(indexPath.row == 0)
            {
                UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 0, 150, _cellHeight)];
                titleLab.text = @"其他作品";
                titleLab.font = [UIFont systemFontOfSize:14];
                titleLab.textColor = TextColors;
                [cell addSubview:titleLab];
                
                
                UILabel *numLab = [[UILabel alloc ] initWithFrame:CGRectMake((SCREEN_WIDTH -80 ), 0, 80, _cellHeight)];
                numLab.text = @"共100部";
                numLab.font = [UIFont systemFontOfSize:12];
                numLab.textColor = TextColors;
                [cell addSubview:numLab];
                
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(numLab.frame.origin.x - 10, 5, 1, _cellHeight-10)];
                lineView.backgroundColor = Separator_Color;
                [cell addSubview:lineView];
                
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
        case 0:
            return 4*_cellHeight;
            break;
        case 1:
        
            return 3*_cellHeight;
            break;
        case 2:
            return 2*_cellHeight;
            break;
        case 3:
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
    
//    switch (section) {
//        case 1:
//     
//            break;
//            
//        default:
//            break;
//    }
    
    return tempView;
}

//设置section header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
//    if(section != 0)
//        return _cellHeight;
//    else
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
