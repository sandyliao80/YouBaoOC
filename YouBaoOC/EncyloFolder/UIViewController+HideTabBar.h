//
//  UIViewController+HideTabBar.h
//  YouBaoOC
//
//  Created by developer on 14-8-21.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HideTabBar)
- (void)hideTabBar;
- (void)showTabBarWithSelector;
- (void)setNaviLeftItem;
- (void)setNaviRightItem:(NSString *)imageName;
- (void)setRightItemAction;
- (UIToolbar*)forKeyBoardHide:(NSString *)itemName;
- (void)hideKeyBoard:(id)sender;
@end
