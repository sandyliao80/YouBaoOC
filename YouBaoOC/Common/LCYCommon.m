//
//  LCYCommon.m
//  YouBaoOC
//
//  Created by Licy on 14-7-24.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYCommon.h"
#import <CocoaSecurity/CocoaSecurity.h>
#import <MBProgressHUD/MBProgressHUD.h>

NSString *const UserDefaultUserName         = @"userName";
NSString *const UserDefaultIsUserLogin      = @"isLogin";
NSString *const UserPassword                = @"userPassword";
NSString *const UserDefaultLoginTime        = @"userLoginTime";

@implementation LCYCommon

static LCYCommon *SINGLETON = nil;

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
    return [[LCYCommon alloc] init];
}

- (id)mutableCopy
{
    return [[LCYCommon alloc] init];
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

#pragma mark - Actions

- (BOOL)isUserLogin{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:UserDefaultUserName]) {
        if ([userDefaults boolForKey:UserDefaultIsUserLogin]) {
            NSDate *currentDate = [NSDate date];
            if ([currentDate timeIntervalSinceDate:[userDefaults objectForKey:UserDefaultLoginTime]] < LOGIN_EXPIRE_TIME) {
                [LCYGlobal sharedInstance].currentUserID = [userDefaults objectForKey:UserDefaultUserName];
                return YES;
            }
        }
    }
    return  NO;
}

- (void)savePassword:(NSString *)password{
    CocoaSecurityResult *aes256 = [CocoaSecurity aesEncrypt:password
                                                     hexKey:@"280f8bb8c43d532f389ef0e2a5321220b0782b065205dcdfcb8d8f02ed5115b9"
                                                      hexIv:@"CC0A69779E15780ADAE46C45EB451A23"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:aes256.base64 forKey:UserPassword];
    [userDefaults synchronize];
}

- (NSString *)takePassword{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *encrypedString = [userDefaults objectForKey:UserPassword];
    CocoaSecurityResult *aes256Decrypt = [CocoaSecurity aesDecryptWithBase64:encrypedString
                                                                      hexKey:@"280f8bb8c43d532f389ef0e2a5321220b0782b065205dcdfcb8d8f02ed5115b9"
                                                                       hexIv:@"CC0A69779E15780ADAE46C45EB451A23"];
    return aes256Decrypt.utf8String;
}

- (void)login:(NSString *)userName{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:UserDefaultIsUserLogin];
    [userDefaults setObject:userName forKey:UserDefaultUserName];
    NSDate *currentDate = [NSDate date];
    [userDefaults setObject:currentDate forKey:UserDefaultLoginTime];
    [userDefaults synchronize];
    [LCYGlobal sharedInstance].currentUserID = [userDefaults objectForKey:UserDefaultUserName];
}

- (void)logout{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:NO forKey:UserDefaultIsUserLogin];
    [userDefaults synchronize];
}


- (void)showTips:(NSString *)message inView:(UIView *)view{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
}

- (void)hideTipsInView:(id)view{
    [MBProgressHUD hideHUDForView:view animated:YES];
}

@end
