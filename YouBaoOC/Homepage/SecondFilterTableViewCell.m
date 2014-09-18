//
//  SecondFilterTableViewCell.m
//  YouBaoOC
//
//  Created by Licy on 14-8-1.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "SecondFilterTableViewCell.h"

NSString *const SecondFilterTableViewCellIdentifier = @"SecondFilterTableViewCellIdentifier";

@implementation SecondFilterTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

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
