//
//  FilterViewController.h
//  YouBaoOC
//
//  Created by Licy on 14-7-31.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondFilterViewController.h"

@interface FilterViewController : UIViewController

@property (weak, nonatomic) UIViewController<SecondFilterDelegate> *delegate;

@end
