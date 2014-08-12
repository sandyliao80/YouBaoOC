//
//  RecommendCell.h
//  YouBaoOC
//
//  Created by eagle on 14/8/12.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString *const RecommendCellIdentifier;

@interface RecommendCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icyMainImage;
@property (weak, nonatomic) IBOutlet UIImageView *icySmallImage;

@end
