//
//  ProfileEditingHeadCell.m
//  YouBaoOC
//
//  Created by eagle on 14/8/20.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "ProfileEditingHeadCell.h"

NSString *const ProfileEditingHeadCellIdentifier = @"ProfileEditingHeadCellIdentifier";

@interface ProfileEditingHeadCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarBGView;

@end

@implementation ProfileEditingHeadCell

- (void)awakeFromNib {
    // Initialization code
    CGFloat avatarBGRadius = MIN(self.avatarBGView.bounds.size.width, self.avatarBGView.bounds.size.height) / 2.0f;
    [self.avatarBGView.layer setCornerRadius:avatarBGRadius];
    [self.avatarBGView.layer setMasksToBounds:YES];
    
    CGFloat avatarImageRadius = MIN(self.avatarImageView.bounds.size.width, self.avatarImageView.bounds.size.height) / 2.0f;
    [self.avatarImageView.layer setCornerRadius:avatarImageRadius];
    [self.avatarImageView.layer setMasksToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
