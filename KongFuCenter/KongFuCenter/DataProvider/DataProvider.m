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

- (NSInteger )voiceAction:(NSString *)Id andUserId:(NSString *)userId andFlg:(NSString *)flg
{
    if(Id != nil && userId != nil && flg != nil)
    {
        
        NSString * url=[NSString stringWithFormat:@"%@Hewuzhe.asmx/MessageRepeatAndFavorite",Url];
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

//获取其他作品
-(NSInteger )getUserid:(NSString *)userId andNum:(NSString *)num
{
    
    if(userId != nil && num != nil)
    {
        
        NSString * url=[NSString stringWithFormat:@"%@Hedongli.asmx/GetOtherVideo",Url];
        NSDictionary * prm=@{@"userid":userId,
                             @"num":num};
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
- (NSInteger )growCateid:(NSString *)cateid andStartRowIndex:(NSString *)startRowIndex andMaximumRows:(NSString *)maximumRows
{
    if(startRowIndex != nil && cateid != nil && maximumRows != nil)
    {
        
        NSString * url=[NSString stringWithFormat:@"%@Helianmeng.asmx/GetDongtaiPageByLianmeng",Url];
        NSDictionary * prm=@{@"cateid":cateid,
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


-(NSInteger)setUserInfo:(NSString *)userId andNickName:(NSString *)nicname andSex:(NSString *)sexuality andHeight:(NSString *)height andWeight:(NSString *)weight andAddr:(NSString *)homeAreaId andExpe:(NSString *)experience andDescription:(NSString *)description
{
   
    
    if(userId != nil&&nicname != nil&&sexuality != nil&&height != nil&&weight != nil&&homeAreaId != nil&&experience != nil&&description)
    {
        
        NSString * url=[NSString stringWithFormat:@"%@LoginAndRegister.asmx/ChangeInfor",Url];
        NSDictionary * prm=@{@"userid":userId,
                             @"nicname":nicname,
                             @"sexuality":sexuality,
                             @"height":height,
                             @"weight":weight,
                             @"homeAreaId":homeAreaId,
                             @"experience":experience,
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

-(NSInteger)getStudyOnlineVideoList:(NSString *)categoryid andstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows
{
    if(categoryid != nil&&startRowIndex&&maximumRows)
    {
        
        NSString * url=[NSString stringWithFormat:@"%@Hewuzhe.asmx/GetOnlineStudyListByPage",Url];
        NSDictionary * prm=@{@"categoryid":categoryid,@"startRowIndex":startRowIndex,@"maximumRows":maximumRows};
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
-(NSInteger)getStudyOnlineVideoDetial:(NSString *)videoid
{
    if(videoid != nil)
    {
        
        NSString * url=[NSString stringWithFormat:@"%@Hewuzhe.asmx/GetOnlineStudy",Url];
        NSDictionary * prm=@{@"id":videoid};
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



#pragma mark - 武馆

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

-(void)SelectTeamPage:(NSString *)startRowIndex andMaximumRows:(NSString *)maximumRows andName:(NSString *)name andAreaid:(NSString *)citycode{
    if (startRowIndex && maximumRows) {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/SelectTeamPage",Url];
        NSDictionary *prm = @{@"startRowIndex":startRowIndex,@"maximumRows":maximumRows,@"name":name,@"citycode":citycode};
        [self PostRequest:url andpram:prm];
    }
}

-(void)JoinTeam:(NSString *)userid andTeamId:(NSString *)teamid andName:(NSString *)name{
    if (userid && teamid && name) {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/JoinTeam",Url];
        NSDictionary *prm = @{@"userid":userid,@"teamid":teamid,@"name":name};
        [self PostRequest:url andpram:prm];
    }
}

-(void)GetFriendBySearch:(NSString *)startRowIndex andMaximumRows:(NSString *)maximumRows andNicName:(NSString *)nicName andAreaId:(NSString *)areaId andAge:(NSString *)age andSexuality:(NSString *)sexuality andUserid:(NSString *)userid{
    NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/GetFriendBySearch",Url];
    NSDictionary *prm = @{@"startRowIndex":startRowIndex,@"maximumRows":maximumRows,@"nicName":nicName,@"areaId":areaId,@"age":age,@"sexuality":sexuality,@"userid":userid};
    [self PostRequest:url andpram:prm];
}

-(void)SaveFriend:(NSString *)userid andFriendid:(NSString *)friendid{
    if (userid && friendid) {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/SaveFriend",Url];
        NSDictionary *prm = @{@"userid":userid,@"friendid":friendid};
        [self PostRequest:url andpram:prm];
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
    }
}

-(void)getTeamMember:(NSString *)teamid
{
    if(teamid)
    {
        NSString *url = [NSString stringWithFormat:@"%@Helianmeng.asmx/SelectTeamMember",Url];
        NSDictionary *prm = @{@"teamid":teamid};
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
        
    }

}

#pragma mark 核动力
-(void)uploadVideoWithPath:(NSURL *)videoPath
{
    if (videoPath) {
        NSString *url = [NSString stringWithFormat:@"%@Hewuzhe.asmx/UpLoadVideo",Url];
        NSData* imageData = [[NSData alloc] initWithContentsOfURL:videoPath];
        NSString *imagebase64= [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        
        NSDictionary *prm = @{@"fileName":@"video.mov",@"filestream":imagebase64};
        [self PostRequest:url andpram:prm];
        //        [self uploadVideoWithFilePath:videoPath andurl:url andprm:prm];
    }
}

-(void)GetNewVideoList:(NSString * )startRowIndex andmaximumRows:(NSString *)maximumRows
{
    if (startRowIndex && maximumRows) {
        NSString *url = [NSString stringWithFormat:@"%@Hedongli.asmx/NewVideo",Url];
        NSDictionary *prm = @{@"startRowIndex":startRowIndex,@"maximumRows":maximumRows};
        [self PostRequest:url andpram:prm];
    }
}
-(void)GetHotVideoList:(NSString * )startRowIndex andmaximumRows:(NSString *)maximumRows
{
    if (startRowIndex && maximumRows) {
        NSString *url = [NSString stringWithFormat:@"%@Hedongli.asmx/HotVideo",Url];
        NSDictionary *prm = @{@"startRowIndex":startRowIndex,@"maximumRows":maximumRows};
        [self PostRequest:url andpram:prm];
    }
}
-(void)GetTuiJianVideoList:(NSString * )startRowIndex andmaximumRows:(NSString *)maximumRows
{
    if (startRowIndex && maximumRows) {
        NSString *url = [NSString stringWithFormat:@"%@Hedongli.asmx/TuijianVideo",Url];
        NSDictionary *prm = @{@"startRowIndex":startRowIndex,@"maximumRows":maximumRows};
        [self PostRequest:url andpram:prm];
    }
}
-(void)GetYuanChuangVideoList:(NSString * )startRowIndex andmaximumRows:(NSString *)maximumRows
{
    if (startRowIndex && maximumRows) {
        NSString *url = [NSString stringWithFormat:@"%@Hedongli.asmx/YuanchuangVideo",Url];
        NSDictionary *prm = @{@"startRowIndex":startRowIndex,@"maximumRows":maximumRows};
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

-(void)GetVideoByCategory:(NSString * )startRowIndex andmaximumRows:(NSString *)maximumRows andcateid:(NSString *)cateid
{
    if (startRowIndex && maximumRows&&cateid) {
        NSString *url = [NSString stringWithFormat:@"%@Hedongli.asmx/SelectVideoByCategory",Url];
        NSDictionary *prm = @{@"startRowIndex":startRowIndex,@"maximumRows":maximumRows,@"cateid":cateid};
        [self PostRequest:url andpram:prm];
    }
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

@end
