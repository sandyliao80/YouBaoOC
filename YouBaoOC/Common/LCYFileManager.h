//
//  LCYFileManager.h
//  YouBaoOC
//
//  Created by Licy on 14-8-8.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

@interface LCYFileManager : NSObject

/**
 * gets singleton object.
 * @return singleton
 */
+ (LCYFileManager*)sharedInstance;

/**
 *  判断图片是否已经存在
 *
 *  @param relativePath 相对路径
 *
 *  @return YES or NO
 */
- (BOOL)imageExistAt:(NSString *)relativePath;

/**
 *  写入数据
 *
 *  @param data 数据内容
 *  @param path 路径
 */
- (void)saveData:(NSData *)data atRelativePath:(NSString *)path;

/**
 *  根据相对路径，返回相应的绝对路径
 *
 *  @param relativePath 相对路径如:/Upload/foobar.png
 *
 *  @return 绝对路径
 */
- (NSString *)absolutePathFor:(NSString *)relativePath;

@end
