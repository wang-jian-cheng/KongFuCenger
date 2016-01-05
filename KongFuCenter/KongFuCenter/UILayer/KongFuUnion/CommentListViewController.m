//
//  CommentListViewController.m
//  KongFuCenter
//
//  Created by Rain on 16/1/4.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "CommentListViewController.h"
#import "CommentTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "OneShuoshuoViewController.h"

@interface CommentListViewController (){
    UITableView *mTableView;
    CGFloat mCellHeight;
    NSUserDefaults *userDefault;
    NSArray *commentArray;
}

@end

@implementation CommentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化参数
    self.view.backgroundColor = BACKGROUND_COLOR;
    mCellHeight = 70;
    [self setBarTitle:@"朋友圈的评论提示"];
    [self addLeftButton:@"left"];
    
    userDefault = [NSUserDefaults standardUserDefaults];
    commentArray = [[NSArray alloc] init];
    
    //初始化data
    [self initData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

#pragma mark 自定义方法

-(void)initData{
    [SVProgressHUD showWithStatus:@"正在加载中..."];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getCommentInfoCallBack:"];
    [dataProvider GetMyDongtaiPage:[userDefault valueForKey:@"id"] andstartRowIndex:@"0" andmaximumRows:@"10"];
}

-(void)getCommentInfoCallBack:(id)dict{
    [SVProgressHUD dismiss];
    NSLog(@"%@",dict);
    if ([dict[@"code"] intValue] == 200) {
        commentArray = dict[@"data"];
        [self initViews];
    }
}

-(void)initViews{
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height)];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = BACKGROUND_COLOR;
    mTableView.separatorColor = Separator_Color;
    mTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:mTableView];
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return commentArray.count;
}

#pragma mark setting for section

#pragma mark setting for cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"CommentCellIdentifier";
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.backgroundColor = ItemsBaseColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    @try {
        NSString *PhotoPath = [commentArray[indexPath.row] valueForKey:@"PhotoPath"];
        NSString *url = [NSString stringWithFormat:@"%@%@",Url,PhotoPath];
        [cell.mImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"me"]];
        cell.mName.text = [[NSString stringWithFormat:@"%@",[commentArray[indexPath.row] valueForKey:@"NicName"]] isEqual:@""]?@"":[commentArray[indexPath.row] valueForKey:@"NicName"];
        cell.mContent.text = [[NSString stringWithFormat:@"%@",[commentArray[indexPath.row] valueForKey:@"Content"]] isEqual:@""]?@"":[commentArray[indexPath.row] valueForKey:@"Content"];
        NSString *mDate = [[NSString stringWithFormat:@"%@",[commentArray[indexPath.row] valueForKey:@"PublishTime"]] isEqual:@""]?@"":[commentArray[indexPath.row] valueForKey:@"PublishTime"];
        NSString *month = [mDate substringWithRange:NSMakeRange(5, 2)];
        NSString *day = [mDate substringWithRange:NSMakeRange(8, 2)];
        cell.mDate.text = [NSString stringWithFormat:@"%@月%@日",month,day];
        
        NSString *ImagePath = [[NSString stringWithFormat:@"%@",[commentArray[indexPath.row] valueForKey:@"ImagePath"]] isEqual:@""]?@"":[commentArray[indexPath.row] valueForKey:@"ImagePath"];
        if([ImagePath isEqual:@""]){
            NSArray *picList = [[NSArray alloc] initWithArray:[commentArray[indexPath.row] valueForKey:@"PicList"]];
            if (picList.count == 0) {
                UITextView *mTv = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, cell.mDetail.frame.size.width, cell.mDetail.frame.size.height)];
                mTv.backgroundColor = [UIColor colorWithRed:0.24 green:0.24 blue:0.25 alpha:1];
                mTv.textColor = [UIColor whiteColor];
                mTv.text = [[NSString stringWithFormat:@"%@",[commentArray[indexPath.row] valueForKey:@"MessageAndVideoContent"]] isEqual:@""]?@"":[commentArray[indexPath.row] valueForKey:@"MessageAndVideoContent"];
                [cell.mDetail addSubview:mTv];
            }else{
                ImagePath = [picList[0] valueForKey:@"ImagePath"];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.mDetail.frame.size.width, cell.mDetail.frame.size.height)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Url,ImagePath]] placeholderImage:[UIImage imageNamed:@"me"]];
                [cell.mDetail addSubview:imageView];
            }
        }else{
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.mDetail.frame.size.width, cell.mDetail.frame.size.height)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Url,ImagePath]] placeholderImage:[UIImage imageNamed:@"me"]];
            
            UIImageView *play = [[UIImageView alloc] initWithFrame:CGRectMake((imageView.frame.size.width - 15) / 2, (imageView.frame.size.height - 15) / 2, 15, 15)];
            play.image = [UIImage imageNamed:@"play"];
            [imageView addSubview:play];
            
            [cell.mDetail addSubview:imageView];
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return mCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [mTableView deselectRowAtIndexPath:indexPath animated:YES];
    OneShuoshuoViewController *oneShuoshuoVC = [[OneShuoshuoViewController alloc] init];
    oneShuoshuoVC.shuoshuoID = [commentArray[indexPath.row] valueForKey:@"Id"];
    //[self.navigationController pushViewController:oneShuoshuoVC animated:YES];
}

@end
