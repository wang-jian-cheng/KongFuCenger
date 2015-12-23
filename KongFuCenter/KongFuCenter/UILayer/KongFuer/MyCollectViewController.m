//
//  MyCollectViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/4.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "MyCollectViewController.h"
#import "model_collect.h"
#import "UIImageView+WebCache.h"
@interface MyCollectViewController ()
{
    NSArray *cateArr;
    NSMutableArray *btnArr;
    //For views
    NSInteger _cellCollectionCount;
    UICollectionView *mainCollectionView;
    
    NSInteger _cellTableCount;
    CGFloat _cellTableHeight;
    UITableView *_mainTableView;
}

@property (nonatomic, strong) NSMutableArray * arr_voiceData;

@property (nonatomic, strong) NSMutableArray * arr_TitleData;

@end

#define _CELL  @"acell"

@implementation MyCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"left"];
    [self addRightbuttontitle:@"编辑"];
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self initDatas];
    [self initViews];
    [self getDatas];
    
    // Do any additional setup after loading the view.
}

#pragma mark - 解析数据
-(void)getDatas
{
    [self getUserInfo];
    
    [self getUserInfo1];
}

-(void)getUserInfo
{
    [SVProgressHUD showWithStatus:@"刷新中" maskType:SVProgressHUDMaskTypeBlack];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"getUserInfoCallBack:"];
//    [dataprovider collectData:[Toolkit getUserID] andIsVideo:@"true" andStartRowIndex:@"1" andMaximumRows:@"6"];
    [dataprovider setCollect:[Toolkit getUserID] andIsVideo:@"true" andStartRowIndex:@"0" andMaximumRowst:@"10"];
}

-(void)getUserInfoCallBack:(id)dict
{
//    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try
        {
            NSLog(@"%@",dict[@"data"]);
            NSArray * arr_ = dict[@"data"];
            model_collect * model = [[model_collect alloc] init];
            [model setValuesForKeysWithDictionary:arr_.firstObject];
            
            [self.arr_voiceData addObject:model];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
            [mainCollectionView reloadData];
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

-(void)getUserInfo1
{
    [SVProgressHUD showWithStatus:@"刷新中" maskType:SVProgressHUDMaskTypeBlack];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"getUserInfoCallBack1:"];
    //    [dataprovider collectData:[Toolkit getUserID] andIsVideo:@"true" andStartRowIndex:@"1" andMaximumRows:@"6"];
    [dataprovider setCollect:[Toolkit getUserID] andIsVideo:@"false" andStartRowIndex:@"0" andMaximumRowst:@"10"];
}

-(void)getUserInfoCallBack1:(id)dict
{
    //    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try
        {
            NSLog(@"%@",dict[@"data"]);
            NSArray * arr_ = dict[@"data"];
            model_collect * model = [[model_collect alloc] init];
            [model setValuesForKeysWithDictionary:arr_.firstObject];
            
            [self.arr_TitleData addObject:model];
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



-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

-(void)initDatas
{
    cateArr = @[@"视频",@"文章"];
    btnArr  = [NSMutableArray array];
    EditMode = NO;
    _cellCollectionCount = self.arr_voiceData.count;
}

-(void)initViews
{
    for (int i = 0;i< cateArr.count; i++) {
        UIButton *cateBtn = [[UIButton alloc] initWithFrame:CGRectMake(0 + i*(SCREEN_WIDTH/cateArr.count), Header_Height + 10,(SCREEN_WIDTH/cateArr.count) , 60)];
        
        if(i == 0)
        {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/cateArr.count)-1, 5, 1, cateBtn.frame.size.height - 5*2)];
            lineView.backgroundColor = BACKGROUND_COLOR;
            [cateBtn addSubview:lineView];
            cateBtn.selected = YES;
        }
        
        [cateBtn setTitle:cateArr[i] forState:UIControlStateNormal];
        cateBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        cateBtn.backgroundColor = ItemsBaseColor;
        [cateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cateBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        cateBtn.tag = i;
        
        [cateBtn addTarget:self action:@selector(cateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:cateBtn];
        [btnArr addObject:cateBtn];
    }
    
    [self initCollectionView];
    [self initTableView];
    
}

-(void)initCollectionView
{
    UICollectionViewFlowLayout *layout=[[ UICollectionViewFlowLayout alloc ] init ];
    layout.minimumLineSpacing = 5.0;
    layout.minimumInteritemSpacing = 5.0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;//设置collection
    
    //  layout.itemSize = CGSizeMake(318, 286);
    
    // layout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0);
    
    layout.headerReferenceSize = CGSizeMake(320, 200);
    
    
    
    mainCollectionView = [[UICollectionView alloc]  initWithFrame:CGRectMake(0, Header_Height + 10 +60+10, SCREEN_WIDTH , SCREEN_HEIGHT-( Header_Height + 10 +60+10)) collectionViewLayout:layout];
    
    [layout setHeaderReferenceSize:CGSizeMake(mainCollectionView.frame.size.width, 0)];//暂不现实时间
    
    [mainCollectionView registerClass :[ UICollectionViewCell class ] forCellWithReuseIdentifier : @"BaseVideoCell" ];
    
    mainCollectionView.delegate= self;
    mainCollectionView.dataSource =self;
    mainCollectionView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*2);
    mainCollectionView.showsHorizontalScrollIndicator = YES;
    mainCollectionView.showsVerticalScrollIndicator = NO;
    mainCollectionView.backgroundColor = BACKGROUND_COLOR;
    
    [self.view addSubview:mainCollectionView];
}


-(void)initTableView
{
    _cellTableHeight = 80;
    _cellTableCount = 10;
    
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height + 10 +60+10, SCREEN_WIDTH, SCREEN_HEIGHT-( Header_Height + 10 +60+10))];
    _mainTableView.backgroundColor = BACKGROUND_COLOR;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorColor =  Separator_Color;
    _mainTableView.tableFooterView = [[UIView alloc] init];
    //_mainTableView.scrollEnabled = NO;
    
    _mainTableView.contentSize = CGSizeMake(SCREEN_HEIGHT, _cellTableCount*(_cellTableHeight)+60);
    //[self.view addSubview:_mainTableView];
}


