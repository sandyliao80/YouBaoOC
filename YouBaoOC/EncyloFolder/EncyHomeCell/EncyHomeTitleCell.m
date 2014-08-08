//
//  EncyHomeTitleCell.m
//  YouBaoOC
//
//  Created by developer on 14-8-6.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "EncyHomeTitleCell.h"
#import "EN_PreDefine.h"
@implementation EncyHomeTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    self.todayInfoLabel.textColor = [UIColor colorWithRed:0.9804 green:0.5098 blue:0.4353 alpha:1];
    [self.moreInfoBtn setTitleColor:[UIColor colorWithRed:0.9804 green:0.5098 blue:0.4353 alpha:1] forState:UIControlStateNormal];
    [self.moreInfoBtn setTitleColor:[UIColor colorWithRed:0.9804 green:0.5098 blue:0.4353 alpha:1] forState:UIControlStateHighlighted];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)moreInfoBtnAction:(id)sender
{
 
}
@end
