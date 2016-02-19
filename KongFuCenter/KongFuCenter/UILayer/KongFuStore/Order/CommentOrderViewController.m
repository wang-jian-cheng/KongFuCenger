//
//  CommentOrderViewController.m
//  KongFuCenter
//
//  Created by Wangjc on 16/1/25.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "CommentOrderViewController.h"
#import "FL_Button.h"
#import "UIImageView+WebCache.h"

@interface CommentOrderViewController ()
{
    CGFloat _cellHeight;
    UITableView *_mainTableView;
//    UITextView *commentTextView;
    
    NSMutableDictionary *mutableDict;//评价
    
    NSMutableDictionary * mutableDictText;//评论内容
    
}
@end

@implementation CommentOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mutableDict=[[NSMutableDictionary alloc] init];
    mutableDictText=[[NSMutableDictionary alloc] init];
    [self addLeftButton:@"left"];
//    [self addRightbuttontitle:@"确定"];
    [self initViews];
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

-(void)initViews
{

    
    _cellHeight = 100;

    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height - 50 )];
//    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height+44, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height ) style:UITableViewStyleGrouped];
    _mainTableView.backgroundColor = BACKGROUND_COLOR;
    
    _mainTableView.delegate = self;
    
    _mainTableView.dataSource = self;
    
    _mainTableView.separatorColor =  Separator_Color;
    
    _mainTableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:_mainTableView];
    
    UIView *backView  = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
    
    backView.backgroundColor = ItemsBaseColor;
    
    UIButton *uploadBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH - 100), 40)];
    
    uploadBtn.center = CGPointMake(SCREEN_WIDTH/2, backView.frame.size.height/2);
    
    uploadBtn.backgroundColor = YellowBlock;
    
    [uploadBtn setTitle:@"提交评论" forState:UIControlStateNormal];
    
    [uploadBtn addTarget:self action:@selector(UploadComment:) forControlEvents:UIControlEventTouchUpInside];
    
    [backView addSubview:uploadBtn];
    
    [self.view addSubview:backView];
    
    //    //注册通知,监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    //
    //    //注册通知,监听键盘消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden) name:UIKeyboardDidHideNotification object:nil];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:) ];
    
    [self.view addGestureRecognizer:tapGesture];
    
}

