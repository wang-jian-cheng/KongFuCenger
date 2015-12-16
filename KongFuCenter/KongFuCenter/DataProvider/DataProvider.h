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

@end
