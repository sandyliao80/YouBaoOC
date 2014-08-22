//
//  ThirdFilterViewController.h
//  YouBaoOC
//
//  Created by eagle on 14/8/22.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchDetailByID.h"

@protocol SecondFilterDelegate <NSObject>
@optional
- (void)filterDidSelected:(SearchDetailByIDChildStyle *)category;
@end

@interface ThirdFilterViewController : UIViewController

@property (weak, nonatomic) UIViewController<SecondFilterDelegate> *delegate;
@property (strong, nonatomic) NSString *parentID;

@end
