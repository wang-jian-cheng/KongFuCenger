//
//  DataProvider.m
//  BuerShopping
//
//  Created by 于金祥 on 15/5/30.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "DataProvider.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFURLRequestSerialization.h"
#import "SVProgressHUD.h"
#import "SBXMLParser.h"
//#import "HttpRequest.h"

#define Url @"http://192.168.1.136:8033/"
//#define Url @"http://115.28.67.86:8033/"
//#define Url @"http://hihome.zhongyangjituan.com/

@implementation DataProvider





#pragma mark - 登陆注册用户信息部分

-(NSInteger)login:(NSString*)account andPassWord:(NSString *)password
{
    if(account != nil &&password !=nil )
    {
        
        NSString * url=[NSString stringWithFormat:@"%@LoginAndRegister.asmx/Login",Url];
        NSDictionary * prm=@{@"username":account,@"password":password};
         DLog(@"prm = %@",prm);
        [self PostRequest:url andpram:prm];
        
        return OK;
    }
    else
    {
        DLog(@"Err:%d",Param_err);
        return Param_err;
    }
}


-(NSInteger)reg:(NSString*)account andPassWord:(NSString *)password
{
    if(account != nil &&password !=nil )
    {
        
        //NSString * url=[NSString stringWithFormat:@"%@api.php?c=user&a=reg",Url];
        NSString * url=[NSString stringWithFormat:@"%@LoginAndRegister.asmx/Register",Url];
   //     NSDictionary * prm=@{@"mob":phone,@"pass":password};
         NSDictionary * prm=@{@"phone":account,@"password":password};
        DLog(@"prm = %@",prm);
        [self PostRequest:url andpram:prm];
        
        return OK;
    }
    else
    {
        DLog(@"Err:%d",Param_err);
        
        return Param_err;
    }
}


-(NSInteger)regAndLogin:(NSString*)account andPassWord:(NSString *)password
{
    if(account != nil &&password !=nil )
    {
        
        NSString * url=[NSString stringWithFormat:@"%@LoginAndRegister.asmx/RegisterAndLogin",Url];
        NSDictionary * prm=@{@"phone":account,@"password":password};
        DLog(@"prm = %@",prm);
        [self PostRequest:url andpram:prm];
        
        return OK;
    }
    else
    {
        DLog(@"Err:%d",Param_err);
        return Param_err;
    }
}

-(NSInteger)getUserInfo:(NSString *)userId
{
    
    if(userId != nil)
    {
        
        NSString * url=[NSString stringWithFormat:@"%@LoginAndRegister.asmx/UpdateUser",Url];
        NSDictionary * prm=@{@"userid":userId};
        DLog(@"prm = %@",prm);
        [self PostRequest:url andpram:prm];
        
        return OK;
    }
    else
    {
        DLog(@"Err:%d",Param_err);
        return Param_err;
    }
}



//int userid 用户ID
//string nicname 昵称
//int sexuality 性别 0：未知 1：男 2：女
//int height 身高 单位/CM
//double weight 体重 单位/KG
//int homeAreaId 地址
//int experience 习武经历 单位/年


-(NSInteger)setUserInfo:(NSString *)userId andNickName:(NSString *)nicname andSex:(NSString *)sexuality andHeight:(NSString *)height andWeight:(NSString *)weight andAddr:(NSString *)homeAreaId andExpe:(NSString *)experience
{
   
    
    if(userId != nil&&nicname != nil&&sexuality != nil&&height != nil&&weight != nil&&homeAreaId != nil&&experience != nil)
    {
        
        NSString * url=[NSString stringWithFormat:@"%@LoginAndRegister.asmx/ChangeInfor",Url];
        NSDictionary * prm=@{@"userid":userId,
                             @"nicname":nicname,
                             @"sexuality":sexuality,
                             @"height":height,
                             @"weight":weight,
                             @"homeAreaId":homeAreaId,
                             @"experience":experience};
        DLog(@"prm = %@",prm);
        [self PostRequest:url andpram:prm];
        
        return OK;
    }
    else
    {
        DLog(@"Err:%d",Param_err);
        return Param_err;
    }
}


#pragma mark - 放飞梦想

-(NSInteger)getMyDream:(NSString *)userid
{
    if(userid != nil)
    {
        
        NSString * url=[NSString stringWithFormat:@"%@Hewuzhe.asmx/SelectMyDream",Url];
        NSDictionary * prm=@{@"userid":userid};
        DLog(@"prm = %@",prm);
        [self PostRequest:url andpram:prm];
        
        return OK;
    }
    else
    {
        DLog(@"Err:%d",Param_err);
        return Param_err;
    }
}

