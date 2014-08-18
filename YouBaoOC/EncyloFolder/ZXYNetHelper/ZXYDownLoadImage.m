//
//  ZXYDownLoadImage.m
//  YouBaoOC
//
//  Created by developer on 14-8-7.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "ZXYDownLoadImage.h"
#import "ZXYPetStylePicDown.h"
@interface ZXYDownLoadImage()
{
    NSString *subDirectory;
    NSMutableArray *allURL;
    NSMutableArray *placeURLARR;
    BOOL isPlaceImageDown;
    NSOperationQueue *tempQueue;
    ZXYPetStylePicDown *cidOperation;
    NSString *_notiKey;
}

@end


@implementation ZXYDownLoadImage

- (id)init
{
    if(self = [super init])
    {
        tempQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

-(void)setTempDirectory:(NSString *)directory
{
    subDirectory = directory;
}

-(void)addImageURL:(NSString *)url 
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
            [self startDownImage];
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

-(void)setNotiKey:(NSString *)notiKey
{
    _notiKey = notiKey;
}

-(void)startDownImage
{
    if([cidOperation isFinished])
    {
        cidOperation = nil;
    }
    
    if(cidOperation == nil)
    {
        cidOperation = [[ZXYPetStylePicDown alloc] initWithFirstArr:placeURLARR andSaveDire:subDirectory];
        [cidOperation setNotificationKey:_notiKey];
        [tempQueue addOperation:cidOperation];
    }
}
@end
