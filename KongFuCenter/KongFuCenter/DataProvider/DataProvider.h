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
#pragma mark － 天气
-(void)getWeatherInfo: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg;
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
-(NSInteger)getStudyOnlineVideoList:(NSString *)categoryid andstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows andSearch:(NSString *)search;

/**
 *  获取在线学习视频详情
 *
 *  @param videoid    视频id
 *  @param userid     用户id
 */
-(NSInteger)getStudyOnlineVideoDetial:(NSString *)videoid andUserId:(NSString *)userid;

#pragma mark - 视频直播
//分页获取视频直播列表
-(void)SelectVideoLiveList:(NSString *)userid andstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows;

//根据ID获取视频直播
-(void)SelectVideoLive:(NSString *)userid andvideoLiveId:(NSString *)videoLiveId;

#pragma mark - 支付
-(void)getPingppCharge:(NSString *)userid andChannel:(NSString *)channel andAmount:(NSString *)amount andDescription:(NSString *)description andFlg:(NSString *)flg;
//成为会员
-(void)becomeVip:(NSString *)userid andMonth:(NSString *)month;
-(void)getVipTime:(NSString *)userid;
-(void)closeVip:(NSString *)userid;
//举报会员
-(void)ReportUser:(NSString *)userId andTargetId:(NSString *)targetId andContent:(NSString *)content;
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
- (NSInteger )voiceAction:(NSString *)Id andUserId:(NSString *)userId andFlg:(NSString *)flg andDescription:(NSString *)description;
- (NSInteger )voicedelete:(NSString *)Id andUserId:(NSString *)userId andFlg:(NSString *)flg;
//获取评论的信息
-(NSInteger )getMessageIdInfo:(NSString *)messageId;

//获取其他作品
-(NSInteger )getUserid:(NSString *)userId andNum:(NSString *)num andmessageID:(NSString *)messageID;


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
-(void)GetHezuoListByPage:(NSString *)startRowIndex andUserId:(NSString *)userid andmaximumRows:(NSString *)maximumRows andcategoryid:(NSString *)categoryid;
//获取江湖故事分类
-(void)GetCateForJianghu;

//获取江湖故事列表
-(void)GetJianghuListByPage:(NSString *)startRowIndex andUserId:(NSString *)userid andmaximumRows:(NSString *)maximumRows andcategoryid:(NSString *)categoryid;
//分页查询个人赛事
-(void)SelectMatchPageByPerson:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows;

//分页查询战队赛事
-(void)SelectMatchPageByTeam:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows;

//获取赛事详情
-(void)SelectMatchDetail:(NSString *)matchId anduserId:(NSString *)userId;

//个人比赛报名
-(void)JoinMatch:(NSString *)matchId anduserid:(NSString *)userid andmatchVideo:(NSString *)matchVideo andmatchImage:(NSString *)matchImage andmatchDescription:(NSString *)matchDescription andtitle:(NSString *)title andvideoDuration:(NSString *)videoDuration;

//查询比赛参赛人员
-(void)SelectAllMatchMemberBySearch:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows andmatchId:(NSString *)matchId andmembercode:(NSString *)membercode andnicname:(NSString *)nicname andflg:(NSString *)flg;

//查询比赛参赛战队
-(void)SelectAllMatchTeamBySearch:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows andmatchId:(NSString *)matchId andmembercode:(NSString *)membercode andnicname:(NSString *)nicname andflg:(NSString *)flg;

//查看参赛人员明细
-(void)SelectMatchMemberDetail:(NSString *)matchId anduserid:(NSString *)userid andMyId:(NSString *)myId;
//查看参赛战队

-(void)getTeamDetailForMatch:(NSString *)matchId andTeamId:(NSString *)teamid andmyId:(NSString *)myId;
//个人比赛取消报名
-(void)CancleJoinMatch:(NSString *)matchId anduserid:(NSString *)userid;
//根据好友ID查询用户视图
-(void)SelectMyFriend:(NSString *)userid andfriend:(NSString *)friendid;

//获取武者动态未查看数
-(void)GetNoReadCommentNumByUserId:(NSString *)userid;

//清空未读赛事个数
-(void)DeleteNoReadMatch:(NSString *)userId andFlg:(NSString *)flg;

//获取未读赛事个数
-(void)SelectNoReadMatch:(NSString *)userId;

//删除被关注列表武友
-(void)DeleteFriended:(NSString *)friendListId;

#pragma mark - 战队赛事评论
-(void)getMatchComment:(NSString *)memberId andstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows;
-(void)commentMatch:(NSString *)memberId andUserID:(NSString *)userId andComment:(NSString *)comment;
//给战队投票
-(void)voteTeam:(NSString *)matchId andTeamId:(NSString *)teamid andUserId:(NSString *)voterId;
//给队员投票
-(void)votePerson:(NSString *)matchId andUserid:(NSString *)userid andUserId:(NSString *)voterId;
//获取被关注列表
-(void)SelectFriended:(NSString *)userid;

