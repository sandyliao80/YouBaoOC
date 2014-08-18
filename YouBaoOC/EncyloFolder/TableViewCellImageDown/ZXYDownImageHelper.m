//
//  ZXYDownImageHelper.m
//  YouBaoOC
//
//  Created by developer on 14-8-18.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "ZXYDownImageHelper.h"
#import "ZXYDownImageOperation.h"
@interface ZXYDownImageHelper()
{
    NSString *_directory;
    NSString *_notiKey;
    NSMutableArray *dicsForDown;
    ZXYDownImageOperation *operation;
    NSInteger indexForDic;
    NSOperationQueue *currentQueue;
}
@end
@implementation ZXYDownImageHelper
-(id)initWithDirect:(NSString *)Dic andNotiKey:(NSString *)notiKey
{
    if(self = [super init])
    {
        _directory  = Dic;
        _notiKey    = notiKey;
        dicsForDown = [[NSMutableArray alloc] init];
        currentQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

-(void)addImageURLWithIndexDic:(NSDictionary *)urlDic
{
    if(operation == nil)
    {
        if(![self isURLExist:urlDic])
        {
            [dicsForDown addObject:urlDic];
        }
        [self startDownLoadImage];
    }
    else
    {
        if([operation isExecuting])
        {
            if(![self isURLExist:urlDic])
            {
                if(operation)
                {
                    [operation addURLDic:urlDic];
                }
            }
        }
        else if([operation isFinished])
        {
            [dicsForDown insertObject:urlDic atIndex:0];
            [self startDownLoadImage];
        }
    }
}

-(void)startDownLoadImage
{
    //当再次调用时，如果发现operation已经执行完毕，重新实例化.
    if([operation isFinished])
    {
        operation = nil;
    }
    if(operation == nil)
    {
         operation = [[ZXYDownImageOperation alloc] initWithFirstArr:dicsForDown andSavePath:_directory];
        [operation setNotificationKey:_notiKey];
        __block ZXYDownImageHelper *blockSelf = self;
        [operation setCompletionBlock:^{
            blockSelf->operation = nil;
            NSLog(@"图片加载结束了");
        }];
        [currentQueue addOperation:operation];
    }
}


- (BOOL)isURLExist:(NSDictionary *)dic
{
    if([dicsForDown containsObject:dic])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
@end
