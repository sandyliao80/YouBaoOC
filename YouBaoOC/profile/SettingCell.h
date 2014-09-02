//
//  SettingCell.h
//  YouBaoOC
//
//  Created by eagle on 14/9/2.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString *const SettingCellIdentifier;

@interface SettingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icyImageView;

@property (weak, nonatomic) IBOutlet UILabel *icyLabel;

@end
