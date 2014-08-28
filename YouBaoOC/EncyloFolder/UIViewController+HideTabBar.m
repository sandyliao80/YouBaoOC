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

- (void)leftItemAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setNaviRightItem:(NSString *)imageName
{
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [leftBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
    [leftBtn addTarget:self action:@selector(setRightItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    [self.navigationItem setRightBarButtonItem:leftBtnItem];
}


- (UIToolbar *)forKeyBoardHide:(NSString *)itemName
{
    UIToolbar *topBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn setTitle:itemName forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(hideKeyBoard:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    NSArray *array = [NSArray arrayWithObjects:leftBtn,rightBtnItem, nil];
    [topBar setItems:array];
    return topBar;
}

- (void)setRightItemAction
{
    return;
}

- (void)hideKeyBoard:(id)sender
{
    if([sender isKindOfClass:[UITextField class]])
    {
        UITextField *text = (UITextField *)sender;
        [text resignFirstResponder];
    }
    else if([sender isKindOfClass:[UITextView class]])
    {
        UITextView *text = (UITextView *)sender;
        [text resignFirstResponder];
    }
    else
    {
        UISearchBar *search = (UISearchBar *)sender;
        [search resignFirstResponder];
    }
}

@end
