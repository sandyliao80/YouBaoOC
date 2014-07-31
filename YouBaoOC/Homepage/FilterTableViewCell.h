//
//  FilterTableViewCell.h
//  YouBaoOC
//
//  Created by Licy on 14-7-31.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString *const FilterTableViewCellIdentifier;

@interface FilterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icyImage;

@property (weak, nonatomic) IBOutlet UILabel *icyLabel;

@end
