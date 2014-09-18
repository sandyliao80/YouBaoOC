//
//  ThirdFilterCellTableViewCell.m
//  YouBaoOC
//
//  Created by eagle on 14/8/22.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "ThirdFilterCellTableViewCell.h"

NSString *const ThirdFilterCellTableViewCellIdentifier = @"ThirdFilterCellTableViewCellIdentifier";

@implementation ThirdFilterCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
    CGFloat radius = MIN(self.icyImageView.frame.size.height, self.icyImageView.frame.size.width)/2.0f;
    [self.icyImageView.layer setCornerRadius:radius];
    [self.icyImageView.layer setMasksToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
