#import "TrainsPlanDetailViewController.h"

@interface TrainsPlanDetailViewController ()
{
    NSMutableArray *imgPaths;
}
@end
static NSString *kPhotoCellIdentifier = @"kPhotoCellIdentifier";
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
    _mainTableView.tableFooterView = [[UIView alloc] init];
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
    _cellCount = 1;
    _cellTextViewHeight = _cellHeight*4;
    
    _titleField = [[UILabel alloc]init];
    
    _textView = [[UITextView alloc] init];
    //   _textView.text = @"发帖内容";
    picShowView = [[UIView alloc] init];
    
    [self.view addSubview:_mainTableView];
    
}


-(void)viewDidAppear:(BOOL)animated
{
    if(editPlan == YES)
    {
        [self.navigationController popViewControllerAnimated:NO];
    }
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
        
        if(imgPaths == nil)
            imgPaths = [NSMutableArray array];
        else
            [imgPaths removeAllObjects];
        
        for (int i = 0; i< picArr.count; i++) {
            NSString *url = [NSString stringWithFormat:@"%@%@",Kimg_path,picArr[i][@"ImagePath"]];
            
            [imgPaths addObject:url ];
        }
    }
    
    
    
    [_mainTableView reloadData];
}


#pragma mark - click action

-(void)clickRightButton:(UIButton *)sender
{
    editPlan = YES;
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
        newPlanViewCtl.delegate = self;
        [self.navigationController pushViewController:newPlanViewCtl animated:YES];
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}


#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if(picArr.count==0)
    {
        return 1;
    }
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return _cellCount;
}

//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell  *cell = [[UITableViewCell alloc] init];
    cell.backgroundColor = ItemsBaseColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(self.planInfo == nil)
        return cell;
    
    
    
    @try {
    
        cell.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width,  _cellTextViewHeight+2*_cellHeight);
        
        if(indexPath.section == 0)
        {
            switch (indexPath.row) {
                case 0:
                {
                    _titleField.frame = CGRectMake(10, 0, cell.frame.size.width, 30);
                    _titleField.text = self.planInfo[@"Title"];
                    _titleField.backgroundColor  = ItemsBaseColor;
                    _titleField.textAlignment = NSTextAlignmentLeft;
                    _titleField.textColor = [UIColor whiteColor];
                    _titleField.font = [UIFont systemFontOfSize:18];
                    [cell addSubview:_titleField];
                    
                    
                    UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, _titleField.frame.size.height, SCREEN_WIDTH, 30)];
                    timeLab.textColor = Separator_Color;
                    timeLab.font = [UIFont systemFontOfSize:14];
                    timeLab.text = [NSString stringWithFormat:@"%@~%@",
                                    [self.planInfo[@"StartTime"] substringToIndex:10],
                                    [self.planInfo[@"EndTime"] substringToIndex:10]];
                    [cell addSubview:timeLab];
                    
                    _textView.frame = CGRectMake(8, (timeLab.frame.size.height+timeLab.frame.origin.y),
                                                 cell.frame.size.width,_cellTextViewHeight);
                    _textView.backgroundColor  = ItemsBaseColor;
                    _textView.font = [UIFont systemFontOfSize:16];
                    _textView.textAlignment = NSTextAlignmentLeft;
                    _textView.textColor = [UIColor whiteColor];
                    _textView.editable = NO;
                    _textView.text = self.planInfo[@"Content"];
                    //            _textView.delegate = self;
                    //            _textView.returnKeyType = UIReturnKeyDefault;
                    //            _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                    
                    [cell addSubview:_textView];
                }
                    break;

                default:
                    break;
            }
        }
        else if(indexPath.section == 1)
        {
            cell.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, _cellHeight*3);
            if(indexPath.row == 0)
            {
                picShowView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight*3);
//                picShowView.backgroundColor = [UIColor redColor];
                [cell addSubview:picShowView];
                
                
                
                if (!_collectionView) {
                    CGFloat titleH = 30;
                    
                    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
                    layout.minimumLineSpacing = 5.0;
                    layout.minimumInteritemSpacing = 5.0;
                    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
                    layout.sectionInset =  UIEdgeInsetsMake(0,20,0,20);
                    layout.itemSize = CGSizeMake(picShowView.frame.size.height - 20 - titleH, picShowView.frame.size.height - 20 - titleH);
                    //                layout.minimumLineSpacing = 10;//cell 的左右间距
                    
                    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-2*_cellHeight, _cellHeight) collectionViewLayout:layout];
                    _collectionView.backgroundColor = ItemsBaseColor;
                    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kPhotoCellIdentifier];
                    _collectionView.delegate = self;
                    _collectionView.dataSource = self;
                    _collectionView.showsHorizontalScrollIndicator = NO;
                    _collectionView.showsVerticalScrollIndicator = NO;
                    
                    
                    _collectionView.frame = CGRectMake(0, 10+titleH, SCREEN_WIDTH, picShowView.frame.size.height - 20-titleH);
                    
                    [picShowView addSubview:_collectionView];
                    
                    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10,SCREEN_WIDTH , titleH)];
                    titleLab.backgroundColor = ItemsBaseColor;
                    titleLab.textColor = [UIColor whiteColor];
                    titleLab.text = @"  文章图片";
                    [picShowView addSubview:titleLab];
                    
                    
                }
                else
                {
                    [picShowView addSubview:_collectionView];
                }
                
                
            }
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
    if(indexPath.section==0)
    {
        if(picArr.count==0)
        {
            _cellTextViewHeight = 7*_cellHeight;
        }
        
        return _cellTextViewHeight+2*_cellHeight;
    }
    return _cellHeight*3;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return picArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCellIdentifier forIndexPath:indexPath];
    
    
    
    
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
    
    
    //    PictureShowView *picShow = [[PictureShowView alloc] initWithUrl:url andHolderImg:[UIImage imageNamed:@"me"]];
    //    picShow.mydelegate = self;
    //    [picShow show];
    
    PictureShowView *picShow  = [[PictureShowView alloc] initWithTitle:@"" andImgUrls:imgPaths andShowIndex:sender.tag andHolderImg:[UIImage imageNamed:@"me"]];
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
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(40, 40);
//}

-( UIEdgeInsets )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section
{
    return UIEdgeInsetsMake(0, 10, 0, 0);
    
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

