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
 *  修改密码
 *
 *  @param phone   电话
 *  @param password  密码
 */

-(void)frogetPassWord:(NSString *)phone andPassWord:(NSString *)password;
/**
 *  第三方登录
 *
 *  @param openid   openin
 *  @param nicname  昵称
 */
-(void)thridLogin:(NSString *)openid andUserName:(NSString *)nicname;
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
 * @param description 个人简历
 * @param birthday 生日
 *
 */
-(NSInteger)setUserInfo:(NSString *)userId andNickName:(NSString *)nicname andSex:(NSString *)sexuality andHeight:(NSString *)height andWeight:(NSString *)weight andAddr:(NSString *)homeAreaId andExpe:(NSString *)experience andDescription:(NSString *)description andBirthday:(NSString *)birthday;
/**
 *  上传用户头像
 *
 *  @param userId    用户id
 *  @param filestream  图片数据
 *  @param fileName     头像上传
 *
 */
-(NSInteger)uploadHeadImg:(NSString *)userId andImgData:(NSString *)filestream  andImgName:(NSString *)fileName;

//修改密码
-(void)ChangePassWord:(NSString *)userid andoldpwd:(NSString *)oldpwd andpassword:(NSString *)password;
#pragma mark - 成长记录
-(void)getGrowHistory:(NSString *)userid andstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows;

#pragma mark - 放飞梦想
//
-(void)getTheirDream;
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
 *  @param userid     用户id
 */
-(NSInteger)getStudyOnlineVideoDetial:(NSString *)videoid andUserId:(NSString *)userid;
#pragma mark - 支付
-(void)getPingppCharge:(NSString *)userid andChannel:(NSString *)channel andAmount:(NSString *)amount andDescription:(NSString *)description;

#pragma mark - 武馆
//根据城市名和经纬度获取武馆
-(void)getWuguanList:(NSString*)areaname andLat:(NSString *)lat andLng:(NSString *)lng andStartRowIndex:(NSString *)startRowIndex andMaximumRows:(NSString *)maximumRows;

//根据城市获取武馆
-(NSInteger)getWuGuanList:(NSString *)cityid andStartRowIndex:(NSString *)startRowIndex andMaximumRows:(NSString *)maximumRows;

/**
 *  获取武馆详情
 *
 *  @param wuGuanId   武馆id
 *
 */

-(void)getWuguanDetail:(NSString *)wuGuanId;
/**
 *  获取武馆相关图片
 *
 *  @param messageid   武馆id
 *
 */

-(void)getWuguanPic:(NSString *)messageid;
#pragma mark - 训练计划
//保存计划
-(void)updatePlan:(NSString *)userid andCateId:(NSString *)cateid andTitle:(NSString *)title andContent:(NSString *)content andPicList:(NSString *)piclist andStartDate:(NSString *)starttime andEndDate:(NSString *)endtime;

//获取训练计划
-(void)getPlanInfo:(NSString *)userid andCateId:(NSString *)cateid andStartRow:(NSString *)startRowIndex andMaxNumRows:(NSString *)maximumRows;
//删除计划
-(void)delePlan:(NSString*)planId;

#pragma mark - 核联盟
//获取好友信息
-(void)getFriendForKeyValue:(NSString *)uid;

//获取战队介绍
-(void)SelectTeam:(NSString *)teamId;

//获取战队列表
-(void)SelectTeamPage:(NSString *)startRowIndex andMaximumRows:(NSString *)maximumRows andName:(NSString *)name andCitycode:(NSString *)citycode;

//加入战队
-(void)JoinTeam:(NSString *)userid andTeamId:(NSString *)teamid andName:(NSString *)name;
//退出战队
-(void)quitTeam:(NSString *)userid andTeamID:(NSString *)teamid;

//获取省
-(void)getProvince;

//根据省获取市
-(void)getCityByProvinceCode:(NSString *)provinceCode;

//根据市获取县
-(void)getCountryByCityCode:(NSString *)cityCode;

//删除好友
-(void)DeleteFriend:(NSString *)userid andfriendid:(NSString *)friendid;

//删除视频
-(void)delVideo:(NSString *)VideoId;

//上传视频
-(void)uploadVideoWithPath:(NSURL *)videoPath;
//根据条件获取用户
-(void)GetFriendBySearch:(NSString *)startRowIndex andMaximumRows:(NSString *)maximumRows andNicName:(NSString *)nicName andAreaCode:(NSString *)areaCode andAge:(NSString *)age andSexuality:(NSString *)sexuality andUserid:(NSString *)userid;

//添加武友
-(void)SaveFriend:(NSString *)userid andFriendid:(NSString *)friendid;

//获取武友动态
-(void)GetDongtaiPageByFriends:(NSString *)userid andstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows;
//获取所有市列表
-(void) getAllCitys;
//上传图片
//-(NSInteger)uploadImgWithData:(NSData *)imgData andImgName:(NSString *)imgName;
-(void)UploadImgWithImgdata:(NSString *)imageData;

/*
我的收藏
 */
- (NSInteger )collectData:(NSString *)userId andIsVideo:(NSString *)isVideo  andStartRowIndex:(NSString *)startRowIndex andMaximumRows:(NSString *)maximumRows;
-(NSInteger)setCollect:(NSString *)userId andIsVideo:(NSString *)isVideo andStartRowIndex:(NSString *)startRowIndex andMaximumRowst:(NSString *)maximumRows;

//视频(我的收藏)
- (NSInteger )voiceAction:(NSString *)Id andUserId:(NSString *)userId andFlg:(NSString *)flg;
- (NSInteger )voicedelete:(NSString *)Id andUserId:(NSString *)userId andFlg:(NSString *)flg;
//获取评论的信息
-(NSInteger )getMessageIdInfo:(NSString *)messageId;