#pragma mark - btn Click

-(void)clickRightButton:(UIButton *)sender
{
    DLog(@" Click ");
    
    EditMode = !EditMode;
    
    [_mainTableView reloadData];
}

-(void)cateBtnClick:(UIButton *)sender
{
    sender.selected = YES;
    
    if(sender.tag == 0)
    {
        if(_mainTableView.superview != nil)
        {
            [_mainTableView removeFromSuperview];
        }
        
        if(mainCollectionView.superview == nil)
        {
            [self.view addSubview:mainCollectionView];
        }
    }
    else if(sender.tag == 1)
    {
        if(mainCollectionView.superview != nil)
        {
            [mainCollectionView removeFromSuperview];
        }
        
        if(_mainTableView.superview == nil)
        {
            [self.view addSubview:_mainTableView];
        }
    }
    
    for(int i =0;i<btnArr.count;i++)
    {
        if(i != sender.tag)
        {
            ((UIButton *)btnArr[i]).selected = NO;
        }
    }
}

#pragma mark - btn_1 btn_2
- (void)btn_1Action:(UIButton *)sender
{
    if (sender.selected == 0)
    {
        sender.selected = 1;
        [sender setImage:[UIImage imageNamed:@"support_h@2x"] forState:(UIControlStateNormal)];
    }
    else
    {
        sender.selected = 0;
        [sender setImage:[UIImage imageNamed:@"support@2x"] forState:(UIControlStateNormal)];
    }
}

- (void)btn_2Action:(UIButton *)sender
{
    if (sender.selected == 0)
    {
        sender.selected = 1;
        [sender setImage:[UIImage imageNamed:@"collect_h@2x"] forState:(UIControlStateNormal)];
    }
    else
    {
        sender.selected = 0;
        [sender setImage:[UIImage imageNamed:@"collect@2x"] forState:(UIControlStateNormal)];
    }
}

- (void)btn_firstAction:(UIButton *)sender
{
    
    model_collect * model = self.arr_voiceData[sender.tag / 10];
    
    if (sender.selected == 0)
    {
        sender.selected = 1;
        [sender setImage:[UIImage imageNamed:@"support_h@2x"] forState:(UIControlStateNormal)];
        
        int x = [model.LikeNum intValue] + 1;
        model.LikeNum = [NSString stringWithFormat:@"%d",x];
        [sender setTitle:model.LikeNum forState:(UIControlStateNormal)];
        NSLog(@"%@",model.LikeNum);
    }
    else
    {
        sender.selected = 0;
        [sender setImage:[UIImage imageNamed:@"support@2x"] forState:(UIControlStateNormal)];
        int x = [model.LikeNum intValue] - 1;
        model.LikeNum = [NSString stringWithFormat:@"%d",x];
        [sender setTitle:model.LikeNum forState:(UIControlStateNormal)];
    }
    
//    [mainCollectionView reloadData];
}

