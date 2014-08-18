//
//  ZXYDownLoadImage.h
//  YouBaoOC
//
//  Created by developer on 14-8-7.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ZXYDownLoadImage : NSOperation
/**
 *根据指定的directory在temp文件中创建指定的文件夹
 *@param 制定的文件夹名称
 */
-(void)setTempDirectory:(NSString *)directory;

/**
 *当operation正在运行时，添加urlString时调用的方法
 *@param 添加的urlString
 *
 */
-(void)addImageURL:(NSString *)urlString ;

/**
 *设置通知的名称
 *@param 通知的名称
 */
-(void)setNotiKey:(NSString *)notiKey;

/**
 *开始下载图片
 */
-(void)startDownImage;
@end
