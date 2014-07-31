//
//  LCYNetworking.h
//  YouBaoOC
//
//  Created by Licy on 14-7-24.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//


FOUNDATION_EXPORT NSString *const hostURL;

FOUNDATION_EXPORT NSString *const User_authcode;
FOUNDATION_EXPORT NSString *const User_register;        /**< 提交注册信息 */
FOUNDATION_EXPORT NSString *const User_login;
FOUNDATION_EXPORT NSString *const User_modifyImage;     /**< 修改头像 */
FOUNDATION_EXPORT NSString *const PetStyle_searchAllTypePets;       /**< 获取宠物一级分类 */

@interface LCYNetworking : NSObject

/**
 * gets singleton object.
 * @return singleton
 */
+ (LCYNetworking*)sharedInstance;

- (BOOL)isNetworkAvailable;

/**
 *  向服务器发送POST请求，使用Block进行回调而避免使用代理
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

/**
 *  向服务器发送POST请求，其中带有文件内容
 *
 *  @param api        接口名
 *  @param parameters 所需参数
 *  @param key        文件key
 *  @param data       文件内容
 *  @param fileName   保存文件的名称
 *  @param mimeType   文件类型
 *  @param success    成功代理
 *  @param failed     失败代理
 */
- (void)postFileWithAPI:(NSString *)api
             parameters:(NSDictionary *)parameters
                fileKey:(NSString *)key
               fileData:(NSData *)data
               fileName:(NSString *)fileName
               mimeType:(NSString *)mimeType
           successBlock:(void(^)(NSDictionary *object))success
            failedBlock:(void (^)(void))failed;
@end
