//
//  ProfileHomePetCell.m
//  YouBaoOC
//
//  Created by Licy on 14-8-4.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "ProfileHomePetCell.h"

NSString *const ProfileHomePetCellIdentifier = @"ProfileHomePetCellIdentifier";

@implementation ProfileHomePetCell

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
    
    CGFloat avatarContainerRadius = MIN(self.avatarContainerView.frame.size.height, self.avatarContainerView.frame.size.width) / 2.0f;
    [self.avatarContainerView.layer setCornerRadius:avatarContainerRadius];
    [self.avatarContainerView.layer setMasksToBounds:YES];
    
    [self.signLabel.layer setCornerRadius:5.0f];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellTypeBreeding:(BOOL)breeding adopting:(BOOL)adopting entrust:(BOOL)entrust{
    NSInteger index = 0;
    self.imageOne.image = nil;
    self.imageTwo.image = nil;
    self.imageThree.image = nil;
    if (breeding) {
        self.imageOne.image = [UIImage imageNamed:@"profileBreedingColor"];
        index++;
    }
    if (adopting) {
        if (index == 0) {
            self.imageOne.image = [UIImage imageNamed:@"profileAdoptColor"];
        } else {
            self.imageTwo.image = [UIImage imageNamed:@"profileAdoptColor"];
        }
        index++;
    }
    if (entrust) {
        if (index == 0) {
            self.imageOne.image = [UIImage imageNamed:@"profileEntrustColor"];
        } else if (index == 1) {
            self.imageTwo.image = [UIImage imageNamed:@"profileEntrustColor"];
        } else {
            self.imageThree.image = [UIImage imageNamed:@"profileEntrustColor"];
        }
        index++;
    }
}

@end
