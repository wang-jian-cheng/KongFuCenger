//
//  TrainsPlanDetailViewController.m
//  KongFuCenter
//
//  Created by Wangjc on 15/12/24.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "TrainsPlanDetailViewController.h"

@interface TrainsPlanDetailViewController ()

@end

@implementation TrainsPlanDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"left"];
    _cellHeight = self.view.frame.size.height/12;
    picArr = [NSMutableArray array];
    [self addRightbuttontitle:@"确定"];
    
    [self initViews];
    
    // Do any additional setup after loading the view.
}
-(void) initViews
{
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, self.view.frame.size.width,self.view.frame.size.height - Header_Height )];
    _mainTableView.backgroundColor =BACKGROUND_COLOR;
    [_mainTableView setDelegate:self];
    [_mainTableView setDataSource:self];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//UITableViewCellSeparatorStyleSingleLine;
    _mainTableView.separatorInset = UIEdgeInsetsZero;
    //  _mainTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _mainTableView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height);
    
    _mainTableView.separatorColor =  Separator_Color;
    //_mainTableView.separatorEffect = ;
    
    
    //设置cell分割线从最左边开始
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
    {
        if ([_mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_mainTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        
        if ([_mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_mainTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
    _cellCount = 4;
    _cellTextViewHeight = SCREEN_HEIGHT - 3*_cellHeight - 64;
    
    _titleField = [[UITextField alloc]init];
    
    _textView = [[UITextView alloc] init];
    //   _textView.text = @"发帖内容";
    
    [self.view addSubview:_mainTableView];
    
}



#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return _cellCount;
}

//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell  *cell = [[UITableViewCell alloc] init];
    if(indexPath.row == 2)
    {
        cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, _cellTextViewHeight);
    }
    else
    {
        cell.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, _cellHeight);
    }
    cell.backgroundColor = BACKGROUND_COLOR;
    
    switch (indexPath.row) {
        case 0:
        {
            _titleField.frame = CGRectMake(10, 0, cell.frame.size.width, _cellHeight);
            _titleField.placeholder = @"标题";
            _titleField.backgroundColor  = BACKGROUND_COLOR;
            [cell addSubview:_titleField];
            
        }
            break;
        case  1:
        {
//            cell.textLabel.text = @"发帖内容";
//            
//            tipbtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150 ), 0, 150, _cellHeight)];
//            tipbtn.backgroundColor = BACKGROUND_COLOR;
//            [tipbtn addTarget:self action:@selector(pushViewAction:) forControlEvents:UIControlEventTouchUpInside];
//            
//            UIImageView *rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right"]];
//            rightView.frame = CGRectMake((tipbtn.frame.size.width - 20 -20), 0, 15, 15);
//            rightView.center = CGPointMake((tipbtn.frame.size.width - 15 -10), _cellHeight/2);
//            rightView.contentMode = UIViewContentModeScaleAspectFit;
//            [tipbtn addSubview:rightView];
//            
//            [cell addSubview:tipbtn];
        }
        case 2:
        {
            _textView.frame = CGRectMake(10, 0, cell.frame.size.width,_cellTextViewHeight);
            _textView.backgroundColor  = BACKGROUND_COLOR;
            _textView.font = [UIFont systemFontOfSize:15];
//            _textView.delegate = self;
            //            _textView.returnKeyType = UIReturnKeyDefault;
            //            _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            
            [cell addSubview:_textView];
        }
            break;
        case 3:
        {
            
            
            UIButton *picBtns = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.height, cell.frame.size.height)];
            [picBtns setImage:[UIImage imageNamed:@"picture"] forState:UIControlStateNormal];
  //          [picBtns addTarget:self action:@selector(composePicAdd) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *photoBtns = [[UIButton alloc] initWithFrame:CGRectMake(cell.frame.size.height, 0, cell.frame.size.height, cell.frame.size.height)];
            [photoBtns setImage:[UIImage imageNamed:@"photo"] forState:UIControlStateNormal];
  //          [photoBtns addTarget:self action:@selector(editPortrait) forControlEvents:UIControlEventTouchUpInside];
            
            [cell addSubview:picBtns];
            [cell addSubview:photoBtns];
            
            
            if (!_collectionView) {
                
                UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
                layout.minimumLineSpacing = 5.0;
                layout.minimumInteritemSpacing = 5.0;
                layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
                
                
                _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-2*_cellHeight, _cellHeight) collectionViewLayout:layout];
                _collectionView.backgroundColor = [UIColor clearColor];
                [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:_CELL];
                _collectionView.delegate = self;
                _collectionView.dataSource = self;
                _collectionView.showsHorizontalScrollIndicator = NO;
                _collectionView.showsVerticalScrollIndicator = NO;
                
                
                _collectionView.frame = CGRectMake(picBtns.frame.size.width+photoBtns.frame.origin.x+5, 0, SCREEN_WIDTH-(2*cell.frame.size.height), cell.frame.size.height);
                
                [cell addSubview:_collectionView];
                
                
                
            }
            else
            {
                [cell addSubview:_collectionView];
            }
            
        }
            break;
        default:
            break;
    }
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    return cell;
    
}



//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //   NSLog(@"%f-%f",SCREEN_HEIGHT,self.view.frame.size.height);
    if(indexPath.row==2)
        return _cellTextViewHeight;
    return _cellHeight;
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return picArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:_CELL forIndexPath:indexPath];
    
    
    UIButton *imgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,  cell.frame.size.width,  cell.frame.size.height)];
    [imgBtn addTarget:self action:@selector(imgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    imgBtn.tag = indexPath.row;
    // imgBtn.backgroundColor = [UIColor redColor];
    [cell bringSubviewToFront:imgBtn];
    [cell addSubview:imgBtn];
    
    return cell;
    
}

-(void)imgBtnClick:(UIButton *)sender
{
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(40, 40);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)[indexPath row]);
    
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
