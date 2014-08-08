//
//  ProfileHomeLikeCell.h
//  YouBaoOC
//
//  Created by Licy on 14-8-4.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString *const ProfileHomeLikeCellIdentifier;

@interface ProfileHomeLikeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *xihuan;

@property (weak, nonatomic) IBOutlet UILabel *fensi;
@property (weak, nonatomic) IBOutlet UILabel *guanzhu;

@end
