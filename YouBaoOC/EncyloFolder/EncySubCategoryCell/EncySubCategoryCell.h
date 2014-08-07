//
//  EncySubCategoryCell.h
//  YouBaoOC
//
//  Created by developer on 14-8-7.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//
#define SUBCATCELLIDENTIFIER @"en_subCategoryCell"
#import <UIKit/UIKit.h>

@interface EncySubCategoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *head_image;
@property (weak, nonatomic) IBOutlet UILabel *petNameLbl;

@end
