//
//  EncyMoreInfoForTypeViewController.m
//  YouBaoOC
//
//  Created by 周效宇 on 14-8-29.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "EncyMoreInfoForTypeViewController.h"
#define TXCELLI @"ENCYTXI"
@interface EncyMoreInfoForTypeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *allDataForShow;
}
@end

@implementation EncyMoreInfoForTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 0;
    }
    else if(section == 1)
    {
        return 1;
    }
    else
    {
        return allDataForShow.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 80;
    }
    else if (indexPath.section == 1)
    {
        return 44;
    }
    else
    {
        return 96;
    }
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
