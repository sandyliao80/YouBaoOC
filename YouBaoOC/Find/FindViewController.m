//
//  FindViewController.m
//  YouBaoOC
//
//  Created by eagle on 14/9/28.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "FindViewController.h"

@interface FindViewController ()

@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return 4;
    } else if (section == 1) {
        return 1;
    } else {
        // this will never be excuted
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"  forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                // 宠物圈
                cell.imageView.image = [UIImage imageNamed:@"find_twitter"];
                cell.textLabel.text = @"宠物圈";
                break;
            case 1:
                // 附近
                cell.imageView.image = [UIImage imageNamed:@"find_nearby"];
                cell.textLabel.text = @"附近";
                break;
            case 2:
                // 宠友
                cell.imageView.image = [UIImage imageNamed:@"find_friend"];
                cell.textLabel.text = @"宠友";
                break;
            case 3:
                // 搜索
                cell.imageView.image = [UIImage imageNamed:@"find_search"];
                cell.textLabel.text = @"搜索";
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            // 宠友录
            cell.imageView.image = [UIImage imageNamed:@"find_catalog"];
            cell.textLabel.text = @"宠友录";
        }
    } else {
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                // 宠物圈
                [self performSegueWithIdentifier:@"showTwitterHome" sender:nil];
                break;
            case 1:
                // 附近
                break;
            case 2:
                // 宠友
                break;
            case 3:
                // 搜索
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            // 宠友录
        }
    } else {
        
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
