//
//  RegisterViewController.m
//  HiHome
//
//  Created by 于金祥 on 15/10/19.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "RegisterViewController.h"
#import "SVProgressHUD.h"
@interface RegisterViewController ()

@end

@implementation RegisterViewController
{
    UITextField * txt_phoneNum;
    UITextField * txt_vrifyCode;
    UITextField * txt_newPwd;
    UITextField * txt_againNewPwd;
    NSUserDefaults *mUserDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if(_pageMode == MODE_forget)
//        _lblTitle.text=@"忘记密码";
//    else
//        _lblTitle.text=@"注册";
//
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:) ];
//    [self.view addGestureRecognizer:tapGesture];
//    mUserDefault = [NSUserDefaults standardUserDefaults];
//    [self addLeftButton:@"goback@2x.png"];
//    [self loadAllView];
}
#if 0


-(void)tapViewAction:(id)sender
{
    [self.view endEditing:YES];
}
-(void)setPageMode:(PageMode)pageMode
{
    _pageMode = pageMode;
    
    [_tableView reloadData];
}

-(void)loadAllView
{
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

//-(void)clickRightButton:(UIButton *)sender
//{
//    [txt_phoneNum resignFirstResponder];
//    [txt_vrifyCode resignFirstResponder];
//    [txt_newPwd resignFirstResponder];
//    [txt_againNewPwd resignFirstResponder];
//    
////    [self dismissViewControllerAnimated:YES completion:nil];
//    
//}
-(void)clickLeftButton:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//设置cell不可点击
    switch (indexPath.row) {
        case 0:
        {
            txt_phoneNum=[[UITextField alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-140, 30)];
            txt_phoneNum.keyboardType = UIKeyboardTypeNumberPad;
            txt_phoneNum.placeholder=@"请输入您的手机号";
            [cell addSubview:txt_phoneNum];
            UIButton * btn_GetvrifyCode=[[UIButton alloc] initWithFrame:CGRectMake(txt_phoneNum.frame.size.width+txt_phoneNum.frame.origin.x, 10, 100, 30)];
            [btn_GetvrifyCode setTitleColor:ZY_UIBASECOLOR forState:UIControlStateNormal];
            [btn_GetvrifyCode setTitle:@"获取验证码" forState:UIControlStateNormal];
            btn_GetvrifyCode.layer.masksToBounds=YES;
            [btn_GetvrifyCode addTarget:self action:@selector(sendeVerifyCode:) forControlEvents:UIControlEventTouchUpInside];
            btn_GetvrifyCode.layer.borderWidth=0.4;
            btn_GetvrifyCode.layer.borderColor=[ZY_UIBASECOLOR CGColor];
            [cell addSubview:btn_GetvrifyCode];
        }
            break;
        case 1:
            txt_vrifyCode=[[UITextField alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-40, 30)];
            txt_vrifyCode.keyboardType = UIKeyboardTypeNumberPad;
            txt_vrifyCode.placeholder=@"请输入您的验证码";
            [cell addSubview:txt_vrifyCode];
            break;
        case 2:
            txt_newPwd=[[UITextField alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-40, 30)];
            txt_newPwd.secureTextEntry = YES;
            txt_newPwd.placeholder=@"请输入您的新密码";
            [cell addSubview:txt_newPwd];
            break;
        case 3:
            txt_againNewPwd=[[UITextField alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-40, 30)];
            txt_againNewPwd.secureTextEntry = YES;
            txt_againNewPwd.placeholder=@"请再次输入您的密码";
            [cell addSubview:txt_againNewPwd];
            break;
        case 4:
        {
            if(_pageMode == MODE_Reg)
            {
                UIButton * btn_fuwuxieyi=[[UIButton alloc] initWithFrame:CGRectMake(20, 10, 100, 30)];
                [btn_fuwuxieyi setImage:[UIImage imageNamed:@"regster_select_icon@2x.png"] forState:UIControlStateNormal];
                [btn_fuwuxieyi setTitle:@"服务协议" forState:UIControlStateNormal];
                [btn_fuwuxieyi setTitleColor:ZY_UIBASECOLOR forState:UIControlStateNormal];
                
                btn_fuwuxieyi.imageView.contentMode = UIViewContentModeScaleAspectFit;
                btn_fuwuxieyi.titleLabel.font = [UIFont systemFontOfSize:14];
                [cell addSubview:btn_fuwuxieyi];
                
                UIButton * btn_yinsi=[[UIButton alloc] initWithFrame:CGRectMake(btn_fuwuxieyi.frame.size.width+btn_fuwuxieyi.frame.origin.x+ 20, 10, 100, 30)];
                [btn_yinsi setImage:[UIImage imageNamed:@"regster_select_icon@2x.png"] forState:UIControlStateNormal];
                [btn_yinsi setTitle:@"隐私政策" forState:UIControlStateNormal];
                [btn_yinsi setTitleColor:ZY_UIBASECOLOR forState:UIControlStateNormal];
                
                
                btn_yinsi.imageView.contentMode = UIViewContentModeScaleAspectFit;
                btn_yinsi.titleLabel.font = [UIFont systemFontOfSize:14];
                [cell addSubview:btn_yinsi];
            }
        }
            break;
        case 5:
        {
            UIButton * btn_sure=[[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, 10, 100, 30)];
            btn_sure.backgroundColor=ZY_UIBASECOLOR;
            [btn_sure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn_sure setTitle:@"确定" forState:UIControlStateNormal];
            if(_pageMode == MODE_Reg)
            {
                [btn_sure addTarget:self action:@selector(LoginFunC:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                [btn_sure addTarget:self action:@selector(ForgetFunC:) forControlEvents:UIControlEventTouchUpInside];
            }
            [cell addSubview:btn_sure];
        }
            break;
        default:
            break;
    }
    
    if (indexPath.row<4) {
        UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(20,cell.frame.size.height-1 , SCREEN_WIDTH-40, 1)];
        fenge.backgroundColor=ZY_UIBASECOLOR;
        [cell addSubview:fenge];
    }
    
    
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(void)sendeVerifyCode:(UIButton *)sender
{
    [SVProgressHUD showWithStatus:@"正在发送验证码..." maskType:SVProgressHUDMaskTypeBlack];
    if (txt_phoneNum.text.length==11) {
        
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:txt_phoneNum.text
                                       zone:@"86"
                           customIdentifier:nil
                                     result:^(NSError *error)
         {
             
             if (!error)
             {
                [SVProgressHUD dismiss];
                 sender.enabled=NO;
                 sender.titleLabel.text=@"验证码已发送";
             }
             else
             {
                 [SVProgressHUD dismiss];
                 UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"codesenderrtitle", nil)
                                                                 message:[NSString stringWithFormat:@"错误描述：%@",[error.userInfo objectForKey:@"getVerificationCode"]]
                                                                delegate:self
                                                       cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                                       otherButtonTitles:nil, nil];
                 [alert show];
             }
             
         }];
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请正确填写手机号" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
}


