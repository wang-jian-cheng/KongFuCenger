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
    [self addRightbuttontitle:@"编辑"];
    
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


-(void)setPlanInfo:(NSDictionary *)planInfo
{
    _planInfo = planInfo;
    if(_planInfo != nil)
    {
        if(picArr == nil)
            picArr = [NSMutableArray array];
        else
            [picArr removeAllObjects];
        [picArr addObjectsFromArray:_planInfo[@"ImageList"]];
    }
    [_mainTableView reloadData];
}


#pragma mark - click action

-(void)clickRightButton:(UIButton *)sender
{
    NewPlanViewController *newPlanViewCtl = [[NewPlanViewController alloc] init];
    newPlanViewCtl.navtitle = @"编辑计划";
    @try {
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
        [tempDict setObject:self.planInfo[@"Title"] forKey:@"planTitle"];
        [tempDict setObject:self.planInfo[@"Content"] forKey:@"planContent"];
        [tempDict setObject:self.planInfo[@"Id"] forKey:@"planId"];
        [tempDict setObject:self.planInfo[@"ImageList"] forKey:@"planImgList"];
        
        
        if([self.navtitle isEqualToString:@"周计划"])
        {
            [tempDict setObject:[NSString stringWithFormat:@"%d",WeekPlan] forKey:@"planCateId"];
        }
        else if([self.navtitle isEqualToString:@"月计划"])
        {
            [tempDict setObject:[NSString stringWithFormat:@"%d",MonthPlan] forKey:@"planCateId"];
        }
        else if([self.navtitle isEqualToString:@"季计划"])
        {
            [tempDict setObject:[NSString stringWithFormat:@"%d",SeasonPlan] forKey:@"planCateId"];
        }
        else if([self.navtitle isEqualToString:@"年计划"])
        {
            [tempDict setObject:[NSString stringWithFormat:@"%d",YearPlan] forKey:@"planCateId"];
        }

        newPlanViewCtl.DefaultDict = tempDict;
        [self.navigationController pushViewController:newPlanViewCtl animated:YES];

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
  
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return _cellCount;
}

//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell  *cell = [[UITableViewCell alloc] init];
    cell.backgroundColor = BACKGROUND_COLOR;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(self.planInfo == nil)
        return cell;
    
    @try {
        if(indexPath.row == 2)
        {
            cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, _cellTextViewHeight);
        }
        else
        {
            cell.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, _cellHeight);
        }
        
        switch (indexPath.row) {
            case 0:
            {
                _titleField.frame = CGRectMake(10, 0, cell.frame.size.width, _cellHeight);
                _titleField.text = self.planInfo[@"Title"];
                _titleField.backgroundColor  = BACKGROUND_COLOR;
                _titleField.enabled = NO;
                _titleField.textAlignment = NSTextAlignmentCenter;
                _titleField.textColor = [UIColor whiteColor];
                _titleField.font = [UIFont boldSystemFontOfSize:18];
                [cell addSubview:_titleField];
                
            }
                break;
            case  1:
            {
                UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, _cellHeight)];
                timeLab.textColor = [UIColor whiteColor];
                timeLab.font = [UIFont systemFontOfSize:14];
                timeLab.text = [NSString stringWithFormat:@"%@~%@",
                                [self.planInfo[@"StartTime"] substringToIndex:10],
                                [self.planInfo[@"EndTime"] substringToIndex:10]];
                [cell addSubview:timeLab];
            }
            case 2:
            {
                _textView.frame = CGRectMake(10, 0, cell.frame.size.width,_cellTextViewHeight);
                _textView.backgroundColor  = BACKGROUND_COLOR;
                _textView.font = [UIFont systemFontOfSize:15];
                _textView.editable = NO;
                _textView.text = self.planInfo[@"Content"];
                //            _textView.delegate = self;
                //            _textView.returnKeyType = UIReturnKeyDefault;
                //            _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                
                [cell addSubview:_textView];
            }
                break;
            case 3:
            {
                
                UIScrollView *imgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight)];
                [cell addSubview:imgScrollView];
                
                CGFloat BtnWidth = _cellHeight - 10;
                int i;
                for ( i = 0; i < picArr.count; i++) {
                    UIButton *imgBtn = [[UIButton alloc] initWithFrame:CGRectMake(10+i*(BtnWidth+10), 5, BtnWidth, BtnWidth)];
                    imgBtn.tag = i;
                    [imgBtn addTarget:self action:@selector(imgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [imgScrollView addSubview:imgBtn];
                    
                    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgBtn.frame.size.width, imgBtn.frame.size.height)];
                    NSString * url=[NSString stringWithFormat:@"%@%@",Kimg_path,picArr[i][@"ImagePath"]];
                    [imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"me"]];
                    
                    [imgBtn addSubview:imgView];
                }
                
                imgScrollView.contentSize = CGSizeMake(i*(BtnWidth+10)+20,_cellHeight );
                [cell addSubview:imgScrollView];
                
