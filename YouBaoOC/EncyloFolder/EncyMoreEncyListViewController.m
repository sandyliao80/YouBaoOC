//
//  EncyMoreEncyListViewController.m
//  YouBaoOC
//
//  Created by developer on 14-8-19.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "EncyMoreEncyListViewController.h"

@interface EncyMoreEncyListViewController ()
{
    NSString *_petID;
}
@end

@implementation EncyMoreEncyListViewController
-(id)initWithPetId:(NSString *)petID
{
    if(self = [super initWithNibName:@"EncyMoreEncyListViewController" bundle:nil])
    {
        _petID = petID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavi
{
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
    [leftBtn setImage:[UIImage imageNamed:@"navigationBack"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"navigationBack"] forState:UIControlStateHighlighted];
    [leftBtn addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    [self.navigationItem setLeftBarButtonItem:leftBtnItem];
    //self.view.backgroundColor = BLUEINSI;
}

- (void)leftItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
