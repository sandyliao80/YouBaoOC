//
//  ZXYDownLoadImage.h
//  YouBaoOC
//
//  Created by developer on 14-8-7.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ZXYDownLoadImage : NSOperation
-(void)setTempDirectory:(NSString *)directory;
-(void)addImageURL:(NSString *)urlString;
-(void)startDownImage;
@end
