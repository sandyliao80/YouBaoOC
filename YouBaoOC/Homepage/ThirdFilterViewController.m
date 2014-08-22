//
//  ThirdFilterViewController.m
//  YouBaoOC
//
//  Created by eagle on 14/8/22.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "ThirdFilterViewController.h"
#import "LCYCommon.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ThirdFilterCellTableViewCell.h"

@interface ThirdFilterViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSDictionary *detailResult;
@property (strong, nonatomic) NSArray *keyArray;

@property (weak, nonatomic) IBOutlet UITableView *icyTableView;


@end

@implementation ThirdFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.detailResult = [NSDictionary dictionary];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"navigationBack"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(navigationBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;
    
    self.navigationItem.title = @"宠物种类";
    
    [[LCYNetworking sharedInstance] postRequestWithAPI:PetStyle_searchDetailByID parameters:@{@"f_id" : self.parentID} successBlock:^(NSDictionary *object) {
        SearchDetailByIDBase *base = [SearchDetailByIDBase modelObjectWithDictionary:object];
        NSArray *result = [NSArray arrayWithArray:base.childStyle];
        NSMutableDictionary *tpl = [NSMutableDictionary dictionary];
        for (SearchDetailByIDChildStyle *child in result) {
            NSString *key = child.spell;
            NSMutableArray *startArray;
            if (!tpl[key]) {
                startArray = [NSMutableArray array];
            } else {
                startArray = tpl[key];
            }
            [startArray addObject:child];
            [tpl setObject:startArray forKey:key];
        }
        self.detailResult = [NSDictionary dictionaryWithDictionary:tpl];
        self.keyArray = [[self.detailResult allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString *str1 = obj1;
            NSString *str2 = obj2;
            char char1 = [str1 characterAtIndex:0];
            char char2 = [str2 characterAtIndex:0];
            return char1 > char2;
        }];
        if (self.detailResult.allKeys.count != 0) {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Actions
- (void)navigationBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[self.detailResult allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *key = [self.keyArray objectAtIndex:section];
    return [self.detailResult[key] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ThirdFilterCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ThirdFilterCellTableViewCellIdentifier];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSString *key = [self.keyArray objectAtIndex:section];
    SearchDetailByIDChildStyle *child = self.detailResult[key][row];
    cell.icyLabel.text = child.name;
    
    NSString *imageRelativePath = child.headImg;
    NSString *imagePath = [hostImageURL stringByAppendingString:imageRelativePath];
    [cell.icyImageView sd_setImageWithURL:[NSURL URLWithString:imagePath]];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.keyArray[section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.keyArray;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(filterDidSelected:)]) {
        NSInteger section = indexPath.section;
        NSInteger row = indexPath.row;
        NSString *key = [self.keyArray objectAtIndex:section];
        SearchDetailByIDChildStyle *child = self.detailResult[key][row];
        [self.delegate filterDidSelected:child];
        [self.navigationController popToViewController:self.delegate animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25.0f;
}

@end
