//
//  EncyHomePageTableViewCell.h
//  YouBaoOC
//
//  Created by developer on 14-8-5.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EncyHomePageTableViewCell : UITableViewCell
@property(nonatomic,strong)IBOutlet UILabel *collectLbl;
@property(nonatomic,strong)IBOutlet UILabel *readLbl;
@property(nonatomic,strong)IBOutlet UILabel *titleLbl;
@property(nonatomic,strong)IBOutlet UIImageView *titleImage;
@property(nonatomic,strong)IBOutlet UILabel *collectNum;
@property(nonatomic,strong)IBOutlet UILabel *readNum;
@end
