//
//  TelAlertView.m
//  KongFuCenter
//
//  Created by Wangjc on 16/2/27.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "TelAlertView.h"

#define ViewWidth   200

@interface TelAlertView ()
{
    NSArray *_phoneArr;
    CGFloat _viewHeight;
    CGFloat _cellHeight;
    
    CGPoint _deltaPoint;
    
    
    UITableView *_maintableView;
    
    DeltaView *deltaView;
}

@end

@implementation TelAlertView

-(instancetype)initWithPhones:(NSArray *)phoneArr andShowPoint:(CGPoint)point
{
    self = [super init];
    if(self)
    {
        _phoneArr = phoneArr;
        _cellHeight = 30;
        _viewHeight = (phoneArr.count+1) * _cellHeight;
        _deltaPoint = point;
        
        
        [self reDrawViewWithPoint:point];
    }
    return self;
}

-(void)reDrawViewWithPoint:(CGPoint)point
{

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:) ];
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
    
    
    
   
//    deltaView.frame = CGRectMake(0, 0, 60, 60);
//    deltaView.center = CGPointMake(50, 50);
    
    
    showView.frame = [self calculateRect:point];
    deltaView =[[DeltaView alloc] initWithPoint:CGPointMake(9, 10) andHeight:-10];
    deltaView.frame = CGRectMake(showView.frame.origin.x+10,
                                 showView.frame.origin.y+showView.frame.size.height,
                                 20, 10);
    deltaView.backgroundColor = [UIColor clearColor];
    [[showView superview] addSubview:deltaView];
    
    
    [self initTableView];
    
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]||[NSStringFromClass([touch.view class]) isEqualToString:@"UIButton"])
    {
        return NO;
    }
    return YES;
}


-(void)show
{
    [UIView animateWithDuration:0.5 animations:^{
        coverView.alpha = 0.5;
        showView.alpha = 1.0;
        deltaView.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
    }];
    
    [[self topView] addSubview:self];
    [self showAnimation];
}

- (void)hideAnimation{
    [UIView animateWithDuration:0.5 animations:^{
        coverView.alpha = 0.0;
        showView.alpha = 0.0;
        deltaView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    
}


-(void)initTableView
{
    _maintableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, showView.frame.size.width, showView.frame.size.height)];
    
    _maintableView.delegate = self;
    _maintableView.dataSource = self;
    _maintableView.separatorColor =  [UIColor blackColor];
    _maintableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _maintableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _maintableView.backgroundColor = BACKGROUND_COLOR;
    _maintableView.tableFooterView = [[UIView alloc] init];
    _maintableView.scrollEnabled = NO;
    [showView addSubview:_maintableView];

}



-(CGRect)calculateRect:(CGPoint)point
{
    return CGRectMake(point.x, point.y,ViewWidth , _viewHeight);
}


-(void)tapViewAction:(id)sender
{
    [self dismiss];
}


#pragma mark - tools

-(void)makeCall:(NSString *)phoneNum
{
    if(phoneNum ==nil||phoneNum.length==0)
    {
        return;
    }
    
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneNum];
    NSLog(@"str======%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

}


#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _phoneArr.count+1;
    
}

#pragma mark - setting for cell

#define ViewsGaptoLine 20
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight)];
    cell.backgroundColor = BACKGROUND_COLOR;
    if(_phoneArr == nil || _phoneArr.count == 0 )
        return cell;
    if(indexPath.row == 0)
    {
        cell.textLabel.text = @"客服电话";
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    else
    {
        cell.textLabel.text = _phoneArr[indexPath.row -1];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.imageView.image = [UIImage imageNamed:@"tel"];
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
    if(indexPath.row>0)
        [self makeCall:_phoneArr[indexPath.row - 1]];
    
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



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
