//
//  SquareHomeDynamicCell.m
//  YouBaoOC
//
//  Created by eagle on 14/10/11.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "SquareHomeDynamicCell.h"

NSString *const SquareHomeDynamicCellIdentifier = @"SquareHomeDynamicCellIdentifier";

@interface SquareHomeDynamicCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seprateLineHeight;

@end

@implementation SquareHomeDynamicCell

- (void)awakeFromNib {
    // Initialization code
    self.seprateLineHeight.constant = 1.f / [UIScreen mainScreen].scale;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
