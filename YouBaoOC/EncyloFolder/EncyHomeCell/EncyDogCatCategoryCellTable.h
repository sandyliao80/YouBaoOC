//
//  EncyDogCatCategoryCellTable.h
//  YouBaoOC
//
//  Created by developer on 14-8-19.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol EncyDogCatClassDelegate <NSObject>
- (void)selectTypeIS:(NSString *)typeID;
@end
@interface EncyDogCatCategoryCellTable : UITableViewCell
@property (nonatomic,strong)id<EncyDogCatClassDelegate>delegate;
@end
