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
   
    
    //datas
    NSMutableArray *studyCateArr;
    NSMutableArray *secondCateArr;
    
    
}
@end

#define _CELL @ "acell"
@implementation StudyOnLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self initDatas];
    [self initViews];
    [self addLeftbuttontitle:@"返回"];
    
    // Do any additional setup after loading the view.
}

-(void)initDatas
{
    studyCateArr = [NSMutableArray array];
    [studyCateArr addObjectsFromArray:@[@"正向品格",@"极限武术",@"教练核能",@"运营管理"]];
    
    secondCateArr= [NSMutableArray array];
    [secondCateArr addObjectsFromArray:@[@"野心",@"坚毅",@"激情",@"自制",@"好奇",@"感恩",@"乐观",@"社交",@"其他"]];
}

-(void)initViews
{
    UIView *viewForBtns = [[UIView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, 44)];
    
    for (int i = 0;i< studyCateArr.count; i++) {
        UIButton *cateBtn = [[UIButton alloc] initWithFrame:CGRectMake(0 + i*(SCREEN_WIDTH/studyCateArr.count), 0,(SCREEN_WIDTH/studyCateArr.count) , viewForBtns.frame.size.height)];
        [cateBtn setTitle:studyCateArr[i] forState:UIControlStateNormal];
        cateBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        cateBtn.backgroundColor = ItemsBaseColor;
        [cateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cateBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        cateBtn.tag = i;
        
        [cateBtn addTarget:self action:@selector(cateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [viewForBtns addSubview:cateBtn];
    }
    
    [self.view addSubview:viewForBtns];
    
    
    
    UICollectionViewFlowLayout *layout=[[ UICollectionViewFlowLayout alloc ] init ];
    layout.minimumLineSpacing = 5.0;
    layout.minimumInteritemSpacing = 5.0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;//设置collection
    
    //  layout.itemSize = CGSizeMake(318, 286);
    
    // layout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0);
    
    layout.headerReferenceSize = CGSizeMake(320, 200);
    
    
    
    mainCollectionView = [[UICollectionView alloc]  initWithFrame:CGRectMake(0, 44+Header_Height, SCREEN_WIDTH , SCREEN_HEIGHT-(44+Header_Height)) collectionViewLayout:layout];
    
    [layout setHeaderReferenceSize:CGSizeMake(mainCollectionView.frame.size.width, 0)];//暂不现实时间
    
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
    
}


-(void)cateBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
}


#pragma mark - UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数

-( NSInteger )collectionView:( UICollectionView *)collectionView numberOfItemsInSection:( NSInteger )section
{

    return secondCateArr.count ;
    
}


//定义展示的Section的个数

-( NSInteger )numberOfSectionsInCollectionView:( UICollectionView *)collectionView
{
    return 1 ;
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
    
    UILabel *cateNameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    cateNameLab.text = secondCateArr[indexPath.row];
    cateNameLab.textColor = [UIColor whiteColor];
    cateNameLab.font = [UIFont boldSystemFontOfSize:20];
    cateNameLab.backgroundColor = [UIColor blackColor];
    cateNameLab.textAlignment = NSTextAlignmentCenter;
    cateNameLab.alpha = 0.3;
    [cell addSubview:cateNameLab];
    return cell;
    
    
}


#pragma mark - UICollectionViewDelegate

//UICollectionView被选中时调用的方法

-( void )collectionView:( UICollectionView *)collectionView didSelectItemAtIndexPath:( NSIndexPath *)indexPath
{
    
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
    
   return  CGSizeMake ( (SCREEN_WIDTH - 10)/2 , SCREEN_HEIGHT/4 -10);
}

//定义每个UICollectionView 的边距

-( UIEdgeInsets )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section
{


    return UIEdgeInsetsMake ( 0 , 0 , 0 , 0 );

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
