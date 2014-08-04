//
//  FilterViewController.m
//  YouBaoOC
//
//  Created by Licy on 14-7-31.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "FilterViewController.h"
#import "LCYCommon.h"
#import "searchAllTypePets.h"
#import "FilterTableViewCell.h"

@interface FilterViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *icyTableView;

@property (strong, nonatomic) NSArray *filterResult;

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.filterResult = [NSArray array];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"navigationBack"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(navigationBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;
    
    [[LCYNetworking sharedInstance] postRequestWithAPI:PetStyle_searchAllTypePets parameters:@{} successBlock:^(NSDictionary *object) {
        searchAllTypePetsBase *base = [searchAllTypePetsBase modelObjectWithDictionary:object];
        self.filterResult = [NSArray arrayWithArray:base.fatherStyle];
        if ([self.filterResult count] != 0) {
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 22)];
            [headerView setBackgroundColor:[UIColor colorWithRed:231.0/255.0f green:242.0/255.0f blue:246.0/255.0f alpha:1.0f]];
            UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 22)];
            [footerView setBackgroundColor:[UIColor colorWithRed:231.0/255.0f green:242.0/255.0f blue:246.0/255.0f alpha:1.0f]];
            [self.icyTableView setTableHeaderView:headerView];
            [self.icyTableView setTableFooterView:footerView];
            [self.icyTableView reloadData];
        }
    } failedBlock:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"分类消息加载失败，请检查您的网络状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"FilterPushToSecond"]) {
        NSInteger row = [self.icyTableView indexPathForSelectedRow].row;
        searchAllTypePetsFatherStyle *style = self.filterResult[row];
        SecondFilterViewController *secondVC = [segue destinationViewController];
        secondVC.delegate = self.delegate;
        secondVC.parentID = style.catId;
    }
}


#pragma mark - Actions
- (void)navigationBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.filterResult count] != 0) {
    }
    return [self.filterResult count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FilterTableViewCellIdentifier];
    
    if (indexPath.row %2 == 0) {
        [cell setBackgroundColor:[UIColor colorWithRed:227.0/255.0f green:247.0/255.0f blue:254.0/255.0f alpha:1.0f]];
    } else {
        [cell setBackgroundColor:[UIColor colorWithWhite:236.0/255.0 alpha:1.0]];
    }
    
    searchAllTypePetsFatherStyle *fartherStyle = self.filterResult[indexPath.row];
    cell.icyLabel.text = fartherStyle.name;
    
    return cell;
}

@end
