//
//  LCYFileManager.m
//  YouBaoOC
//
//  Created by Licy on 14-8-8.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYFileManager.h"

@implementation LCYFileManager

static LCYFileManager *SINGLETON = nil;

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
    return [[LCYFileManager alloc] init];
}

- (id)mutableCopy
{
    return [[LCYFileManager alloc] init];
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

- (NSString *)tmpFolderPath{
    return NSTemporaryDirectory();
}

- (NSString *)cachePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

- (BOOL)imageExistAt:(NSString *)relativePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *folderPath = [[self cachePath] stringByAppendingPathComponent:[relativePath stringByDeletingLastPathComponent]];
    NSError *error;
    BOOL isDir;
    if (![fileManager fileExistsAtPath:folderPath isDirectory:&isDir]) {
        [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    NSString *absolutePath = [[self cachePath] stringByAppendingPathComponent:relativePath];
    if ([fileManager fileExistsAtPath:absolutePath]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)saveData:(NSData *)data atRelativePath:(NSString *)relativePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *absolutePath = [[self cachePath] stringByAppendingPathComponent:relativePath];
    NSString *pathWithoutFileName = [absolutePath stringByDeletingLastPathComponent];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:pathWithoutFileName isDirectory:&isDir]) {
        [fileManager createDirectoryAtPath:pathWithoutFileName withIntermediateDirectories:YES attributes:nil error:nil];
    }
    [data writeToFile:absolutePath atomically:YES];
}

- (NSString *)absolutePathFor:(NSString *)relativePath{
    return [[self cachePath] stringByAppendingPathComponent:relativePath];
}

@end
