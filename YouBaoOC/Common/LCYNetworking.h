//
//  LCYNetworking.h
//  YouBaoOC
//
//  Created by Licy on 14-7-24.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//


FOUNDATION_EXPORT NSString *const hostURL;

FOUNDATION_EXPORT NSString *const User_authcode;
FOUNDATION_EXPORT NSString *const User_register;
FOUNDATION_EXPORT NSString *const User_login;

@interface LCYNetworking : NSObject

/**
 * gets singleton object.
 * @return singleton
 */
+ (LCYNetworking*)sharedInstance;

- (BOOL)isNetworkAvailable;

/**
 *  向服务器发动POST请求，使用Block进行回调而避免使用代理
 *
 *  @param api        接口名
 *  @param parameters 所需参数
 *  @param success    成功后的回调-object为返回内容
 *  @param failed     失败的回调
 */
- (void)postRequestWithAPI:(NSString *)api
                parameters:(NSDictionary *)parameters
              successBlock:(void (^)(NSDictionary *object))success
               failedBlock:(void (^)(void))failed;

@end
