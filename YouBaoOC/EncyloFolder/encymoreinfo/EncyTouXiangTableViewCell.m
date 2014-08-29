//
//  EncyTouXiangTableViewCell.m
//  YouBaoOC
//
//  Created by 周效宇 on 14-8-29.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "EncyTouXiangTableViewCell.h"
@interface EncyTouXiangTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *bigHeadImage;
@property (weak, nonatomic) IBOutlet UIImageView *leftLine;

@property (weak, nonatomic) IBOutlet UIImageView *rightLine;

@end
@implementation EncyTouXiangTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.smallImage.layer.cornerRadius = self.smallImage.frame.size.width/2;
    self.bigHeadImage.layer.cornerRadius = self.bigHeadImage.frame.size.width/2;
    self.smallImage.layer.masksToBounds = YES;
    self.bigHeadImage.layer.masksToBounds = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
