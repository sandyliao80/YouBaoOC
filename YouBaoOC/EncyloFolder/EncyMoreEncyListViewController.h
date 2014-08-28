//
//  EncyMoreEncyListViewController.h
//  YouBaoOC
//
//  Created by developer on 14-8-19.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EncyMoreEncyListViewController : UIViewController
-(id)initWithPetId:(NSInteger)petID;
- (void)setTitles:(NSString *)title;
- (void)hideSearchBtn;
- (void)setPetID:(NSInteger)petID;

@end
