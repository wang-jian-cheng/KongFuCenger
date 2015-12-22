//
//  DataProvider.h
//  BuerShopping
//
//  Created by 于金祥 on 15/5/30.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataProvider : NSObject
{
    id CallBackObject;
    NSString * callBackFunctionName;
}
/**
 *  设置回调函数
 *
 *  @param cbobject     回调对象
 *  @param selectorName 回调函数
 */
- (void)setDelegateObject:(id)cbobject setBackFunctionName:(NSString *)selectorName;


#pragma mark - login and reg
/**
 *  登陆
 *
 *  @param account   账户
 *  @param password  密码
 */
-(NSInteger)login:(NSString*)account andPassWord:(NSString *)password;
/**
 *  注册
 *
 *  @param phone    电话
 *  @param password 设置密码
 */
-(NSInteger)reg:(NSString*)phone andPassWord:(NSString *)password;
/**
 *  注册并登录
 *
 *  @param phone    电话
 *  @param password 设置密码
 */
-(NSInteger)regAndLogin:(NSString*)account andPassWord:(NSString *)password;
/**
 *  获取用户信息
 *
 *  @param userId    用户id
 *
 */
-(NSInteger)getUserInfo:(NSString *)userId;


/**
 *  修改用户信息
 *
 * @param userid 用户ID
 * @param nicname 昵称
 * @param sexuality 性别 0：未知 1：男 2：女
 * @param height 身高 单位/CM
 * @param weight 体重 单位/KG
 * @param homeAreaId 地址
 * @param experience 习武经历 单位/年
 *
 */
-(NSInteger)setUserInfo:(NSString *)userId andNickName:(NSString *)nicname andSex:(NSString *)sexuality andHeight:(NSString *)height andWeight:(NSString *)weight andAddr:(NSString *)homeAreaId andExpe:(NSString *)experience;
#pragma mark - 放飞梦想
/**
 *  获取用户梦想
 *
 *  @param userId    用户id
 *
 */
-(NSInteger)getMyDream:(NSString *)userid;
/**
 *  设置梦想
 *
 *  @param userId    用户id
 *
 */
-(NSInteger)setMyDream:(NSString *)userid andMyDream:(NSString *)mydream andHow:(NSString *)realizedream;
#pragma mark - 在线学习
/**
 *  获取在线学习主分类
 *
 *
 *
 */
-(NSInteger)getStudyOnlineMainCategory;
/**
 *  获取在线学习二级分类
 *
 *  @param categoryid    一级分类id
 *
 */
-(NSInteger)getStudyOnlineSecundCategory:(NSString *)categoryid;
/**
 *  获取在线学习视频列表
 *
 *  @param categoryid    二级分类id
 *
 */
-(NSInteger)getStudyOnlineVideoList:(NSString *)categoryid andstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows;

/**
 *  获取在线学习视频详情
 *
 *  @param videoid    视频id
 *
 */
-(NSInteger)getStudyOnlineVideoDetial:(NSString *)videoid;


#pragma mark - 核联盟
//获取好友信息
-(void)getFriendForKeyValue:(NSString *)uid;

//获取战队介绍
-(void)SelectTeam:(NSString *)teamId;

//获取战队列表
-(void)SelectTeamPage:(NSString *)startRowIndex andMaximumRows:(NSString *)maximumRows andName:(NSString *)name andAreaid:(NSString *)citycode;

//加入战队
-(void)JoinTeam:(NSString *)userid andTeamId:(NSString *)teamid andName:(NSString *)name;

//获取省
-(void)getProvince;

//根据省获取市
-(void)getCityByProvinceCode:(NSString *)provinceCode;

//根据市获取县
-(void)getCountryByCityCode:(NSString *)cityCode;

//上传视频
-(void)uploadVideoWithPath:(NSURL *)videoPath;
//根据条件获取用户
-(void)GetFriendBySearch:(NSString *)startRowIndex andMaximumRows:(NSString *)maximumRows andNicName:(NSString *)nicName andAreaId:(NSString *)areaId andAge:(NSString *)age andSexuality:(NSString *)sexuality andUserid:(NSString *)userid;

//添加武友
-(void)SaveFriend:(NSString *)userid andFriendid:(NSString *)friendid;

//根据城市获取武馆
-(NSInteger)getWuGuanList:(NSString *)cityid andStartRowIndex:(NSString *)startRowIndex andMaximumRows:(NSString *)maximumRows;
//获取所有市列表
-(void) getAllCitys;
//上传图片
-(NSInteger)uploadImgWithData:(NSData *)imgData andImgName:(NSString *)imgName;
-(void)UploadImgWithImgdata:(NSString *)imagePath;


@end
