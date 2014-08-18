//
//  ZXYDownImageOperation.h
//  YouBaoOC
//
//  Created by developer on 14-8-18.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXYDownImageOperation : NSOperation
- (id)initWithFirstArr:(NSMutableArray *)firstArr andSavePath:(NSString *)savePath;
- (void)addURLDic:(NSDictionary *)needTo;
/**
 *设置当每一个url执行下载完毕是调用的通知名称
 *@param notiKey 通知名称
 */
- (void)setNotificationKey:(NSString *)notiKey;
@end
