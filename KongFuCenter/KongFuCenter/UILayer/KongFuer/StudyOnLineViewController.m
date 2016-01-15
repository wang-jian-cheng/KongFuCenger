//
//  StudyOnLineViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/3.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "StudyOnLineViewController.h"

@interface StudyOnLineViewController ()
{
    //Views
    UICollectionView *mainCollectionView;
    UIImageView *btnImgView;
    UIView *viewForBtns;
    //datas
    NSMutableArray *studyCateArr;
    NSMutableArray *secondCateArr;
    NSMutableArray *btnArr;
    
    
}
@end

#define _CELL @ "acell"
@implementation StudyOnLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initDatas];
    [self initViews];
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self addLeftButton:@"left"];
    
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
   
}


-(void)initDatas
{
    studyCateArr = [NSMutableArray array];
  //  [studyCateArr addObjectsFromArray:@[@"正向品格",@"极限武术",@"教练核能",@"运营管理"]];
    
    secondCateArr= [NSMutableArray array];
  //  [secondCateArr addObjectsFromArray:@[@"野心",@"坚毅",@"激情",@"自制",@"好奇",@"感恩",@"乐观",@"社交",@"其他",@"4",@"3",@"2",@"1"]];

    btnArr = [NSMutableArray array];
}

-(void)initViews
{
    viewForBtns = [[UIView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, 44)];
    btnImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btnFlag"]];
    btnImgView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view addSubview:viewForBtns];
    

    self.collectionViewLayout = [[RAMCollectionViewFlemishBondLayout alloc] init];
    self.collectionViewLayout.delegate = self;
    self.collectionViewLayout.numberOfElements = 3;
    self.collectionViewLayout.highlightedCellHeight = (SCREEN_HEIGHT - Header_Height )/100*35;//150.f;
    self.collectionViewLayout.highlightedCellWidth = SCREEN_WIDTH/5*3;
    //  layout.itemSize = CGSizeMake(318, 286);
   // self.collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // layout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0);
    mainCollectionView = [[UICollectionView alloc]  initWithFrame:CGRectMake(0, 44+Header_Height, SCREEN_WIDTH , SCREEN_HEIGHT-(44+Header_Height)) collectionViewLayout:self.collectionViewLayout];
    
    
    [mainCollectionView registerClass :[ UICollectionViewCell class ] forCellWithReuseIdentifier : _CELL ];
    
    mainCollectionView.delegate= self;
    mainCollectionView.dataSource =self;
    mainCollectionView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*2);
    mainCollectionView.showsHorizontalScrollIndicator = YES;
    mainCollectionView.showsVerticalScrollIndicator = NO;
    mainCollectionView.backgroundColor = BACKGROUND_COLOR;
    
    
   // [mainCollectionView registerClass:[MYCollectionHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    //#pragma mark -- 注册尾部视图
    //    [mainCollectionView registerClass:[MyCollectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
    [self.view addSubview:mainCollectionView];
    
    
    [self getDatas];
    
}

#pragma mark - self data source

-(void)getDatas
{
    [self getMainCategary];
}

-(void)getMainCategary
{
    [SVProgressHUD showWithStatus:@"刷新" maskType:SVProgressHUDMaskTypeBlack];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"getMainCategaryCallBack:"];
    [dataprovider getStudyOnlineMainCategory];
    
}

