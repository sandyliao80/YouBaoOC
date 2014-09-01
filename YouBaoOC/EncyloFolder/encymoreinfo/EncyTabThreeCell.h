//
//  EncyTabThreeCell.h
//  YouBaoOC
//
//  Created by 周效宇 on 14-8-29.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TabDelegate<NSObject>
- (void)selectTabBtn:(NSInteger)currentTag;
@end
@interface EncyTabThreeCell : UITableViewCell
@property (nonatomic,strong)id<TabDelegate>delegate;
@end
