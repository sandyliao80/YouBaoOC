//
//  SecondFilterViewController.h
//  YouBaoOC
//
//  Created by Licy on 14-8-1.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchDetailByID.h"

@protocol SecondFilterDelegate <NSObject>
@optional
- (void)filterDidSelected:(SearchDetailByIDChildStyle *)category;
@end

@interface SecondFilterViewController : UIViewController

@property (weak, nonatomic) UIViewController<SecondFilterDelegate> *delegate;
@property (strong, nonatomic) NSString *parentID;

@end
