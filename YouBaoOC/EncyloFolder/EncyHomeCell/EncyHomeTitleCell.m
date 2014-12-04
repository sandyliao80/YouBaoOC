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
    self.todayInfoLabel.textColor = EN_BLUECAT;
    [self.moreInfoBtn setTitleColor:[UIColor colorWithRed:65.0/255.0 green:134.0/255.0 blue:174.0/255.0 alpha:1] forState:UIControlStateNormal];
    [self.moreInfoBtn setTitleColor:[UIColor colorWithRed:65.0/255.0 green:134.0/255.0 blue:174.0/255.0 alpha:1] forState:UIControlStateHighlighted];
    [self.searchButton setTitleColor:[UIColor colorWithRed:65.0/255.0 green:134.0/255.0 blue:174.0/255.0 alpha:1] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)moreInfoBtnAction:(id)sender
{
    if([self.delegate respondsToSelector:@selector(moreInfoBtnClick)])
    {
        [self.delegate moreInfoBtnClick];
    }
}
@end
