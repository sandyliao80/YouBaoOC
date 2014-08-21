//
//  ProfileEditingSignCell.h
//  YouBaoOC
//
//  Created by eagle on 14/8/20.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString *const ProfileEditingSignCellIdentifier;

@class ProfileEditingSignCell;
@protocol ProfileEditingSignCellDelegate <NSObject>

- (void)profileEditingSignCell:(ProfileEditingSignCell *)cell didChangeSwichStateAt:(NSIndexPath *)indexPath toState:(BOOL)state;

@end

@interface ProfileEditingSignCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *icyLabel;

@property (weak, nonatomic) IBOutlet UILabel *icyDetailLabel;

@property (weak, nonatomic) IBOutlet UISwitch *icySwitch;

@property (strong, nonatomic) NSIndexPath *indexPath;

@property (weak, nonatomic) id<ProfileEditingSignCellDelegate>delegate;

@end
