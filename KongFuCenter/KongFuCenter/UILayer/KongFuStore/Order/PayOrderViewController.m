//
//  PayOrderViewController.m
//  KongFuCenter
//
//  Created by Wangjc on 16/1/23.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "PayOrderViewController.h"

@interface PayOrderViewController ()

@end

@implementation PayOrderViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"left"];
    roundBtnArr = [NSMutableArray array];
    [self initViews];
    // Do any additional setup after loading the view.
}


-(void)initViews
{
    
    _cellHeight = 100;
    pageSize = 10;
    
    for(int i = 0;i<2;i++)
    {
        SelectRoundBtn *roundBtn = [[SelectRoundBtn alloc] initWithCenter:CGPointMake((SCREEN_WIDTH - 60), 50/2)];
        if (i == 0) {
            roundBtn.selected = YES;
        }
        roundBtn.backgroundColor = BACKGROUND_COLOR;
        [roundBtn addTarget:self action:@selector(roundBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        roundBtn.tag = i+1000;
        [roundBtnArr addObject:roundBtn];
    }
    
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height - 50 ) style:UITableViewStyleGrouped];
    _mainTableView.backgroundColor = BACKGROUND_COLOR;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorColor =  Separator_Color;
    //    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.tableFooterView = [[UIView alloc] init];
    //_mainTableView.scrollEnabled = NO;
    [self.view addSubview:_mainTableView];
    
    UIView *btnBackView = [[UIView alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT - 50), SCREEN_WIDTH, 50)];
    btnBackView.backgroundColor = ItemsBaseColor;
    
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH  - 100), 0, 100, 30)];
    btnRight.backgroundColor = YellowBlock;
    btnRight.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnBackView addSubview:btnRight];
    btnRight.titleLabel.text = @"确认结算";
    
//    UIButton *btnLeft = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 20 - 80-20-btnRight.frame.size.width),
//                                                                   10, 80, 30)];
//    btnLeft.backgroundColor = [UIColor grayColor];
//    btnLeft.titleLabel.font = [UIFont systemFontOfSize:14];
//    [btnBackView addSubview:btnLeft];
    

    [self.view addSubview:btnBackView];
    
}

#pragma mark - click action

-(void)roundBtnClick:(UIButton *)sender
{

}

#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 1) {
        return 5;
    }
    if(section == 2)
        return 3;
    return 1;
    
}

#pragma mark - setting for cell

#define GapToLeft 20
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight)];;
    cell.backgroundColor = ItemsBaseColor;
    @try {
        
        if (indexPath.section == 0) {
            UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(GapToLeft, 15, cell.frame.size.height - 30 , cell.frame.size.height - 30)];
            image.image = [UIImage imageNamed:@"dingwei"];
            image.center = CGPointMake(GapToLeft+10, _cellHeight/2);
            [cell.contentView addSubview:image];
            
            UILabel *infoLab = [[UILabel alloc] initWithFrame:CGRectMake((image.frame.size.width+image.frame.origin.x)+5,
                                                                         10, SCREEN_WIDTH - (image.frame.size.width+image.frame.origin.x)-5, _cellHeight/2-10)];
            
            infoLab.textColor = [UIColor whiteColor];
            infoLab.text = [NSString  stringWithFormat:@"收货人：%@    %@",@"杨某某",@"15269914187"];
            infoLab.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:infoLab];
            
            UILabel *addrLab = [[UILabel alloc] initWithFrame:CGRectMake(infoLab.frame.origin.x,
                                                                         _cellHeight/2,infoLab.frame.size.width , _cellHeight/2-10)];
            addrLab.text = [NSString stringWithFormat:@"收货地址：%@",@"山东省临沂市兰山区通达路10号北园路城建时代广场10楼"];
            addrLab.numberOfLines = 0;
            addrLab.textColor = [UIColor whiteColor];
            addrLab.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:addrLab];
            
        }
        
        if(indexPath.section == 1)
        {
            
            if (indexPath.row== 0) {
                cell.textLabel.text = @"核武者自营店";
                cell.textLabel.textColor = [UIColor whiteColor];
                cell.textLabel.font = [UIFont systemFontOfSize:14];
                
            }
            if(indexPath.row == 1 || indexPath.row == 2)
            {
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(GapToLeft, 10, _cellHeight, _cellHeight - 20)];
                imgView.image = [UIImage imageNamed:@"KongFuStoreProduct"];
                [cell addSubview:imgView];
                
                UILabel *nowPriceLab = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 10 - 80), 10, 80, 30)];
                nowPriceLab.textColor = Separator_Color;
                nowPriceLab.text = @"¥20.00";
                nowPriceLab.textAlignment = NSTextAlignmentRight;
                nowPriceLab.font = [UIFont systemFontOfSize:14];
                [cell addSubview:nowPriceLab];
                
                UILabel *oldPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(nowPriceLab.frame.origin.x,
                                                                                 (nowPriceLab.frame.origin.y+nowPriceLab.frame.size.height),
                                                                                 nowPriceLab.frame.size.width, 20)];
                oldPriceLab.textColor = Separator_Color;
                oldPriceLab.text = @"¥20.00";
                oldPriceLab.textAlignment = NSTextAlignmentRight;
                oldPriceLab.font = [UIFont systemFontOfSize:12];
                [cell addSubview:oldPriceLab];
                
                UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(oldPriceLab.frame.origin.x,
                                                                            (oldPriceLab.frame.origin.y+oldPriceLab.frame.size.height),
                                                                            oldPriceLab.frame.size.width, 20)];
                numLab.textColor = Separator_Color;
                numLab.text = @"x1";
                numLab.textAlignment = NSTextAlignmentRight;
                numLab.font = [UIFont systemFontOfSize:12];
                [cell addSubview:numLab];
                
                UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake((imgView.frame.origin.x + imgView.frame.size.width)+5,
                                                                              10, (SCREEN_WIDTH), 30)];
                titleLab.text = @"男士哑铃一对10公斤";
                titleLab.textColor = [UIColor whiteColor];
                
                titleLab.font = [UIFont systemFontOfSize:14];
                [cell addSubview:titleLab];
            }
            else if(indexPath.row == 3)
            {
                cell.textLabel.textColor = [UIColor whiteColor];
                cell.textLabel.text = @"卖家包邮";
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                
                UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 60-20), 0, 60, 50)];
                tipLab.text = @"不包邮";
                tipLab.font = [UIFont systemFontOfSize:15];
                tipLab.textColor = [UIColor whiteColor];
                tipLab.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:tipLab];
            }
            else if(indexPath.row == 4)
            {
                cell.textLabel.textColor = [UIColor whiteColor];
                cell.textLabel.text = @"共两件商品";
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                
                UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 160-20), 0, 160, 50)];
                tipLab.text = @"合计¥ 40.00";
                tipLab.font = [UIFont systemFontOfSize:15];
                tipLab.textColor = [UIColor orangeColor];
                tipLab.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:tipLab];
            }
        }
        
        if(indexPath.section == 2)
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
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
    return cell;
    
}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 1)
    {
        if(indexPath.row == 0||indexPath.row == 3||indexPath.row == 4)
        {
            return 50;
        }
    }
    if(indexPath.section == 2)
        return 50;
    
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
    tempView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
    return tempView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *tempView = [[UIView alloc] init];
    tempView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 10);
    return tempView;
}

//设置section header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
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
