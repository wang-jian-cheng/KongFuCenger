//
//  MushaMatchOngoingViewController.m
//  KongFuCenter
//
//  Created by 王建成 on 15/12/12.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "MushaMatchOngoingViewController.h"
#import "MushaMatchDetailGoingViewController.h"
#define _CELL @ "acell"

@interface MushaMatchOngoingViewController ()
{
    NSArray *cateArr;
    NSMutableArray *btnArr;
    //For views
    NSInteger _cellCollectionCount;
    UICollectionView *mainCollectionView;
    UITextField *searchTxt;
    
}
@end

@implementation MushaMatchOngoingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"left"];
    self.view.backgroundColor = BACKGROUND_COLOR;
    if (_mushaMatchOngoingMode == Mode_MushaOnGoing || _mushaMatchOngoingMode == Mode_TeamOnGoing) {
        [self addRightbuttontitle:@"赛事介绍"];
    }
    [self initViews];
    // Do any additional setup after loading the view.
}


-(void)initViews
{
//    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, Header_Height + 10, SCREEN_WIDTH, 60)];
//    backView.backgroundColor = ItemsBaseColor;
//    [self.view addSubview:backView];
//    
//    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, Header_Height + 10, SCREEN_WIDTH
//                                                               , 60)];
//    _searchBar.delegate = self;
//    _searchBar.placeholder = @"参赛者编号";
//    _searchBar.backgroundColor = ItemsBaseColor;
    
    
    searchTxt = [[UITextField alloc] initWithFrame:CGRectMake(0, Header_Height + 5, SCREEN_WIDTH, 45)];
    searchTxt.backgroundColor = ItemsBaseColor;
    searchTxt.returnKeyType = UIReturnKeySearch;
    searchTxt.delegate = self;
    searchTxt.textColor = [UIColor whiteColor];
    searchTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"参赛者编号" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.44 green:0.43 blue:0.44 alpha:1]}];
    UIImageView *searchIv = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 35, 20)];
    searchIv.contentMode = UIViewContentModeScaleAspectFit;
    searchIv.image = [UIImage imageNamed:@"search"];
    searchTxt.leftView = searchIv;
    searchTxt.leftViewMode = UITextFieldViewModeAlways;
    
    [self.view addSubview:searchTxt];
    
    _cellCollectionCount = 6;
    [self initCollectionView];
}

-(void)clickRightButton:(UIButton *)sender{
    if (_mushaMatchOngoingMode == Mode_MushaOnGoing) {
        MushaMatchDetailGoingViewController *mushaMatchDetailGoingVC = [[MushaMatchDetailGoingViewController alloc] init];
        [mushaMatchDetailGoingVC setMushaMatchDetailGoingMode:Mode_MushaGoing];
        mushaMatchDetailGoingVC.navtitle = @"武者大赛介绍";
        mushaMatchDetailGoingVC.matchId = _matchId;
        [self.navigationController pushViewController:mushaMatchDetailGoingVC animated:YES];
    }else if (_mushaMatchOngoingMode == Mode_TeamOnGoing){
        MushaMatchDetailGoingViewController *mushaMatchDetailGoingVC = [[MushaMatchDetailGoingViewController alloc] init];
        [mushaMatchDetailGoingVC setMushaMatchDetailGoingMode:Mode_TeamGoing];
        mushaMatchDetailGoingVC.navtitle = @"战队大赛介绍";
        mushaMatchDetailGoingVC.matchId = _matchId;
        [self.navigationController pushViewController:mushaMatchDetailGoingVC animated:YES];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [searchTxt resignFirstResponder];
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
    
    
    
    mainCollectionView = [[UICollectionView alloc]  initWithFrame:CGRectMake(0, Header_Height + 5 +45+10, SCREEN_WIDTH , SCREEN_HEIGHT-( Header_Height + 5 +45+10)) collectionViewLayout:layout];
    
    [layout setHeaderReferenceSize:CGSizeMake(mainCollectionView.frame.size.width, 0)];//暂不现实时间
    
    [mainCollectionView registerClass :[ UICollectionViewCell class ] forCellWithReuseIdentifier : _CELL ];
    
    mainCollectionView.delegate= self;
    mainCollectionView.dataSource =self;
    mainCollectionView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*2);
    mainCollectionView.showsHorizontalScrollIndicator = YES;
    mainCollectionView.showsVerticalScrollIndicator = NO;
    mainCollectionView.backgroundColor = BACKGROUND_COLOR;
    
    [self.view addSubview:mainCollectionView];
}

