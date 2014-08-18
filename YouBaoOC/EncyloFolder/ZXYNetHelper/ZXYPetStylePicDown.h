//
//  ZXYPetStylePicDown.h
//  YouBaoOC
//
//  Created by developer on 14-8-7.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#define FinishDownNoti @"downLoadImageFinish"
#import <Foundation/Foundation.h>

@interface ZXYPetStylePicDown : NSOperation

/**
 *为operation实例化
 *@param firstArr 初始化第一组传入的url数组
 *@param subDire  要存入到temp的文件夹名称
 */
- (id)initWithFirstArr:(NSMutableArray *)firstArr andSaveDire:(NSString *)subDire;

/**
 *在operation没有执行完毕的时候为需要下载的url数组增加新的url数据
 *@param needToDownURL 需要添加的url
 */
- (void)addURLTONeedToDown:(NSString *)needToDownURL;

/**
 *设置当每一个url执行下载完毕是调用的通知名称
 *@param notiKey 通知名称
 */
- (void)setNotificationKey:(NSString *)notiKey;
@end