-(void)LoginFunC:(UIButton * )sender
{
    
    NSLog(@"txt_newPwd.text = %@",txt_newPwd.text);
    NSLog(@"txt_againNewPwd.text = %@",txt_againNewPwd.text);
    NSLog(@"txt_newPwd.text.length = %lu",txt_newPwd.text.length);
    NSLog(@"txt_vrifyCode.text.length = %lu",txt_vrifyCode.text.length);
    
    if ([txt_newPwd.text isEqualToString:txt_againNewPwd.text]&&txt_newPwd.text.length>0&&txt_vrifyCode.text.length>0) {
        
  
        [SVProgressHUD showWithStatus:@"正在注册..." maskType:SVProgressHUDMaskTypeBlack];
        [SMSSDK commitVerificationCode:txt_vrifyCode.text phoneNumber:txt_phoneNum.text zone:@"86" result:^(NSError *error) {
            
            if (!error) {
                
                NSLog(@"验证成功");
                @try {
                    DataProvider * dataprovider=[[DataProvider alloc] init];
                    [dataprovider setDelegateObject:self setBackFunctionName:@"RegisteBackCall:"];
                    NSDictionary * prm=[[NSDictionary alloc] initWithObjectsAndKeys:txt_phoneNum.text,@"mob",
                                        txt_newPwd.text,@"pass", nil];
                    [dataprovider RegisterUserInfo:prm];
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
                
            }
            else
            {
                NSLog(@"验证失败");
                [SVProgressHUD dismiss];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                                                message:[NSString stringWithFormat:@"%@",[error.userInfo objectForKey:@"commitVerificationCode"]]
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                                      otherButtonTitles:nil, nil];
                [alert show];
                
            }
        }];
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请正确填写信息" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
}




-(void)RegisteBackCall:(id)dict
{
    [SVProgressHUD dismiss];
    NSLog(@"注册返回数据%@",dict);
    if ([dict[@"code"] intValue]==200) {
        
        [mUserDefault setValue:txt_phoneNum.text forKey:@"RegisterAccount"];
        [mUserDefault setValue:txt_newPwd.text forKey:@"RegisterPwd"];
        
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
        NSArray * itemdict=[[NSArray alloc] initWithArray:dict[@"datas"]];
        [itemdict[0] writeToFile:plistPath atomically:YES];
        
        PersonSecondViewController *mPersonSecondVC = [[PersonSecondViewController alloc] init];
        mPersonSecondVC.navTitle = @"个人资料";
        mPersonSecondVC.mIFlag = @"1";
        mPersonSecondVC.mSex = @"男";
        mPersonSecondVC.mUID = [dict[@"datas"][0] valueForKey:@"id"];
        [self presentViewController:mPersonSecondVC animated:NO completion:nil];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:dict[@"message"] maskType:SVProgressHUDMaskTypeBlack];
        
    }
}