#pragma mark - UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数

-( NSInteger )collectionView:( UICollectionView *)collectionView numberOfItemsInSection:( NSInteger )section
{
    return _cellCollectionCount;
    
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
    cell.backgroundColor = ItemsBaseColor;
    
    if(cell != nil)
    {
        for (int i =0 ; i<cell.subviews.count; i++) {
            [ [cell.subviews objectAtIndex:i] removeFromSuperview];//清空一下原来cell上面的view'防止cell的重用影响到后面section的显示
        }
        
    }
    
    UIImageView *baseImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, (cell.frame.size.height/3*2))];
    baseImg.image = [UIImage imageNamed:@"temp2"];
    [cell addSubview:baseImg];
    
    UILabel *timeLabInImg = [[UILabel alloc] initWithFrame:CGRectMake((baseImg.frame.size.width - 10 -40), (baseImg.frame.size.height - 40), 40, 25)];
    timeLabInImg.text = @"5:00";
    timeLabInImg.textColor = [UIColor whiteColor];
    timeLabInImg.textAlignment = NSTextAlignmentCenter;
    timeLabInImg.backgroundColor = BACKGROUND_COLOR;
    timeLabInImg.alpha = 0.8;
    timeLabInImg.font = [UIFont boldSystemFontOfSize:14];
    timeLabInImg.layer.cornerRadius = 5;
    timeLabInImg.layer.masksToBounds = YES;
    [baseImg addSubview:timeLabInImg];
    
    UILabel *idLab = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, 40, 25)];
    idLab.backgroundColor = YellowBlock;
    idLab.textColor = [UIColor whiteColor];
    idLab.text = [NSString stringWithFormat:@"%03ld",(long)indexPath.row];
    idLab.textAlignment = NSTextAlignmentCenter;
    idLab.font = [UIFont systemFontOfSize:14];
    [baseImg addSubview:idLab];
    
    UserHeadView *headView = [[UserHeadView alloc]  initWithFrame:CGRectMake(10, baseImg.frame.size.height + 5, (cell.frame.size.height/3 -5*2), (cell.frame.size.height/3 -5*2)) andImgName:@"me" andNav:self.navigationController];
    [headView makeSelfRound];
    
    [cell addSubview:headView];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake((headView.frame.size.width+headView.frame.origin.x+10),
                                                                headView.frame.origin.y,
                                                                (cell.frame.size.width -(headView.frame.size.width+headView.frame.origin.x+10)),
                                                                 (headView.frame.size.height/2))];
    nameLab.text = @"成龙徒弟";
    nameLab.textColor = [UIColor whiteColor];
    nameLab.font = [UIFont systemFontOfSize:14];
    
    [cell addSubview:nameLab];
    
    UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake((headView.frame.size.width+headView.frame.origin.x+10),
                                                                 (nameLab.frame.size.height+nameLab.frame.origin.y),
                                                                 (cell.frame.size.width -(headView.frame.size.width+headView.frame.origin.x+10)),
                                                                 (headView.frame.size.height/2))];
    numLab.text = @"得票数：1000";
    numLab.textColor = [UIColor whiteColor];
    numLab.font = [UIFont systemFontOfSize:14];
    
    [cell addSubview:numLab];
    
    return cell;
    
    
}



#pragma mark - UICollectionViewDelegate

//UICollectionView被选中时调用的方法

-( void )collectionView:( UICollectionView *)collectionView didSelectItemAtIndexPath:( NSIndexPath *)indexPath
{
    VideoDetailForMatchViewController *videoViewCtl = [[VideoDetailForMatchViewController alloc] init];
    videoViewCtl.navtitle = @"大赛个人详情";
    [self.navigationController pushViewController:videoViewCtl animated:YES];
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

#pragma mark UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    //[self TeamTopRefresh];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [searchTxt resignFirstResponder];
    return YES;
}

@end
