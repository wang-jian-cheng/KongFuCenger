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

#define  WebViewHeight  (9*_cellHeight)

#define USECONTENT  0
@interface UnionNewsDetailViewController ()
{
#pragma mark - pram for tableView
    NSInteger _sectionNum;
    CGFloat _cellHeight;
    UITableView *_mainTableView;
    
    NSMutableArray * videoCommentArray;//评论列表
}
@end

@implementation UnionNewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"left"];
    videoCommentArray = [NSMutableArray array];
    [self GetVideoCommentDetial];
    self.view.backgroundColor = BACKGROUND_COLOR;
    // Do any additional setup after loading the view.
}

-(void)initViews
{
    _cellHeight = SCREEN_HEIGHT/12;
    _sectionNum = 2;
    commentWidth = SCREEN_WIDTH - _cellHeight -GapToLeft - 40;
    
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
    
    
    
    webView = [[UIWebView alloc] init];
 //   webView.scalespageToFit = YES;
    
    collectBtn = [[UIButton alloc] init];
    
    commentTextView = [[UITextView alloc] init];
    commentTextView.delegate = self;
    commentTextView.textColor = [UIColor whiteColor];
    commentTextView.backgroundColor = [UIColor grayColor];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:) ];
    [self.view addGestureRecognizer:tapGesture];
    tapGesture.delegate = self;
    
    //    //注册通知,监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    //
    //    //注册通知,监听键盘消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden) name:UIKeyboardDidHideNotification object:nil];
    
    
    
}

#pragma mark - self data source

-(void)GetVideoCommentDetial
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetVideoCommentDetialCallBack:"];
    
    [dataprovider getMessageIdInfo:self.webId];
}

-(void)GetVideoCommentDetialCallBack:(id)dict
{
    DLog(@"%@",dict);
    [SVProgressHUD dismiss];
    if ([dict[@"code"] intValue]==200) {
        @try
        {
            if(videoCommentArray !=nil && videoCommentArray.count>0)
                [ videoCommentArray removeAllObjects];
            
            [videoCommentArray addObjectsFromArray:dict[@"data"]];
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
            //[_mainTableView reloadData];
            [SVProgressHUD dismiss];
            [self initViews];
            NSLog(@"完成");
        }
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"data"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }
    
}

-(void)commentCallBack:(id)dict
{
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try
        {
            [SVProgressHUD showSuccessWithStatus:@"评论成功" maskType:SVProgressHUDMaskTypeBlack];
            commentTextView.text = @"";
            [self GetVideoCommentDetial];
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
            [_mainTableView reloadData];
            [SVProgressHUD dismiss];
        }
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"data"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }
}
-(void)MakeActionCallBack:(id)dict
{
    if ([dict[@"code"] intValue]==200) {
        [SVProgressHUD showSuccessWithStatus:@"操作成功" maskType:SVProgressHUDMaskTypeBlack];
        
        
        NSInteger num =  [collectBtn.titleLabel.text integerValue];
        if(zan == YES)
            num++;
        else if(num > 0)
        {
            num--;
        }
        [collectBtn setTitle:[NSString stringWithFormat:@"%ld",num] forState:UIControlStateNormal];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"操作失败" maskType:SVProgressHUDMaskTypeBlack];
    }
}

#pragma mark - click actions
-(void)tapViewAction:(id)sender
{
    [self.view endEditing:YES];
    
}

//设置点在某个view时部触发事件
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"-%@", NSStringFromClass([touch.view class]));
    
    //||[NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"] [NSStringFromClass([touch.view class]) isEqualToString:@"UIView"]||
    
    // if(gestureRecognizer.d)
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]||[NSStringFromClass([touch.view class]) isEqualToString:@"UIButton"])
    {
        return NO;
    }
    //  NSLog(@"return YES");
    return  YES;
}

-(void)btnClick:(UIButton *)sender
{
    
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"MakeActionCallBack:"];
  
    if(sender.selected == NO)
    {
        sender.selected = YES;
        NSLog(@"收藏");
        zan = YES;
        [dataprovider voiceAction:self.webId andUserId:[Toolkit getUserID] andFlg:@"1" andDescription:nil];
    }
    else
    {
        sender.selected = NO;
        zan = NO;
        NSLog(@"取消收藏");
        
        //                DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider voicedelete:self.webId andUserId:[Toolkit getUserID] andFlg:@"1"];
    }
    

}