-(void)ForgetFunC:(UIButton * )sender
{
    NSLog(@"txt_newPwd.text = %@",txt_newPwd.text);
    NSLog(@"txt_againNewPwd.text = %@",txt_againNewPwd.text);
    NSLog(@"txt_newPwd.text.length = %lu",txt_newPwd.text.length);
    NSLog(@"txt_vrifyCode.text.length = %lu",txt_vrifyCode.text.length);
    
    if ([txt_newPwd.text isEqualToString:txt_againNewPwd.text]&&txt_newPwd.text.length>0&&txt_vrifyCode.text.length>0) {
        
        
        [SVProgressHUD showWithStatus:@"正在更改..." maskType:SVProgressHUDMaskTypeBlack];
        [SMSSDK commitVerificationCode:txt_vrifyCode.text phoneNumber:txt_phoneNum.text zone:@"86" result:^(NSError *error) {
            
            if (!error) {
                
                NSLog(@"验证成功");
                @try {
                    DataProvider * dataprovider=[[DataProvider alloc] init];
                    [dataprovider setDelegateObject:self setBackFunctionName:@"ForgetCallback:"];
                    NSDictionary * prm=[[NSDictionary alloc] initWithObjectsAndKeys:txt_phoneNum.text,@"mob",
                                        txt_newPwd.text,@"pass", nil];
                    [dataprovider ForgetPassWord:prm];
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
                
            }
            else
            {
                NSLog(@"验证失败");
                [SVProgressHUD dismiss];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                                                message:[NSString stringWithFormat:@"%@",[error.userInfo objectForKey:@"commitVerificationCode"]]
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                                      otherButtonTitles:nil, nil];
                [alert show];
                
            }
        }];
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请正确填写信息" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)ForgetCallback:(id)dict
{
    [SVProgressHUD dismiss];
    NSLog(@"忘记密码返回数据%@",dict);
    if ([dict[@"code"] intValue]==200) {
        //[self dismissViewControllerAnimated:YES completion:nil];
        PersonSecondViewController *userInfoVC = [[PersonSecondViewController alloc] init];
        userInfoVC.mIFlag = @"1";
        
      
        [self dismissViewControllerAnimated:YES completion:^{}];
     
       
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:dict[@"message"] maskType:SVProgressHUDMaskTypeBlack];
        
    }
}



#endif
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
