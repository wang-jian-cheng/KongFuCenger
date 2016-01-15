//
//  VideoDetailForMatchViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/14.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "VideoDetailForMatchViewController.h"
#import "UserHeadView.h"
#import "MoviePlayer.h"

#define VideoPlaySection    0
#define SupportSection      1
#define VideoDetailSection  2
#define CommentSection      3

#define GapToLeft           20
#define TextColors          [UIColor whiteColor]

@interface VideoDetailForMatchViewController ()
{
#pragma mark - pram for tableView
    NSInteger _sectionNum;
    CGFloat _cellHeight;
    UITableView *_mainTableView;
    MoviePlayer *moviePlayerview;
    
    NSDictionary * VideoDict;//视频信息
    NSString * VideoPath;
}
@end

@implementation VideoDetailForMatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"left"];
    videoCommentArray = [NSMutableArray array];
    [self initViews];
    pageSize = 15;
    //_videoID = @"254";
    
    [self getData];
    // Do any additional setup after loading the view.
}



-(void)initViews
{
    _cellHeight = SCREEN_HEIGHT/12;
    _sectionNum = 4;
    commentWidth = SCREEN_WIDTH - _cellHeight -GapToLeft - 40;
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height )];
    _mainTableView.backgroundColor = BACKGROUND_COLOR;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorColor = Separator_Color;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _mainTableView.tableFooterView = [[UIView alloc] init];
    //_mainTableView.scrollEnabled = NO;
    __unsafe_unretained __typeof(self) weakSelf = self;

    _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf GetVideoCommentDetial];
        [_mainTableView.mj_footer endRefreshing];
    }];

    
    _mainTableView.contentSize = CGSizeMake(SCREEN_HEIGHT, _sectionNum*(_cellHeight + 20));
    [self.view addSubview:_mainTableView];
    
    
//    moviePlayerview = [[MoviePlayer alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 4*_cellHeight) URL:[NSURL URLWithString:@"http://baobab.cdn.wandoujia.com/14468618701471.mp4"]];
    //     MoviePlayer *view = [[MoviePlayer alloc] initWithFrame:self.view.bounds URL:[NSURL URLWithString:@"http://192.168.1.136/4.flv"]];
//    [self.view addSubview:moviePlayerview];
    
    
    
    commentTextView = [[UITextView alloc] init];
    commentTextView.delegate = self;
    commentTextView.textColor = [UIColor whiteColor];
    commentTextView.backgroundColor = [UIColor grayColor];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:) ];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    
    //    //注册通知,监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    //
    //    //注册通知,监听键盘消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden) name:UIKeyboardDidHideNotification object:nil];
    
    
    
}
#pragma mark - self data source


- (void)getData
{
    [self GetVideoDetial];
    
    [self GetVideoCommentDetial];
}

-(void)GetVideoDetial
{
    
    if(self.matchUserId==nil&&self.matchTeamId!=nil)
    {
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"GetTeamMatchCallBack:"];
        [dataprovider getTeamDetailForMatch:self.matchId andTeamId:self.matchTeamId];
        
    }
    else if(self.matchUserId !=nil &&self.matchTeamId == nil)
    {
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"GetUserMatchCallBack:"];
        [dataprovider SelectMatchMemberDetail:self.matchId anduserid:self.matchUserId];

    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未找到视频" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alertView show];
        return;
    }
}


-(void)voteCallBack:(id)dict
{
    [SVProgressHUD dismiss];
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        //        _lblTitle.text=[dict[@"data"][@"Title"] isEqual:[NSNull null]]?@"":dict[@"data"][@"Title"];
        [SVProgressHUD showSuccessWithStatus:@"操作成功" maskType:SVProgressHUDMaskTypeBlack];
    }
    else{
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"data"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)GetTeamMatchCallBack:(id)dict
{
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        //        _lblTitle.text=[dict[@"data"][@"Title"] isEqual:[NSNull null]]?@"":dict[@"data"][@"Title"];

    }
    else{
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"data"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)GetUserMatchCallBack:(id)dict
{
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        //        _lblTitle.text=[dict[@"data"][@"Title"] isEqual:[NSNull null]]?@"":dict[@"data"][@"Title"];
        
    }
    else{
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"data"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }
}


-(void)GetVideoDetialCallBack:(id)dict
{
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        //        _lblTitle.text=[dict[@"data"][@"Title"] isEqual:[NSNull null]]?@"":dict[@"data"][@"Title"];
        
        VideoPath=[NSString stringWithFormat:@"%@%@",Url,[dict[@"data"][@"VideoPath"] isEqual:[NSNull null]]?@"":dict[@"data"][@"VideoPath"]];
        
        VideoPath=[VideoPath stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
        
        VideoDict=dict[@"data"];
        
       
        if([dict[@"data"][@"IsFree"] intValue] == 0)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"会员才可观看" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return;
        }
        
        moviePlayerview = [[MoviePlayer alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 4*_cellHeight) URL:[NSURL URLWithString:VideoPath]];
        
        [_mainTableView reloadData];
        [self.view addSubview:moviePlayerview];
    }
    else{
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"data"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)GetVideoCommentDetial
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetVideoCommentDetialCallBack:"];
    
    [dataprovider getMatchComment:self.matchId andstartRowIndex:[NSString stringWithFormat:@"%d",pageNo*pageSize] andmaximumRows:[NSString stringWithFormat:@"%d",pageSize]];
}

