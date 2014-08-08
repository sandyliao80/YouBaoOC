//
//  EncyHomeTitleCell.h
//  YouBaoOC
//
//  Created by developer on 14-8-6.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EncyHomeTitleCell : UITableViewCell
@property(nonatomic,strong)IBOutlet UILabel *todayInfoLabel;
@property(nonatomic,strong)IBOutlet UIButton *moreInfoBtn;
- (IBAction)moreInfoBtnAction:(id)sender;
@end
