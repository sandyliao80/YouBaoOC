//
//  EncyHomeImageCell.m
//  YouBaoOC
//
//  Created by developer on 14-8-6.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "EncyHomeImageCell.h"
#import "ZXYScrollView.h"
@interface EncyHomeImageCell()<ZXYScrollDataSource,ZXYScrollDelegate>
{
    
}
@end

@implementation EncyHomeImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    NSLog(@"%f,%f",self.zxyScroll.frame.size.width,self.zxyScroll.frame.size.height);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.zxyScroll.dataSource = self;
    self.zxyScroll.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(BOOL)shouldTurnAutoWithTime
{
    return YES;
}//定时滚动
-(NSTimeInterval)turnTimeInterVal
{
    return 3;
};//滚动间隔
-(BOOL)shouldClickAtIndex:(NSInteger)index
{
    return NO;
}//是否可以进行点击事件
- (NSInteger)numberOfPages
{
    return 3;
}//页数
- (UIView *)viewAtIndexPage:(NSInteger)index
{
    UIImageView *currentImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 119)];
    currentImage.image = [UIImage imageNamed:@"en_Home"];
    return currentImage;
}
@end
