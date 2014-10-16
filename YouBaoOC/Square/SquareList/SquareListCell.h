//
//  SquareListCell.h
//  YouBaoOC
//
//  Created by eagle on 14/10/16.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString *const SquareListCellIdentifier;

@interface SquareListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *businessNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *businessBriefLabel;

@property (weak, nonatomic) IBOutlet UILabel *businessDistanceLabel;


@end
