//
//  ProfileHomePetCell.h
//  YouBaoOC
//
//  Created by Licy on 14-8-4.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString *const ProfileHomePetCellIdentifier;

@interface ProfileHomePetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icyImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarContainerView;

@property (weak, nonatomic) IBOutlet UIImageView *breakLineImageView;

@property (weak, nonatomic) IBOutlet UIImageView *imageOne;

@property (weak, nonatomic) IBOutlet UIImageView *imageTwo;

@property (weak, nonatomic) IBOutlet UIImageView *imageThree;

- (void)cellTypeBreeding:(BOOL)breeding adopting:(BOOL)adopting entrust:(BOOL)entrust;

@end
