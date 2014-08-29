//
//  EncyHomeImageCell.h
//  YouBaoOC
//
//  Created by developer on 14-8-6.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol EncyHomeImageCellDelegate<NSObject>
- (void)selectADImageWithEncy_ID:(NSString *)ency_id andTitle:(NSString *)title;
@end

@class ZXYScrollView;
@interface EncyHomeImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet ZXYScrollView *zxyScroll;
@property (nonatomic,strong)id<EncyHomeImageCellDelegate>delegate;
@end
