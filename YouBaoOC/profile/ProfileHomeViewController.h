//
//  ProfileHomeViewController.h
//  YouBaoOC
//
//  Created by Licy on 14-7-28.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileHomeViewController : UIViewController
@end


@class ProfileImageDownloadOperation;
@protocol ProfileImageDownloadOperationDelegate <NSObject>
@optional
- (void)imageDownloadOperation:(ProfileImageDownloadOperation *)operation didFinishedDownloadImageAt:(NSIndexPath *)indexPath;
@end

@interface ProfileImageDownloadOperation : NSOperation
@property (weak, nonatomic) id<ProfileImageDownloadOperationDelegate>delegate;
- (void)addImageName:(NSString *)imageName atIndexPath:(NSIndexPath *)indexPath;
@end
