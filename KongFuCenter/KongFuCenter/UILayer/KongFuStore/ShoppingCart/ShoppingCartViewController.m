//
//  ShoppinCartViewController.m
//  KongFuCenter
//
//  Created by Wangjc on 16/1/20.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "ShoppingCartViewController.h"

#define GapToLeft   30

@interface ShoppingCartViewController ()

@end

@implementation ShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"left"];
    [self addRightbuttontitle:@"删除"];
    [self initData];
    [self initViews];
    // Do any additional setup after loading the view.
}




-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

-(void)initData
{
    cellBtnArr = [NSMutableArray array];
    delArr  = [NSMutableArray array];
    numLabArr = [NSMutableArray array];
    pageSize = 0xFFFFFFFF;
    pageNo = 0;
}

-(void)initViews
{
    _cellHeight = SCREEN_HEIGHT/7;
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height )];
    _mainTableView.backgroundColor = ItemsBaseColor;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorColor =  Separator_Color;
    _mainTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_mainTableView];
    
    
    UIView *payView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 60, SCREEN_WIDTH , 60)];
    payView.backgroundColor = BACKGROUND_COLOR;
    
    SelectRoundBtn *selectAllBtn = [[SelectRoundBtn alloc] initWithCenter:CGPointMake(GapToLeft/2, payView.frame.size.height/2)];
    selectAllBtn.backgroundColor = [UIColor grayColor];
    [selectAllBtn addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [payView addSubview:selectAllBtn];
    
    UIButton *payBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3*2, 0, SCREEN_WIDTH/3, payView.frame.size.height)];
    payBtn.backgroundColor = YellowBlock;
    [payBtn setTitle:@"结算" forState:UIControlStateNormal];
    [payView addSubview:payBtn];
    
    UILabel * priceLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 5,
                                                                  (SCREEN_WIDTH - 60 -SCREEN_WIDTH/3-10),
                                                                  payView.frame.size.height/2-5)];
    priceLab.textAlignment = NSTextAlignmentRight;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"结算:¥20.00"];
    [str addAttribute:NSForegroundColorAttributeName value:YellowBlock range:NSMakeRange(3,str.length-3)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,3)];
    priceLab.attributedText = str;
    priceLab.font = [UIFont systemFontOfSize:14];
    [payView addSubview:priceLab];
    
    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(priceLab.frame.origin.x, payView.frame.size.height/2,
                                                                priceLab.frame.size.width, payView.frame.size.height/2-5)];
    tipLab.text = @"不含运费";
    tipLab.font = [UIFont systemFontOfSize:14];
    tipLab.textColor = [UIColor whiteColor];
    tipLab.textAlignment = NSTextAlignmentRight;
    [payView addSubview:tipLab];

    [self.view addSubview:payView];
    [self.view bringSubviewToFront:payView];
    
    [self getShoppingCartList];
}

#pragma mark - self data source

-(void)getShoppingCartList
{
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getShoppingCartListCallBack:"];
    [dataProvider getShoppingCartList:[Toolkit getUserID] andstartRowIndex:NSStringFromFormat(@"%u",pageNo*pageSize) andmaximumRows:NSStringFromFormat(@"%u",pageSize)];
}

-(void)getShoppingCartListCallBack:(id)dict
{
    DLog(@"%@",dict);
    if([dict[@"code"] intValue] == 200)
    {
        [SVProgressHUD dismiss];
        
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:dict[@"data"] maskType:SVProgressHUDMaskTypeBlack];
    }
}


#pragma mark - click actions

-(void)plusBtnClick:(UIButton*)sender
{
    UILabel *tempLab = numLabArr[sender.tag-1];
    NSInteger num = [tempLab.text intValue];
    num++;
    tempLab.text = [NSString stringWithFormat:@"%ld",(long)num];
}
-(void)delBtnClick:(UIButton*)sender
{
    UILabel *tempLab = numLabArr[sender.tag-1];
    NSInteger num = [tempLab.text intValue];
    if(num>0)
    {
        num--;
        tempLab.text = [NSString stringWithFormat:@"%ld",(long)num];
    }
}


-(void)selectAllBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    
    
    for (UIButton *tempBtn in cellBtnArr) {
        tempBtn.selected = sender.selected;
    }
}


