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

//#define Url @"http://115.28.67.86:8033/"
//#define Url @"http://hihome.zhongyangjituan.com/

@implementation DataProvider





#pragma mark - 登陆注册用户信息部分

-(void)frogetPassWord:(NSString *)phone andPassWord:(NSString *)password
{
    if(phone&&password)
    {
        NSString * url=[NSString stringWithFormat:@"%@LoginAndRegister.asmx/ForgetPassword",Url];
        NSDictionary * prm=@{@"phone":phone,
                             @"password":password};
        DLog(@"prm = %@",prm);
        [self PostRequest:url andpram:prm];
    }

}

-(void)thridLogin:(NSString *)openid andUserName:(NSString *)nicname
{
    if(openid)
    {
        NSString * url=[NSString stringWithFormat:@"%@LoginAndRegister.asmx/LoginByOther",Url];
        NSDictionary * prm=@{@"openid":openid,
                             @"nicname":nicname};
        DLog(@"prm = %@",prm);
        [self PostRequest:url andpram:prm];
    }
}

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

-(NSInteger)getUserInfo:(NSString *)userId andfriendid:(NSString *)friendid
{
    if(userId != nil)
    {
        NSString * url=[NSString stringWithFormat:@"%@LoginAndRegister.asmx/GetUserInfor",Url];
        NSDictionary * prm=@{@"userid":userId,@"friendid":friendid};
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

-(NSInteger)uploadHeadImg:(NSString *)userId andImgData:(NSString *)filestream  andImgName:(NSString *)fileName
{
    if(userId != nil  && filestream !=nil)
    {
        
        NSString * url=[NSString stringWithFormat:@"%@LoginAndRegister.asmx/UpLoadPhoto",Url];
        NSDictionary * prm=@{@"userid":userId,
                             @"fileName":(fileName==nil?@"imgname.jpg":fileName),
                             @"filestream":filestream};
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
#pragma mark - 支付
-(void)getPingppCharge:(NSString *)userid andChannel:(NSString *)channel andAmount:(NSString *)amount andDescription:(NSString *)description andFlg:(NSString *)flg
{
    if(userid != nil  && channel !=nil && amount != nil & description != nil)
    {
        
        NSString * url=[NSString stringWithFormat:@"%@LoginAndRegister.asmx/GetCharge",Url];
        NSDictionary * prm=@{@"userid":userid,
                             @"channel":channel,
                             @"amount":amount,
                             @"description":description,
                             @"flg":flg};
        DLog(@"prm = %@",prm);
        [self PostRequest:url andpram:prm];
        
    }
}

-(void)becomeVip:(NSString *)userid andMonth:(NSString *)month
{
    
    if(userid&& month)
    {
        
        NSString * url=[NSString stringWithFormat:@"%@LoginAndRegister.asmx/OpenHuiyuan",Url];
        NSDictionary * prm=@{@"userid":userid,
                             @"month":month};
        DLog(@"prm = %@",prm);
        [self PostRequest:url andpram:prm];
        
    }
    else
    {
        [SVProgressHUD dismiss];
    }
}

-(void)getVipTime:(NSString *)userid
{
//
    if(userid)
    {
        
        NSString * url=[NSString stringWithFormat:@"%@LoginAndRegister.asmx/GetPayOverTime",Url];
        NSDictionary * prm=@{@"userid":userid};
        DLog(@"prm = %@",prm);
        [self PostRequest:url andpram:prm];
        
    }
    else
    {
        [SVProgressHUD dismiss];
    }
    
}


-(void)closeVip:(NSString *)userid
{
    if(userid)
    {
        
        NSString * url=[NSString stringWithFormat:@"%@LoginAndRegister.asmx/CloseHuiyuan",Url];
        NSDictionary * prm=@{@"userid":userid};
        DLog(@"prm = %@",prm);
        [self PostRequest:url andpram:prm];
        
    }
    else
    {
        [SVProgressHUD dismiss];
    }
}
#pragma mark - 我的收藏
- (NSInteger )collectData:(NSString *)userId andIsVideo:(NSString *)isVideo  andStartRowIndex:(NSString *)startRowIndex andMaximumRows:(NSString *)maximumRows
{
    if(userId != nil  && isVideo !=nil && startRowIndex != nil & maximumRows != nil)
    {
        
        NSString * url=[NSString stringWithFormat:@"%@Hewuzhe.asmx/SelectFavoriteByUserId",Url];
        NSDictionary * prm=@{@"userid":userId,
                             @"isVideo":isVideo,
                             @"startRowIndex":startRowIndex,
                             @"maximumRows":maximumRows};
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

-(NSInteger)setCollect:(NSString *)userId andIsVideo:(NSString *)isVideo andStartRowIndex:(NSString *)startRowIndex andMaximumRowst:(NSString *)maximumRows
{
    if(userId != nil&&isVideo != nil&&startRowIndex != nil&&maximumRows != nil)
    {
        
        NSString * url=[NSString stringWithFormat:@"%@Hewuzhe.asmx/SelectFavoriteByUserId",Url];
        NSDictionary * prm=@{@"userid":userId,
                             @"isVideo":isVideo,
                             @"maximumRows":maximumRows,
                             @"startRowIndex":startRowIndex};
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

- (NSInteger )voiceAction:(NSString *)Id andUserId:(NSString *)userId andFlg:(NSString *)flg andDescription:(NSString *)description
{
    if(description == nil)
        description = @"";
    if(Id != nil && userId != nil && flg != nil )
    {
        
        NSString * url=[NSString stringWithFormat:@"%@Hewuzhe.asmx/MessageRepeatAndFavorite",Url];
        NSDictionary * prm=@{@"userid":userId,
                             @"flg":flg,
                             @"id":Id,
                             @"description":description};
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



-(void)ReportUser:(NSString *)userId andTargetId:(NSString *)targetId andContent:(NSString *)content
{
    if(userId != nil && targetId != nil && content != nil )
    {
        
        NSString * url=[NSString stringWithFormat:@"%@LoginAndRegister.asmx/ReportUser",Url];
        NSDictionary * prm=@{@"targetId":targetId,
                             @"userid":userId,
                             @"content":content};
        DLog(@"prm = %@",prm);
        [self PostRequest:url andpram:prm];
    }
    else
    {
        [SVProgressHUD dismiss];
    }
}
//视频的取消
- (NSInteger )voicedelete:(NSString *)Id andUserId:(NSString *)userId andFlg:(NSString *)flg
{
    if(Id != nil && userId != nil && flg != nil)
    {
        
        NSString * url=[NSString stringWithFormat:@"%@Hewuzhe.asmx/MessageRepeatAndFavoriteCancel",Url];
        NSDictionary * prm=@{@"userid":userId,
                             @"flg":flg,
                             @"id":Id};
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

//成长记录数据
- (NSInteger )growUserId:(NSString *)userId andStartRowIndex:(NSString *)startRowIndex andMaximumRows:(NSString *)maximumRows
{
    if(startRowIndex != nil && userId != nil && maximumRows != nil)
    {
        
        NSString * url=[NSString stringWithFormat:@"%@Hewuzhe.asmx/GetUpRecord",Url];
        NSDictionary * prm=@{@"userid":userId,
                             @"startRowIndex":startRowIndex,
                             @"maximumRows":maximumRows};
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



//获取其他作品
-(NSInteger )getUserid:(NSString *)userId andNum:(NSString *)num andmessageID:(NSString *)messageID
{
    
    if(userId != nil && num != nil&&messageID)
    {
        
        NSString * url=[NSString stringWithFormat:@"%@Hedongli.asmx/GetOtherVideo",Url];
        NSDictionary * prm=@{@"userid":userId,
                             @"num":num,
                             @"id":messageID};
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


//分页获取联盟动态
- (NSInteger )growCateid:(NSString *)cateid andUserId:(NSString *)userid andStartRowIndex:(NSString *)startRowIndex andMaximumRows:(NSString *)maximumRows
{
    if(startRowIndex != nil && cateid != nil && maximumRows != nil &&userid)
    {
        
        NSString * url=[NSString stringWithFormat:@"%@Helianmeng.asmx/GetDongtaiPageByLianmeng",Url];
        NSDictionary * prm=@{@"cateid":cateid,
                             @"startRowIndex":startRowIndex,
                             @"maximumRows":maximumRows,
                             @"userid":userid};
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

//获取联盟动态横向分类
-(NSInteger)getlianmengdongtai
{
    NSString * url=[NSString stringWithFormat:@"%@Helianmeng.asmx/GetLianmengCate",Url];
    [self PostRequest:url andpram:nil];
    return OK;
}


//int userid 用户ID
//string nicname 昵称
//int sexuality 性别 0：未知 1：男 2：女
//int height 身高 单位/CM
//double weight 体重 单位/KG
//int homeAreaId 地址
//int experience 习武经历 单位/年


-(NSInteger)setUserInfo:(NSString *)userId andNickName:(NSString *)nicname andSex:(NSString *)sexuality andHeight:(NSString *)height andWeight:(NSString *)weight andAddr:(NSString *)homeAreaId andExpe:(NSString *)experience andDescription:(NSString *)description andBirthday:(NSString *)birthday
{
   
    
    if(userId != nil&&nicname != nil&&sexuality != nil&&height != nil&&weight != nil&&homeAreaId != nil&&experience != nil&&description&&birthday)
    {
        
        NSString * url=[NSString stringWithFormat:@"%@LoginAndRegister.asmx/ChangeInfor",Url];
        NSDictionary * prm=@{@"userid":userId,
                             @"nicname":nicname,
                             @"sexuality":sexuality,
                             @"height":height,
                             @"weight":weight,
                             @"homeAreaId":homeAreaId,
                             @"experience":experience,
                             @"description":description,
                             @"birthday":birthday};
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

-(void)ChangePassWord:(NSString *)userid andoldpwd:(NSString *)oldpwd andpassword:(NSString *)password{
    if (userid) {
        NSString * url=[NSString stringWithFormat:@"%@LoginAndRegister.asmx/ChangePassWord",Url];
        NSDictionary * prm=@{@"userid":userid,
                             @"oldpwd":oldpwd,
                             @"password":password
                             };
        [self PostRequest:url andpram:prm];
    }
}
#pragma mark - 视频评论

//获取评论的信息
-(NSInteger )getMessageIdInfo:(NSString *)messageId
{
    
    if(messageId != nil)
    {
        
        NSString * url=[NSString stringWithFormat:@"%@Hewuzhe.asmx/SelectCommentByMessageId",Url];
        NSDictionary * prm=@{@"messageId":messageId};
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

-(void)commentVideo:(NSString *)videoId andUserId:(NSString *)userid andComment:(NSString *)comment
{
    if (userid&&videoId&&comment) {
        NSString * url=[NSString stringWithFormat:@"%@Hewuzhe.asmx/MessageComment",Url];
        NSDictionary * prm=@{@"id":videoId,
                             @"userid":userid,
                             @"comment":comment
                             };
        DLog(@"prm = %@",prm);
        [self PostRequest:url andpram:prm];
    }
}
#pragma mark - 图片上传
//-(NSInteger)uploadImgWithData:(NSData *)imgData andImgName:(NSString *)imgName
//{
//    if (imgData) {
//        NSString * url=[NSString stringWithFormat:@"%@Helianmeng.asmx/UpLoadImage",Url];
//        NSDictionary * prm=@{@"fileName":(imgName==nil?@"imgsrc.jpg":imgName)};
//        [self ShowOrderuploadImageWithImage:imgData andurl:url andprm:prm];
//        return OK;
//    }else{
//        [SVProgressHUD dismiss];
//        DLog(@"Err:%d",Param_err);
//        return Param_err;
//    }
//
//}


-(void)UploadImgWithImgdata:(NSString *)imageData
{
    if (imageData) {
        NSString * url=[NSString stringWithFormat:@"%@Helianmeng.asmx/UpLoadImage",Url];
        NSDictionary * prm=@{@"fileName":@"imgsrc.jpg",@"filestream":imageData};
        [self PostRequest:url andpram:prm];
      //  [self uploadImageWithImage:imagePath andurl:url andprm:prm];
        //        [self ShowOrderuploadImageWithImage:imagePath andurl:url andprm:prm];
    }
    
}
#pragma mark - 成长记录

-(void)getGrowHistory:(NSString *)userid andstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows
{
    if(userid != nil&&startRowIndex&&maximumRows)
    {
        
        NSString * url=[NSString stringWithFormat:@"%@Hewuzhe.asmx/GetUpRecord",Url];
        NSDictionary * prm=@{@"userid":userid,
                             @"startRowIndex":startRowIndex,
                             @"maximumRows":maximumRows};
        DLog(@"prm = %@",prm);
        [self PostRequest:url andpram:prm];
    }
}

#pragma mark - 放飞梦想

-(void)getTheirDream
{
    NSString * url=[NSString stringWithFormat:@"%@LoginAndRegister.asmx/GetDreamHeader",Url];
    [self PostRequest:url andpram:nil];
    
}

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

-(NSInteger)getStudyOnlineVideoList:(NSString *)categoryid andstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows andSearch:(NSString *)search
{
    if(categoryid != nil&&startRowIndex&&maximumRows)
    {
        
        NSString * url=[NSString stringWithFormat:@"%@Hewuzhe.asmx/GetOnlineStudyListByPage",Url];
        NSDictionary * prm=@{@"categoryid":categoryid,
                             @"startRowIndex":startRowIndex,
                             @"maximumRows":maximumRows,
                             @"search":search};
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
-(NSInteger)getStudyOnlineVideoDetial:(NSString *)videoid andUserId:(NSString *)userid
{
    if(videoid != nil &&userid != nil)
    {
        
        NSString * url=[NSString stringWithFormat:@"%@Hewuzhe.asmx/GetOnlineStudy",Url];
        NSDictionary * prm=@{@"id":videoid,
                             @"userid":userid};
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

#pragma mark - 视频直播
-(void)SelectVideoLiveList:(NSString *)userid andstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows{
    if (userid) {
        NSString * url=[NSString stringWithFormat:@"%@Hewuzhe.asmx/SelectVideoLiveList",Url];
        NSDictionary * prm=@{@"userid":userid,@"startRowIndex":startRowIndex,@"maximumRows":maximumRows};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)SelectVideoLive:(NSString *)userid andvideoLiveId:(NSString *)videoLiveId{
    if (userid) {
        NSString * url=[NSString stringWithFormat:@"%@Hewuzhe.asmx/SelectVideoLive",Url];
        NSDictionary * prm=@{@"userid":userid,@"videoLiveId":videoLiveId};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

#pragma mark - 武馆
-(void)getWuguanList:(NSString*)areaname andLat:(NSString *)lat andLng:(NSString *)lng andStartRowIndex:(NSString *)startRowIndex andMaximumRows:(NSString *)maximumRows
{

    if(areaname&&lat&&lng&&startRowIndex&&maximumRows)
    {
        NSString * url=[NSString stringWithFormat:@"%@Hewuzhe.asmx/SelectWuGuanPageByCityName",Url];
        NSDictionary * prm=@{@"areaname":areaname,
                             @"lat":lat,
                             @"lng":lng,
                             @"startRowIndex":startRowIndex,
                             @"maximumRows":maximumRows};
        DLog(@"prm = %@",prm);
        [self PostRequest:url andpram:prm];
    }
}


//Hewuzhe.asmx/SelectWuGuanPageByCityId
-(NSInteger)getWuGuanList:(NSString *)cityid andStartRowIndex:(NSString *)startRowIndex andMaximumRows:(NSString *)maximumRows
{
    if(cityid != nil)
    {
        
        NSString * url=[NSString stringWithFormat:@"%@Hewuzhe.asmx/SelectWuGuanPageByCityId",Url];
        NSDictionary * prm=@{@"cityid":cityid,
                             @"startRowIndex":startRowIndex,
                             @"maximumRows":maximumRows};
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
-(void)getWuguanDetail:(NSString *)wuGuanId
{
    if(wuGuanId != nil)
    {
        
        NSString * url=[NSString stringWithFormat:@"%@Hewuzhe.asmx/SelectWuGuan",Url];
        NSDictionary * prm=@{@"id":wuGuanId};
        DLog(@"prm = %@",prm);
        [self PostRequest:url andpram:prm];
        
    }
}

-(void)getWuguanPic:(NSString *)messageid
{
//
    if(messageid != nil)
    {
        
        NSString * url=[NSString stringWithFormat:@"%@Hewuzhe.asmx/SelectImageByMessageId",Url];
        NSDictionary * prm=@{@"messageid":messageid};
        DLog(@"prm = %@",prm);
        [self PostRequest:url andpram:prm];
        
    }

}
#pragma mark - 位置 城市
-(void) getAllCitys
{
 
    NSString * url=[NSString stringWithFormat:@"%@LoginAndRegister.asmx/GetCity",Url];
    [self PostRequest:url andpram:nil];
}

#pragma mark - 训练计划

-(void)updatePlan:(NSString *)userid andCateId:(NSString *)cateid andTitle:(NSString *)title andContent:(NSString *)content andPicList:(NSString *)piclist andStartDate:(NSString *)starttime andEndDate:(NSString *)endtime
{
    if(userid&&title&&content&&piclist&&cateid&&starttime&&endtime)
    {
        NSString * url=[NSString stringWithFormat:@"%@Hewuzhe.asmx/SavePlan",Url];
        NSDictionary * prm=@{@"userid":userid,
                             @"title":title,
                             @"cateid":cateid,
                             @"content":content,
                             @"piclist":piclist,
                             @"starttime":starttime,
                             @"endtime":endtime
                             };
        DLog(@"prm = %@",prm);
        [self PostRequest:url andpram:prm];
    }
    else
    {
        [SVProgressHUD dismiss];
    }
}

-(void)getPlanInfo:(NSString *)userid andCateId:(NSString *)cateid andStartRow:(NSString *)startRowIndex andMaxNumRows:(NSString *)maximumRows
{
    if(userid&&cateid&&startRowIndex&&maximumRows)
    {
        NSString * url=[NSString stringWithFormat:@"%@Hewuzhe.asmx/GetPlanByCate",Url];
        NSDictionary * prm=@{@"userid":userid,
                             @"cateid":cateid,
                             @"startRowIndex":startRowIndex,
                             @"maximumRows":maximumRows};
        DLog(@"prm = %@",prm);
        [self PostRequest:url andpram:prm];
    }

}

-(void)delePlan:(NSString*)planId
{
    if(planId)
    {
        NSString * url=[NSString stringWithFormat:@"%@Hewuzhe.asmx/DeletePlan",Url];
        NSDictionary * prm=@{@"id":planId};
        DLog(@"prm = %@",prm);
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

#pragma mark - 积分
-(void)getJiFenList:(NSString *)userid andStartRow:(NSString *)startRowIndex andMaxNumRows:(NSString *)maximumRows
{
    if(userid&&startRowIndex&&maximumRows)
    {
        NSString * url=[NSString stringWithFormat:@"%@Hewuzhe.asmx/GetCreditRecord",Url];
        NSDictionary * prm=@{@"userid":userid,
                             @"startRowIndex":startRowIndex,
                             @"maximumRows":maximumRows};
        DLog(@"prm = %@",prm);
        [self PostRequest:url andpram:prm];
    }
    
}



#pragma mark - 核联盟

-(void)getFriendForKeyValue:(NSString *)uid{
    if (uid) {
        NSString * url=[NSString stringWithFormat:@"%@Helianmeng.asmx/GetFriendForKeyValue",Url];
        NSDictionary * prm=@{@"userid":uid};
        [self PostRequest:url andpram:prm];

    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)SelectTeam:(NSString *)teamId{
    if (teamId) {
        NSString * url=[NSString stringWithFormat:@"%@Helianmeng.asmx/SelectTeam",Url];
        NSDictionary * prm=@{@"teamid":teamId};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)SelectTeamPage:(NSString *)startRowIndex andMaximumRows:(NSString *)maximumRows andName:(NSString *)name andCitycode:(NSString *)citycode{
    if (startRowIndex && maximumRows && name && citycode) {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/SelectTeamPage",Url];
        NSDictionary *prm = @{@"startRowIndex":startRowIndex,@"maximumRows":maximumRows,@"name":name,@"citycode":citycode};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)JoinTeam:(NSString *)userid andTeamId:(NSString *)teamid andName:(NSString *)name{
    if (userid && teamid && name) {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/JoinTeam",Url];
        NSDictionary *prm = @{@"userid":userid,@"teamid":teamid,@"name":name};
        [self PostRequest:url andpram:prm];
    }
}

-(void)quitTeam:(NSString *)userid andTeamID:(NSString *)teamid
{
    if (userid && teamid ) {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/QuitGroup",Url];
        NSDictionary *prm = @{@"userid":userid,
                              @"teamid":teamid};
        [self PostRequest:url andpram:prm];
    }
}
-(void)GetFriendBySearch:(NSString *)startRowIndex andMaximumRows:(NSString *)maximumRows andNicName:(NSString *)nicName andAreaCode:(NSString *)areaCode andAge:(NSString *)age andSexuality:(NSString *)sexuality andUserid:(NSString *)userid{
    NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/GetFriendByAreaCodeAndSearch",Url];
    NSDictionary *prm = @{@"startRowIndex":startRowIndex,@"maximumRows":maximumRows,@"nicName":nicName,@"areaCode":areaCode,@"age":age,@"sexuality":sexuality,@"userid":userid};
    [self PostRequest:url andpram:prm];
}

-(void)SaveFriend:(NSString *)userid andFriendid:(NSString *)friendid{
    if (userid && friendid) {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/SaveFriend",Url];
        NSDictionary *prm = @{@"userid":userid,@"friendid":friendid};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)DeleteFriend:(NSString *)userid andfriendid:(NSString *)friendid{
    if (userid && friendid) {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/DeleteFriend",Url];
        NSDictionary *prm = @{@"userid":userid,@"friendid":friendid};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)GetDongtaiPageByFriends:(NSString *)userid andstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows{
    if (userid) {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/GetDongtaiPageByFriends",Url];
        NSDictionary *prm = @{@"userid":userid,@"startRowIndex":startRowIndex,@"maximumRows":maximumRows};
        [self PostRequest:url andpram:prm];
        DLog(@"%@",prm);
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)IsWuyou:(NSString *)userid andfriendid:(NSString *)friendid{
    if (userid && friendid) {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/IsWuyou",Url];
        NSDictionary *prm = @{@"userid":userid,@"friendid":friendid};
        [self PostRequest:url andpram:prm];
    }
}

-(void)MessageComment:(NSString *)mid anduserid:(NSString *)userid andcomment:(NSString *)comment{
    if (mid && userid) {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/MessageComment",Url];
        NSDictionary *prm = @{@"id":mid,@"userid":userid,@"comment":comment};
        DLog(@"%@",prm);
        [self PostRequest:url andpram:prm];
    }
}

-(void)CommentComment:(NSString *)mid anduserid:(NSString *)userid andcomment:(NSString *)comment{
    if (mid && userid) {
        if (mid && userid) {
            NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/CommentComment",Url];
            NSDictionary *prm = @{@"id":mid,@"userid":userid,@"comment":comment};
            DLog(@"%@",prm);
            [self PostRequest:url andpram:prm];
        }
    }
}

-(void)SaveDongtai:(NSString *)userid andcontent:(NSString *)content andpathlist:(NSString *)pathlist andvideoImage:(NSString *)videoImage andvideopath:(NSString *)videopath andvideoDuration:(NSString *)videoDuration{
    if (userid) {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/SaveDongtai",Url];
        NSDictionary *prm = @{@"userid":userid,@"content":content,@"pathlist":pathlist,@"videopath":videopath,@"videoImage":videoImage,@"videoDuration":videoDuration};
        [self PostRequest:url andpram:prm];
    }
}

-(void)SelectDongtaiByFriendId:(NSString *)friendid andstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows{
    if (friendid) {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/SelectDongtaiByFriendId",Url];
        NSDictionary *prm = @{@"friendid":friendid,@"startRowIndex":startRowIndex,@"maximumRows":maximumRows};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)GetMyDongtaiPage:(NSString *)userid andstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows{
    if (userid) {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/GetMyDongtaiPage",Url];
        NSDictionary *prm = @{@"userid":userid,@"startRowIndex":startRowIndex,@"maximumRows":maximumRows};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)GetDongtaiById:(NSString *)userid andmessid:(NSString *)messid{
    if(userid&&messid){
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/GetDongtaiById",Url];
        NSDictionary *prm = @{@"userid":userid,@"messid":messid};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)GetCateForHezuo{
    NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/GetCateForHezuo",Url];
    [self PostRequest:url andpram:nil];
}

-(void)GetHezuoListByPage:(NSString *)startRowIndex andUserId:(NSString *)userid andmaximumRows:(NSString *)maximumRows andcategoryid:(NSString *)categoryid{
    if (categoryid) {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/GetHezuoListByPage",Url];
        NSDictionary *prm = @{@"startRowIndex":startRowIndex,
                              @"userid":userid,
                              @"maximumRows":maximumRows,
                              @"categoryid":categoryid};
        [self PostRequest:url andpram:prm];
    }
}

-(void)GetCateForJianghu{
    NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/GetCateForJianghu",Url];
    [self PostRequest:url andpram:nil];
}

-(void)GetJianghuListByPage:(NSString *)startRowIndex andUserId:(NSString *)userid andmaximumRows:(NSString *)maximumRows andcategoryid:(NSString *)categoryid{
    if (categoryid) {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/GetJianghuListByPage",Url];
        NSDictionary *prm = @{@"startRowIndex":startRowIndex,
                              @"userid":userid,
                              @"maximumRows":maximumRows,
                              @"categoryid":categoryid};
        [self PostRequest:url andpram:prm];
    }
}

-(void)SelectMatchPageByPerson:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows{
    NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/SelectMatchPageByPerson",Url];
    NSDictionary *prm = @{@"startRowIndex":startRowIndex,@"maximumRows":maximumRows};
    [self PostRequest:url andpram:prm];
}

-(void)SelectMatchPageByTeam:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows{
    NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/SelectMatchPageByTeam",Url];
    NSDictionary *prm = @{@"startRowIndex":startRowIndex,@"maximumRows":maximumRows};
    [self PostRequest:url andpram:prm];
}

-(void)DeleteNoReadMatch:(NSString *)userId andFlg:(NSString *)flg{
    if (userId) {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/DeleteNoReadMatch",Url];
        NSDictionary *prm = @{@"userId":userId,@"flg":flg};
        [self PostRequest:url andpram:prm];
    }
}

-(void)SelectNoReadMatch:(NSString *)userId{
    if (userId) {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/SelectNoReadMatch",Url];
        NSDictionary *prm = @{@"userId":userId};
        [self PostRequest:url andpram:prm];
    }
}

-(void)SelectMatchDetail:(NSString *)matchId anduserId:(NSString *)userId{
    if (matchId&&userId) {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/SelectMatchDetailWithIsJoin",Url];
        NSDictionary *prm = @{@"matchId":matchId,@"userId":userId};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)getTeamDetailForMatch:(NSString *)matchId andTeamId:(NSString *)teamid andmyId:(NSString *)myId
{
    if (matchId&&teamid&&myId) {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/SelectMatchTeamDetail",Url];
        NSDictionary *prm = @{@"matchId":matchId,
                              @"teamid":teamid,
                              @"myId":myId};
        DLog(@"%@",prm);
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}


-(void)JoinMatch:(NSString *)matchId anduserid:(NSString *)userid andmatchVideo:(NSString *)matchVideo andmatchImage:(NSString *)matchImage andmatchDescription:(NSString *)matchDescription andtitle:(NSString *)title andvideoDuration:(NSString *)videoDuration{
    if (matchId && userid) {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/JoinMatch",Url];
        NSDictionary *prm =@{@"matchId":matchId,@"userid":userid,@"matchVideo":matchVideo,@"matchImage":matchImage,@"matchDescription":matchDescription,@"title":title,@"videoDuration":videoDuration};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)SelectAllMatchMemberBySearch:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows andmatchId:(NSString *)matchId andmembercode:(NSString *)membercode andnicname:(NSString *)nicname andflg:(NSString *)flg{
    if (matchId) {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/SelectAllMatchMemberBySearch",Url];
        NSDictionary *prm = @{@"startRowIndex":startRowIndex,@"maximumRows":maximumRows,@"matchId":matchId,@"membercode":membercode,@"nicname":nicname,@"flg":flg};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)SelectAllMatchTeamBySearch:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows andmatchId:(NSString *)matchId andmembercode:(NSString *)membercode andnicname:(NSString *)nicname andflg:(NSString *)flg{
    if (matchId) {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/SelectAllMatchTeamBySearch",Url];
        NSDictionary *prm = @{@"startRowIndex":startRowIndex,@"maximumRows":maximumRows,@"matchId":matchId,@"membercode":membercode,@"nicname":nicname,@"flg":flg};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)SelectMatchMemberDetail:(NSString *)matchId anduserid:(NSString *)userid andMyId:(NSString *)myId{
    if (matchId && userid) {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/SelectMatchMemberDetail",Url];
        NSDictionary *prm = @{@"matchId":matchId,
                              @"userid":userid,
                              @"myId":myId};
        DLog(@"%@",prm);
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)CancleJoinMatch:(NSString *)matchId anduserid:(NSString *)userid{
    if (matchId && userid) {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/CancleJoinMatch",Url];
        NSDictionary *prm = @{@"matchId":matchId,@"userid":userid};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)SelectMyFriend:(NSString *)userid andfriend:(NSString *)friendid{
    if (userid && friendid) {
        NSString *url = [NSString stringWithFormat:@"%@LoginAndRegister.asmx/SelectMyFriend",Url];
        NSDictionary *prm = @{@"userid":userid,@"friend":friendid};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)GetNoReadCommentNumByUserId:(NSString *)userid{
    if (userid) {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/GetNoReadCommentNumByUserId",Url];
        NSDictionary *prm = @{@"userid":userid};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

#pragma mark - 战队赛事评论

-(void)getMatchComment:(NSString *)memberId andstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows
{
    if(memberId && startRowIndex && maximumRows)
    {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/GetMatchComment",Url];
        NSDictionary *prm = @{@"memberId":memberId,
                              @"startRowIndex":startRowIndex,
                              @"maximumRows":maximumRows};
        DLog(@"%@",prm);
        [self PostRequest:url andpram:prm];
    }
    else
    {
        [SVProgressHUD dismiss];
    }
}

-(void)commentMatch:(NSString *)memberId andUserID:(NSString *)userId andComment:(NSString *)comment
{
    if(memberId && userId && comment)
    {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/CommentMatch",Url];
        NSDictionary *prm = @{@"memberId":memberId,
                              @"userId":userId,
                              @"comment":comment};
        DLog(@"%@",prm);
        [self PostRequest:url andpram:prm];
    }
    else
    {
        [SVProgressHUD dismiss];
    }
}


-(void)voteTeam:(NSString *)matchId andTeamId:(NSString *)teamid andUserId:(NSString *)voterId
{
//Helianmeng.asmx/VoteTeam
    if(matchId && teamid && voterId)
    {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/VoteTeam",Url];
        NSDictionary *prm = @{@"matchId":matchId,
                              @"teamid":teamid,
                              @"voterId":voterId};
        DLog(@"%@",prm);
        [self PostRequest:url andpram:prm];
    }
    else
    {
        [SVProgressHUD dismiss];
    }
}

-(void)votePerson:(NSString *)matchId andUserid:(NSString *)userid andUserId:(NSString *)voterId
{
    if(matchId && userid && voterId)
    {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/VotePerso",Url];
        NSDictionary *prm = @{@"matchId":matchId,
                              @"userid":userid,
                              @"voterId":voterId};
        DLog(@"%@",prm);
        [self PostRequest:url andpram:prm];
    }
    else
    {
        [SVProgressHUD dismiss];
    }
}

-(void)SelectFriended:(NSString *)userid{
    if (userid) {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/SelectFriended",Url];
        NSDictionary *prm = @{@"userid":userid};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

#pragma mark -  武友动态

-(void)ShieldFriendNew:(NSString *)userid andFriendid:(NSString *)friendid
{
    if(userid&&friendid)
    {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/ShieldFriend",Url];
        NSDictionary *prm = @{@"userid":userid,
                              @"friendid":friendid};
        DLog(@"prm = %@",prm);
        [self PostRequest:url andpram:prm];
    }
    else
    {
       [SVProgressHUD dismiss];
    }
}

-(void)UnShieldFriend:(NSString *)userid andFriendId:(NSString *)friendid
{
    if(userid&&friendid)
    {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/UnShieldFriend",Url];
        NSDictionary *prm = @{@"userid":userid,
                              @"friendid":friendid};
        DLog(@"prm = %@",prm);
        [self PostRequest:url andpram:prm];
    }
    else
    {
        [SVProgressHUD dismiss];
    }
}


-(void)ShieldFriendMessage:(NSString *)userid andFriendId:(NSString *)friendid
{
    if(userid && friendid)
    {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/ShieldFriendNews",Url];
        NSDictionary *prm = @{@"userid":userid,
                              @"friendid":friendid};
        DLog(@"prm = %@",prm);
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}
-(void)UnShieldFriendMessage:(NSString *)userid andFriendId:(NSString *)friendid
{
    if(userid && friendid)
    {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/UnShieldFriendNews",Url];
        NSDictionary *prm = @{@"userid":userid,
                              @"friendid":friendid};
        DLog(@"prm = %@",prm);
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}
#pragma mark - 联盟动态


-(void)getUnionNewsCate
{
    NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/GetLianmengCate",Url];
    [self PostRequest:url andpram:nil];
}
#pragma mark - 战队动态

-(void)getSelfTeamNews:(NSString *)userid andStartRowIndex:(NSString *)startRowIndex andMaximumRows:(NSString *)maximumRows
{
    if(userid && startRowIndex && maximumRows)
    {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/GetTeamDongtaiPageByUserId",Url];
        NSDictionary *prm = @{@"userid":userid,
                              @"startRowIndex":startRowIndex,
                              @"maximumRows":maximumRows};
        DLog(@"%@",prm);
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}
-(void)getOtherTeamNews:(NSString *)teamid andStartRowIndex:(NSString *)startRowIndex andMaximumRows:(NSString *)maximumRows
{
    if(teamid && startRowIndex && maximumRows)
    {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/GetTeamDongtaiPageByTeamId",Url];
        NSDictionary *prm = @{@"teamid":teamid,
                              @"startRowIndex":startRowIndex,
                              @"maximumRows":maximumRows};
        DLog(@"%@",prm);
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }

}

-(void)getTeamMember:(NSString *)teamid andUserId:(NSString *)userid
{
    if(teamid&&userid)
    {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/SelectTeamMember",Url];
        NSDictionary *prm = @{@"teamid":teamid,@"userid":userid};
        DLog(@"%@",prm);
        [self PostRequest:url andpram:prm];

    }
}

-(void)getTeamIntro:(NSString *)teamid
{
    if(teamid)
    {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/SelectTeamIntroduce",Url];
        NSDictionary *prm = @{@"teamid":teamid};
        DLog(@"%@",prm);
        [self PostRequest:url andpram:prm];
        
    }
}

-(void)getTeamAnnouncement:(NSString *)teamid andStartRowIndex:(NSString *)startRowIndex andMaximumRows:(NSString *)maximumRows
{
    if(teamid && startRowIndex && maximumRows)
    {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/SelectTeamAnnouncement",Url];
        NSDictionary *prm = @{@"teamid":teamid,
                              @"startRowIndex":startRowIndex,
                              @"maximumRows":maximumRows};
        DLog(@"%@",prm);
        [self PostRequest:url andpram:prm];
    }

}

-(void)delComment:(NSString*)messageID
{
    if(messageID)
    {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/DeleteComment",Url];
        NSDictionary *prm = @{@"id":messageID};
        DLog(@"%@",prm);
        [self PostRequest:url andpram:prm];
        
    }else{
        [SVProgressHUD dismiss];
    }

}

#pragma mark 核动力

-(void)delVideo:(NSString *)VideoId
{
    if(VideoId)
    {
        NSString *url = [NSString stringWithFormat:@"%@Hewuzhe.asmx/DeleteVideo",Url];
        NSDictionary *prm = @{@"id":VideoId};
        DLog(@"%@",prm);
        [self PostRequest:url andpram:prm];
        
    }
}

-(void)uploadVideoWithPath:(NSURL *)videoPath
{
    if (videoPath) {
        NSString *url = [NSString stringWithFormat:@"%@Hewuzhe.asmx/UpLoadVideo",Url];
        NSData* imageData = [[NSData alloc] initWithContentsOfURL:videoPath];
        NSString *imagebase64= [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        
        NSDictionary *prm = @{@"fileName":@"video.mov",@"filestream":imagebase64};
        [self PostRequest:url andpram:prm];
        //        [self uploadVideoWithFilePath:videoPath andurl:url andprm:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)GetNewVideoList:(NSString * )startRowIndex andmaximumRows:(NSString *)maximumRows andSearch:(NSString *)search
{
    if (startRowIndex && maximumRows &&search) {
        NSString *url = [NSString stringWithFormat:@"%@Hedongli.asmx/NewVideo",Url];
        NSDictionary *prm = @{@"startRowIndex":startRowIndex,
                              @"maximumRows":maximumRows,
                              @"search":search};
        [self PostRequest:url andpram:prm];
    }
}
-(void)GetHotVideoList:(NSString * )startRowIndex andmaximumRows:(NSString *)maximumRows andSearch:(NSString *)search
{
    if (startRowIndex && maximumRows &&search) {
        NSString *url = [NSString stringWithFormat:@"%@Hedongli.asmx/HotVideo",Url];
        NSDictionary *prm = @{@"startRowIndex":startRowIndex,
                              @"maximumRows":maximumRows,
                              @"search":search};
        [self PostRequest:url andpram:prm];
    }
}
-(void)GetTuiJianVideoList:(NSString * )startRowIndex andmaximumRows:(NSString *)maximumRows andSearch:(NSString *)search
{
    if (startRowIndex && maximumRows &&search) {
        NSString *url = [NSString stringWithFormat:@"%@Hedongli.asmx/TuijianVideo",Url];
        NSDictionary *prm = @{@"startRowIndex":startRowIndex,
                              @"maximumRows":maximumRows,
                              @"search":search};
        [self PostRequest:url andpram:prm];
    }
}
-(void)GetYuanChuangVideoList:(NSString * )startRowIndex andmaximumRows:(NSString *)maximumRows andSearch:(NSString *)search
{
    if (startRowIndex && maximumRows &&search) {
        NSString *url = [NSString stringWithFormat:@"%@Hedongli.asmx/YuanchuangVideo",Url];
        NSDictionary *prm = @{@"startRowIndex":startRowIndex,@"maximumRows":maximumRows,@"search":search};
        [self PostRequest:url andpram:prm];
    }
}
-(void)GetChinnel:(NSString * )startRowIndex andmaximumRows:(NSString *)maximumRows
{
    if (startRowIndex && maximumRows) {
        NSString *url = [NSString stringWithFormat:@"%@Hedongli.asmx/GetChannel",Url];
        NSDictionary *prm = @{@"startRowIndex":startRowIndex,@"maximumRows":maximumRows};
        [self PostRequest:url andpram:prm];
    }
}
-(void)SendVideoInfo:(NSDictionary *)prm
{
    if (prm) {
        NSString *url = [NSString stringWithFormat:@"%@Hewuzhe.asmx/SaveOrEditVideoMessage",Url];
        [self PostRequest:url andpram:prm];
    }
}

-(void)GetVideoByCategory:(NSString * )startRowIndex andmaximumRows:(NSString *)maximumRows andcateid:(NSString *)cateid andSearch:(NSString *)search{
    if (startRowIndex && maximumRows&&cateid&&search) {
        NSString *url = [NSString stringWithFormat:@"%@Hedongli.asmx/SelectVideoByCategory",Url];
        NSDictionary *prm = @{@"startRowIndex":startRowIndex,
                              @"maximumRows":maximumRows,
                              @"cateid":cateid,
                              @"search":search};
        [self PostRequest:url andpram:prm];
    }
}

-(void)SetNickName:(NSString *)userid andfriend:(NSString *)friend andrname:(NSString *)rname
{
    if (userid && friend&&rname) {
        NSString *url = [NSString stringWithFormat:@"%@LoginAndRegister.asmx/ChangeFriendRName",Url];
        NSDictionary *prm = @{@"userid":userid,@"friend":friend,@"rname":rname};
        [self PostRequest:url andpram:prm];
    }
}

#pragma mark - 核装备
-(void)SelectBigCategory{
    NSString *url = [NSString stringWithFormat:@"%@Hezhuangbei.asmx/SelectBigCategory",Url];
    [self PostRequest:url andpram:nil];
}

-(void)SelectSmallCategory:(NSString *)parentId{
    if (parentId) {
        NSString *url = [NSString stringWithFormat:@"%@Hezhuangbei.asmx/SelectSmallCategory",Url];
        NSDictionary *prm = @{@"parentId":parentId};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)SaveComment:(NSArray *)commlist
{
    if (commlist) {
        NSString *url = [NSString stringWithFormat:@"%@Hezhuangbei.asmx/CommentProduct",Url];
        NSString *jsonString = [[NSString alloc] initWithData:[self toJSONData:commlist]
                                                     encoding:NSUTF8StringEncoding];
        NSDictionary *prm = @{@"comlist":jsonString};
        [self PostRequest:url andpram:prm];

    }
}

//startRowIndex 开始行索引
//maximumRows 每页条数
//search 搜索内容
//categoryId 类别ID 不按照类别搜索传0
//isPriceAsc 是否价格升序 0：默认 1：升序 2：降序
//isSalesAsc 是否销量升序 0：默认 1：升序 2：降序
//isCommentAsc 是否好评升序 0：默认 1：升序 2：降序
//isNewAsc 是否最新升序 0：默认 1：升序 2：降序
//isCredit 是否可以兑换 0：积分兑换 1：购买


-(void)SelectProductBySearch:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows andsearch:(NSString *)search andcategoryId:(NSString *)categoryId andisPriceAsc:(NSString *)isPriceAsc andisSalesAsc:(NSString *)isSalesAsc andisCommentAsc:(NSString *)isCommentAsc andisNewAsc:(NSString *)isNewAsc andisCredit:(NSString *)isCredit andisRecommend:(NSString *)isRecommend{
    
    if (categoryId && search && isPriceAsc&&isSalesAsc
        && isCommentAsc && isNewAsc && isCredit
        &&startRowIndex&&maximumRows&&isRecommend
        )
    {
        NSString *url = [NSString stringWithFormat:@"%@Hezhuangbei.asmx/SelectProductBySearch",Url];
        NSDictionary *prm = @{@"categoryId":categoryId,
                              @"search":search,
                              @"isPriceAsc":isPriceAsc,
                              @"isSalesAsc":isSalesAsc,
                              @"isCommentAsc":isCommentAsc,
                              @"isNewAsc":isNewAsc,
                              @"isCredit":isCredit,
                              @"startRowIndex":startRowIndex,
                              @"maximumRows":maximumRows,
                              @"isRecommend":isRecommend};
        DLog(@"%@",prm);
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
    
}

-(void)SelectProduct:(NSString *)sid anduserid:(NSString *)userid andmaximumRows:(NSString *)maximumRows{
    if (sid && userid && maximumRows) {
        NSString *url = [NSString stringWithFormat:@"%@Hezhuangbei.asmx/SelectProduct",Url];
        NSDictionary *prm = @{@"id":sid,
                              @"userid":userid,
                              @"maximumRows":maximumRows};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)FavoriteProduct:(NSString *)userId andproductId:(NSString *)productId{
    if (userId && productId) {
        NSString *url = [NSString stringWithFormat:@"%@Hezhuangbei.asmx/FavoriteProduct",Url];
        NSDictionary *prm = @{@"userId":userId,
                              @"productId":productId};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)CancleFavoriteProduct:(NSString *)userId andproductId:(NSString *)productId{
    if (userId && productId) {
        NSString *url = [NSString stringWithFormat:@"%@Hezhuangbei.asmx/CancleFavoriteProduct",Url];
        NSDictionary *prm = @{@"userId":userId,
                              @"productId":productId};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)BuyNow:(NSString *)productId andnum:(NSString *)num andpriceId:(NSString *)priceId anduserId:(NSString *)userId andprice:(NSString *)price anddeliveryId:(NSString *)deliveryId anddescription:(NSString *)description{
    if (productId && num && priceId && userId && price && deliveryId && description) {
        NSString *url = [NSString stringWithFormat:@"%@Hezhuangbei.asmx/BuyNow",Url];
        NSDictionary *prm = @{@"productId":productId,
                              @"num":num,
                              @"priceId":priceId,
                              @"userId":userId,
                              @"price":price,
                              @"deliveryId":deliveryId,
                              @"description":description};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)InsertBasket:(NSString *)productId andnum:(NSString *)num andpriceId:(NSString *)priceId anduserId:(NSString *)userId andprice:(NSString *)price{
    if (productId && num && priceId && userId && price) {
        NSString *url = [NSString stringWithFormat:@"%@Hezhuangbei.asmx/InsertBasket",Url];
        NSDictionary *prm = @{@"productId":productId,
                              @"num":num,
                              @"priceId":priceId,
                              @"userId":userId,
                              @"price":price};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)SelectCommentByProductId:(NSString *)productId andstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows{
    if (productId && startRowIndex && maximumRows) {
        NSString *url = [NSString stringWithFormat:@"%@Hezhuangbei.asmx/SelectCommentByProductId",Url];
        NSDictionary *prm = @{@"productId":productId,
                              @"startRowIndex":startRowIndex,
                              @"maximumRows":maximumRows};
        
        DLog(@"%@",prm);
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)GetRecomendCategoryAndProduct:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows anduserId:(NSString *)userId andproductNum:(NSString *)productNum{
    if (startRowIndex && maximumRows && userId && productNum) {
        NSString *url = [NSString stringWithFormat:@"%@Hezhuangbei.asmx/GetRecomendCategoryAndProduct",Url];
        NSDictionary *prm = @{@"startRowIndex":startRowIndex,
                              @"maximumRows":maximumRows,
                              @"userId":userId,
                              @"productNum":productNum};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)SelectFavoriteByUserIdAndSearch:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows anduserId:(NSString *)userId andsearch:(NSString *)search{
    if (startRowIndex && maximumRows && userId && search) {
        NSString *url = [NSString stringWithFormat:@"%@Hezhuangbei.asmx/SelectFavoriteByUserIdAndSearch",Url];
        NSDictionary *prm = @{@"startRowIndex":startRowIndex,
                              @"maximumRows":maximumRows,
                              @"userId":userId,
                              @"search":search};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)SetDefaultDeliveryAddress:(NSString *)goodsId anduserId:(NSString *)userId{
    if (goodsId && userId) {
        NSString *url = [NSString stringWithFormat:@"%@Hezhuangbei.asmx/SetDefaultDeliveryAddress",Url];
        NSDictionary *prm = @{@"id":goodsId,
                              @"userId":userId};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)SelectPageChangeBillByUserId:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows anduserId:(NSString *)userId andstate:(NSString *)state andproNum:(NSString *)proNum{
    if (startRowIndex && maximumRows && userId && state && proNum) {
        NSString *url = [NSString stringWithFormat:@"%@Hezhuangbei.asmx/SelectPageChangeBillByUserId",Url];
        NSDictionary *prm = @{@"startRowIndex":startRowIndex,
                              @"maximumRows":maximumRows,
                              @"userId":userId,
                              @"state":state,
                              @"proNum":proNum};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)ChangeDetail:(NSString *)productId anduserId:(NSString *)userId andbillDetailId:(NSString *)billDetailId{
    if (productId && userId && billDetailId) {
        NSString *url = [NSString stringWithFormat:@"%@Hezhuangbei.asmx/ChangeDetail",Url];
        NSDictionary *prm = @{@"productId":productId,
                              @"userId":userId,
                              @"billDetailId":billDetailId};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

#pragma mark -  购物车

-(void)getShoppingCartList:(NSString *)userId andstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows
{
    if (startRowIndex && maximumRows && userId ) {
        NSString *url = [NSString stringWithFormat:@"%@Hezhuangbei.asmx/SelectBasketProduct",Url];
        NSDictionary *prm = @{@"startRowIndex":startRowIndex,
                              @"maximumRows":maximumRows,
                              @"userId":userId};
        DLog(@"%@",prm);
        
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}


-(void)delShopCartGoods:(NSString *)userId andIdList:(NSString *)idList
{
    if (idList && userId ) {
        NSString *url = [NSString stringWithFormat:@"%@Hezhuangbei.asmx/DeleteBasketProduct",Url];
        NSDictionary *prm = @{@"idList":idList,
                              @"userId":userId};
        DLog(@"%@",prm);
        
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)changeCartGoodNum:(NSString *)userId andGoodId:(NSString *)Id andNum:(NSString *)num
{
    if (Id && userId && num) {
        NSString *url = [NSString stringWithFormat:@"%@Hezhuangbei.asmx/ChangeBasketProductNum",Url];
        NSDictionary *prm = @{@"id":Id,
                              @"userId":userId,
                              @"num":num};
        DLog(@"%@",prm);
        
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}


-(void)getPostage:(NSString *)userId andGoodIds:(NSString *)idList
{
    if (userId && idList) {
        NSString *url = [NSString stringWithFormat:@"%@Hezhuangbei.asmx/GetPostage",Url];
        NSDictionary *prm = @{@"idList":idList,
                              @"userId":userId};
        DLog(@"%@",prm);
        
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

#pragma mark - 订单
//startRowIndex 开始行索引
//maximumRows 每页条数
//userId 用户ID
//state 订单状态 1：未付款 2：代发货 3：已发货 4：已签收 5：买家已评价 6：卖家已评价 7：已过期 8：全部 9:申请取消订单 10：已取消订单
//proNum 每个订单下显示商品个数
-(void)getOrderList:(NSString *)userId andState:(NSString *)state andProNum:(NSString *)proNum andStartRowIndex:(NSString *)startRowIndex andMaximumRows:(NSString *)maximumRows
{
    if (state && userId  && proNum &&startRowIndex && maximumRows) {
        NSString *url = [NSString stringWithFormat:@"%@Hezhuangbei.asmx/SelectPageBillByUserId",Url];
        NSDictionary *prm = @{@"state":state,
                              @"userId":userId,
                              @"proNum":proNum,
                              @"startRowIndex":startRowIndex,
                              @"maximumRows":maximumRows};
        DLog(@"%@",prm);
        
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)getAddrById:(NSString *)Id
{

    if (Id) {
        NSString *url = [NSString stringWithFormat:@"%@Hezhuangbei.asmx/GetDeliveryAddressById",Url];
        NSDictionary *prm = @{@"Id":Id};
        [self PostRequest:url andpram:prm];
        DLog(@"%@",prm);
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)sureForOrder:(NSString *)userId andBillId:(NSString *)billId
{
    if (userId&&billId) {
        NSString *url = [NSString stringWithFormat:@"%@Hezhuangbei.asmx/Acceptance",Url];
        NSDictionary *prm = @{@"userId":userId,
                              @"billId":billId};
        [self PostRequest:url andpram:prm];
        DLog(@"%@",prm);
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)getDefaultAddress:(NSString *)userId
{
    if (userId) {
        NSString *url = [NSString stringWithFormat:@"%@Hezhuangbei.asmx/SelectDefaultDeliveryAddress",Url];
        NSDictionary *prm = @{@"userId":userId};
        [self PostRequest:url andpram:prm];
        DLog(@"%@",prm);
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)SelectAllDeliveryAddress:(NSString *)userId{
    if (userId) {
        NSString *url = [NSString stringWithFormat:@"%@Hezhuangbei.asmx/SelectAllDeliveryAddress",Url];
        NSDictionary *prm = @{@"userId":userId};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)EditDeliveryAddress:(NSString *)addressId andareaId:(NSString *)areaId andaddress:(NSString *)address andisDefaul:(NSString *)isDefaul anduserId:(NSString *)userId andreceiverName:(NSString *)receiverName andphone:(NSString *)phone andcodeForAddress:(NSString *)codeForAddress{
    if (addressId && areaId && address && isDefaul && userId && receiverName && phone && codeForAddress) {
        NSString *url = [NSString stringWithFormat:@"%@Hezhuangbei.asmx/EditDeliveryAddress",Url];
        NSDictionary *prm = @{@"id":addressId,
                              @"areaId":areaId,
                              @"address":address,
                              @"isDefaul":isDefaul,
                              @"userId":userId,
                              @"receiverName":receiverName,
                              @"phone":phone,
                              @"codeForAddress":codeForAddress};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)DeleteDeliveryAddress:(NSString *)idList anduserId:(NSString *)userId{
    if (idList && userId) {
        NSString *url = [NSString stringWithFormat:@"%@Hezhuangbei.asmx/DeleteDeliveryAddress",Url];
        NSDictionary *prm = @{@"idList":idList,
                              @"userId":userId};

        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)CancleOrderWithOrderID:(NSString *)orderid andUserId:(NSString *)userid
{
    if (orderid&&userid) {
        NSString *url = [NSString stringWithFormat:@"%@Hezhuangbei.asmx/CancleProduct",Url];
        NSDictionary *prm = @{@"billId":orderid,
                              @"userId":userid};
        DLog(@"%@",prm);
        [self PostRequest:url andpram:prm];
    }
    else{
        [SVProgressHUD dismiss];
    }
}
//userId 用户ID
//deliveryId 收货地址ID
//description 订单备注
//basketDeatilIdList 购物车明细ID

-(void)buyInShoppingCart:(NSString *)userId andDeliveryId:(NSString *)deliveryId andDescription:(NSString *)description andBasketDeatilIdList:(NSString *)basketDeatilIdList
{
    if (userId &&deliveryId&&description&&basketDeatilIdList) {
        NSString *url = [NSString stringWithFormat:@"%@Hezhuangbei.asmx/SubmitBasket",Url];
        NSDictionary *prm = @{@"userId":userId,
                              @"deliveryId":deliveryId,
                              @"description":description,
                              @"basketDeatilIdList":basketDeatilIdList};
        DLog(@"%@",prm);
        [self PostRequest:url andpram:prm];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

-(void)getChargeForShopping:(NSString *)userid andChannel:(NSString *)channel andAmount:(NSString *)amount andDescription:(NSString *)description andFlg:(NSString *)flg andBillId:(NSString *)billId
{
    if (userid &&channel&&amount&&description&&flg) {
        NSString *url = [NSString stringWithFormat:@"%@Hezhuangbei.asmx/GetCharge",Url];
        NSDictionary *prm = @{@"userid":userid,
                              @"channel":channel,
                              @"amount":amount,
                              @"description":description,
                              @"flg":flg,
                              @"billId":billId};
        DLog(@"%@",prm);
        [self PostRequest:url andpram:prm];
    }
    else{
        [SVProgressHUD dismiss];
    }
        
}
//Hezhuangbei.asmx/ChangeNow
//productId 产品ID
//num 兑换个数
//userId 用户ID
//deliveryId 收货地址ID
//description 订单备注
-(void)payByjiFen:(NSString *)userId andProductId:(NSString *)productId andNum:(NSString *)num andDeliveryId:(NSString *)deliveryId andDescription:(NSString *)description
{
    if (userId &&productId&&num&&deliveryId&&description) {
        NSString *url = [NSString stringWithFormat:@"%@Hezhuangbei.asmx/ChangeNow",Url];
        NSDictionary *prm = @{@"userId":userId,
                              @"productId":productId,
                              @"num":num,
                              @"deliveryId":deliveryId,
                              @"description":description};
        DLog(@"%@",prm);
        [self PostRequest:url andpram:prm];
    }
    else{
        [SVProgressHUD dismiss];
    }
    
}

#pragma mark - 更多
-(void)ChangeTuiSong:(NSString *)userid andistuisong:(NSString *)istuisong{
    if (userid && istuisong) {
        NSString *url = [NSString stringWithFormat:@"%@LoginAndRegister.asmx/ChangeTuiSong",Url];
        NSDictionary *prm = @{@"userid":userid,@"istuisong":istuisong};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)ShieldNewsFriend:(NSString *)userid{
    if (userid) {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/ShieldNewsFriend",Url];
        NSDictionary *prm = @{@"userid":userid};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}


-(void)GetAboutUs
{
    NSString *url = [NSString stringWithFormat:@"%@AboutUs.asmx/GetAuoutUs",Url];
//    NSDictionary *prm = @{@"userid":userid};
    [self PostRequest:url andpram:nil];
}





#pragma mark -  天气
//获取天气信息
-(void)getWeatherInfo: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg {
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, [HttpArg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"POST"];
    [request addValue: @"4e01ff24cadf672086df1d5f654f4785" forHTTPHeaderField: @"apikey"];
    
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"error:%@",error);
                                   [SVProgressHUD dismiss];
                               } else {
                                   id dict =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                   SEL func_selector = NSSelectorFromString(callBackFunctionName);
                                   if ([CallBackObject respondsToSelector:func_selector]) {
                                       NSLog(@"回调成功...");
                                       [CallBackObject performSelector:func_selector withObject:dict];
                                   }else{
                                       NSLog(@"回调失败...");
                                       [SVProgressHUD dismiss];
                                   }
                               }
                           }];
}






#pragma mark 赋值回调
- (void)setDelegateObject:(id)cbobject setBackFunctionName:(NSString *)selectorName
{
    CallBackObject = cbobject;
    
    callBackFunctionName = selectorName;
}

-(void)getProvince{
    NSString *url = [NSString stringWithFormat:@"%@LoginAndRegister.asmx/GetProvince",Url];
    [self PostRequest:url andpram:nil];
}

-(void)getCityByProvinceCode:(NSString *)provinceCode{
    NSString *url = [NSString stringWithFormat:@"%@LoginAndRegister.asmx/GetCityByProvince",Url];
    NSDictionary *prm = @{@"provinceCode":provinceCode};
    [self PostRequest:url andpram:prm];
}

-(void)getCountryByCityCode:(NSString *)cityCode{
    NSString *url = [NSString stringWithFormat:@"%@LoginAndRegister.asmx/GetCountyByCity",Url];
    NSDictionary *prm = @{@"cityCode":cityCode};
    [self PostRequest:url andpram:prm];
}

-(void)PostRequest:(NSString *)url andpram:(NSDictionary *)pram
{
    AFHTTPRequestOperationManager * manage=[[AFHTTPRequestOperationManager alloc] init];
    manage.responseSerializer=[AFHTTPResponseSerializer serializer];
    manage.requestSerializer=[AFHTTPRequestSerializer serializer];
    manage.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/plain"];//可接收到的数据类型
    manage.requestSerializer.timeoutInterval=20;//设置请求时限
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
        NSLog(@"check time 1");
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
//        [SVProgressHUD dismiss];
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

-(NSDictionary *)getUserInfoByUserID:(NSString *)userID
{
    BOOL isTrue = false;
    NSString * urlstr=[NSString stringWithFormat:@"%@LoginAndRegister.asmx/UpdateUser",Url];
    NSURL *url = [NSURL URLWithString:urlstr];
    NSMutableURLRequest *urlrequest = [[NSMutableURLRequest alloc]initWithURL:url];
    urlrequest.HTTPMethod = @"POST";
    NSString *bodyStr = [NSString stringWithFormat:@"userid=%@",userID];
    NSData *body = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    urlrequest.HTTPBody = body;
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlrequest];
    requestOperation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [requestOperation start];
    [requestOperation waitUntilFinished];
    
    NSData * data =[requestOperation.responseString dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSRange range = [requestOperation.responseString rangeOfString:@"\"msg\":\"0\""];
    if (range.location != NSNotFound) {
        isTrue = true;
    }
    if (!isTrue) {
        //SHOWALERT(@"错误", @"您需要联系开发人员");
    }
    return  dict;
}

- (void)uploadImageWithImage:(NSString *)imagePath andurl:(NSString *)url andprm:(NSDictionary *)prm
{
    NSData *data=[NSData dataWithContentsOfFile:imagePath];
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:prm constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"filestream" fileName:@"avatar.jpg" mimeType:@"image/jpg"];
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

- (void)UploadImageWithImage:(NSData *)imagedata andurl:(NSString *)url andprm:(NSDictionary *)prm
{
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:prm constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imagedata name:@"filestream" fileName:@"showorder_img.jpg" mimeType:@"image/jpg"];
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


- (void)uploadVideoWithFilePath:(NSURL *)videoPath andurl:(NSString *)url andprm:(NSDictionary *)prm
{
    NSData *itemdata=[NSData dataWithContentsOfURL:videoPath];
//    
//    NSData * data=[[NSData alloc] initWithBase64EncodedData:itemdata options:0];
    
    
    // Get NSString from NSData object in Base64
    NSString *base64Encoded = [itemdata base64EncodedStringWithOptions:0];
    
    
    // NSData from the Base64 encoded str
    NSData *data = [[NSData alloc]initWithBase64EncodedString:base64Encoded options:0];
    
    
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:prm constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"filestream" fileName:@"video.mov" mimeType:@"video/quicktime"];
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
// 将字典或者数组转化为JSON串
- (NSData *)toJSONData:(id)theData{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}

@end
