//
//  EncyHomeTitleCell.h
//  YouBaoOC
//
//  Created by developer on 14-8-6.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol EncyHomeTitleDelegate <NSObject>
- (void)moreInfoBtnClick;
@end
@interface EncyHomeTitleCell : UITableViewCell
@property(nonatomic,strong)IBOutlet UILabel *todayInfoLabel;
@property(nonatomic,strong)IBOutlet UIButton *moreInfoBtn;
@property(nonatomic,strong)id<EncyHomeTitleDelegate>delegate;
- (IBAction)moreInfoBtnAction:(id)sender;
@end
