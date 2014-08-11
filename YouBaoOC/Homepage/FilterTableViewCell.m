//
//  FilterTableViewCell.m
//  YouBaoOC
//
//  Created by Licy on 14-7-31.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "FilterTableViewCell.h"

NSString *const FilterTableViewCellIdentifier = @"FilterTableViewCellIdentifier";

@implementation FilterTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    CGFloat radius = MIN(self.icyImage.frame.size.height, self.icyImage.frame.size.width)/2.0f;
    [self.icyImage.layer setCornerRadius:radius];
    [self.icyImage.layer setMasksToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