-(void)roundBtnClick:(UIButton *)sender
{
    sender.selected = ! sender.selected;
    
    
    if(sender.selected == YES)
    {
//        [delArr addObject:planArr[sender.tag][@"Id"]];
    }
    else
    {
        for (int i = 0; i <delArr.count; i++) {
//            if([planArr[sender.tag][@"Id"] isEqual:delArr[i]])
//            {
//                [delArr removeObjectAtIndex:i];
//            }
        }
    }
}

#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

#pragma mark - setting for cell
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    @try {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight*3)];
        cell.backgroundColor = ItemsBaseColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if(indexPath.row == 0)
        {
            cell.textLabel.text = @"核武者自营店";
            cell.textLabel.textColor = [UIColor whiteColor];
        }
        else
        {
            UIImageView *productImgView = [[UIImageView alloc] initWithFrame:CGRectMake(GapToLeft, 10, (_cellHeight+10), (_cellHeight-10*2))];
            productImgView.image = [UIImage imageNamed:@"KongFuStoreProduct"];
            [cell addSubview:productImgView];
            
            UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(5+productImgView.frame.size.width+productImgView.frame.origin.x,
                                                                         10,
                                                                          (SCREEN_WIDTH-(productImgView.frame.size.width+productImgView.frame.origin.x)), _cellHeight/3)];
            titleLab.text = @"男士哑铃一对10公斤";
            titleLab.font = [UIFont systemFontOfSize:14];
            titleLab.textColor = [UIColor whiteColor];
            [cell addSubview:titleLab];
            
            
            UIButton *plusBtn = [[UIButton alloc] initWithFrame:CGRectMake(titleLab.frame.origin.x,
                                                                           (titleLab.frame.origin.y+titleLab.frame.size.height)+10,
                                                                           20,
                                                                           20 )];
            plusBtn.tag = indexPath.row;
            [plusBtn setImage:[UIImage imageNamed:@"KongFuStoreAdd"] forState:UIControlStateNormal];
            [plusBtn addTarget:self action:@selector(plusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:plusBtn];
            
            UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake((plusBtn.frame.size.width+plusBtn.frame.origin.x+2),
                                                                        plusBtn.frame.origin.y,
                                                                        30,
                                                                        plusBtn.frame.size.height)];
            numLab.backgroundColor = BACKGROUND_COLOR;
            numLab.text = @"1";
            numLab.textColor = [UIColor whiteColor];
            numLab.textAlignment = NSTextAlignmentCenter;
            numLab.tag = indexPath.row;
            [cell addSubview:numLab];
            
            if(numLabArr.count>indexPath.row)
            {
                [numLabArr replaceObjectAtIndex:indexPath.row withObject:numLab];
            }
            else
            {
                [numLabArr addObject:numLab];
            }
            
            UIButton *delBtn = [[UIButton alloc] initWithFrame:CGRectMake((numLab.frame.size.width+numLab.frame.origin.x+2),
                                                                          plusBtn.frame.origin.y,
                                                                          20,
                                                                          plusBtn.frame.size.height)];
            delBtn.tag = indexPath.row;
            [delBtn setImage:[UIImage imageNamed:@"KongFuStoreDel"] forState:UIControlStateNormal];
            [delBtn addTarget:self action:@selector(delBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:delBtn];
            
            
            UILabel *newPrice = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 20 -180),
                                                                         (titleLab.frame.origin.y+titleLab.frame.size.height),
                                                                         180,
                                                                          20)];
            newPrice.textAlignment = NSTextAlignmentRight;
            newPrice.textColor = YellowBlock;
            newPrice.font = [UIFont systemFontOfSize:14];
            newPrice.text = @"¥ 20.00";
            [cell addSubview:newPrice];
            
            
            
            UILabel *oldPrice = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 20 -180),
                                                                          (newPrice.frame.origin.y+newPrice.frame.size.height), 180, 20)];
            oldPrice.textAlignment = NSTextAlignmentRight;
            oldPrice.textColor = [UIColor grayColor];
            oldPrice.font = [UIFont systemFontOfSize:12];
            oldPrice.text = @"¥ 20.00";
            [cell addSubview:oldPrice];
            
            
            
            
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
//                if ([tempDict[@"Id"] isEqual:delArr[i]]) {
//                    roundBtn.selected = YES;
//                }
            }
            
            [cellBtnArr addObject:roundBtn];
            
        }
        return cell;
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }

}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0)
        return 30;
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
