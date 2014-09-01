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

#ifndef CHENGYUDEBUG
NSString *const hostURL         = @"http://115.29.46.22/pet/index.php/Api/";
NSString *const hostImageURL    = @"http://115.29.46.22/pet/";
#else
NSString *const hostURL         = @"http://192.168.1.106/pet/index.php/Api/";
NSString *const hostImageURL    = @"http://192.168.1.106/pet/";
#endif //CHENGYUDEBUF

NSString *const User_authcode       = @"User/register_authcode";
NSString *const User_register       = @"User/register";
NSString *const User_login          = @"User/login";
NSString *const User_modifyImage    = @"User/modifyImage";
NSString *const PetStyle_searchAllTypePets      = @"PetStyle/searchAllTypePets";
NSString *const PetStyle_searchDetailByID       = @"PetStyle/searchDetailByID";
NSString *const Pet_petAdd          = @"Pet/petAdd";
NSString *const User_getUserInfoByID    = @"User/getUserInfoByID";
NSString *const User_setPassword    = @"User/setPassword";
NSString *const Pet_UploadPetImage  = @"Pet/UploadPetImage";
NSString *const Pet_GetPetDetailByID= @"Pet/GetPetDetailByID";
NSString *const User_modifyInfo     = @"User/modifyInfo";
NSString *const Pet_recommend       = @"Pet/recommend";
NSString *const Pet_updatePetInfo   = @"Pet/updatePetInfo";
NSString *const User_reset_password_authcode    = @"User/reset_password_authcode";
NSString *const User_modifyLocation = @"User/modifyLocation";
NSString *const User_modifySingleProperty       = @"User/modifySingleProperty";
NSString *const Common_Upload_index = @"Common/Upload/ios";

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

- (void)testFileWithAPI:(NSString *)api parameters:(NSDictionary *)parameters fileKey:(NSString *)key fileData:(NSData *)data fileName:(NSString *)fileName mimeType:(NSString *)mimeType successBlock:(void (^)(NSDictionary *))success failedBlock:(void (^)(void))failed{
    NSString *URLString = [@"http://192.168.1.207:9001/index.php/Api/" stringByAppendingString:api];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/plain", nil];
    
    NSLog(@"testing---->%@/nwith--->%@",URLString, parameters);
    
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

- (void)testFileWithAPI:(NSString *)api parameters:(NSDictionary *)parameters progress:(NSProgress *)progress fileKey:(NSString *)key fileData:(NSData *)data fileName:(NSString *)fileName mimeType:(NSString *)mimeType successBlock:(void (^)(NSDictionary *))success failedBlock:(void (^)(void))failed{
    NSString *URLString = [@"http://192.168.1.106/pet/index.php" stringByAppendingString:api];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:key fileName:fileName mimeType:mimeType];
//        [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            if (failed) {
                dispatch_async(dispatch_get_main_queue(), failed);
            }
        } else {
//            NSLog(@"%@ %@", response, responseObject);
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(responseObject);
                });
            }
        }
    }];
    
    [uploadTask resume];
}

- (void)postCommonFileWithKey:(NSString *)key fileData:(NSData *)data fileName:(NSString *)fileName mimeType:(NSString *)mimeType successBlock:(void (^)(NSDictionary *))success failedBlock:(void (^)(void))failed{
    NSString *URLString = @"http://115.29.46.22/pet/index.php/Common/Upload/ios";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/plain", nil];
    [manager POST:URLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:key fileName:fileName mimeType:mimeType];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = responseObject;
        NSLog(@"common response object = %@", dic);
        
        NSArray *imageArray = dic[@"images"];
        NSDictionary *firstImage = [imageArray firstObject];
        NSString *saveName = firstImage[@"savename"];
        
        NSDictionary *result = @{@"result":dic[@"result"],
                                 @"savename":saveName};
        
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(result);
            });
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error in common: %@", error);
        if (failed) {
            dispatch_async(dispatch_get_main_queue(), failed);
        }
    }];
}

- (void)postFileWithAPI:(NSString *)api parameters:(NSDictionary *)parameters progress:(NSProgress *)progress fileKey:(NSString *)key fileData:(NSData *)data fileName:(NSString *)fileName mimeType:(NSString *)mimeType successBlock:(void (^)(NSDictionary *))success failedBlock:(void (^)(void))failed{
    NSString *urlString = [hostURL stringByAppendingString:api];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFormData:data name:key];
    } error:nil];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/plain", nil];
    
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            if ([(NSError *)(error) code] == NSURLErrorCannotDecodeContentData) {
                NSLog(@"%@ %@",response, responseObject);
            }
        } else {
            NSLog(@"%@ %@", response, responseObject);
        }
    }];
    
    [uploadTask resume];
}

@end