//获取其他作品
-(NSInteger )getUserid:(NSString *)userId andNum:(NSString *)num andmessageID:(NSString *)messageID;

//分页获取联盟动态
- (NSInteger )growCateid:(NSString *)cateid andStartRowIndex:(NSString *)startRowIndex andMaximumRows:(NSString *)maximumRows;

//获取联盟动态横向分类
-(NSInteger )getlianmengdongtai;

//积分
-(void)getJiFenList:(NSString *)userid andStartRow:(NSString *)startRowIndex andMaxNumRows:(NSString *)maximumRows;

//是否是武友
-(void)IsWuyou:(NSString *)userid andfriendid:(NSString *)friendid;

//对主题进行评论
-(void)MessageComment:(NSString *)mid anduserid:(NSString *)userid andcomment:(NSString *)comment;

//对回复进行评论
-(void)CommentComment:(NSString *)mid anduserid:(NSString *)userid andcomment:(NSString *)comment;

//成长记录数据
- (NSInteger )growUserId:(NSString *)userId andStartRowIndex:(NSString *)startRowIndex andMaximumRows:(NSString *)maximumRows;

//上传动态
-(void)SaveDongtai:(NSString *)userid andcontent:(NSString *)content andpathlist:(NSString *)pathlist andvideoImage:(NSString *)videoImage andvideopath:(NSString *)videopath andvideoDuration:(NSString *)videoDuration;

//获取我的动态
-(void)SelectDongtaiByFriendId:(NSString *)friendid andstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows;
//获取我的动态所有评论信息
-(void)GetMyDongtaiPage:(NSString *)userid andstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows;
//根据动态ID获取动态信息
-(void)GetDongtaiById:(NSString *)userid andmessid:(NSString *)messid;

//获取招聘合作横向分类
-(void)GetCateForHezuo;

//获取招聘合作信息
-(void)GetHezuoListByPage:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows andcategoryid:(NSString *)categoryid;

//获取江湖故事分类
-(void)GetCateForJianghu;

//获取江湖故事列表
-(void)GetJianghuListByPage:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows andcategoryid:(NSString *)categoryid;

//分页查询个人赛事
-(void)SelectMatchPageByPerson:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows;

//分页查询战队赛事
-(void)SelectMatchPageByTeam:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows;

//获取赛事详情
-(void)SelectMatchDetail:(NSString *)matchId anduserId:(NSString *)userId;

//个人比赛报名
-(void)JoinMatch:(NSString *)matchId anduserid:(NSString *)userid andmatchVideo:(NSString *)matchVideo andmatchImage:(NSString *)matchImage andmatchDescription:(NSString *)matchDescription andtitle:(NSString *)title;

//查询比赛参赛人员
-(void)SelectAllMatchMemberBySearch:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows andmatchId:(NSString *)matchId andmembercode:(NSString *)membercode andnicname:(NSString *)nicname andflg:(NSString *)flg;

//查询比赛参赛战队
-(void)SelectAllMatchTeamBySearch:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows andmatchId:(NSString *)matchId andmembercode:(NSString *)membercode andnicname:(NSString *)nicname andflg:(NSString *)flg;

//查看参赛人员明细
-(void)SelectMatchMemberDetail:(NSString *)matchId anduserid:(NSString *)userid;

//个人比赛取消报名
-(void)CancleJoinMatch:(NSString *)matchId anduserid:(NSString *)userid;

#pragma mark - 视频评论
// 评论视频
-(void)commentVideo:(NSString *)videoId andUserId:(NSString *)userid andComment:(NSString *)comment;


#pragma mark － 战队动态
-(void)getSelfTeamNews:(NSString *)userid andStartRowIndex:(NSString *)startRowIndex andMaximumRows:(NSString *)maximumRows;
//获取其他战队状态
-(void)getOtherTeamNews:(NSString *)teamid andStartRowIndex:(NSString *)startRowIndex andMaximumRows:(NSString *)maximumRows;
//获取战队成员
-(void)getTeamMember:(NSString *)teamid;
//获取战队介绍　
-(void)getTeamIntro:(NSString *)teamid;
//删除评论
-(void)delComment:(NSString*)messageID;
//获取战队公告
-(void)getTeamAnnouncement:(NSString *)teamid andStartRowIndex:(NSString *)startRowIndex andMaximumRows:(NSString *)maximumRows;


#pragma mark - 联盟动态
-(void)getUnionNewsCate;

#pragma mark 核动力
//获取最新视频列表
-(void)GetNewVideoList:(NSString * )startRowIndex andmaximumRows:(NSString *)maximumRows;
//获取热门视频列表
-(void)GetHotVideoList:(NSString * )startRowIndex andmaximumRows:(NSString *)maximumRows;
//获取推荐视频列表
-(void)GetTuiJianVideoList:(NSString * )startRowIndex andmaximumRows:(NSString *)maximumRows;
//获取原创视频列表
-(void)GetYuanChuangVideoList:(NSString * )startRowIndex andmaximumRows:(NSString *)maximumRows;
//获取视频频道
-(void)GetChinnel:(NSString * )startRowIndex andmaximumRows:(NSString *)maximumRows;
//保存视频信息
-(void)SendVideoInfo:(NSDictionary *)prm;
//根据视频频道获取视频列表
-(void)GetVideoByCategory:(NSString * )startRowIndex andmaximumRows:(NSString *)maximumRows andcateid:(NSString *)cateid;
@end
