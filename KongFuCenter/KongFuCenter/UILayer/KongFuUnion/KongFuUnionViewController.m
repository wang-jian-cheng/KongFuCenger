//
//  KongFuUnionViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/3.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "KongFuUnionViewController.h"

@interface KongFuUnionViewController ()
{
    //tableview参数
    CGFloat _cellHeight;
    UITableView *_mainTableView;
}
@end

@implementation KongFuUnionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    _cellHeight = SCREEN_HEIGHT / 12;
    [self setBarTitle:@"核联盟"];
    [self initViews];
}


-(void)initViews
{
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height - TabBar_HEIGHT)];
    _mainTableView.backgroundColor = BACKGROUND_COLOR;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorColor =  BACKGROUND_COLOR;
    _mainTableView.tableFooterView = [[UIView alloc] init];
    _mainTableView.scrollEnabled = NO;
    [self.view addSubview:_mainTableView];
    
}


#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 2;
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
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self setCell:cell andImg:@"" andName:@"武友动态"];
        }else if(indexPath.row == 1){
            [self setCell:cell andImg:@"" andName:@"战队动态"];
        }else{
            [self setCell:cell andImg:@"" andName:@"联盟动态"];
        }
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            [self setCell:cell andImg:@"" andName:@"结交武者"];
        }else{
            [self setCell:cell andImg:@"" andName:@"加入战队"];
        }
    }else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            [self setCell:cell andImg:@"" andName:@"武者赛事"];
        }else{
            [self setCell:cell andImg:@"" andName:@"江湖故事"];
        }
    }else{
        [self setCell:cell andImg:@"" andName:@"扫一扫"];
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
    if(section == 0){
        return 10;
    }else{
        return 8;
    }
}

#pragma mark - 自定义方法

-(void)setCell:(UITableViewCell *)cell andImg:(NSString *)img andName:(NSString *)name{
    
    //图标
    UIImageView *img_icon;
    if (img_icon == nil) {
        img_icon = [[UIImageView alloc] initWithFrame:CGRectMake(14, 0, 20, cell.frame.size.height)];
    }
    [cell addSubview:img_icon];
    
    //名称
    UILabel *lbl_name;
    if (lbl_name == nil) {
        lbl_name = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 100, cell.frame.size.height)];
        lbl_name.textColor = [UIColor whiteColor];
        lbl_name.font = [UIFont systemFontOfSize:18];
    }
    lbl_name.text = name;
    [cell addSubview:lbl_name];
}

@end
