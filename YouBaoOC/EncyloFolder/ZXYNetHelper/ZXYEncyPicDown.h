//
//  ZXYEncyPicDown.h
//  YouBaoOC
//
//  Created by developer on 14-8-5.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXYEncyPicDown : NSOperation
- (id)initWithFirstArr:(NSMutableArray *)firstArr;
- (void)addURLTONeedToDown:(NSString *)needToDownURL;
@end
