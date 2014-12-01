//
//  TwitterHomeViewController.m
//  YouBaoOC
//
//  Created by eagle on 14/9/30.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "TwitterHomeViewController.h"
#import "TwitterHeaderCell.h"
#import "TwitterContentCell.h"

@interface TwitterHomeViewController ()<UITableViewDataSource>

@end

@implementation TwitterHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setImage:[UIImage imageNamed:@"wikiDot"] forState:UIControlStateNormal];
    [doneButton sizeToFit];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        TwitterHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:TwitterHeaderCellIdentifier];
        return cell;
    } else {
        TwitterContentCell *cell = [tableView dequeueReusableCellWithIdentifier:TwitterContentCellIdentifier];
        return cell;
    }
}

@end
