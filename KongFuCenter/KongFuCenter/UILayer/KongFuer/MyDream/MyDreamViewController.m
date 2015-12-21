//
//  MyDreamViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/8.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "MyDreamViewController.h"

@interface MyDreamViewController ()
{
#pragma mark - pram for tableView
    NSInteger _sectionNum;
    CGFloat _cellHeight;
    UITableView *_mainTableView;
    
    UITextView *myPlan;
    UITextView *myDream;
}
@end

@implementation MyDreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"left"];
    [self addRightbuttontitle:@"编辑"];
    [self initViews];
    
    [self getMyDream];
    
    // Do any additional setup after loading the view.
}



-(void)initViews
{
    _cellHeight = SCREEN_HEIGHT/6;
    _sectionNum = 2;
    
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height )];
    _mainTableView.backgroundColor = BACKGROUND_COLOR;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorColor =  Separator_Color;
    _mainTableView.tableFooterView = [[UIView alloc] init];
    //_mainTableView.scrollEnabled = NO;
    
    _mainTableView.contentSize = CGSizeMake(SCREEN_HEIGHT, _sectionNum*(_cellHeight + 20));
    [self.view addSubview:_mainTableView];
    
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:) ];
    [self.view addGestureRecognizer:tapGesture];
    
    
    //    //注册通知,监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    //
    //    //注册通知,监听键盘消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden) name:UIKeyboardDidHideNotification object:nil];
    
    myPlan = [[UITextView alloc] init];
    myPlan.editable = NO;
    myPlan.delegate = self;
    
    myDream = [[UITextView alloc] init];
    myDream.editable = NO;
    myDream.delegate = self;
}


-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

#pragma mark - self data source
-(void)getMyDream
{
    [SVProgressHUD showWithStatus:@"刷新" maskType:SVProgressHUDMaskTypeBlack];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"getMyDreamCallBack:"];
    [dataprovider getMyDream:[Toolkit getUserID]];
    
}
-(void)getMyDreamCallBack:(id)dict
{
    [SVProgressHUD dismiss];
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try {

            NSDictionary *tempDict = dict[@"data"];
            myDream.text = tempDict[@"MyDream"];
            myPlan.text = tempDict[@"RealizeDream"];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"data"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        
    }

}




-(void)setMyDream
{
    [SVProgressHUD showWithStatus:@"刷新" maskType:SVProgressHUDMaskTypeBlack];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"setMyDreamCallBack:"];
    [dataprovider setMyDream:[Toolkit getUserID] andMyDream:myDream.text andHow:myPlan.text];
    
}
-(void)setMyDreamCallBack:(id)dict
{
    [SVProgressHUD dismiss];
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try {
            
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"data"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        
    }
    
}

#pragma mark - 键盘操作

// 键盘弹出时
-(void)keyboardDidShow:(NSNotification *)notification
{
    
    //获取键盘高度
    NSValue *keyboardObject = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect;
    [keyboardObject getValue:&keyboardRect];
    
    
    _keyHeight = keyboardRect.size.height;
    //调整放置有textView的view的位置
    
    //设置动画
    [UIView beginAnimations:nil context:nil];
    
    //定义动画时间
    [UIView setAnimationDuration:0.5];
    //               CGRectMake(0, self.view.frame.size.height-keyboardRect.size.height-kViewHeight, 320, kViewHeight)]
    //设置view的frame，往上平移
    [_mainTableView setFrame:CGRectMake(0, Header_Height, self.view.frame.size.width,self.view.frame.size.height -Header_Height -keyboardRect.size.height)];
    
    [_mainTableView scrollToRowAtIndexPath:tempIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    
    //[_mainTableView reloadData];
    [UIView commitAnimations];
    
}

//键盘消失时
-(void)keyboardDidHidden
{
    //定义动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    //设置view的frame，往下平移
    [_mainTableView setFrame:CGRectMake(0, Header_Height, self.view.frame.size.width,SCREEN_HEIGHT - Header_Height)];
    
    //[_mainTableView reloadData];
    [UIView commitAnimations];
    
}
#pragma mark - textView delegate


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if(textView == myDream)
    {
        tempIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    }
    else if(textView == myPlan)
    {
         tempIndexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    }
}

