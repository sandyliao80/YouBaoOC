//
//  CellImageDownloadOperation.m
//  YouBaoOC
//
//  Created by Licy on 14-8-11.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "CellImageDownloadOperation.h"
#import <AFNetworking/AFNetworking.h>
#import "LCYCommon.h"

@interface CellImageDownloadOperation ()

@property (strong, atomic) NSMutableArray *imageInfoArray;
@property (strong, atomic) NSCondition *arrayCondition;
@property (strong, nonatomic) NSMutableArray *imageDownloaded;
@end

@implementation CellImageDownloadOperation
- (instancetype)init{
    if (self = [super init]) {
        self.imageInfoArray = [NSMutableArray array];
        self.arrayCondition = [[NSCondition alloc] init];
        self.imageDownloaded = [NSMutableArray array];
    }
    return self;
}

- (void)main{
    while (YES) {
        // 检查线程是否已经结束
        if (self.isCancelled) {
            break;
        }
        // 检查需要下载的列表
        [self.arrayCondition lock];
        if (self.imageInfoArray.count == 0) {
            [self.arrayCondition wait];
            [self.arrayCondition unlock];
        } else {
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            NSDictionary *imageInfo = [self.imageInfoArray lastObject];
            NSString *imageName = imageInfo[@"imageName"];
            [self.imageInfoArray removeLastObject];
            NSLog(@"pop object:%@",imageName);
            NSLog(@"current object count = %ld",(long)self.imageInfoArray.count);
            [self.arrayCondition unlock];
            // 开启异步下载，完成后发送signal
            NSString *imageURL = [hostImageURL stringByAppendingString:imageName];
            NSURL *url = [NSURL URLWithString:imageURL];
            NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
            AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
            requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
            [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                UIImage *downImg = (UIImage *)responseObject;
                NSData *imageData = UIImageJPEGRepresentation(downImg, 1.0);
                [[LCYFileManager sharedInstance] saveData:imageData atRelativePath:imageName];
                if (self.delegate &&
                    [self.delegate respondsToSelector:@selector(imageDownloadOperation:didFinishedDownloadImageAt:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate imageDownloadOperation:self didFinishedDownloadImageAt:imageInfo[@"indexPath"]];
                    });
                }
                dispatch_semaphore_signal(sema);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"下载图片失败 error is %@",error);
                dispatch_semaphore_signal(sema);
            }];
            [requestOperation start];
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        }
    }
}

- (void)addImageName:(NSString *)imageName atIndexPath:(NSIndexPath *)indexPath{
    [self.arrayCondition lock];
    // 检查重复，Make sure bogus URLs won't be retried again and again
    BOOL limit = NO;
    for (NSString *oneName in self.imageDownloaded) {
        if ([oneName isEqualToString:imageName]) {
            limit = YES;
            break;
        }
    }
    if (!limit) {
        // 加入下载栈
        NSDictionary *imageInfo = @{@"imageName"    : imageName,
                                    @"indexPath"    : indexPath};
        [self.imageInfoArray addObject:imageInfo];
        NSLog(@"push object:%@",imageInfo);
        [self.imageDownloaded addObject:imageName];
    }
    [self.arrayCondition signal];
    [self.arrayCondition unlock];
}
@end
