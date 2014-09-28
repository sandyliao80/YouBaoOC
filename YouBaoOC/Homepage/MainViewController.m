//
//  MainViewController.m
//  YouBaoOC
//
//  Created by Licy on 14-7-28.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "MainViewController.h"

typedef NS_ENUM(NSUInteger, TabBarIndex) {
    TabBarIndexWo = 0,
    TabBarIndexBaike = 1,
    TabBarIndexFaxian = 2,
    TabBarIndexGuangchang = 3,
    TabBarIndexTemai = 4,
};

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tabBar setTintColor:THEME_COLOR];
    
    // 发现
    UINavigationController *findVC = [[UIStoryboard storyboardWithName:@"Find" bundle:nil] instantiateInitialViewController];
    findVC.tabBarItem.image = [UIImage imageNamed:@"tabbarFaxian"];
    [self addChildViewController:findVC];
    
    // 广场
    UINavigationController *SquareVC = [[UIStoryboard storyboardWithName:@"Square" bundle:nil] instantiateInitialViewController];
    SquareVC.tabBarItem.image = [UIImage imageNamed:@"tabbarGuangchang"];
    [self addChildViewController:SquareVC];
    
    // 特卖
    UINavigationController *SellingVC = [[UIStoryboard storyboardWithName:@"Selling" bundle:nil] instantiateInitialViewController];
    SellingVC.tabBarItem.image = [UIImage imageNamed:@"tabbarTemai"];
    [self addChildViewController:SellingVC];
    
    NSArray *orderArray = @[self.viewControllers[TabBarIndexFaxian], self.viewControllers[TabBarIndexGuangchang], self.viewControllers[TabBarIndexBaike], self.viewControllers[TabBarIndexTemai], self.viewControllers[TabBarIndexWo]];
    
    self.viewControllers = orderArray;
    
    [self setSelectedIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
