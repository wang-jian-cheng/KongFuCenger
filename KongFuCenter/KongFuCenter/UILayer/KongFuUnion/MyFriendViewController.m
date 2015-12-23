//
//  MyFriendViewController.m
//  KongFuCenter
//
//  Created by Rain on 15/12/21.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "MyFriendViewController.h"
#import "ChineseString.h"
#import "MyFriendTableViewCell.h"
#import "UserHeadView.h"
#import "ChatContentViewController.h"

@interface MyFriendViewController (){
    
    //tableview
    UITableView *mTableView;
    CGFloat mCellHeight;
    
    //数据
    NSArray *oFriendArray;
    NSMutableArray *friendArray;
    NSMutableArray *indexArray;
    NSMutableArray *LetterResultArr;
    
    //通用
    DataProvider *dataProvider;
    NSUserDefaults *userDefault;
    
    //控件
    UITextField *searchTxt;
    UILabel *nameLbl;
}

@end

@implementation MyFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化参数
    self.view.backgroundColor = ItemsBaseColor;
    mCellHeight = 70;
    [self setBarTitle:@"我的武友"];
    [self addLeftButton:@"left"];
    
    dataProvider = [[DataProvider alloc] init];
    userDefault = [NSUserDefaults standardUserDefaults];
    oFriendArray = [[NSArray alloc] init];
    friendArray = [[NSMutableArray alloc] init];
    
    //初始化数据
    [self initData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [searchTxt resignFirstResponder];
}

#pragma mark 自定义方法
-(void)initData{
    [SVProgressHUD showWithStatus:@"加载中"];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getFriendCallBack:"];
    [dataProvider getFriendForKeyValue:[userDefault valueForKey:@"id"]];
}

-(void)getFriendCallBack:(id)dict{
    oFriendArray = dict[@"data"];
    friendArray = [[NSMutableArray alloc] initWithArray:oFriendArray];
    NSMutableArray * itemmutablearray=[[NSMutableArray alloc] init];
    for (int i=0; i<friendArray.count; i++) {
        [itemmutablearray addObject:friendArray[i][@"Value"]];
    }
    indexArray = [ChineseString mIndexArray:[itemmutablearray valueForKey:@"NicName"]];
    LetterResultArr = [ChineseString mLetterSortArray:itemmutablearray];
    [SVProgressHUD dismiss];
    //初始化View
    [self initViews];
}

-(void)initViews{
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height)];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    
    mTableView.backgroundColor = BACKGROUND_COLOR;
    mTableView.separatorColor = Separator_Color;
    mTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:mTableView];
    mTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    mTableView.sectionIndexColor = [UIColor whiteColor];
}

-(void)mReloadData:(NSString *)filterStr{
    NSMutableArray * itemmutablearray=[[NSMutableArray alloc] init];
    if ([filterStr isEqual:@""]) {
        friendArray = [[NSMutableArray alloc] initWithArray:oFriendArray];
        for (int i=0; i<friendArray.count; i++) {
            [itemmutablearray addObject:friendArray[i][@"Value"]];
        }
    }else{
        friendArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < oFriendArray.count; i++) {
            NSString *itemName = oFriendArray[i][@"Value"][@"NicName"];
            if ([itemName containsString:filterStr]) {
                [friendArray addObject:oFriendArray[i]];
                [itemmutablearray addObject:oFriendArray[i][@"Value"]];
            }
        }
    }
    
    indexArray = [ChineseString IndexArray:[itemmutablearray valueForKey:@"NicName"]];
    LetterResultArr = [ChineseString mLetterSortArray:itemmutablearray];
    [mTableView reloadData];
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return indexArray.count + 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return 1;
    }else{
        return [[LetterResultArr objectAtIndex:section - 2] count];
    }
}

#pragma mark setting for section
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }else{
        return 25;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return indexArray;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *mView = [[UIView alloc] init];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 22)];
    titleLabel.textColor=[UIColor whiteColor];
    if (section == 0) {
        
    }else if (section == 1){
        titleLabel.text = @"我的战队";
    }else{
        titleLabel.text = [indexArray objectAtIndex:section - 2];
    }
    [mView addSubview:titleLabel];
    return mView;
}

#pragma mark setting for cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        cell.backgroundColor = ItemsBaseColor;
        searchTxt = [[UITextField alloc] initWithFrame:CGRectMake(14, 0, SCREEN_WIDTH - 28, cell.frame.size.height)];
        searchTxt.delegate = self;
        searchTxt.returnKeyType = UIReturnKeySearch;
        searchTxt.textColor = [UIColor whiteColor];
        searchTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索好友昵称" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.44 green:0.43 blue:0.44 alpha:1]}];
        UIImageView *searchIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 20)];
        searchIv.contentMode = UIViewContentModeScaleAspectFit;
        searchIv.image = [UIImage imageNamed:@"search"];
        searchTxt.leftView = searchIv;
        searchTxt.leftViewMode = UITextFieldViewModeAlways;
        [cell addSubview:searchTxt];
        return cell;
    }else if(indexPath.section == 1){
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        cell.backgroundColor = ItemsBaseColor;
        UserHeadView *headView = [[UserHeadView alloc] initWithFrame:CGRectMake(8, 7, 55, 55) andImg:[UIImage imageNamed:@"me"]];
        //headView.userId = friendArray[indexPath.row][@"Value"][@"Id"];
        [headView makeSelfRound];
        [cell addSubview:headView];
        
        nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(8 + headView.frame.size.width + 5, (mCellHeight - 21) / 2, 100, 21)];
        nameLbl.textColor = [UIColor whiteColor];
        nameLbl.text = @"成龙战队";
        [cell addSubview:nameLbl];
        return cell;
    }else{
        NSString *CellIdentifier = @"MyFriendCellIdentifier";
        MyFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MyFriendTableViewCell" owner:self options:nil] objectAtIndex:0];
            cell.backgroundColor = ItemsBaseColor;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSString *photoImage = ((ChineseString *)LetterResultArr[indexPath.section - 2][indexPath.row]).photoImg;
        NSString *url = [NSString stringWithFormat:@"%@%@",Url,photoImage];
        UserHeadView *headView = [[UserHeadView alloc] initWithFrame:cell.mImageView.frame andImg:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]] andNav:self.navigationController];
        headView.userId = ((ChineseString *)LetterResultArr[indexPath.section - 2][indexPath.row]).friendID;
        [headView makeSelfRound];
        
        [cell addSubview:headView];
        cell.mName.text = ((ChineseString *)LetterResultArr[indexPath.section - 2][indexPath.row]).string;
        cell.mLevel.text = [NSString stringWithFormat:@"等级:lv%@",((ChineseString *)LetterResultArr[indexPath.section - 2][indexPath.row]).level];
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 45;
    }else{
        return mCellHeight;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [mTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        //新建一个聊天会话View Controller对象
        ChatContentViewController *chat = [[ChatContentViewController alloc]init];
        //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众账号等
        chat.conversationType = ConversationType_GROUP;
        //设置会话的目标会话ID。（单聊、客服、公众账号服务为对方的ID，讨论组、群聊、聊天室为会话的ID）
        chat.targetId = [NSString stringWithFormat:@"%@",[userDefault valueForKey:@"TeamId"]];
        //设置聊天会话界面要显示的标题
        chat.mTitle = nameLbl.text;
        //显示聊天会话界面
        [self.navigationController pushViewController:chat animated:YES];
    }
}

#pragma mark - textfield deledate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self mReloadData:textField.text];
}

@end