#pragma mark - 视频评论
// 评论视频
-(void)commentVideo:(NSString *)videoId andUserId:(NSString *)userid andComment:(NSString *)comment;

#pragma mark － 武友相关
//屏蔽武友动态
-(void)ShieldFriendNew:(NSString *)userid andFriendid:(NSString *)friendid;
//取消屏蔽
-(void)UnShieldFriend:(NSString *)userid andFriendId:(NSString *)friendid;
//屏蔽武友消息
-(void)ShieldFriendMessage:(NSString *)userid andFriendId:(NSString *)friendid;
//取消屏蔽武友消息
-(void)UnShieldFriendMessage:(NSString *)userid andFriendId:(NSString *)friendid;

#pragma mark － 战队动态
-(void)getSelfTeamNews:(NSString *)userid andStartRowIndex:(NSString *)startRowIndex andMaximumRows:(NSString *)maximumRows;
//获取其他战队状态
-(void)getOtherTeamNews:(NSString *)teamid andStartRowIndex:(NSString *)startRowIndex andMaximumRows:(NSString *)maximumRows;
//获取战队成员
-(void)getTeamMember:(NSString *)teamid andUserId:(NSString *)userid;
//获取战队介绍　
-(void)getTeamIntro:(NSString *)teamid;
//删除评论
-(void)delComment:(NSString*)messageID;
//获取战队公告
-(void)getTeamAnnouncement:(NSString *)teamid andStartRowIndex:(NSString *)startRowIndex andMaximumRows:(NSString *)maximumRows;


#pragma mark - 联盟动态
-(void)getUnionNewsCate;
//分页获取联盟动态
- (NSInteger )growCateid:(NSString *)cateid andUserId:(NSString *)userid andStartRowIndex:(NSString *)startRowIndex andMaximumRows:(NSString *)maximumRows;
#pragma mark 核动力
//获取最新视频列表
-(void)GetNewVideoList:(NSString * )startRowIndex andmaximumRows:(NSString *)maximumRows andSearch:(NSString *)search;
//获取热门视频列表
-(void)GetHotVideoList:(NSString * )startRowIndex andmaximumRows:(NSString *)maximumRows andSearch:(NSString *)search;
//获取推荐视频列表
-(void)GetTuiJianVideoList:(NSString * )startRowIndex andmaximumRows:(NSString *)maximumRows andSearch:(NSString *)search;
//获取原创视频列表
-(void)GetYuanChuangVideoList:(NSString * )startRowIndex andmaximumRows:(NSString *)maximumRows andSearch:(NSString *)search;
//获取视频频道
-(void)GetChinnel:(NSString * )startRowIndex andmaximumRows:(NSString *)maximumRows;
//保存视频信息
-(void)SendVideoInfo:(NSDictionary *)prm;
//根据视频频道获取视频列表
-(void)GetVideoByCategory:(NSString * )startRowIndex andmaximumRows:(NSString *)maximumRows andcateid:(NSString *)cateid andSearch:(NSString *)search;
//设置备注名
-(void)SetNickName:(NSString *)userid andfriend:(NSString *)friend andrname:(NSString *)rname;
//获取用户信息带备注名称
-(NSInteger)getUserInfo:(NSString *)userId andfriendid:(NSString *)friendid;

#pragma mark - 核装备

/**
 * 获取首页轮播图
 */
-(void)getIndexLunbo;
//获取一级分类
-(void)SelectBigCategory;

//获取小分类
-(void)SelectSmallCategory:(NSString *)parentId;

//根据ID查询商品详情和第一页评论
-(void)SelectProduct:(NSString *)sid anduserid:(NSString *)userid andmaximumRows:(NSString *)maximumRows;
/**
 *  保存商品评论
 *
 *  @param commlist <#commlist description#>
 */
-(void)SaveComment:(NSArray *)commlist andbillid:(NSString *)billid;

//startRowIndex 开始行索引
//maximumRows 每页条数
//search 搜索内容
//categoryId 类别ID 不按照类别搜索传0
//isPriceAsc 是否价格升序 0：默认 1：升序 2：降序
//isSalesAsc 是否销量升序 0：默认 1：升序 2：降序
//isCommentAsc 是否好评升序 0：默认 1：升序 2：降序
//isNewAsc 是否最新升序 0：默认 1：升序 2：降序
//isCredit 是否可以兑换 0：积分兑换 1：购买
//分页查询商品列表
-(void)SelectProductBySearch:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows andsearch:(NSString *)search andcategoryId:(NSString *)categoryId andisPriceAsc:(NSString *)isPriceAsc andisSalesAsc:(NSString *)isSalesAsc andisCommentAsc:(NSString *)isCommentAsc andisNewAsc:(NSString *)isNewAsc andisCredit:(NSString *)isCredit andisRecommend:(NSString *)isRecommend;

//根据商品ID收藏商品
-(void)FavoriteProduct:(NSString *)userId andproductId:(NSString *)productId;

