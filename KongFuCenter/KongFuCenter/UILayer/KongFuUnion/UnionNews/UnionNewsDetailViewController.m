//
//  UnionNewsDetailViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/14.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "UnionNewsDetailViewController.h"


#define DetailSection    0
#define CommentSection      1

#define GapToLeft           20
#define TextColors          [UIColor whiteColor]

@interface UnionNewsDetailViewController ()
{
#pragma mark - pram for tableView
    NSInteger _sectionNum;
    CGFloat _cellHeight;
    UITableView *_mainTableView;
}
@end

@implementation UnionNewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"left"];
    [self initViews];
    // Do any additional setup after loading the view.
}

-(void)initViews
{
    _cellHeight = SCREEN_HEIGHT/12;
    _sectionNum = 2;
    
    
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
    
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:) ];
    [self.view addGestureRecognizer:tapGesture];
    
    
    //    //注册通知,监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    //
    //    //注册通知,监听键盘消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden) name:UIKeyboardDidHideNotification object:nil];
    
    
    
}
#pragma mark - click actions
-(void)tapViewAction:(id)sender
{
    [self.view endEditing:YES];
    
}

-(void)btnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
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
    //tableView 滚动
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


#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _sectionNum;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case DetailSection:
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
        case DetailSection:
        {
            if(indexPath.row == 1)
            {
                UIButton *collectBtn = [[UIButton alloc] initWithFrame:CGRectMake(GapToLeft,5 ,60 , _cellHeight - 5*2)];
                [collectBtn setTitle:@"100" forState:UIControlStateNormal];
                [collectBtn setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
                [collectBtn setImage:[UIImage imageNamed:@"collect_h"] forState:UIControlStateSelected];
                [collectBtn setTitleColor:TextColors forState:UIControlStateNormal];
                [collectBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                collectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [cell addSubview:collectBtn];
                
                
                UILabel *commentLab = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 20 -60), 5, 60, (_cellHeight - 5*2))];
                commentLab.text = @"阅读 100";
                commentLab.textColor = TextColors;
                commentLab.font = [UIFont systemFontOfSize:14];
                
                [cell addSubview:commentLab];
                
                UILabel *readNumLab = [[UILabel alloc] initWithFrame:CGRectMake((commentLab.frame.origin.x - 5 -60), 5, 60,
                                                                                (_cellHeight - 5*2))];
                readNumLab.text = @"阅读 100";
                readNumLab.textColor = TextColors;
                readNumLab.font = [UIFont systemFontOfSize:14];
                
                [cell addSubview:readNumLab];
                
            }
            
        }
            break;
       
        case CommentSection:
        {
            if(indexPath.row == 0)
            {
                UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 0, 150, _cellHeight)];
                titleLab.text = @"用户评论";
                titleLab.font = [UIFont systemFontOfSize:14];
                titleLab.textColor = TextColors;
                [cell addSubview:titleLab];
                
                
                UILabel *numLab = [[UILabel alloc ] initWithFrame:CGRectMake((SCREEN_WIDTH -80 ), 0, 80, _cellHeight)];
                numLab.text = @"共100条";
                numLab.font = [UIFont systemFontOfSize:12];
                numLab.textColor = TextColors;
                [cell addSubview:numLab];
                
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(numLab.frame.origin.x - 10, 5, 1, _cellHeight-10)];
                lineView.backgroundColor = Separator_Color;
                [cell addSubview:lineView];
                
            }
            else if(indexPath.row == 1)
            {
                /*head */
                UserHeadView *headView = [[UserHeadView alloc] initWithFrame:CGRectMake(GapToLeft, 5, _cellHeight-10, _cellHeight-10)
                                                                  andImgName:@"me"
                                                                      andNav:self.navigationController];
                [headView makeSelfRound];
                [cell addSubview:headView];
                
                UITextView *commentTextView = [[UITextView alloc] initWithFrame:CGRectMake((headView.frame.origin.x + headView.frame.size.width+5),
                                                                                           5,
                                                                                           (SCREEN_WIDTH -(headView.frame.origin.x + headView.frame.size.width+5) - 10),(_cellHeight - 5*2) )];
                
                tempIndexPath = indexPath;
                [cell addSubview:commentTextView];
            }
            else
            {
                UserHeadView *headView = [[UserHeadView alloc] initWithFrame:CGRectMake(GapToLeft, 5, _cellHeight-10, _cellHeight-10)
                                                                  andImgName:@"me"
                                                                      andNav:self.navigationController];
                [headView makeSelfRound];
                [cell addSubview:headView];
                
                /*name*/
                UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake((headView.frame.origin.x +headView.frame.size.width + 10),
                                                                             headView.frame.origin.y, 40, headView.frame.size.height/2)];
                nameLab.text = @"鹿晗";
                nameLab.textColor = TextColors;
                nameLab.font = [UIFont systemFontOfSize:12];
                [cell addSubview:nameLab];
                
                UIButton *supportBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 44),headView.frame.origin.y , 44, headView.frame.size.height/2)];
                [supportBtn setImage:[UIImage imageNamed:@"support"] forState:UIControlStateNormal];
                [supportBtn setImage:[UIImage imageNamed:@"support_h"] forState:UIControlStateSelected];
                [supportBtn setTitle:@"20" forState:UIControlStateNormal];
                [supportBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                supportBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [cell addSubview:supportBtn];
                
                
                NSString *commentStr = @"666 很好 很好 很好，666 很好 很好 很好，666 很好 很好 很好，666 很好 很好 很好，666 很好 很好 很好";
                CGFloat commentWidth = (SCREEN_WIDTH-(headView.frame.origin.x +headView.frame.size.width + 10) - 10);
                CGFloat commentHeight = [Toolkit heightWithString:commentStr fontSize:12 width:commentWidth];
                
                UILabel *commentLab = [[UILabel alloc] initWithFrame:CGRectMake((headView.frame.origin.x +headView.frame.size.width + 10),
                                                                                headView.frame.size.height/2,
                                                                                commentWidth,
                                                                                commentHeight)];
                commentLab.text = commentStr;
                commentLab.font = [UIFont systemFontOfSize:12];
                commentLab.numberOfLines = 0;
                [cell addSubview:commentLab];
                
                UILabel *dateLab = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100),
                                                                             (commentLab.frame.size.height+commentLab.frame.origin.y),
                                                                             100, 30)];
                dateLab.text = @"2015年04月12日";
                dateLab.font = [UIFont systemFontOfSize:12];
                
                [cell addSubview:dateLab];
                
                
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
            if (indexPath.row == 1) {
                return _cellHeight;
            }
            return 4*_cellHeight;
            
            break;

        case 1:
            if(indexPath.row == 1)
            {
                return  _cellHeight;
            }
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