#pragma mark - click action

-(void)tapViewAction:(id)sender
{
    [self.view endEditing:YES];
    
}

-(void)clickRightButton:(UIButton *)sender
{
    
    sender.selected = !sender.selected;
    if(sender.selected == YES)
    {
        [self addRightbuttontitle:@"确定"];
        myDream.editable = YES;
        myPlan.editable = YES;
    }
    else
    {
        myDream.editable = NO;
        myPlan.editable = NO;
        [self addRightbuttontitle:@"编辑"];
        
        [self setMyDream];
    }
}


#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _sectionNum;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 1)
    {
    
        return 2;
    }
    return 1;
    
}
#define GapToLeft   20
#pragma mark - setting for cell
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight*3)];
        cell.backgroundColor = ItemsBaseColor;
        
        UIImageView *dreamImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight*1.5)];
        dreamImgView.image = [UIImage imageNamed:@"temp2"];
        [cell addSubview:dreamImgView];
        
        NSString *dreamStr = @"咏春拳的创始者是福建福清南少林的少林庵五枚师太，她姓朱名红梅，生于明朝天启三年（公元1623年）正月初五，那时候正是红梅盛开的日子。朱红梅，三岁读四书五经、六岁跟府中的将军们学武功，九岁跟御医学中医理论并修炼禅功";
        CGFloat labWidth = SCREEN_WIDTH-GapToLeft -10;
        CGFloat labHeight = [Toolkit heightWithString:dreamStr fontSize:14 width:labWidth] ;
        
        UILabel *dreamContentLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, (dreamImgView.frame.size.height + 10), labWidth , labHeight)];
        dreamContentLab.font = [UIFont systemFontOfSize:14];
        dreamContentLab.textColor = [UIColor whiteColor];
        dreamContentLab.text = dreamStr;
        dreamContentLab.numberOfLines = 0;
        dreamContentLab.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:dreamContentLab];
        
        return cell;
    }
    else
    {

        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight)];
        cell.backgroundColor = ItemsBaseColor;
        if(indexPath.row == 0)
        {
            UILabel *titlelab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 0, 50, _cellHeight)];
            titlelab.text = @"我的梦想";
            titlelab.textColor = [UIColor whiteColor];
            titlelab.numberOfLines = 0;
            
            [cell addSubview:titlelab];
            
            myDream.frame = CGRectMake((titlelab.frame.origin.x+titlelab.frame.size.width),
                                                                               10, (SCREEN_WIDTH - (titlelab.frame.origin.x+titlelab.frame.size.width) -10 ), _cellHeight -2*10);

            myDream.backgroundColor = BACKGROUND_COLOR;
            myDream.tag =0;
            [cell addSubview:myDream];
            
        }
        if(indexPath.row == 1)
        {
            UILabel *titlelab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 0, 50, _cellHeight)];
            titlelab.text = @"如何实现";
            titlelab.numberOfLines = 0;
            titlelab.textColor = [UIColor whiteColor];
            [cell addSubview:titlelab];
            
            myPlan.frame =  CGRectMake((titlelab.frame.origin.x+titlelab.frame.size.width),
                                                                               10, (SCREEN_WIDTH - (titlelab.frame.origin.x+titlelab.frame.size.width) -10 ), 2*_cellHeight -2*10);
            myPlan.backgroundColor = BACKGROUND_COLOR;
            myPlan.tag = 1;

            [cell addSubview:myPlan];
          //  tempIndexPath = indexPath;
        }
        return cell;
        
    }
    
}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0)
    {
        return 3*_cellHeight;
    }
    if(indexPath.section == 1)
    {
        if(indexPath.row == 0)
            return _cellHeight;
        else if(indexPath.row == 1)
        {
            return _cellHeight*2;
        }
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
    
    return tempView;
}

//设置section header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 0;
}

//设置section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section ==0)
        return 10;
    else
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
