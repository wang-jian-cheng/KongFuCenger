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
    
    unsigned int resendTime;
    //修改密码
    UITextField *txt_oldPwd;
    NSTimer *timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    resendTime = 60;
    timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(function) userInfo:nil repeats:YES];
    [timer setFireDate:[NSDate distantFuture]];
     btn_GetvrifyCode=[[UIButton alloc] init];
    if(_pageMode == MODE_forget){
        _lblTitle.text=@"忘记密码";
    }
    else if (_pageMode == MODE_change)
    {
        _lblTitle.text=@"修改密码";
    }
    else{
        _lblTitle.text=@"注册";
    }
    [self addLeftButton:@"left"];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:) ];
    [self.view addGestureRecognizer:tapGesture];
    mUserDefault = [NSUserDefaults standardUserDefaults];
    self.view.backgroundColor = BACKGROUND_COLOR;
//    [self addLeftButton:@"goback@2x.png"];
    [self loadAllView];
}
#if 1

-(void)function
{
    [btn_GetvrifyCode setTitle:[NSString stringWithFormat:@"(%ds)后重发",resendTime] forState:UIControlStateNormal];
    btn_GetvrifyCode.enabled= NO;
    if(resendTime > 0)
    {
        resendTime --;
    }
    else
    {
        [timer setFireDate:[NSDate distantFuture]];
        [btn_GetvrifyCode setTitle:@"发送验证码" forState:UIControlStateNormal];
        btn_GetvrifyCode.enabled= YES;
    }
}

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
    _tableView.backgroundColor = BACKGROUND_COLOR;
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
////}
-(void)clickLeftButton:(UIButton *)sender
{
    if(self.pageMode == MODE_change)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//设置cell不可点击
    cell.backgroundColor = ItemsBaseColor;
    if (_pageMode == MODE_change) {
        if (indexPath.row == 0) {
            txt_oldPwd=[[UITextField alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH, 30)];
            txt_oldPwd.secureTextEntry = YES;
            txt_oldPwd.placeholder=@"请输入您的原密码";
            txt_oldPwd.textColor = [UIColor whiteColor];
            [txt_oldPwd setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
            [cell addSubview:txt_oldPwd];
        }else if (indexPath.row == 1){
            txt_newPwd=[[UITextField alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH, 30)];
            txt_newPwd.secureTextEntry = YES;
            txt_newPwd.placeholder=@"请输入您的新密码";
            txt_newPwd.textColor = [UIColor whiteColor];
            [txt_newPwd setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
            [cell addSubview:txt_newPwd];
        }else if (indexPath.row == 2){
            txt_againNewPwd=[[UITextField alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH, 30)];
            txt_againNewPwd.secureTextEntry = YES;
            txt_againNewPwd.placeholder=@"请再次输入您的密码";
            txt_againNewPwd.textColor = [UIColor whiteColor];
            [txt_againNewPwd setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
            [cell addSubview:txt_againNewPwd];
        }else if (indexPath.row == 3){
            cell.backgroundColor = BACKGROUND_COLOR;
            UIButton * btn_sure=[[UIButton alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH - 20*2, 44)];
            btn_sure.backgroundColor=YellowBlock;
            [btn_sure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn_sure setTitle:@"确定" forState:UIControlStateNormal];
            [btn_sure addTarget:self action:@selector(ChangePwdFunC:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn_sure];
        }
        if (indexPath.row<2) {
            UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(20,cell.frame.size.height-1 , SCREEN_WIDTH-40, 1)];
            fenge.backgroundColor=BACKGROUND_COLOR;
            [cell addSubview:fenge];
        }
    }else{
        switch (indexPath.row) {
            case 0:
            {
                txt_phoneNum=[[UITextField alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH, 30)];
                txt_phoneNum.keyboardType = UIKeyboardTypeNumberPad;
                txt_phoneNum.placeholder=@"请输入您的手机号";
                txt_phoneNum.textColor = [UIColor whiteColor];
                [txt_phoneNum setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
                [cell addSubview:txt_phoneNum];
                
            }
                break;
            case 1:
            {
                txt_vrifyCode=[[UITextField alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-140, 30)];
                txt_vrifyCode.keyboardType = UIKeyboardTypeNumberPad;
                txt_vrifyCode.placeholder=@"请输入您的验证码";
                txt_vrifyCode.textColor = [UIColor whiteColor];
                [txt_vrifyCode setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
                [cell addSubview:txt_vrifyCode];
                
                btn_GetvrifyCode.frame = CGRectMake(txt_vrifyCode.frame.size.width+txt_vrifyCode.frame.origin.x, 10, 100, 30);
                [btn_GetvrifyCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btn_GetvrifyCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                btn_GetvrifyCode.layer.masksToBounds=YES;
                btn_GetvrifyCode.layer.cornerRadius = 5;
                btn_GetvrifyCode.titleLabel.font = [UIFont systemFontOfSize:14];
                btn_GetvrifyCode.backgroundColor = [UIColor blackColor];
                [btn_GetvrifyCode addTarget:self action:@selector(sendeVerifyCode:) forControlEvents:UIControlEventTouchUpInside];
                btn_GetvrifyCode.titleLabel.textAlignment = NSTextAlignmentCenter;
                [cell addSubview:btn_GetvrifyCode];
            }
                break;
            case 2:
                txt_newPwd=[[UITextField alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH, 30)];
                txt_newPwd.secureTextEntry = YES;
                txt_newPwd.placeholder=@"请输入您的新密码";
                txt_newPwd.textColor = [UIColor whiteColor];
                [txt_newPwd setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
                [cell addSubview:txt_newPwd];
                break;
            case 3:
                txt_againNewPwd=[[UITextField alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH, 30)];
                txt_againNewPwd.secureTextEntry = YES;
                txt_againNewPwd.placeholder=@"请再次输入您的密码";
                txt_againNewPwd.textColor = [UIColor whiteColor];
                [txt_againNewPwd setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
                [cell addSubview:txt_againNewPwd];
                break;
//            case 4:
//            {
//                
//                cell.backgroundColor = BACKGROUND_COLOR;
//                //if(_pageMode == MODE_Reg)
////                if(1)
////                {
//                    UIButton * btn_fuwuxieyi=[[UIButton alloc] initWithFrame:CGRectMake(20, 10, 100, 30)];
//                    [btn_fuwuxieyi setImage:[UIImage imageNamed:@"regster_select_icon@2x.png"] forState:UIControlStateNormal];
//                    [btn_fuwuxieyi setTitle:@"服务协议" forState:UIControlStateNormal];
//                    [btn_fuwuxieyi setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                    
//                    btn_fuwuxieyi.imageView.contentMode = UIViewContentModeScaleAspectFit;
//                    btn_fuwuxieyi.titleLabel.font = [UIFont systemFontOfSize:14];
//                    [cell addSubview:btn_fuwuxieyi];
//                    
//                    UIButton * btn_yinsi=[[UIButton alloc] initWithFrame:CGRectMake(btn_fuwuxieyi.frame.size.width+btn_fuwuxieyi.frame.origin.x+ 20, 10, 100, 30)];
//                    [btn_yinsi setImage:[UIImage imageNamed:@"regster_select_icon@2x.png"] forState:UIControlStateNormal];
//                    [btn_yinsi setTitle:@"隐私政策" forState:UIControlStateNormal];
//                    [btn_yinsi setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                    
//                    
//                    btn_yinsi.imageView.contentMode = UIViewContentModeScaleAspectFit;
//                    btn_yinsi.titleLabel.font = [UIFont systemFontOfSize:14];
//                    [cell addSubview:btn_yinsi];
////                }
//            }
//                break;
            case 4:
            {
                cell.backgroundColor = BACKGROUND_COLOR;
                UIButton * btn_sure=[[UIButton alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH - 20*2, 44)];
                btn_sure.backgroundColor=YellowBlock;
                [btn_sure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btn_sure setTitle:@"确定" forState:UIControlStateNormal];
                if(_pageMode == MODE_Reg)
                {
                    [btn_sure addTarget:self action:@selector(LoginFunC:) forControlEvents:UIControlEventTouchUpInside];
                }else if(_pageMode == MODE_change){
                    [btn_sure addTarget:self action:@selector(ChangePwdFunC:) forControlEvents:UIControlEventTouchUpInside];
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
            fenge.backgroundColor=BACKGROUND_COLOR;
            [cell addSubview:fenge];
        }
    }
    
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_pageMode == MODE_Reg){
        return 6;
    }else if (_pageMode == MODE_change){
        return 4;
    }
    return 5;
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
                 sender.titleLabel.text=@"已发送";
                 resendTime = 60;
                 [timer setFireDate:[NSDate distantPast]];
                 
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
        [SVProgressHUD dismiss];
    }
}


-(void)LoginFunC:(UIButton * )sender
{
    
    NSLog(@"txt_newPwd.text = %@",txt_newPwd.text);
    NSLog(@"txt_againNewPwd.text = %@",txt_againNewPwd.text);
    NSLog(@"txt_newPwd.text.length = %lu",txt_newPwd.text.length);
    NSLog(@"txt_vrifyCode.text.length = %lu",txt_vrifyCode.text.length);
    
    if ([txt_newPwd.text isEqualToString:txt_againNewPwd.text]&&txt_newPwd.text.length>0&&txt_vrifyCode.text.length>0) {
        
        
//    NSLog(@"验证成功");
//    @try {
//        NSInteger ret;
//        DataProvider * dataprovider=[[DataProvider alloc] init];
//        [dataprovider setDelegateObject:self setBackFunctionName:@"RegisteBackCall:"];
//        ret =[dataprovider reg:txt_phoneNum.text andPassWord:txt_newPwd.text];
//        if(ret!=OK)
//        {
//            DLog(@"ret = %ld",ret);
//        }
//    }
//    @catch (NSException *exception) {
//
//    }
//    @finally {
//        
//    }

  
        [SVProgressHUD showWithStatus:@"正在注册..." maskType:SVProgressHUDMaskTypeBlack];
        [SMSSDK commitVerificationCode:txt_vrifyCode.text phoneNumber:txt_phoneNum.text zone:@"86" result:^(NSError *error) {
            
            if (!error) {
                
                NSLog(@"验证成功");
                @try {
                    DataProvider * dataprovider=[[DataProvider alloc] init];
                    [dataprovider setDelegateObject:self setBackFunctionName:@"RegisteBackCall:"];

                    [dataprovider reg:txt_phoneNum.text andPassWord:txt_newPwd.text];
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
    DLog(@"注册返回数据%@",dict);
    if ([dict[@"code"] intValue]==200) {
        
        [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
            
            NSString *lng;
            NSString *lat;
            
            lng = [NSString stringWithFormat:@"%.02f",locationCorrrdinate.longitude];
            lat = [NSString stringWithFormat:@"%.02f",locationCorrrdinate.latitude];
            //[dataprovider GetcityInfoWithlng:[NSString stringWithFormat:@"%f",locationCorrrdinate.longitude] andlat:[NSString stringWithFormat:@"%f",locationCorrrdinate.latitude]];
            
            [[CCLocationManager shareLocation] getCity:^(NSString *addressString) {
                // NSLog(@"City : %@",addressString);
                
                [SVProgressHUD showWithStatus:@"定位中"];
                DataProvider * dataprovider=[[DataProvider alloc] init];
                [dataprovider setDelegateObject:self setBackFunctionName:@"uploadLocationForUserCallBack:"];
                [dataprovider uploadLocationForUser:[NSString stringWithFormat:@"%@",dict[@"data"]]  andLat:lat anLng:lng];
                
            }];
            
        }];
        
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:dict[@"data"] maskType:SVProgressHUDMaskTypeBlack];
        
    }
}
-(void)uploadLocationForUserCallBack:(id)dict
{
    DLog(@"%@",dict);
    [SVProgressHUD dismiss];
    UIAlertView *tipAlert = [[UIAlertView alloc] initWithTitle:@"成功" message:@"注册成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    tipAlert.tag = 101;
    [tipAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 101)
    {
        if(self.pageMode == MODE_change)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
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
                    [dataprovider frogetPassWord:txt_phoneNum.text andPassWord:txt_newPwd.text];
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
    DLog(@"忘记密码返回数据%@",dict);
    if ([dict[@"code"] intValue]==200) {
        
        [SVProgressHUD showSuccessWithStatus:@"修改成功" maskType:SVProgressHUDMaskTypeBlack];
      
        [self dismissViewControllerAnimated:YES completion:^{}];
     
       
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:dict[@"data"] maskType:SVProgressHUDMaskTypeBlack];
        
    }
}

-(void)ChangePwdFunC:(UIButton *)sender{
    if ([txt_newPwd.text isEqualToString:txt_againNewPwd.text]&&txt_oldPwd.text.length>0) {
        DataProvider *dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"ChangePwdCallBack:"];
        [dataProvider ChangePassWord:[mUserDefault valueForKey:@"id"] andoldpwd:txt_oldPwd.text andpassword:txt_newPwd.text];
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请正确填写信息" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)ChangePwdCallBack:(id)dict{
    NSLog(@"%@",dict);
    if ([dict[@"code"] intValue] == 200) {
        [SVProgressHUD showSuccessWithStatus:@"修改密码成功~" maskType:SVProgressHUDMaskTypeBlack];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"修改密码失败~"];
    }
}

#endif
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
