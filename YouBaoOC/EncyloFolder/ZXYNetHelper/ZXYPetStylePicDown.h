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
- (id)initWithFirstArr:(NSMutableArray *)firstArr andSaveDire:(NSString *)subDire;
- (void)addURLTONeedToDown:(NSString *)needToDownURL;
@end
