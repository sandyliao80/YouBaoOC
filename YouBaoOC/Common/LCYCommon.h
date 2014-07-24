//
//  LCYCommon.h
//  YouBaoOC
//
//  Created by Licy on 14-7-24.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//


@interface LCYCommon : NSObject

/**
 * gets singleton object.
 * @return singleton
 */
+ (LCYCommon*)sharedInstance;

/**
 *  判断用户是否已经登录
 *
 *  @return YES or NO
 */
- (BOOL)isUserLogin;

@end
