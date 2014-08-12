//
//  RecommendCell.m
//  YouBaoOC
//
//  Created by eagle on 14/8/12.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "RecommendCell.h"

NSString *const RecommendCellIdentifier = @"RecommendCellIdentifier";

@implementation RecommendCell

- (void)awakeFromNib{
    CGFloat radius = MIN(self.icySmallImage.frame.size.height, self.icySmallImage.frame.size.width)/2.0f;
    [self.icySmallImage.layer setCornerRadius:radius];
    [self.icySmallImage.layer setMasksToBounds:YES];
}

@end
