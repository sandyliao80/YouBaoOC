//
//  ZXYEncyPicDown.m
//  YouBaoOC
//
//  Created by developer on 14-8-5.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "ZXYEncyPicDown.h"
#import "ZXYFileOperation.h"
#import "AFNetworking.h"
#import "ZXYProvider.h"
@interface ZXYEncyPicDown()
{
    NSMutableArray *firstArrToDown;
    NSMutableArray *needToDown;
    NSString *currentURL;
    BOOL isDownLoad;
    ZXYFileOperation *fileOperate;
    ZXYProvider *provider;
    

}
@end

@implementation ZXYEncyPicDown
- (id)initWithFirstArr:(NSMutableArray *)firstArr
{
    if(self = [super init])
    {
        firstArrToDown = [[NSMutableArray alloc] initWithArray:firstArr];
        needToDown     = [[NSMutableArray alloc] init];
        isDownLoad = NO;
        fileOperate = [ZXYFileOperation sharedSelf];
        provider = [ZXYProvider sharedInstance];
    }
    return self;
}

- (void)addURLTONeedToDown:(NSString *)needToDownURL
{
    //[needToDown insertObject:needToDownURL atIndex:0];
    if([needToDown containsObject:needToDownURL]||[firstArrToDown containsObject:needToDownURL])
    {
        if([currentURL isEqualToString:needToDownURL])
        {
            return;
        }
        else
        {
            if([needToDown containsObject:needToDownURL])
            {
                [needToDown removeObject:needToDownURL];
            }
            else if([firstArrToDown containsObject:needToDownURL])
            {
                [firstArrToDown removeObject:needToDownURL];
            }
        }
    }
    [needToDown addObject:needToDownURL];
}

- (void)main
{
    while ((firstArrToDown.count + needToDown.count)>0)
    {
        if(!isDownLoad)
        {
            if(needToDown.count > 0)
            {
                for(int i =0;i<needToDown.count;i++)
                {
                    if([needToDown objectAtIndex:i])
                    {
                        [firstArrToDown insertObject:[needToDown objectAtIndex:i] atIndex:0];
                    }
                }
                [needToDown removeAllObjects];
            }
            
            isDownLoad = YES;
            if(firstArrToDown.count >0)
            {
                currentURL = [firstArrToDown objectAtIndex:0];
                NSString *lastURL = [currentURL componentsSeparatedByString:@"/"].lastObject;
                NSString *filePath = [fileOperate cidImagePath:lastURL];
                if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
                {
                    
                    [firstArrToDown removeObject:currentURL];
                    currentURL = nil;
                    isDownLoad = NO;
                    continue;
                }
                else
                            {
                //                    LocDetailInfo *loc = [[provider readCoreDataFromDB:@"LocDetailInfo" withContent:currentURL andKey:@"cid"] objectAtIndex:0];
                    NSURL *urlS = [NSURL URLWithString:[NSString stringWithFormat:@"%@",currentURL]];
                    NSURLRequest *request = [NSURLRequest requestWithURL:urlS];
                    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                    operation.responseSerializer = [AFImageResponseSerializer serializer];
                                    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
                {
                    NSData *imageData = [operation responseData];
                    [imageData writeToFile:filePath atomically:YES];

                    [firstArrToDown removeObject:currentURL];
                    currentURL = nil;

                    NSNotification *addNoti = [[NSNotification alloc] initWithName:@"ency_noti" object:self userInfo:nil];
                    [[NSNotificationCenter defaultCenter] postNotification:addNoti];
                    isDownLoad = NO;

                } failure:^(AFHTTPRequestOperation *operation, NSError *error)
                {
                    
                    [firstArrToDown removeObject:currentURL];
                    isDownLoad = NO;
                    currentURL = nil;

                    NSLog(@"ZXYDownCIDOperation error is %@",error);
                }];
                [operation start];
                }
            }
        }
    }
}
@end
