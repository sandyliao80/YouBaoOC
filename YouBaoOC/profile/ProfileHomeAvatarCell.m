//
//  ProfileHomeAvatarCell.m
//  YouBaoOC
//
//  Created by Licy on 14-8-4.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "ProfileHomeAvatarCell.h"

NSString *const ProfileHomeAvatarCellIdentifier = @"ProfileHomeAvatarCellIdentifier";

@implementation ProfileHomeAvatarCell

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
    
    CGFloat avatarContainerRadius = MIN(self.avatarContainerView.frame.size.height, self.avatarContainerView.frame.size.width) /2.0f;
    [self.avatarContainerView.layer setCornerRadius:avatarContainerRadius];
    [self.avatarContainerView.layer setMasksToBounds:YES];
    [self.avatarContainerView.layer setBorderWidth:1.0f];
    [self.avatarContainerView.layer setBorderColor:[THEME_DARK_BLUE CGColor]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
