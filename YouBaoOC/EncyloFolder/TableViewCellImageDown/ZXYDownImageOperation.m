//
//  ZXYDownImageOperation.m
//  YouBaoOC
//
//  Created by developer on 14-8-18.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "ZXYDownImageOperation.h"
#import "ZXYFileOperation.h"
#import <AFNetworking.h>
@interface ZXYDownImageOperation()
{
    NSMutableArray *downLoadArr;
    NSMutableArray *needToDown;
    BOOL isDown;
    NSMutableDictionary *currentDic;
    NSDictionary *currentDownDic;
    NSString *_savePath;
    ZXYFileOperation *fileOperate;
    NSString *_notiKey;
}
@end
@implementation ZXYDownImageOperation
- (id)initWithFirstArr:(NSMutableArray *)firstArr andSavePath:(NSString *)savePath
{
    if(self = [super init])
    {
        downLoadArr = firstArr;
        needToDown  = [[NSMutableArray alloc] init];
        _savePath   = savePath;
         fileOperate = [[ZXYFileOperation alloc] init];
    }
    return self;
}

- (void)addURLDic:(NSDictionary *)needTo
{
    if([needToDown containsObject:needTo]||[downLoadArr containsObject:needTo])
    {
        if(currentDownDic == needTo)
        {
            return;
        }
        else
        {
            if([needToDown containsObject:needTo])
            {
                [needToDown removeObject:needTo];
            }
            else if([downLoadArr containsObject:needTo])
            {
                [downLoadArr removeObject:needTo];
            }
            [needToDown addObject:needTo];
        }
    }
    else
    {
        [needToDown addObject:needTo];
    }
}

- (void)setNotificationKey:(NSString *)notiKey
{
    _notiKey = notiKey;
}


- (void)main
{
    while ((downLoadArr.count + needToDown.count)>0)
    {
        if(!isDown)
        {
            if(needToDown.count > 0)
            {
                for(int i =0;i<needToDown.count;i++)
                {
                    if([needToDown objectAtIndex:i])
                    {
                        [downLoadArr insertObject:[needToDown objectAtIndex:i] atIndex:0];
                    }
                }
                [needToDown removeAllObjects];
            }
            
            isDown = YES;
            if(downLoadArr.count >0)
            {
                currentDownDic = [downLoadArr objectAtIndex:0];
                NSString *lastURL = [[currentDownDic objectForKey:@"url"] componentsSeparatedByString:@"/"].lastObject;
                NSString *filePath = [fileOperate pathTempFile:_savePath andURL:lastURL];
                if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
                {
                    
                    [downLoadArr removeObject:currentDownDic];
                    currentDownDic = nil;
                    isDown = NO;
                    continue;
                }
                else
                {
                    NSURL *urlS = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[currentDownDic objectForKey:@"url"]]];
                    NSURLRequest *request = [NSURLRequest requestWithURL:urlS];
                    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                    operation.responseSerializer = [AFImageResponseSerializer serializer];
                    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
                     {
                         NSData *imageData = [operation responseData];
                         [imageData writeToFile:filePath atomically:YES];
                         
                         [downLoadArr removeObject:currentDownDic];
                         NSNotification *addNoti = [[NSNotification alloc] initWithName:_notiKey object:self userInfo:currentDownDic];
                         if(addNoti == nil)
                         {
                             NSLog(@"没有找到相关的通知 key:%@",_notiKey);
                             return ;
                         }
                         [[NSNotificationCenter defaultCenter] postNotification:addNoti];
                         currentDownDic = nil;
                         isDown = NO;
                         
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
                     {
                         
                         [downLoadArr removeObject:currentDownDic];
                         currentDownDic = nil;
                         isDown = NO;
                         NSLog(@"ZXYDownCIDOperation error is %@",error);
                     }];
                    [operation start];
                }
            }
        }
    }

}

@end
