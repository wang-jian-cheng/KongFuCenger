//
//  SimpleMessage.m
//  rongyun
//
//  Created by 王明辉 on 16/1/19.
//  Copyright © 2016年 王明辉. All rights reserved.
//

#import "SimpleMessage.h"
#import <RongIMLib/RCUtilities.h>

@implementation SimpleMessage

///初始化
+(instancetype)messageWithContent:(NSString *)content imageUrl:(NSString*)imageUrl url:(NSString*)url {
    SimpleMessage *msg = [[SimpleMessage alloc] init];
    if (msg) {
        msg.content = content;
        msg.imageUrl = imageUrl;
        msg.url = url;
        
    }
    
    return msg;
}
///消息是否存储，是否计入未读数
+(RCMessagePersistent)persistentFlag {
    return (MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED);
}



#pragma mark – NSCoding protocol methods
#define KEY_TXTMSG_CONTENT @"content"
#define KEY_TXTMSG_imageurl @"imageUrl"
#define KEY_TXTMSG_url @"url"
#define KEY_TXTMSG_EXTRA @"extra"

/// NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.content = [aDecoder decodeObjectForKey:KEY_TXTMSG_CONTENT];
        self.imageUrl = [aDecoder decodeObjectForKey:KEY_TXTMSG_imageurl];
        self.url = [aDecoder decodeObjectForKey:KEY_TXTMSG_url];
        
        self.extra = [aDecoder decodeObjectForKey:KEY_TXTMSG_EXTRA]; }
    return self;
}



/// NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.content forKey:KEY_TXTMSG_CONTENT];
    [aCoder encodeObject:self.imageUrl forKey:KEY_TXTMSG_imageurl];
    [aCoder encodeObject:self.url forKey:KEY_TXTMSG_url];
    
    [aCoder encodeObject:self.extra forKey:KEY_TXTMSG_EXTRA];
    
}


///将消息内容编码成json
-(NSData *)encode {
    
    NSMutableDictionary *dataDict=[NSMutableDictionary dictionary];
    [dataDict setObject:self.content forKey:@"content"];
    [dataDict setObject:self.imageUrl forKey:@"imageUrl"];
    [dataDict setObject:self.url forKey:@"url"];
    
    if (self.extra) {
        [dataDict setObject:self.extra forKey:@"extra"];
    }
    
    if (self.senderUserInfo) {
        NSMutableDictionary *__dic=[[NSMutableDictionary alloc]init];
        if (self.senderUserInfo.name) {
            [__dic setObject:self.senderUserInfo.name forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [__dic setObject:self.senderUserInfo.portraitUri forKeyedSubscript:@"icon"];
        }
        if (self.senderUserInfo.userId) {
            [__dic setObject:self.senderUserInfo.userId forKeyedSubscript:@"id"];
        }
        [dataDict setObject:__dic forKey:@"user"];
    }
    
    //NSDictionary* dataDict = [NSDictionary dictionaryWithObjectsAndKeys:self.content, @"content", nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict
                                                   options:kNilOptions
                                                     error:nil];
    return data;
}
///将json解码生成消息内容
-(void)decodeWithData:(NSData *)data {
    __autoreleasing NSError* __error = nil;
    if (!data) {
        return;
    }
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&__error];
    
    if (json) {
        self.content = json[@"content"];
        self.imageUrl = json[@"imageUrl"];
        self.imageUrl = json[@"url"];
        
        self.extra = json[@"extra"];
        NSObject *__object = [json objectForKey:@"user"];
        NSDictionary *userinfoDic = nil;
        if (__object &&[__object isMemberOfClass:[NSDictionary class]]) {
            userinfoDic =__object;
        }
        if (userinfoDic) {
            RCUserInfo *userinfo =[RCUserInfo new];
            userinfo.userId = [userinfoDic objectForKey:@"id"];
            userinfo.name =[userinfoDic objectForKey:@"name"];
            userinfo.portraitUri =[userinfoDic objectForKey:@"icon"];
            self.senderUserInfo = userinfo;
        }
        
    }
}




/// 会话列表中显示的摘要
- (NSString *)conversationDigest
{
    return @"会话列表显示内容";
}

///消息的类型名
+(NSString *)getObjectName {
    return RCLocalMessageTypeIdentifier;
}
@end
