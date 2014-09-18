//
//  EncySubCategoryCell.m
//  YouBaoOC
//
//  Created by developer on 14-8-7.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "EncySubCategoryCell.h"

@implementation EncySubCategoryCell

- (void)awakeFromNib {
    // Initialization code
    CGFloat radius = MIN(self.head_image.bounds.size.height, self.head_image.bounds.size.width) / 2.0f;
    [self.head_image.layer setCornerRadius:radius];
    [self.head_image.layer setMasksToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
