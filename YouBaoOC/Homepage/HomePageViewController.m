//
//  HomePageViewController.m
//  YouBaoOC
//
//  Created by Licy on 14-7-31.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "HomePageViewController.h"
#import "FilterViewController.h"
#import "RecommendCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MJRefresh.h"

@interface HomePageViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *icyCollectionView;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 导航栏
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 0.0f;
    UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [filterButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
    [filterButton setFrame:CGRectMake(0, 0, 44.0f, 44.0f)];
    [filterButton setTitle:@"筛选" forState:UIControlStateNormal];
    [filterButton setTitle:@"筛选" forState:UIControlStateHighlighted];
    [filterButton addTarget:self action:@selector(filterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:filterButton];
    [self.navigationItem setLeftBarButtonItems:@[fixedSpace, buttonItem]];
    
    [self.icyCollectionView addHeaderWithCallback:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.icyCollectionView headerEndRefreshing];
        });
    }];
    [self.icyCollectionView addFooterWithCallback:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.icyCollectionView footerEndRefreshing];
        });
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
    if ([segue.identifier isEqualToString:@"homePushFilter"]) {
        
    }
}


- (void)filterButtonPressed:(id)sender{
    [self performSegueWithIdentifier:@"homePushFilter" sender:nil];
}

#pragma mark - Actions


#pragma mark - CollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 24;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:RecommendCellIdentifier forIndexPath:indexPath];
    [cell.icyMainImage sd_setImageWithURL:[NSURL URLWithString:@"http://115.29.46.22/pet/Upload/pets/53e97c0edaf3a.png"]];
    [cell.icySmallImage sd_setImageWithURL:[NSURL URLWithString:@"http://115.29.46.22/pet/Upload/users/53da11a0d9a69.png"]];
    return cell;
}

@end