-(void)GetVideoCommentDetialCallBack:(id)dict
{
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try
        {
            pageNo++;
            
//            if(videoCommentArray !=nil && videoCommentArray.count>0)
//                [ videoCommentArray removeAllObjects];
//            
            [videoCommentArray addObjectsFromArray:dict[@"data"]];
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
            [_mainTableView reloadData];
            [SVProgressHUD dismiss];
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

#pragma mark - 手势代理

//设置点在某个view时部触发事件
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"-%@", NSStringFromClass([touch.view class]));
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

#pragma mark - click actions

-(void)tapViewAction:(id)sender
{
    [self.view endEditing:YES];
    
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
//    [dataprovider commentVideo:self.videoID andUserId:[Toolkit getUserID] andComment:commentTextView.text];
    [dataprovider commentMatch:self.matchId andUserID:[Toolkit getUserID] andComment:commentTextView.text];
    
}
-(void)clickLeftButton:(UIButton *)sender
{
    [moviePlayerview stopPlayer];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}


-(void)btnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
}



-(void)voteBtnClick:(UIButton *)sender
{
    [SVProgressHUD showWithStatus:@"操作中..."];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"voteCallBack:"];
    //    [dataprovider commentVideo:self.videoID andUserId:[Toolkit getUserID] andComment:commentTextView.text];
    if(self.matchUserId==nil&&self.matchTeamId!=nil)
    {
        [dataprovider voteTeam:self.matchId andTeamId:self.matchTeamId andUserId:[Toolkit getUserID]];
        
    }
    else if(self.matchUserId !=nil &&self.matchTeamId == nil)
    {
        [dataprovider votePerson:self.matchId andUserid:self.matchUserId andUserId:[Toolkit getUserID]];
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
        case VideoDetailSection:
            return 2;
            break;
        case SupportSection:
            return 1;
            break;
        case VideoPlaySection:
            return 1;
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
        case VideoDetailSection:
        {
            if(indexPath.row == 0)
            {
                
                CGFloat FontSize = 12;
                
                /*head */
                UserHeadView *headView = [[UserHeadView alloc] initWithFrame:CGRectMake(GapToLeft, 5, _cellHeight-10, _cellHeight-10)
                                                                  andImgName:@"me"
                                                                      andNav:self.navigationController];
                [headView makeSelfRound];
                [cell addSubview:headView];
                
                /*name*/
                UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake((headView.frame.origin.x +headView.frame.size.width + 10),
                                                                             headView.frame.origin.y, 100, headView.frame.size.height/2)];
                nameLab.text = @"成龙战队";
                nameLab.textColor = TextColors;
                nameLab.font = [UIFont systemFontOfSize:FontSize];
                [cell addSubview:nameLab];
                
                
                
                UILabel *supportNum = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH -140 - 10),
                                                                                headView.frame.origin.y, 140, headView.frame.size.height/2)];
                supportNum.text = @"已获得票数：100";
                supportNum.textColor = [UIColor whiteColor];
                supportNum.font = [UIFont systemFontOfSize:12];
                supportNum.textAlignment = NSTextAlignmentRight;
                [cell addSubview:supportNum];
                
               
                UILabel *dateLab = [[UILabel alloc] initWithFrame:CGRectMake(nameLab.frame.origin.x,
                                                                             (nameLab.frame.origin.y + nameLab.frame.size.height + 2),
                                                                             100, headView.frame.size.height/2)];
                dateLab.text = @"编号：001";
                dateLab.textColor = TextColors;
                dateLab.font = [UIFont systemFontOfSize:FontSize];
                [cell addSubview:dateLab];
                
                UILabel *checkNum = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH -140 - 10),
                                                                                 (nameLab.frame.origin.y + nameLab.frame.size.height + 2), 140, headView.frame.size.height/2)];
                checkNum.text = @"查看人数：100";
                checkNum.textColor = [UIColor whiteColor];
                checkNum.font = [UIFont systemFontOfSize:12];
                checkNum.textAlignment = NSTextAlignmentRight;
                [cell addSubview:checkNum];
                
            }
            
            if(indexPath.row == 1)
            {
                UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 10, SCREEN_WIDTH, 30)];
                titleLab.textColor = TextColors;
                titleLab.text = @"名字：咏春拳最快制敌方法";
                titleLab.font = [UIFont boldSystemFontOfSize:14];
                [cell addSubview:titleLab];
                
                NSString *detailStr = @"简介：咏春拳是一门传统的中国武术，是一门禁止侵袭技术，是一个积极、精简的正当防卫系统";
                CGFloat detailWidth = SCREEN_WIDTH-GapToLeft*2;
                CGFloat detailHeight = [Toolkit heightWithString:detailStr fontSize:12 width:detailWidth];
                
                UILabel *detailLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft,
                                                                               (titleLab.frame.origin.y+titleLab.frame.size.height+5),
                                                                               detailWidth, detailHeight)];
                detailLab.textColor = TextColors;
                detailLab.text = detailStr;
                detailLab.numberOfLines = 0;
                detailLab.font = [UIFont boldSystemFontOfSize:12];
                [cell addSubview:detailLab];
                
            }
        }
            break;
        case SupportSection:
        {
            UIButton *supportBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, _cellHeight -10)];
            supportBtn.center = CGPointMake(SCREEN_WIDTH/2, _cellHeight/2);
            supportBtn.backgroundColor = YellowBlock;
            [supportBtn addTarget:self action:@selector(voteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [supportBtn setTitle:@"点击投票" forState:UIControlStateNormal];
            [cell addSubview:supportBtn];
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
            return 4*_cellHeight;
            break;
        case 1:
            
            return 3*_cellHeight;
            break;
        case 2:
            return 2*_cellHeight;
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
            break;
            
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
            
            commentTextView.text = [NSString stringWithFormat:@"//%@:%@",tempDict[@"CommenterNicName"],tempDict[@"Content"]];
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