-(void)getMainCategaryCallBack:(id)dict
{

    [SVProgressHUD dismiss];
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try {
           // NSDictionary *tempDict = dict[@"data"];
            if(studyCateArr!=nil)
            {
                [studyCateArr removeAllObjects];
                studyCateArr = dict[@"data"];
                
                
                for (int i = 0;i< studyCateArr.count; i++) {
                    UIButton *cateBtn = [[UIButton alloc] initWithFrame:CGRectMake(0 + i*(SCREEN_WIDTH/studyCateArr.count), 0,(SCREEN_WIDTH/studyCateArr.count) , viewForBtns.frame.size.height)];
                    
                    if(i == 0)
                    {
                        cateBtn.selected = YES;
                        btnImgView.frame = CGRectMake((cateBtn.frame.size.width - 15)/2, (cateBtn.frame.size.height - 15), 15, 15);
                        [cateBtn addSubview:btnImgView];
                    }
                    
                    //  [cateBtn setTitle:studyCateArr[i] forState:UIControlStateNormal];
                    [cateBtn setTitle:[studyCateArr objectAtIndex:i][@"Name"] forState:UIControlStateNormal];
                    cateBtn.titleLabel.font = [UIFont systemFontOfSize:16];
                    cateBtn.backgroundColor = ItemsBaseColor;
                    [cateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [cateBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
                    cateBtn.tag = i;
                    
                    [cateBtn addTarget:self action:@selector(cateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [viewForBtns addSubview:cateBtn];
                    [btnArr addObject:cateBtn];
                }

                
                [self getSecundCategory:studyCateArr[0][@"Id"]];
                
            }
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


-(void)getSecundCategory:(NSString *)categoryid
{
    [SVProgressHUD showWithStatus:@"刷新" maskType:SVProgressHUDMaskTypeBlack];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"getSecundCategoryCallBack:"];
    [dataprovider getStudyOnlineSecundCategory:categoryid];
}


-(void)getSecundCategoryCallBack:(id)dict
{
    
    [SVProgressHUD dismiss];
    DLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        @try {
            if(secondCateArr != nil && secondCateArr.count > 0)
                [secondCateArr removeAllObjects];
            [secondCateArr addObjectsFromArray:dict[@"data"]];
            
            
            mainCollectionView = [[UICollectionView alloc]  initWithFrame:CGRectMake(0, 44+Header_Height, SCREEN_WIDTH , SCREEN_HEIGHT-(44+Header_Height)) collectionViewLayout:self.collectionViewLayout];
            
            
            [mainCollectionView registerClass :[ UICollectionViewCell class ] forCellWithReuseIdentifier : _CELL ];
            
            mainCollectionView.delegate= self;
            mainCollectionView.dataSource =self;
            mainCollectionView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*2);
            mainCollectionView.showsHorizontalScrollIndicator = YES;
            mainCollectionView.showsVerticalScrollIndicator = NO;
            mainCollectionView.backgroundColor = BACKGROUND_COLOR;
        
            [self.view addSubview:mainCollectionView];
            [mainCollectionView reloadData];

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

-(void)cateBtnClick:(UIButton *)sender
{
    sender.selected = YES;
    [btnImgView removeFromSuperview];
    btnImgView.frame = CGRectMake((sender.frame.size.width-15)/2, (sender.frame.size.height - 15), 15, 15);
    [sender addSubview:btnImgView];
    
    if(secondCateArr !=nil)
        [secondCateArr removeAllObjects];
    
    [mainCollectionView removeFromSuperview];
    [self getSecundCategory:studyCateArr[sender.tag][@"Id"]];
    for(int i =0;i<btnArr.count;i++)
    {
        if(i != sender.tag)
        {
            ((UIButton *)btnArr[i]).selected = NO;
        }
    }
}


#pragma mark - UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数

-( NSInteger )collectionView:( UICollectionView *)collectionView numberOfItemsInSection:( NSInteger )section
{

    return secondCateArr.count;
    
}


//定义展示的Section的个数

-( NSInteger )numberOfSectionsInCollectionView:( UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容

-( UICollectionViewCell *)collectionView:( UICollectionView *)collectionView cellForItemAtIndexPath:( NSIndexPath *)indexPath
{
    
    
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:_CELL forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];

    if(cell != nil)
    {
        for (int i =0 ; i<cell.subviews.count; i++) {
            [ [cell.subviews objectAtIndex:i] removeFromSuperview];//清空一下原来cell上面的view'防止cell的重用影响到后面section的显示
        }
        
    }
    @try {
        if(secondCateArr == nil ||secondCateArr.count == 0||indexPath.row > secondCateArr.count -1)
            return cell;
        
        
        UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        NSString *url = [NSString stringWithFormat:@"%@%@",Kimg_path,secondCateArr[indexPath.row][@"ImagePath"]];
        [backView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"temp2"]];
        [cell addSubview:backView];
        
        UILabel *cateNameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        cateNameLab.text = secondCateArr[indexPath.row][@"Name"];
        cateNameLab.textColor = [UIColor whiteColor];
        cateNameLab.font = [UIFont boldSystemFontOfSize:20];
        cateNameLab.backgroundColor = [UIColor blackColor];
        cateNameLab.textAlignment = NSTextAlignmentCenter;
        cateNameLab.alpha = 0.3;
        [cell addSubview:cateNameLab];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        return cell;
    }
   
    
    
}


#pragma mark - UICollectionViewDelegate

//UICollectionView被选中时调用的方法

-( void )collectionView:( UICollectionView *)collectionView didSelectItemAtIndexPath:( NSIndexPath *)indexPath
{
    
    NSLog(@"click cell");
    
    VideoListForStudyViewController *videoList = [[VideoListForStudyViewController alloc] init];
    videoList.navtitle = secondCateArr[indexPath.row][@"Name"];
    videoList.categoryid=secondCateArr[indexPath.row][@"Id"];
    [self.navigationController pushViewController:videoList animated:YES];
    
}

//返回这个UICollectionViewCell是否可以被选择

-( BOOL )collectionView:( UICollectionView *)collectionView shouldSelectItemAtIndexPath:( NSIndexPath *)indexPath
{
    return YES ;
}

#pragma mark - UICollectionViewDelegateFlowLayout

////定义每个UICollectionView 的大小
//
//- ( CGSize )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath
//{
//    
//   return  CGSizeMake ( (SCREEN_WIDTH - 10)/2 , SCREEN_HEIGHT/4 -10);
//}
//
////定义每个UICollectionView 的边距
//
-( UIEdgeInsets )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section
{


    return UIEdgeInsetsMake ( 10 ,10 , 10 , 10 );

}


#pragma mark - RAMCollectionViewVunityLayoutDelegate
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(RAMCollectionViewFlemishBondLayout *)collectionViewLayout estimatedSizeForHeaderInSection:(NSInteger)section
//{
//    return CGSizeMake(CGRectGetWidth(mainCollectionView.frame), 100);
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(RAMCollectionViewFlemishBondLayout *)collectionViewLayout estimatedSizeForFooterInSection:(NSInteger)section
//{
//    return CGSizeMake(CGRectGetWidth(mainCollectionView.frame), 100);
//}

- (RAMCollectionViewFlemishBondLayoutGroupDirection)collectionView:(UICollectionView *)collectionView layout:(RAMCollectionViewFlemishBondLayout *)collectionViewLayout highlightedCellDirectionForGroup:(NSInteger)group atIndexPath:(NSIndexPath *)indexPath
{
    RAMCollectionViewFlemishBondLayoutGroupDirection direction;
    
   
    
    if ((indexPath.row/3) % 2) {
        direction = RAMCollectionViewFlemishBondLayoutGroupDirectionRight;
    } else {
        direction = RAMCollectionViewFlemishBondLayoutGroupDirectionLeft;
    }
    
    if(indexPath.row %3 ==1)
    {
        direction |= RAMCollectionViewUnHighlightedCellInTop;
    }
    else if(indexPath.row %3 ==2)
    {
        direction |= RAMCollectionViewUnHighlightedCellInBottom;
    }
    
   
    
    return direction;
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