-(NSInteger)setMyDream:(NSString *)userid andMyDream:(NSString *)mydream andHow:(NSString *)realizedream
{
    if(userid != nil && mydream!=nil && realizedream != nil)
    {
        
        NSString * url=[NSString stringWithFormat:@"%@Hewuzhe.asmx/SaveMyDream",Url];
        NSDictionary * prm=@{@"userid":userid,
                             @"mydream":mydream,
                             @"realizedream":realizedream};
        DLog(@"prm = %@",prm);
        [self PostRequest:url andpram:prm];
        
        return OK;
    }
    else
    {
        DLog(@"Err:%d",Param_err);
        return Param_err;
    }
}





#pragma mark - 在线学习

-(NSInteger)getStudyOnlineMainCategory
{
 
    NSString * url=[NSString stringWithFormat:@"%@Hewuzhe.asmx/GetBigCateForOnlineStudy",Url];

    [self PostRequest:url andpram:nil];
        
    return OK;
  
}

-(NSInteger)getStudyOnlineSecundCategory:(NSString *)categoryid
{
    if(categoryid != nil)
    {
        
        NSString * url=[NSString stringWithFormat:@"%@Hewuzhe.asmx/GetSmallCateForOnlineStudy",Url];
        NSDictionary * prm=@{@"categoryid":categoryid};
        DLog(@"prm = %@",prm);
        [self PostRequest:url andpram:prm];
        
        return OK;
    }
    else
    {
        DLog(@"Err:%d",Param_err);
        return Param_err;
    }
}

-(NSInteger)getStudyOnlineVideoList:(NSString *)categoryid
{
    if(categoryid != nil)
    {
        
        NSString * url=[NSString stringWithFormat:@"%@Hewuzhe.asmx/GetOnlineStudyList",Url];
        NSDictionary * prm=@{@"categoryid":categoryid};
        DLog(@"prm = %@",prm);
        [self PostRequest:url andpram:prm];
        
        return OK;
    }
    else
    {
        DLog(@"Err:%d",Param_err);
        return Param_err;
    }
}
#pragma mark - 核联盟

-(void)getFriendForKeyValue:(NSString *)uid{
    if (uid) {
        NSString * url=[NSString stringWithFormat:@"%@Helianmeng.asmx/GetFriendForKeyValue",Url];
        NSDictionary * prm=@{@"userid":uid};
        [self PostRequest:url andpram:prm];

    }
}

-(void)SelectTeam:(NSString *)teamId{
    if (teamId) {
        NSString * url=[NSString stringWithFormat:@"%@Helianmeng.asmx/SelectTeam",Url];
        NSDictionary * prm=@{@"teamid":teamId};
        [self PostRequest:url andpram:prm];
    }
}

#pragma mark 赋值回调
- (void)setDelegateObject:(id)cbobject setBackFunctionName:(NSString *)selectorName
{
    CallBackObject = cbobject;
    callBackFunctionName = selectorName;
}



-(void)PostRequest:(NSString *)url andpram:(NSDictionary *)pram
{
    AFHTTPRequestOperationManager * manage=[[AFHTTPRequestOperationManager alloc] init];
    manage.responseSerializer=[AFHTTPResponseSerializer serializer];
    manage.requestSerializer=[AFHTTPRequestSerializer serializer];
    manage.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/plain"];//可接收到的数据类型
    manage.requestSerializer.timeoutInterval=10;//设置请求时限
    NSDictionary * prm =[[NSDictionary alloc] init];
    if (pram!=nil) {
        prm=pram;
    }
    [manage POST:url parameters:prm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSDictionary * dict =responseObject;
        NSString *str=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
//        /*解析xml字符串开始*/
//        SBXMLParser * parser = [[SBXMLParser alloc] init];
//        XMLElement * root = [parser parserXML:[str dataUsingEncoding:NSASCIIStringEncoding]];
//        NSLog(@"解析后：root=%@",root.text);
//        /*解析xml字符串结束*/
        
        NSData * data =[str dataUsingEncoding:NSUTF8StringEncoding];
        id dict =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        SEL func_selector = NSSelectorFromString(callBackFunctionName);
        if ([CallBackObject respondsToSelector:func_selector]) {
            NSLog(@"回调成功...");
            [CallBackObject performSelector:func_selector withObject:dict];
        }else{
            NSLog(@"回调失败...");
            [SVProgressHUD dismiss];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:@"请检查网络或防火墙" maskType:SVProgressHUDMaskTypeBlack];
    }];
}




