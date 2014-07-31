//
//  LCYNetworking.m
//  YouBaoOC
//
//  Created by Licy on 14-7-24.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYNetworking.h"
#import <Reachability/Reachability.h>
#import <AFNetworking/AFNetworking.h>

NSString *const hostURL = @"http://115.29.46.22/pet/index.php/Api/";

NSString *const User_authcode       = @"User/register_authcode";
NSString *const User_register       = @"/User/register";
NSString *const User_login          = @"/User/login";
NSString *const User_modifyImage    = @"/User/modifyImage";
NSString *const PetStyle_searchAllTypePets      = @"/PetStyle/searchAllTypePets";

@implementation LCYNetworking

static LCYNetworking *SINGLETON = nil;

static bool isFirstAccess = YES;

#pragma mark - Public Method

+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isFirstAccess = NO;
        SINGLETON = [[super allocWithZone:NULL] init];    
    });
    
    return SINGLETON;
}

#pragma mark - Life Cycle

+ (id) allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

+ (id)mutableCopyWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copy
{
    return [[LCYNetworking alloc] init];
}

- (id)mutableCopy
{
    return [[LCYNetworking alloc] init];
}

- (id) init
{
    if(SINGLETON){
        return SINGLETON;
    }
    if (isFirstAccess) {
        [self doesNotRecognizeSelector:_cmd];
    }
    self = [super init];
    return self;
}

- (BOOL)isNetworkAvailable{
    Reachability* reach = [Reachability reachabilityWithHostname:hostURL];
    return reach.isReachable;
}

- (void)postRequestWithAPI:(NSString *)api parameters:(NSDictionary *)parameters successBlock:(void (^)(NSDictionary *))success failedBlock:(void (^)(void))failed{
    NSString *URLString = [hostURL stringByAppendingString:api];
    NSLog(@"posting :%@\nwith parameter :%@",URLString,parameters);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/plain", nil];
    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@ response string = %@",api ,operation.responseString);
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(responseObject);
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error in api:%@: %@",api, error);
        if (failed) {
            dispatch_async(dispatch_get_main_queue(), failed);
        }
    }];
}

- (void)postFileWithAPI:(NSString *)api parameters:(NSDictionary *)parameters fileKey:(NSString *)key fileData:(NSData *)data fileName:(NSString *)fileName mimeType:(NSString *)mimeType successBlock:(void (^)(NSDictionary *))success failedBlock:(void (^)(void))failed{
    NSString *URLString = [hostURL stringByAppendingString:api];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/plain", nil];
    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:key fileName:fileName mimeType:mimeType];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = responseObject;
        NSLog(@"%@ response object = %@", api, dic);
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(responseObject);
            });
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error in api:%@: %@",api, error);
        if (failed) {
            dispatch_async(dispatch_get_main_queue(), failed);
        }
    }];
}


@end
