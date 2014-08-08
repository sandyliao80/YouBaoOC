//
//  ProfileHomeHeaderCell.m
//  YouBaoOC
//
//  Created by Licy on 14-8-8.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "ProfileHomeHeaderCell.h"

NSString *const ProfileHomeHeaderCellIdentifier = @"ProfileHomeHeaderCellIdentifier";

@implementation ProfileHomeHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
