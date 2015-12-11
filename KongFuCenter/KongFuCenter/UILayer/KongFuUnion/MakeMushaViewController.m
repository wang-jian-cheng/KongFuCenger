//
//  MakeMushaViewController.m
//  KongFuCenter
//
//  Created by Rain on 15/12/11.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "MakeMushaViewController.h"
#import "MakeMushaCell.h"

@interface MakeMushaViewController (){
    
    //datatable
    UITableView *mTableView;
    CGFloat mCellHeight;
    
    //控件
    UITextField *searchTxt;
}

@end

@implementation MakeMushaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化参数
    //self.view.backgroundColor = BACKGROUND_COLOR;
    mCellHeight = 70;
    [self setBarTitle:@"江湖故事"];
    [self addLeftButton:@"left"];
    
    //初始化View
    [self initViews];
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

#pragma mark 自定义方法
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
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }else if (section == 1){
        return 2;
    }else{
        return 6;
    }
}

#pragma mark setting for section
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BACKGROUND_COLOR;
    return view;
}

#pragma mark setting for cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        cell.backgroundColor = ItemsBaseColor;
        searchTxt = [[UITextField alloc] initWithFrame:CGRectMake(14, 0, SCREEN_WIDTH - 28, cell.frame.size.height)];
        searchTxt.textColor = [UIColor whiteColor];
        searchTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索战队昵称、所在地区" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.44 green:0.43 blue:0.44 alpha:1]}];
        UIImageView *searchIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 20)];
        searchIv.contentMode = UIViewContentModeScaleAspectFit;
        searchIv.image = [UIImage imageNamed:@"search"];
        searchTxt.leftView = searchIv;
        searchTxt.leftViewMode = UITextFieldViewModeAlways;
        [cell addSubview:searchTxt];
        return cell;
    }else if (indexPath.section == 1){
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        cell.backgroundColor = ItemsBaseColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(indexPath.row == 0){
            UILabel *mLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, 100, cell.frame.size.height)];
            mLabel.font = [UIFont systemFontOfSize:20];
            mLabel.textColor = [UIColor whiteColor];
            mLabel.text = @"条件筛选";
            [cell addSubview:mLabel];
        }else{
            //第一行
            //地区
            UILabel *lbl_address = [[UILabel alloc] initWithFrame:CGRectMake(14, (cell.frame.size.height - 25) / 2, 45,30)];
            lbl_address.textColor = [UIColor whiteColor];
            lbl_address.text = @"地区:";
            [cell addSubview:lbl_address];
            
            //省
            UIButton *btnProvince = [[UIButton alloc] initWithFrame:CGRectMake(lbl_address.frame.origin.x + lbl_address.frame.size.width + 5, (cell.frame.size.height - 25) / 2, 80, 30)];
            btnProvince.backgroundColor = [UIColor colorWithRed:0.24 green:0.24 blue:0.25 alpha:1];
            [btnProvince setTitle:@"山东" forState:UIControlStateNormal];
            [cell addSubview:btnProvince];
            UIImageView *provinceIv = [[UIImageView alloc] initWithFrame:CGRectMake(btnProvince.frame.origin.x + btnProvince.frame.size.width - 11, btnProvince.frame.origin.y + btnProvince.frame.size.height - 11, 10, 10)];
            provinceIv.image = [UIImage imageNamed:@"btnCorner"];
            [cell addSubview:provinceIv];
            //市
            UIButton *btnCity = [[UIButton alloc] initWithFrame:CGRectMake(btnProvince.frame.origin.x + btnProvince.frame.size.width + 5, (cell.frame.size.height - 25) / 2, 80, 30)];
            btnCity.backgroundColor = [UIColor colorWithRed:0.24 green:0.24 blue:0.25 alpha:1];
            [btnCity setTitle:@"临沂" forState:UIControlStateNormal];
            [cell addSubview:btnCity];
            UIImageView *cityIv = [[UIImageView alloc] initWithFrame:CGRectMake(btnCity.frame.origin.x + btnCity.frame.size.width - 11, btnCity.frame.origin.y + btnCity.frame.size.height - 11, 10, 10)];
            cityIv.image = [UIImage imageNamed:@"btnCorner"];
            [cell addSubview:cityIv];
            //县
            UIButton *btnCountry = [[UIButton alloc] initWithFrame:CGRectMake(btnCity.frame.origin.x + btnCity.frame.size.width + 5, (cell.frame.size.height - 25) / 2, 80, 30)];
            btnCountry.backgroundColor = [UIColor colorWithRed:0.24 green:0.24 blue:0.25 alpha:1];
            [btnCountry setTitle:@"兰山区" forState:UIControlStateNormal];
            [cell addSubview:btnCountry];
            UIImageView *countryIv = [[UIImageView alloc] initWithFrame:CGRectMake(btnCountry.frame.origin.x + btnCountry.frame.size.width - 11, btnCountry.frame.origin.y + btnCountry.frame.size.height - 11, 10, 10)];
            countryIv.image = [UIImage imageNamed:@"btnCorner"];
            [cell addSubview:countryIv];
            
            //第二行
            //年龄
            UILabel *age_lbl = [[UILabel alloc] initWithFrame:CGRectMake(14, lbl_address.frame.origin.y + lbl_address.frame.size.height + (cell.frame.size.height - 25) / 2, 45,30)];
            age_lbl.textColor = [UIColor whiteColor];
            age_lbl.text = @"年龄:";
            [cell addSubview:age_lbl];
            UIButton *btnAge = [[UIButton alloc] initWithFrame:CGRectMake(age_lbl.frame.origin.x + age_lbl.frame.size.width + 5, lbl_address.frame.origin.y + lbl_address.frame.size.height + (cell.frame.size.height - 25) / 2, 80, 30)];
            btnAge.backgroundColor = [UIColor colorWithRed:0.24 green:0.24 blue:0.25 alpha:1];;
            [btnAge setTitle:@"18岁" forState:UIControlStateNormal];
            [cell addSubview:btnAge];
            UIImageView *ageIv = [[UIImageView alloc] initWithFrame:CGRectMake(btnAge.frame.origin.x + btnAge.frame.size.width - 11, btnAge.frame.origin.y + btnAge.frame.size.height - 11, 10, 10)];
            ageIv.image = [UIImage imageNamed:@"btnCorner"];
            [cell addSubview:ageIv];
            
            //第三行
            //性别
            UILabel *sex_lbl = [[UILabel alloc] initWithFrame:CGRectMake(14, age_lbl.frame.origin.y + age_lbl.frame.size.height + (cell.frame.size.height - 25) / 2, 45,30)];
            sex_lbl.textColor = [UIColor whiteColor];
            sex_lbl.text = @"年龄:";
            [cell addSubview:sex_lbl];
            UIButton *btnSex = [[UIButton alloc] initWithFrame:CGRectMake(sex_lbl.frame.origin.x + sex_lbl.frame.size.width + 5, age_lbl.frame.origin.y + age_lbl.frame.size.height + (cell.frame.size.height - 25) / 2, 80, 30)];
            btnSex.backgroundColor = [UIColor colorWithRed:0.24 green:0.24 blue:0.25 alpha:1];;
            [btnSex setTitle:@"18岁" forState:UIControlStateNormal];
            [cell addSubview:btnSex];
            UIImageView *sexIv = [[UIImageView alloc] initWithFrame:CGRectMake(btnSex.frame.origin.x + btnSex.frame.size.width - 11, btnSex.frame.origin.y + btnSex.frame.size.height - 11, 10, 10)];
            sexIv.image = [UIImage imageNamed:@"btnCorner"];
            [cell addSubview:sexIv];
        }
         return cell;
    }else{
        NSString *CellIdentifier = @"MakeMushaCellIdentifier";
        MakeMushaCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MakeMushaCell" owner:self options:nil] objectAtIndex:0];
            cell.backgroundColor = ItemsBaseColor;
        }
        cell.mImageView.image = [UIImage imageNamed:@"friend_avatar"];
        cell.mName.text = @"李小龙";
        cell.mLevel.text = @"等级:lv1";
        cell.mConcern.backgroundColor = [UIColor colorWithRed:0.51 green:0.51 blue:0.51 alpha:1];
        [cell.mConcern setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell.mConcern setTitle:@"关注" forState:UIControlStateNormal];
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 45;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            return 40;
        }else{
            return 125;
        }
    }else{
        return mCellHeight;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [mTableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
