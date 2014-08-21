//
//  ProfileEditingSignCell.m
//  YouBaoOC
//
//  Created by eagle on 14/8/20.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "ProfileEditingSignCell.h"

NSString *const ProfileEditingSignCellIdentifier = @"ProfileEditingSignCellIdentifier";

@implementation ProfileEditingSignCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)switchDidChanged:(UISwitch *)sender {
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(profileEditingSignCell:didChangeSwichStateAt:toState:)] ) {
        [self.delegate profileEditingSignCell:self didChangeSwichStateAt:self.indexPath toState:sender.isOn];
    }
}
@end