-(void)sendCommentBtnClick:(id)sender
{
    if(commentTextView.text.length == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入评论内容" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alertView show];
        return;
        
    }
    
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"commentCallBack:"];
    [dataprovider commentVideo:self.webId andUserId:[Toolkit getUserID] andComment:commentTextView.text];
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
            return 2+videoCommentArray.count;
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
            if(indexPath.row==0)
            {
                
                if(self.content!=nil&&USECONTENT)
                {
                    
                    RCLabel *label = [[RCLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [Toolkit heightWithString:self.content fontSize:14 width:SCREEN_WIDTH]+80+20)];
                    [label setBackgroundColor:[UIColor clearColor]];
                    
                    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:self.content];
                    label.componentsAndPlainText = componentsDS;
                    label.textColor = [UIColor whiteColor];
                    [cell addSubview:label];
                }
                else
                {
                    [cell addSubview:webView];
                    webView.scalesPageToFit = YES;
                    
                    webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, WebViewHeight);
                    webView.backgroundColor = BACKGROUND_COLOR;
                    
                    
                    NSURL* url;
                    if(self.webId == nil)
                    {
    //                    url = [NSURL URLWithString:@"http://115.28.67.86:8033/MessageAndImageNews.aspx?id=260"];//创建URL
                    }
                    else
                    {
                        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Web_path,self.webId]];
                    }
                    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
                    [webView loadRequest:request];
                }
                
            }
            
            if(indexPath.row == 1)
            {
                collectBtn.frame = CGRectMake(20,5 ,40 , _cellHeight - 5*2);
                if(self.collectNum !=nil)
                    [collectBtn setTitle:[NSString stringWithFormat:@"  %@",self.collectNum] forState:UIControlStateNormal];
                else
                    [collectBtn setTitle:@" 0" forState:UIControlStateNormal];
                [collectBtn setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
                [collectBtn setImage:[UIImage imageNamed:@"collect_h"] forState:UIControlStateSelected];
                [collectBtn setTitleColor:TextColors forState:UIControlStateNormal];
                [collectBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                collectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                if(self.isFavorite !=nil && [self.isFavorite isEqualToString:@"1"])
                {
                    collectBtn.selected = YES;
                }
                
                [cell addSubview:collectBtn];
                
                
                UILabel *commentLab = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 20 -60), 5, 60, (_cellHeight - 5*2))];
                commentLab.text = [NSString stringWithFormat:@"评论 %ld",videoCommentArray.count];
                commentLab.textColor = TextColors;
                commentLab.font = [UIFont systemFontOfSize:14];
                
                [cell addSubview:commentLab];
                
                UILabel *readNumLab = [[UILabel alloc] initWithFrame:CGRectMake((commentLab.frame.origin.x - 5 -60), 5, 60,
                                                                                (_cellHeight - 5*2))];
                
                if(self.readNum!=nil)
                    readNumLab.text = [NSString stringWithFormat:@"阅读 %@",self.readNum];
                else
                    readNumLab.text = [NSString stringWithFormat:@"阅读 %@",@"0"];
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
                numLab.text = [NSString stringWithFormat:@"共%ld条",videoCommentArray.count];
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
                                                                  andImgName:@"headImg"
                                                                      andNav:self.navigationController];
                
                NSString *url = [NSString stringWithFormat:@"%@%@",Kimg_path,get_sp(@"PhotoPath")];
                [headView.headImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed: @"headImg"]];
                [headView makeSelfRound];
                [cell addSubview:headView];
                
                commentTextView.frame = CGRectMake((headView.frame.origin.x + headView.frame.size.width+5),
                                                   (_cellHeight -44)/2,
                                                   (SCREEN_WIDTH -(headView.frame.origin.x + headView.frame.size.width+5) - 80),44 );
                
                tempIndexPath = indexPath;
                if(commentTextView.subviews !=nil)
                {
                    [commentTextView removeFromSuperview];
                }
                [cell.contentView addSubview:commentTextView];
                
                UIButton * btn_SendComment=[[UIButton alloc] initWithFrame:CGRectMake(commentTextView.frame.size.width+commentTextView.frame.origin.x+10, commentTextView.frame.origin.y, 60, commentTextView.frame.size.height)];
                
                [btn_SendComment setTitle:@"发布" forState:UIControlStateNormal];
                [btn_SendComment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btn_SendComment addTarget:self action:@selector(sendCommentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                btn_SendComment.backgroundColor=ItemsBaseColor;
                [cell addSubview:btn_SendComment];
            }
            else
            {
                
                
                if(videoCommentArray == nil || videoCommentArray.count <= 0 || videoCommentArray.count < indexPath.row-1)
                    return cell;
                
                @try {
                    NSDictionary *tempDict = videoCommentArray[indexPath.row - 2];
                    
                    
                    UserHeadView *headView = [[UserHeadView alloc] initWithFrame:CGRectMake(GapToLeft, 5, _cellHeight-10, _cellHeight-10)
                                                                      andImgName:@"me"
                                                                          andNav:self.navigationController];
                    
                    NSString *url = [NSString stringWithFormat:@"%@%@",Kimg_path,tempDict[@"CommenterPhotoPath"]];
                    [headView.headImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"headImg"]] ;
                    headView.userId = tempDict[@"CommenterId"];
                    [headView makeSelfRound];
                    [cell addSubview:headView];
                    
                    /*name*/
                    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake((headView.frame.origin.x +headView.frame.size.width + 10),
                                                                                 headView.frame.origin.y, 200, headView.frame.size.height/2)];
                    nameLab.text = tempDict[@"CommenterNicName"];
                    nameLab.textColor = TextColors;
                    nameLab.font = [UIFont systemFontOfSize:12];
                    [cell addSubview:nameLab];
                    
                    
                    UIButton *supportBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 44),headView.frame.origin.y , 44, headView.frame.size.height/2)];
                    [supportBtn setImage:[UIImage imageNamed:@"support"] forState:UIControlStateNormal];
                    [supportBtn setImage:[UIImage imageNamed:@"support_h"] forState:UIControlStateSelected];
                    [supportBtn setTitle:@"20" forState:UIControlStateNormal];
                    [supportBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                    supportBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                    // [cell addSubview:supportBtn];
                    
                    
                    NSString *commentStr = tempDict[@"Content"];
                    // commentWidth = (SCREEN_WIDTH-(headView.frame.origin.x +headView.frame.size.width + 10) - 10);
                    CGFloat commentHeight = [Toolkit heightWithString:commentStr fontSize:12 width:commentWidth];
                    
                    UILabel *commentLab = [[UILabel alloc] initWithFrame:CGRectMake((headView.frame.origin.x +headView.frame.size.width + 10),
                                                                                    headView.frame.size.height/2+5,
                                                                                    commentWidth,
                                                                                    commentHeight)];
                    commentLab.text = commentStr;
                    commentLab.font = [UIFont systemFontOfSize:12];
                    commentLab.numberOfLines = 0;
                    commentLab.textColor = [UIColor whiteColor];
                    [cell addSubview:commentLab];
                    
                    UILabel *dateLab = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100),
                                                                                 (commentLab.frame.size.height+commentLab.frame.origin.y),
                                                                                 100, 30)];
                    dateLab.text =[tempDict[@"PublishTime"] substringToIndex:10];
                    dateLab.font = [UIFont systemFontOfSize:12];
                    dateLab.textColor = [UIColor grayColor];
                    
                    [cell addSubview:dateLab];
                    
                    
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
                
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
            if(self.content!=nil&&USECONTENT)
            {
                return [Toolkit heightWithString:self.content fontSize:14 width:SCREEN_WIDTH]+80+20;
            }
            else
                return WebViewHeight;
            
            break;
        case CommentSection:
        {
            if(indexPath.row == 1)
                return _cellHeight;
            
            NSString *commentStr = videoCommentArray[indexPath.row - 2][@"Content"];
            //commentWidth = (SCREEN_WIDTH-(headView.frame.origin.x +headView.frame.size.width + 10) - 10);
            CGFloat commentHeight = [Toolkit heightWithString:commentStr fontSize:12 width:commentWidth];
            return commentHeight + 30+(_cellHeight-10)/2+10;
        }
        default:
            break;
    }
    
    return _cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    NSLog(@"click cell section : %ld row : %ld",(long)indexPath.section,(long)indexPath.row);
    if(indexPath.section == CommentSection)
    {
        if(indexPath.row < 2)
            return;
        
        if(videoCommentArray == nil || videoCommentArray.count <= 0 || videoCommentArray.count < indexPath.row-1)
            return;
        @try {
            NSDictionary *tempDict = videoCommentArray[indexPath.row -2];
            
            commentTextView.text = [NSString stringWithFormat:@"回复：//%@:%@",tempDict[@"CommenterNicName"],tempDict[@"Content"]];
            [_mainTableView scrollToRowAtIndexPath:tempIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            [commentTextView becomeFirstResponder];
            
            NSRange range;
            range.location = 0;
            range.length = 0;
            commentTextView.selectedRange = range;//光标设置到开始位置
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    }
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
