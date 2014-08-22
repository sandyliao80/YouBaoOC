//
//  UIViewController+HideTabBar.m
//  YouBaoOC
//
//  Created by developer on 14-8-21.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "UIViewController+HideTabBar.h"

@implementation UIViewController (HideTabBar)
- (void)hideTabBar
{
    for(UIView *view in self.tabBarController.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
           [UIView animateWithDuration:0.3 animations:^{
               view.frame = CGRectMake(0, self.view.frame.size.height, view.frame.size.width, view.frame.size.height);
           }];
        }
    }
}

- (void)showTabBarWithSelector
{
    for(UIView *view in self.tabBarController.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [UIView animateWithDuration:0.3 animations:^{
                view.frame = CGRectMake(0, self.view.frame.size.height-view.frame.size.height, view.frame.size.width, view.frame.size.height);
            }];
        }
    }

}

- (void)setNaviLeftItem
{
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
    [leftBtn setImage:[UIImage imageNamed:@"navigationBack"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"navigationBack"] forState:UIControlStateHighlighted];
    [leftBtn addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    [self.navigationItem setLeftBarButtonItem:leftBtnItem];
}
@end
