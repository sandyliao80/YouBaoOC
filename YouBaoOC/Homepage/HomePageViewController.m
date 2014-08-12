//
//  HomePageViewController.m
//  YouBaoOC
//
//  Created by Licy on 14-7-31.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "HomePageViewController.h"
#import "FilterViewController.h"
#import <SVPullToRefresh/SVPullToRefresh.h>

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
    
    [self.icyCollectionView addPullToRefreshWithActionHandler:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.icyCollectionView.pullToRefreshView stopAnimating];
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
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"gsl" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blueColor];
    return cell;
}

@end