-(void)UploadComment:(UIButton *)sender
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    
    [dataprovider setDelegateObject:self setBackFunctionName:@"SaveCommentCallBack:"];
    
    @try {
        NSMutableArray * mutableArray=[[NSMutableArray alloc] init];
        
        for (int i=0; i<_GoodsArray.count; i++) {
            NSString * strid=mutableDict[[NSString stringWithFormat:@"%d",i]];
            NSString * strComment=mutableDictText[[NSString stringWithFormat:@"%d",i]];
            NSDictionary * prm=[[NSDictionary alloc] initWithObjectsAndKeys:_GoodsArray[i][@"ProductId"],@"productId",
                                strComment==nil?@"":strComment,@"content",
                                strid==nil?@"1":strid,@"typeId",
                                [Toolkit getUserID],@"userId",
                                [_GoodsArray[i][@"ProductPriceId"] isEqual:[NSNull null]]?@"0":_GoodsArray[i][@"ProductPriceId"],@"productPriceId",
                                nil];
            
            [mutableArray addObject:prm];
        }
        
        
        if (mutableArray.count>0) {
            [dataprovider SaveComment:mutableArray andbillid:_billId];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

-(void)tapViewAction:(id)sender
{
    
     [_mainTableView setFrame:CGRectMake(0, Header_Height, self.view.frame.size.width,self.view.frame.size.height - Header_Height - 50)];
    
    [self.view endEditing:YES];
    
}


// 键盘弹出时
-(void)keyboardDidShow:(NSNotification *)notification
{
    
    //获取键盘高度
    NSValue *keyboardObject = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect;
    [keyboardObject getValue:&keyboardRect];
    
    
    [_mainTableView setFrame:CGRectMake(0, Header_Height, self.view.frame.size.width,self.view.frame.size.height -Header_Height -keyboardRect.size.height)];
    
    [_mainTableView scrollToRowAtIndexPath:tempIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];

    
}

//键盘消失时
-(void)keyboardDidHidden
{

    //设置view的frame，往下平移
//    [_mainTableView setFrame:CGRectMake(0, Header_Height, self.view.frame.size.width,self.view.frame.size.height - Header_Height - 50)];
    
}

#pragma mark - MY text View delegate
-(void)myTextViewDidBeginEditing:(MyTextView *)textView
{
    tempIndexPath = [NSIndexPath indexPathForRow:1 inSection:textView.tag];
}

#pragma mark - click actions


#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _GoodsArray.count;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
    
}

#pragma mark - setting for cell

#define GapToLeft 20
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight)];;
    cell.backgroundColor = ItemsBaseColor;
    @try {
        
        if(indexPath.row == 0)
        {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(GapToLeft, 10, _cellHeight, _cellHeight - 20)];
//            imgView.image = [UIImage imageNamed:@"KongFuStoreProduct"];
            [imgView sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",Url,[_GoodsArray[indexPath.section][@"MiddleImagePath"] isEqual:[NSNull null]]?@"":_GoodsArray[indexPath.section][@"MiddleImagePath"]]] placeholderImage:[UIImage imageNamed:@"KongFuStoreProduct"]];
            [cell.contentView addSubview:imgView];
            
            UILabel *nowPriceLab = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 10 - 80), 10, 80, 30)];
            nowPriceLab.textColor = Separator_Color;
            nowPriceLab.text = [_GoodsArray[indexPath.section][@"ProductPriceTotalPrice"] isEqual:[NSNull null]]?@"":_GoodsArray[indexPath.section][@"ProductPriceTotalPrice"];
            nowPriceLab.textAlignment = NSTextAlignmentRight;
            nowPriceLab.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:nowPriceLab];
            
            UILabel *oldPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(nowPriceLab.frame.origin.x,
                                                                             (nowPriceLab.frame.origin.y+nowPriceLab.frame.size.height),
                                                                             nowPriceLab.frame.size.width, 20)];
            oldPriceLab.textColor = Separator_Color;
            oldPriceLab.text = @"";
            oldPriceLab.textAlignment = NSTextAlignmentRight;
            oldPriceLab.font = [UIFont systemFontOfSize:12];
            [cell.contentView addSubview:oldPriceLab];
            
            UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(oldPriceLab.frame.origin.x,
                                                                        (oldPriceLab.frame.origin.y+oldPriceLab.frame.size.height),
                                                                        oldPriceLab.frame.size.width, 20)];
            numLab.textColor = Separator_Color;
            numLab.text = [_GoodsArray[indexPath.section][@"Number"] isEqual:[NSNull null]]?@"X1":[NSString stringWithFormat:@"X%@",_GoodsArray[indexPath.section][@"Number"]];
            numLab.textAlignment = NSTextAlignmentRight;
            numLab.font = [UIFont systemFontOfSize:12];
            [cell.contentView addSubview:numLab];
            
            UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake((imgView.frame.origin.x + imgView.frame.size.width)+5,
                                                                          10, (SCREEN_WIDTH), 30)];
            titleLab.text = [_GoodsArray[indexPath.section][@"ProductName"] isEqual:[NSNull null]]?@"":_GoodsArray[indexPath.section][@"ProductName"];
            titleLab.textColor = [UIColor whiteColor];
            
            titleLab.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:titleLab];
        }
        else if (indexPath.row==1)
        {
            FL_Button *btn_new  = [FL_Button fl_shareButton];
            NSString * strid=mutableDict[[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
            if (![strid isEqualToString:@"0"]) {
                [btn_new setImage:[UIImage imageNamed:@"point"] forState:UIControlStateNormal];
            }
            else
            {
                [btn_new setImage:[UIImage imageNamed:@"selectRound"] forState:UIControlStateNormal];
            }
            [btn_new addTarget:self action:@selector(selectPingjia:) forControlEvents:UIControlEventTouchUpInside];
            [btn_new setTitle:@"差评" forState:UIControlStateNormal];
            [btn_new setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn_new.backgroundColor=[UIColor clearColor];
            btn_new.tag=indexPath.section*10;
            btn_new.status = FLAlignmentStatusNormal;
            btn_new.titleLabel.font = [UIFont systemFontOfSize:14];
            btn_new.frame=CGRectMake((SCREEN_WIDTH-240)/4, 0, 80, 44);
            [cell.contentView addSubview:btn_new];
            FL_Button *btn_midle  = [FL_Button fl_shareButton];
            NSLog(@"45456456%@",mutableDict[[NSString stringWithFormat:@"%ld",(long)indexPath.section]]);
            strid=mutableDict[[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
            if (![strid isEqualToString:@"1"]) {
                [btn_midle setImage:[UIImage imageNamed:@"point"] forState:UIControlStateNormal];
            }
            else
            {
                [btn_midle setImage:[UIImage imageNamed:@"selectRound"] forState:UIControlStateNormal];
            }
            [btn_midle addTarget:self action:@selector(selectPingjia:) forControlEvents:UIControlEventTouchUpInside];
            [btn_midle setTitle:@"中评" forState:UIControlStateNormal];
            [btn_midle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn_midle.backgroundColor=[UIColor clearColor];
            btn_midle.status = FLAlignmentStatusNormal;
            btn_midle.tag=indexPath.section*10+1;
            btn_midle.frame=CGRectMake((SCREEN_WIDTH-240)/4*2+80, 0, 80, 44);
            btn_midle.titleLabel.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:btn_midle];
            FL_Button *btn_best  = [FL_Button fl_shareButton];
            strid=mutableDict[[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
            if (![strid isEqualToString:@"2"]) {
                [btn_best setImage:[UIImage imageNamed:@"point"] forState:UIControlStateNormal];
            }
            else
            {
                [btn_best setImage:[UIImage imageNamed:@"selectRound"] forState:UIControlStateNormal];
            }
//            [btn_best setImage:[UIImage imageNamed:@"selectRound"] forState:UIControlStateNormal];
            [btn_best addTarget:self action:@selector(selectPingjia:) forControlEvents:UIControlEventTouchUpInside];
            [btn_best setTitle:@"好评" forState:UIControlStateNormal];
            [btn_best setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn_best.backgroundColor=[UIColor clearColor];
            btn_best.status = FLAlignmentStatusNormal;
            btn_best.tag=indexPath.section*10+2;
            btn_best.frame=CGRectMake((SCREEN_WIDTH-240)/4*3+160, 0, 80, 44);
            btn_best.titleLabel.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:btn_best];
        }
        else if(indexPath.row == 2)
        {
            MyTextView *commentTextView = [[MyTextView alloc] initWithFrame:CGRectMake(GapToLeft,5,SCREEN_WIDTH - 2*GapToLeft , _cellHeight-10)];
            commentTextView.textColor = [UIColor whiteColor];
            commentTextView.font = [UIFont systemFontOfSize:14];
            commentTextView.backgroundColor = BACKGROUND_COLOR;
            NSString *strid=mutableDictText[[NSString stringWithFormat:@"%ld",indexPath.section]];
            if (strid!=nil&&strid.length>0) {
                commentTextView.text = strid;
            }
            else
            {
                commentTextView.placeHolder.text = @"请输入评论的内容......";
            }
            
            commentTextView.tag = indexPath.section;
            commentTextView.mydelegate = self;
            [cell.contentView addSubview:commentTextView];
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
    if (indexPath.row==1) {
        return 44;
    }
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




-(void)mytextViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"%@",textView.text);
    
    [mutableDictText setObject:textView.text forKey:[NSString stringWithFormat:@"%ld",(long)textView.tag]];
}




-(void)selectPingjia:(UIButton *)sender
{
    UITableViewCell *cell = (UITableViewCell *)[[sender superview] superview];
    
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    
    NSLog(@"indexPath is = %li",(long)indexPath.row);
    
    [mutableDict setObject:[NSString stringWithFormat:@"%ld",sender.tag%10] forKey:[NSString stringWithFormat:@"%ld",sender.tag/10]];
    
    NSArray * array=[[NSArray alloc] initWithObjects:indexPath, nil];
    
    [_mainTableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
}

-(void)SaveCommentCallBack:(id)dict
{
    NSLog(@"%@",dict);
    if([dict[@"code"] intValue] == 200){
        NSUserDefaults *mUserDefault = [NSUserDefaults standardUserDefaults];
        [mUserDefault setValue:@"1" forKey:@"saveCommentFlag"];
        if ([_billDetail isEqual:@"1"]) {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"操作失败~" maskType:SVProgressHUDMaskTypeBlack];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