//                UIButton *picBtns = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.height, cell.frame.size.height)];
//                [picBtns setImage:[UIImage imageNamed:@"picture"] forState:UIControlStateNormal];
//                //          [picBtns addTarget:self action:@selector(composePicAdd) forControlEvents:UIControlEventTouchUpInside];
//                
//                UIButton *photoBtns = [[UIButton alloc] initWithFrame:CGRectMake(cell.frame.size.height, 0, cell.frame.size.height, cell.frame.size.height)];
//                [photoBtns setImage:[UIImage imageNamed:@"photo"] forState:UIControlStateNormal];
//                //          [photoBtns addTarget:self action:@selector(editPortrait) forControlEvents:UIControlEventTouchUpInside];
//                
//                [cell addSubview:picBtns];
//                [cell addSubview:photoBtns];
                
                
//                if (!_collectionView) {
//                    
//                    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//                    layout.minimumLineSpacing = 5.0;
//                    layout.minimumInteritemSpacing = 5.0;
//                    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//                    
//                    
//                    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-2*_cellHeight, _cellHeight) collectionViewLayout:layout];
//                    _collectionView.backgroundColor = [UIColor clearColor];
//                    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:_CELL];
//                    _collectionView.delegate = self;
//                    _collectionView.dataSource = self;
//                    _collectionView.showsHorizontalScrollIndicator = NO;
//                    _collectionView.showsVerticalScrollIndicator = NO;
//                    
//                    
//                    _collectionView.frame = CGRectMake(picBtns.frame.size.width+photoBtns.frame.origin.x+5, 0, SCREEN_WIDTH-(2*cell.frame.size.height), cell.frame.size.height);
//                    
//                    [cell addSubview:_collectionView];
//                    
//                    
//                    
//                }
//                else
//                {
//                    [cell addSubview:_collectionView];
//                }
//
            }
                break;
            default:
                break;
        }

    }
    @catch (NSException *exception) {
    }
    @finally {
        if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
        {
            [cell setSeparatorInset:UIEdgeInsetsZero];
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        return cell;

    }
    
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
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:imgBtn.frame];
    NSString * url=[NSString stringWithFormat:@"%@%@",Kimg_path,picArr[indexPath.row][@"ImagePath"]];
    [imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"me"]];
    
    [imgBtn addSubview:imgView];
    // imgBtn.backgroundColor = [UIColor redColor];
    [cell bringSubviewToFront:imgBtn];
    [cell addSubview:imgBtn];
    
    return cell;
    
}

-(void)imgBtnClick:(UIButton *)sender
{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",Kimg_path,picArr[sender.tag][@"ImagePath"]];
    PictureShowView *picShow = [[PictureShowView alloc] initWithUrl:url andHolderImg:[UIImage imageNamed:@"me"]];
    picShow.mydelegate = self;
    [picShow show];
}

#pragma mark - pick show delegate

-(void)longPressCallBack
{
 //   NSLog(@"long press delegate");
    
    
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"删除",/* @"保存到本地",*/ nil];
    [choiceSheet showInView:self.view];
}


#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"删除" message:@"是否删除图片？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alertView show];
    }
}
#pragma mark - alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        NSLog(@"删除图片");
    }

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
