//
//  ZXYPetStylePicDown.m
//  YouBaoOC
//
//  Created by developer on 14-8-7.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "ZXYPetStylePicDown.h"
#import "ZXYFileOperation.h"
#import "ZXYProvider.h"
#import "ZXYNETHelper.h"
@interface ZXYPetStylePicDown()
{
    NSMutableArray *firstArrToDown;
    NSMutableArray *needToDown;
    NSString *currentURL;
    BOOL isDownLoad;
    ZXYFileOperation *fileOperate;
    ZXYProvider *provider;
    NSString *_subDire;
    NSString *_notiKey;
}
@end

@implementation ZXYPetStylePicDown
- (id)initWithFirstArr:(NSMutableArray *)firstArr andSaveDire:(NSString *)subDire
{
    if(self = [super init])
    {
        _subDire = subDire;
        firstArrToDown = [[NSMutableArray alloc] initWithArray:firstArr];
        needToDown     = [[NSMutableArray alloc] init];
        isDownLoad = NO;
        fileOperate = [ZXYFileOperation sharedSelf];
        provider = [ZXYProvider sharedInstance];
    }
    return self;
}

- (void)setNotificationKey:(NSString *)notiKey
{
    _notiKey = notiKey;
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
                NSString *filePath = [fileOperate pathTempFile:_subDire andURL:lastURL];
                if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
                {
                    
                    [firstArrToDown removeObject:currentURL];
                    currentURL = nil;
                    isDownLoad = NO;
                    continue;
                }
                else
                {
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
                         
                         NSNotification *addNoti = [[NSNotification alloc] initWithName:_notiKey object:self userInfo:nil];
                         if(addNoti == nil)
                         {
                             NSLog(@"没有找到相关的通知 key:%@",_notiKey);
                             return ;
                         }
                         [[NSNotificationCenter defaultCenter] postNotification:addNoti];
                         isDownLoad = NO;
                         
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
                     {
                         
                         [firstArrToDown removeObject:currentURL];
                         currentURL = nil;
                         isDownLoad = NO;
                         NSLog(@"ZXYDownCIDOperation error is %@",error);
                     }];
                    [operation start];
                }
            }
        }
    }
}

@end