//根据商品ID取消收藏商品
-(void)CancleFavoriteProduct:(NSString *)userId andproductId:(NSString *)productId;

//立即购买
-(void)BuyNow:(NSString *)productId andnum:(NSString *)num andpriceId:(NSString *)priceId anduserId:(NSString *)userId andprice:(NSString *)price anddeliveryId:(NSString *)deliveryId anddescription:(NSString *)description;

//加入购物车
-(void)InsertBasket:(NSString *)productId andnum:(NSString *)num andpriceId:(NSString *)priceId anduserId:(NSString *)userId andprice:(NSString *)price;

//根据商品ID查询商品评论
-(void)SelectCommentByProductId:(NSString *)productId andstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows;

//首页查询商品推荐分类并显示推荐商品
-(void)GetRecomendCategoryAndProduct:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows anduserId:(NSString *)userId andproductNum:(NSString *)productNum;

/**
 * 积分兑换
 */
-(void)payByjiFen:(NSString *)userId andProductId:(NSString *)productId andNum:(NSString *)num andDeliveryId:(NSString *)deliveryId andDescription:(NSString *)description;

//根据订单ID获取订单详情
-(void)SelectBillProduct:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows andbillId:(NSString *)billId;

#pragma mark - 购物车
/**
 获取购物车列表
 */
-(void)getShoppingCartList:(NSString *)userId andstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows;
/**
 批量删除
 */
-(void)delShopCartGoods:(NSString *)userId andIdList:(NSString *)idList;
/**
 修改商品数量
 */
-(void)changeCartGoodNum:(NSString *)userId andGoodId:(NSString *)Id andNum:(NSString *)num;
/**
 获取邮费
 */
-(void)getPostage:(NSString *)userId andGoodIds:(NSString *)idList;
#pragma mark - 订单
/**
 获取订单列表
 */
-(void)getOrderList:(NSString *)userId andState:(NSString *)state andProNum:(NSString *)proNum andStartRowIndex:(NSString *)startRowIndex andMaximumRows:(NSString *)maximumRows;

//查询全部收货地址
-(void)SelectAllDeliveryAddress:(NSString *)userId;

//编辑收货地址   addressId:0-添加  其它对应地址id编辑
-(void)EditDeliveryAddress:(NSString *)addressId andareaId:(NSString *)areaId andaddress:(NSString *)address andisDefaul:(NSString *)isDefaul anduserId:(NSString *)userId andreceiverName:(NSString *)receiverName andphone:(NSString *)phone andcodeForAddress:(NSString *)codeForAddress;
/**
    购物车结算
 */
-(void)buyInShoppingCart:(NSString *)userId andDeliveryId:(NSString *)deliveryId andDescription:(NSString *)description andBasketDeatilIdList:(NSString *)basketDeatilIdList;

/**
 获取charge
 
 userid 用户ID
 channel 支付方式
 amount 金额
 description 描述
 flg 类型 0：充值会员 1：购买商品
 billId 订单号
 
 */
-(void)getChargeForShopping:(NSString *)userid andChannel:(NSString *)channel andAmount:(NSString *)amount andDescription:(NSString *)description andFlg:(NSString *)flg andBillId:(NSString *)billId;
/**
 根据id获取收货地址
 */
-(void)getAddrById:(NSString *)Id;
/**
 确认收货
 */
-(void)sureForOrder:(NSString *)userId andBillId:(NSString *)billId;
/**
 获取默认地址
 */
-(void)getDefaultAddress:(NSString *)userId;
//批量删除收货地址
-(void)DeleteDeliveryAddress:(NSString *)idList anduserId:(NSString *)userId;

//分页查询收藏商品
-(void)SelectFavoriteByUserIdAndSearch:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows anduserId:(NSString *)userId andsearch:(NSString *)search;

//根据地址ID设置默认收货地址
-(void)SetDefaultDeliveryAddress:(NSString *)goodsId anduserId:(NSString *)userId;

//根据用户ID分页查询兑换记录
-(void)SelectPageChangeBillByUserId:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows anduserId:(NSString *)userId andstate:(NSString *)state andproNum:(NSString *)proNum;

//兑换详情
-(void)ChangeDetail:(NSString *)productId anduserId:(NSString *)userId andbillDetailId:(NSString *)billDetailId;
/**
 *  取消订单
 *
 *  @param orderid 订单id
 *  @param userid  userid
 */
-(void)CancleOrderWithOrderID:(NSString *)orderid andUserId:(NSString *)userid;

//删除订单
-(void)DeleteBill:(NSString *)orderid andUserId:(NSString *)userid;

#pragma mark - 更多
-(void)ChangeTuiSong:(NSString *)userid andistuisong:(NSString *)istuisong;
-(void)ShieldNewsFriend:(NSString *)userid;
-(NSDictionary *)getUserInfoByUserID:(NSString *)userID;
/**
 *  获取关于我们
 */
-(void)GetAboutUs;


@end
