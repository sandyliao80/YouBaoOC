//
//  ZXYNETHelper.m
//  DLTourOfJapan
//
//  Created by developer on 14-6-17.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXYNETHelper.h"
#import "Reachability.h"
#import "ZXYDownCIDOperation.h"
#import "Reachability.h"
#import "ZXYEncyPicDown.h"
#import "ZXYPetStylePicDown.h"
@interface ZXYNETHelper()
{
    NSMutableArray *allURL;
    NSMutableArray *placeURLARR;
    BOOL isPlaceImageDown;
   
    ZXYEncyPicDown *cidOperation;
    NSOperationQueue *tempQueue;
}
@end
@implementation ZXYNETHelper
static ZXYNETHelper *instance;
static NSOperationQueue *queue;
- (id)init
{
    if(self=[super init])
    {
        tempQueue = [[NSOperationQueue alloc] init];
        
    }
    return self;
}

+ (ZXYNETHelper *)sharedSelf
{
    @synchronized(self)
    {
        if(instance == nil)
        {
            return [[self alloc] init];
        }
    }
    return instance;
}

+ (NSOperationQueue *)getQueue
{
    if(queue == nil)
    {
        queue = [[NSOperationQueue alloc] init];
    }
    return queue;
}

+ (id)alloc
{
    @synchronized(self)
    {
        instance = [super alloc];
        return instance;
    }
    return nil;
}

// !!!:isNETConnect
+(BOOL)isNETConnect
{
    Reachability *r = [Reachability reachabilityWithHostname:@"http://www.baidu.com"];
    BOOL flag;
    switch ([r currentReachabilityStatus])
    {
        case NotReachable:
        {
            // 没有网络连接
            flag = YES;
            break;
        }
        default:
        {
            flag = YES;
            break;
        }
    }
    return  flag;
}

- (void)requestStart:(NSString *)urlString withParams:(NSDictionary *)params bySerialize:(AFHTTPResponseSerializer *)serializer
{
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    operationManager.responseSerializer = serializer;
    if(params==nil)
    {
        [operationManager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if([self.netHelperDelegate respondsToSelector:@selector(requestCompleteDelegateWithFlag:withOperation:withObject:)])
            {
                [self.netHelperDelegate requestCompleteDelegateWithFlag:requestCompleteSuccess withOperation:operation withObject:responseObject];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if([self.netHelperDelegate respondsToSelector:@selector(requestCompleteDelegateWithFlag:withOperation:withObject:)])
            {
                [self.netHelperDelegate requestCompleteDelegateWithFlag:requestCompleteFail withOperation:operation withObject:error];
            }
            
        }];
    }
    else
    {
        [operationManager POST:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if([self.netHelperDelegate respondsToSelector:@selector(requestCompleteDelegateWithFlag:withOperation:withObject:)])
            {
                [self.netHelperDelegate requestCompleteDelegateWithFlag:requestCompleteSuccess withOperation:operation withObject:responseObject];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if([self.netHelperDelegate respondsToSelector:@selector(requestCompleteDelegateWithFlag:withOperation:withObject:)])
            {
                [self.netHelperDelegate requestCompleteDelegateWithFlag:requestCompleteFail withOperation:operation withObject:error];
            }
            
        }];
    }
}


//- (void)placeURLADD:(NSString *)url
//{
//    if(placeURLARR==nil)
//    {
//        placeURLARR = [[NSMutableArray alloc] init];
//    }
//
//    if(cidOperation == nil)
//    {
//        if([placeURLARR containsObject:url])
//        {
//            [placeURLARR removeObject:url];
//        }
//        [placeURLARR insertObject:url atIndex:0];
//    }
//    else {
//        if(!cidOperation.isExecuting)
//        {
//            if([placeURLARR containsObject:url])
//            {
//                [placeURLARR removeObject:url];
//            }
//            [placeURLARR insertObject:url atIndex:0];
//            [self startDownPlaceImage];
//        }
//        else
//        {
//            if(cidOperation)
//            {
//                [cidOperation addURLTONeedToDown:url];
//            }
//            else
//            {
//                NSLog(@"cid operation is dead");
//            }
//        }
//    }
//}
//
//- (void)startDownPlaceImage
//{
//    if([cidOperation isFinished])
//    {
//        cidOperation = nil;
//    }
//
//    if(cidOperation == nil)
//    {
//        cidOperation = [[ZXYEncyPicDown alloc] initWithFirstArr:placeURLARR];
//        [tempQueue addOperation:cidOperation];
//    }
//}
//
//- (void)cancelPlaceImageDown
//{
//    isPlaceImageDown = NO;
//}

- (void)placeURLADD:(NSString *)url
{
    if(placeURLARR==nil)
    {
        placeURLARR = [[NSMutableArray alloc] init];
    }
    
    if(cidOperation == nil)
    {
        if([placeURLARR containsObject:url])
        {
            [placeURLARR removeObject:url];
        }
        [placeURLARR insertObject:url atIndex:0];
    }
    else {
        if(!cidOperation.isExecuting)
        {
            if([placeURLARR containsObject:url])
            {
                [placeURLARR removeObject:url];
            }
            [placeURLARR insertObject:url atIndex:0];
            [self startDownPlaceImage];
        }
        else
        {
            if(cidOperation)
            {
                [cidOperation addURLTONeedToDown:url];
            }
            else
            {
                NSLog(@"cid operation is dead");
            }
        }
    }
}

- (void)startDownPlaceImage
{
    if([cidOperation isFinished])
    {
        cidOperation = nil;
    }
    
    if(cidOperation == nil)
    {
        cidOperation = [[ZXYEncyPicDown alloc] initWithFirstArr:placeURLARR];
        [tempQueue addOperation:cidOperation];
    }
}

- (void)cancelPlaceImageDown
{
    isPlaceImageDown = NO;
}

@end
