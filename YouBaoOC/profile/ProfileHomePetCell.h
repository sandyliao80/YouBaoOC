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


@end
