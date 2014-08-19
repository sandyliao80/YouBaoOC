//
//  EncyHomePageTableViewCell.m
//  YouBaoOC
//
//  Created by developer on 14-8-5.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "EncyHomePageTableViewCell.h"
@interface EncyHomePageTableViewCell()

@end
@implementation EncyHomePageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    self.titleLbl.textColor= [UIColor colorWithRed:0.9804 green:0.5098 blue:0.4353 alpha:1];
    self.readLbl.textColor = [UIColor colorWithRed:0.9804 green:0.5098 blue:0.4353 alpha:1];
    self.collectLbl.textColor = [UIColor colorWithRed:0.2824 green:0.5725 blue:0.7137 alpha:1];
    self.readNum.textColor = [UIColor whiteColor];
    self.collectNum.textColor = [UIColor whiteColor];
    self.titleImage.layer.cornerRadius = self.titleImage.frame.size.height/2;
    self.titleImage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
