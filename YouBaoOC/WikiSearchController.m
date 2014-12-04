//
//  WikiSearchController.m
//  YouBaoOC
//
//  Created by eagle on 14/12/4.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "WikiSearchController.h"
#import "LCYCommon.h"
#import "UIScrollView+MJRefresh.h"
#import "LCYWikiSearchDataModel.h"
#import "EncyHomePageTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "EncyloFolder/EncyDetailPetWeb.h"

@interface WikiSearchController ()<UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (copy, nonatomic) NSArray *resultInfo;

@property (nonatomic) NSInteger currentPage;

@end

@implementation WikiSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"搜索";
    self.searchDisplayController.searchBar.tintColor = THEME_COLOR;
    
    UIView *emptyView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.searchDisplayController.searchResultsTableView setTableFooterView:emptyView];
    
    __weak __typeof(self) weakSelf = self;
    [self.searchDisplayController.searchResultsTableView addFooterWithCallback:^{
        [[LCYCommon sharedInstance] showTips:@"" inView:weakSelf.searchDisplayController.searchResultsTableView];
        [[LCYNetworking sharedInstance] postRequestWithAPI:ZXY_GETMORE parameters:@{@"keyword":weakSelf.searchDisplayController.searchBar.text, @"p":@(self.currentPage++)} successBlock:^(NSDictionary *object) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [[LCYCommon sharedInstance] hideTipsInView:strongSelf.searchDisplayController.searchResultsTableView];
            LCYWikiSearchbase *baseInfo = [LCYWikiSearchbase modelObjectWithDictionary:object];
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:strongSelf.resultInfo];
            [tempArray addObjectsFromArray:baseInfo.data];
            strongSelf.resultInfo = tempArray;
            [strongSelf.searchDisplayController.searchResultsTableView reloadData];
            [strongSelf.searchDisplayController.searchResultsTableView footerEndRefreshing];
        } failedBlock:^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [[LCYCommon sharedInstance] hideTipsInView:strongSelf.searchDisplayController.searchResultsTableView];
            [strongSelf.searchDisplayController.searchResultsTableView footerEndRefreshing];
        }];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.resultInfo) {
        return self.resultInfo.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EncyHomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    if (!cell) {
        UINib *nib = [UINib nibWithNibName:@"EncyHomePageTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:@"cellIdentifier"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    }
    LCYWikiSearchData *data = self.resultInfo[indexPath.row];
    cell.titleLbl.text = data.title;
    cell.readNum.text = data.encyRead;
    cell.collectNum.text = data.encyCollect;
    cell.keyWork.text = @"关键词";
    cell.firstKey.text = data.keyword;
    
    [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",hostImageURL,data.headImg]] placeholderImage:[UIImage imageNamed:@"profilePetPlaceHolder"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64.0f;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    // 开始搜索
    self.currentPage = 0;
    __weak __typeof(self) weakSelf = self;
    [[LCYCommon sharedInstance] showTips:@"" inView:self.searchDisplayController.searchResultsTableView];
    [[LCYNetworking sharedInstance] postRequestWithAPI:ZXY_GETMORE parameters:@{@"keyword":searchBar.text, @"p":@(self.currentPage)} successBlock:^(NSDictionary *object) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [[LCYCommon sharedInstance] hideTipsInView:strongSelf.searchDisplayController.searchResultsTableView];
        LCYWikiSearchbase *baseInfo = [LCYWikiSearchbase modelObjectWithDictionary:object];
        strongSelf.resultInfo = baseInfo.data;
        [strongSelf.searchDisplayController.searchResultsTableView reloadData];
    } failedBlock:^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [[LCYCommon sharedInstance] hideTipsInView:strongSelf.searchDisplayController.searchResultsTableView];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LCYWikiSearchData *info = self.resultInfo[indexPath.row];
    EncyDetailPetWeb *detailWeb = [[EncyDetailPetWeb alloc] initWithPetID:info.encyId.integerValue andType:NO];
    [detailWeb setIsSelected:NO];
    [self.navigationController pushViewController:detailWeb animated:YES];
}

@end
