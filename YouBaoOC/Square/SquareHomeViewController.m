//
//  SquareHomeViewController.m
//  YouBaoOC
//
//  Created by eagle on 14/10/8.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "SquareHomeViewController.h"
#import "LCYNetworking.h"
#import "LCYGetSquareCategory.h"
#import "LCYCommon.h"
#import "SquareHomeAdCell.h"
#import "SquareHomeStaticCell.h"
#import "SquareHomeDynamicCell.h"

@interface SquareHomeViewController ()<UITableViewDelegate, UITableViewDataSource>

// 所有分类信息
@property (strong, nonatomic) LCYGetSquareCategoryBase *getSquareCategoryBase;
// 可变的信息（所有信息的子集）
@property (strong, nonatomic) NSArray *dynamicCategory;

@property (weak, nonatomic) IBOutlet UITableView *icyTableView;

@end

@implementation SquareHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.icyTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    __weak __typeof(self) weakSelf = self;
    [[LCYCommon sharedInstance] showTips:@"加载中" inView:self.view];
    [[LCYNetworking sharedInstance] postRequestWithAPI:Square_getSquareCategory parameters:nil successBlock:^(NSDictionary *object) {
        [[LCYCommon sharedInstance] hideTipsInView:weakSelf.view];
        if ([object[@"result"] boolValue]) {
            self.getSquareCategoryBase = [LCYGetSquareCategoryBase modelObjectWithDictionary:object];
            [weakSelf.icyTableView reloadData];
        }
    } failedBlock:^{
        [[LCYCommon sharedInstance] hideTipsInView:weakSelf.view];
    }];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 152.0f;
            break;
        case 1:
            return 215.0f;
            break;
        case 2:
            return 50.0f;
            break;
            
        default:
            return 0.0f;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!self.getSquareCategoryBase) {
        return 0;
    } else {
        return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
        {
            NSMutableArray *dynamicInfoArray = [NSMutableArray array];
            for (LCYGetSquareCategoryListInfo *info in self.getSquareCategoryBase.listInfo) {
                if ([info.isLock isEqualToString:@"0"]) {
                    [dynamicInfoArray addObject:info];
                }
            }
            self.dynamicCategory = [NSArray arrayWithArray:dynamicInfoArray];
            return self.dynamicCategory.count;
            break;
        }
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        SquareHomeAdCell *cell = [tableView dequeueReusableCellWithIdentifier:SquareHomeAdCellIdentifier];
        return cell;
    } else if (indexPath.section == 1) {
        SquareHomeStaticCell *cell = [tableView dequeueReusableCellWithIdentifier:SquareHomeStaticCellIdentifier];
        return cell;
    } else if (indexPath.section == 2) {
        SquareHomeDynamicCell * cell = [tableView dequeueReusableCellWithIdentifier:SquareHomeDynamicCellIdentifier];
        LCYGetSquareCategoryListInfo *info = self.dynamicCategory[indexPath.row];
        cell.icyLabel.text = info.cateName;
        return cell;
    } else {
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        CGRect headerFrame = CGRectMake(0, 0, self.view.frame.size.width, 30.0f);
        UIView *sectionHeader = [[UIView alloc] initWithFrame:headerFrame];
        [sectionHeader setBackgroundColor:[UIColor colorWithWhite:0.9f alpha:1.0f]];
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.f, 0.f, 140.f, 30.f)];
        headerLabel.text = @"其他服务";
        headerLabel.textColor = THEME_PINK;
        headerLabel.font = [UIFont boldSystemFontOfSize:13.f];
        [sectionHeader addSubview:headerLabel];
        return sectionHeader;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 30.f;
    } else {
        return 0;
    }
}

@end
