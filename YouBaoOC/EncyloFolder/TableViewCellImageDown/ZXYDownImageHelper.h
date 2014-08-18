//
//  ZXYDownImageHelper.h
//  YouBaoOC
//
//  Created by developer on 14-8-18.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXYDownImageHelper : NSObject
-(id)initWithDirect:(NSString *)Dic andNotiKey:(NSString *)notiKey;
-(void)addImageURLWithIndexDic:(NSDictionary *)urlDic;
-(void)startDownLoadImage;
@end