-(void)GetRequest:(NSString *)url andpram:(NSDictionary *)pram
{
    AFHTTPRequestOperationManager * manage=[[AFHTTPRequestOperationManager alloc] init];
    manage.responseSerializer=[AFHTTPResponseSerializer serializer];
    manage.requestSerializer=[AFHTTPRequestSerializer serializer];
    manage.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/xml"];//可接收到的数据类型
    manage.requestSerializer.timeoutInterval=10;//设置请求时限
    NSDictionary * prm =[[NSDictionary alloc] init];
    if (pram!=nil) {
        prm=pram;
    }
    [manage GET:url parameters:prm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        /*解析xml字符串开始*/
        SBXMLParser * parser = [[SBXMLParser alloc] init];
        XMLElement * root = [parser parserXML:[str dataUsingEncoding:NSASCIIStringEncoding]];
        NSLog(@"解析后：root=%@",root.text);
        /*解析xml字符串结束*/
        
        NSData * data =[root.text dataUsingEncoding:NSUTF8StringEncoding];
        
        
        id dict =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        SEL func_selector = NSSelectorFromString(callBackFunctionName);
        if ([CallBackObject respondsToSelector:func_selector]) {
            NSLog(@"回调成功...");
            [CallBackObject performSelector:func_selector withObject:dict];
        }else{
            NSLog(@"回调失败...");
            [SVProgressHUD dismiss];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:@"请检查网络或防火墙" maskType:SVProgressHUDMaskTypeBlack];
    }];
}

- (void)uploadImageWithImage:(NSString *)imagePath andurl:(NSString *)url andprm:(NSDictionary *)prm
{
    NSData *data=[NSData dataWithContentsOfFile:imagePath];
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:prm constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"imgsrc" fileName:@"avatar.jpg" mimeType:@"image/jpg"];
    }];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData * data =[str dataUsingEncoding:NSUTF8StringEncoding];
        id dict =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        SEL func_selector = NSSelectorFromString(callBackFunctionName);
        if ([CallBackObject respondsToSelector:func_selector]) {
            NSLog(@"回调成功...");
            [CallBackObject performSelector:func_selector withObject:dict];
        }else{
            NSLog(@"回调失败...");
            [SVProgressHUD dismiss];
        }
        NSLog(@"上传完成");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"上传失败->%@", error);
        [SVProgressHUD showErrorWithStatus:@"请检查网络或防火墙" maskType:SVProgressHUDMaskTypeBlack];
    }];
    
    //执行
    NSOperationQueue * queue =[[NSOperationQueue alloc] init];
    [queue addOperation:op];
//    FileDetail *file = [FileDetail fileWithName:@"avatar.jpg" data:data];
//    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
//                            file,@"FILES",
//                            @"avatar",@"name",
//                            key, @"key", nil];
//    NSDictionary *result = [HttpRequest upload:[NSString stringWithFormat:@"%@index.php?act=member_index&op=avatar_upload",Url] widthParams:params];
//    NSLog(@"%@",result);
}

- (void)ShowOrderuploadImageWithImage:(NSData *)imagedata andurl:(NSString *)url andprm:(NSDictionary *)prm
{
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:prm constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imagedata name:@"imgsrc" fileName:@"showorder_img.jpg" mimeType:@"image/jpg"];
    }];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData * data =[str dataUsingEncoding:NSUTF8StringEncoding];
        id dict =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        SEL func_selector = NSSelectorFromString(callBackFunctionName);
        if ([CallBackObject respondsToSelector:func_selector]) {
            NSLog(@"回调成功...");
            [CallBackObject performSelector:func_selector withObject:dict];
        }else{
            NSLog(@"回调失败...");
            [SVProgressHUD dismiss];
        }
        NSLog(@"上传完成");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"上传失败->%@", error);
        [SVProgressHUD showErrorWithStatus:@"请检查网络或防火墙" maskType:SVProgressHUDMaskTypeBlack];
    }];
    
    //执行
    NSOperationQueue * queue =[[NSOperationQueue alloc] init];
    [queue addOperation:op];
    //    FileDetail *file = [FileDetail fileWithName:@"avatar.jpg" data:data];
    //    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
    //                            file,@"FILES",
    //                            @"avatar",@"name",
    //                            key, @"key", nil];
    //    NSDictionary *result = [HttpRequest upload:[NSString stringWithFormat:@"%@index.php?act=member_index&op=avatar_upload",Url] widthParams:params];
    //    NSLog(@"%@",result);
}

@end
