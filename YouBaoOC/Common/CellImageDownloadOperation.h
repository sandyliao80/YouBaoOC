//
//  CellImageDownloadOperation.h
//  YouBaoOC
//
//  Created by Licy on 14-8-11.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CellImageDownloadOperation;

@protocol CellImageDownloadOperationDelegate <NSObject>
@optional
- (void)imageDownloadOperation:(CellImageDownloadOperation *)operation didFinishedDownloadImageAt:(NSIndexPath *)indexPath;
@end

@interface CellImageDownloadOperation : NSOperation
@property (weak, nonatomic) id<CellImageDownloadOperationDelegate>delegate;
- (void)addImageName:(NSString *)imageName atIndexPath:(NSIndexPath *)indexPath;

@end