- (void)btn_secondAction:(UIButton *)sender
{
    
    model_collect * model = self.arr_voiceData[sender.tag / 10];
    
    if (sender.selected == 0)
    {
        sender.selected = 1;
        [sender setImage:[UIImage imageNamed:@"collect_h@2x"] forState:(UIControlStateNormal)];
        
        int x = [model.FavoriteNum intValue] + 1;
        model.FavoriteNum = [NSString stringWithFormat:@"%d",x];
        [sender setTitle:model.FavoriteNum forState:(UIControlStateNormal)];

    }
    else
    {
        sender.selected = 0;
        [sender setImage:[UIImage imageNamed:@"collect@2x"] forState:(UIControlStateNormal)];
        
        int x = [model.FavoriteNum intValue] - 1;
        model.FavoriteNum = [NSString stringWithFormat:@"%d",x];
        [sender setTitle:model.FavoriteNum forState:(UIControlStateNormal)];

    }
    
//    [mainCollectionView reloadData];
}
//?
- (void)btn_thridAction:(UIButton *)sender
{
    NSLog(@"跳到转发页面");
}

#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arr_TitleData.count;
    
}

#pragma mark - setting for cell
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier = @"mycollectTableCell";
    MyCollectTableViewCell *cell = (MyCollectTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.contentView.backgroundColor=ItemsBaseColor;
    cell.layer.masksToBounds=YES;
    cell.layer.cornerRadius=5;
    cell.bounds=CGRectMake(0, 0, SCREEN_WIDTH-50, cell.frame.size.height);
    cell  = [[[NSBundle mainBundle] loadNibNamed:@"MyCollectTableViewCell" owner:self options:nil] lastObject];
    cell.layer.masksToBounds=YES;
    cell.frame=CGRectMake(cell.frame.origin.x, cell.frame.origin.y, SCREEN_WIDTH, cell.frame.size.height);
//    cell.btn_1.backgroundColor = [UIColor orangeColor];
    
    model_collect * model = self.arr_TitleData[indexPath.row];
    NSString * url=[NSString stringWithFormat:@"%@%@",Kimg_path,model.ImagePath];
    [cell.image sd_setImageWithURL:[NSURL URLWithString:url]];
    cell.name.text = model.Title;
    cell.detail.text = model.Content;
    NSRange x = NSMakeRange(5, 5);
    //    [model.OperateTime substringWithRange:x];
    cell.date.text = [model.OperateTime substringWithRange:x];

#warning +++++++++++
    [cell.btn_1 setTitle:@"1000" forState:(UIControlStateNormal)];
    [cell.btn_1 setImage:[UIImage imageNamed:@"support@2x"] forState:(UIControlStateNormal)];
    [cell.btn_1 addTarget:self action:@selector(btn_1Action:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [cell.btn_2 setTitle:@"1000" forState:(UIControlStateNormal)];
    [cell.btn_2 setImage:[UIImage imageNamed:@"collect@2x"] forState:(UIControlStateNormal)];
    [cell.btn_2 addTarget:self action:@selector(btn_2Action:) forControlEvents:(UIControlEventTouchUpInside)];
    
    return cell;
    
}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return _cellTableHeight ;
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
    
    return YES;
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


#pragma mark - UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数

-( NSInteger )collectionView:( UICollectionView *)collectionView numberOfItemsInSection:( NSInteger )section
{
    return self.arr_voiceData.count;
    
}

//定义展示的Section的个数

-( NSInteger )numberOfSectionsInCollectionView:( UICollectionView *)collectionView
{
    return 1 ;
}

//每个UICollectionView展示的内容

-( UICollectionViewCell *)collectionView:( UICollectionView *)collectionView cellForItemAtIndexPath:( NSIndexPath *)indexPath
{
    
    
    UINib *nib = [UINib nibWithNibName:@"BaseVideoCollectionViewCell"
                                bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"BaseVideoCell"];
    BaseVideoCollectionViewCell *cell = [[BaseVideoCollectionViewCell alloc]init];
    
    // Set up the reuse identifier
    cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"BaseVideoCell"
                                                     forIndexPath:indexPath];
    cell.backgroundColor = ItemsBaseColor;
    
    model_collect * model = self.arr_voiceData[indexPath.row];
    
    cell.lbl_title.text = model.Title;
    cell.lbl_content.text = model.Content;
//    cell.img_logo.image = [UIImage imageNamed:model.ImagePath];
    NSString * url=[NSString stringWithFormat:@"%@%@",Kimg_path,model.ImagePath];
    [cell.img_logo sd_setImageWithURL:[NSURL URLWithString:url]];
    
    NSRange x = NSMakeRange(5, 5);
//    [model.OperateTime substringWithRange:x];
    cell.date.text = [model.OperateTime substringWithRange:x];
    
    
//    NSLog(@"%@",model.IsFree);
    NSString * str_free = [NSString stringWithFormat:@"%@",model.IsFree];
    if([str_free isEqualToString:@"0"])
    {
        cell.free.hidden = YES;
    }
    else
    {
        cell.free.hidden = NO;
        cell.btn_thrid.hidden = YES;
    }
    
//    NSLog(@"%@",model.LikeNum);
    
    [cell.btn_first setTitle:[NSString stringWithFormat:@"%@",model.LikeNum] forState:(UIControlStateNormal)];
    [cell.btn_first setImage:[UIImage imageNamed:@"support@2x"] forState:(UIControlStateNormal)];
    [cell.btn_first addTarget:self action:@selector(btn_firstAction:) forControlEvents:(UIControlEventTouchUpInside)];
    cell.btn_first.tag = indexPath.row * 10;
    
    [cell.btn_second setTitle:[NSString stringWithFormat:@"%@",model.FavoriteNum] forState:(UIControlStateNormal)];
    [cell.btn_second setImage:[UIImage imageNamed:@"collect@2x"] forState:(UIControlStateNormal)];
    [cell.btn_second addTarget:self action:@selector(btn_secondAction:) forControlEvents:(UIControlEventTouchUpInside)];
    cell.btn_second.tag = indexPath.row * 10;
    
    [cell.btn_thrid setTitle:[NSString stringWithFormat:@"%@",model.RepeatNum] forState:(UIControlStateNormal)];
    [cell.btn_thrid setImage:[UIImage imageNamed:@"relay@2x"] forState:(UIControlStateNormal)];
    [cell.btn_thrid addTarget:self action:@selector(btn_thridAction:) forControlEvents:(UIControlEventTouchUpInside)];
    cell.btn_thrid.tag = indexPath.row * 10;
//    cell.btn_thrid.enabled = NO;
    
    return cell;
}



#pragma mark - UICollectionViewDelegate

//UICollectionView被选中时调用的方法

-( void )collectionView:( UICollectionView *)collectionView didSelectItemAtIndexPath:( NSIndexPath *)indexPath
{
    
    VideoDetailViewController *viewDetailViewCtl = [[VideoDetailViewController alloc] init];
    
    [self.navigationController pushViewController:viewDetailViewCtl animated:YES];
    
    
    NSLog(@"click cell");
    
    
}

//返回这个UICollectionViewCell是否可以被选择

-( BOOL )collectionView:( UICollectionView *)collectionView shouldSelectItemAtIndexPath:( NSIndexPath *)indexPath
{
    return YES ;
}

#pragma mark - UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小

- ( CGSize )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath
{

    return CGSizeMake ( SCREEN_WIDTH/2-5 ,  SCREEN_WIDTH/2-5);

}

//定义每个UICollectionView 的边距

-( UIEdgeInsets )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section
{
    //if()

        return UIEdgeInsetsMake ( 0 , 0 , 10 , 1 );

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载
- (NSMutableArray *)arr_voiceData
{
    if(_arr_voiceData == nil)
    {
        self.arr_voiceData = [NSMutableArray array];
    }
    return _arr_voiceData;
}

- (NSMutableArray *)arr_TitleData
{
    if(_arr_TitleData == nil)
    {
        self.arr_TitleData = [NSMutableArray array];
    }
    return _arr_TitleData;
}

@end
