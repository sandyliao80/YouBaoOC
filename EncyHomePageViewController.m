//
//  EncyHomePageViewController.m
//  YouBaoOC
//
//  Created by developer on 14-8-5.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "EncyHomePageViewController.h"
#import "AppDelegate.h"
@interface EncyHomePageViewController ()

@end

@implementation EncyHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"宠物百科";
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.3882 green:0.6235 blue:0.7569 alpha:1],NStext, nil];
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [leftBtn addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setImage:[UIImage imageNamed:@"en_leftNavi"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"en_leftNavi"] forState:UIControlStateHighlighted];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    [self.navigationItem setLeftBarButtonItem:leftBtnItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)zouQI
{
    UIStoryboard *stroyCurrent = [UIStoryboard storyboardWithName:@"Encyclope" bundle:nil];
    UIViewController *inTo     = [stroyCurrent instantiateInitialViewController];
    [self.navigationController pushViewController:inTo animated:YES];
}

- (void)leftItemAction
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
