//
//  LCYGlobal.h
//  YouBaoOC
//
//  Created by Licy on 14-7-31.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

@interface LCYGlobal : NSObject

/**
 * gets singleton object.
 * @return singleton
 */
+ (LCYGlobal*)sharedInstance;

@property (strong, nonatomic) NSString *currentUserID;

@end
