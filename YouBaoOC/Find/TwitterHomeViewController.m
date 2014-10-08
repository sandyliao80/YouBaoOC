//
//  TwitterHomeViewController.m
//  YouBaoOC
//
//  Created by eagle on 14/9/30.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "TwitterHomeViewController.h"

@interface TwitterHomeViewController ()

@end

@implementation TwitterHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 确定按钮
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setFrame:CGRectMake(0, 0, 40, 24)];
    [doneButton setTitle:@"发送" forState:UIControlStateNormal];
    doneButton.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 12);
    [doneButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [doneButton sizeToFit];
    doneButton.layer.cornerRadius = 4.0f;
    doneButton.layer.masksToBounds = YES;
    [doneButton setBackgroundColor:THEME_DARK_BLUE];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    [doneButton addTarget:self action:@selector(makeTwitterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (void)makeTwitterButtonPressed:(id)sender{
    
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
