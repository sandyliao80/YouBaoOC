//
//  WelcomeViewController.m
//  YouBaoOC
//
//  Created by Licy on 14-7-24.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "WelcomeViewController.h"
#import "WelcomeCell.h"

@interface WelcomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    titleImage.image = [UIImage imageNamed:@"navigationLogo"];
    self.navigationItem.titleView = titleImage;
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 21;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WelcomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WelcomeCellIdentifier forIndexPath:indexPath];
    NSString *imageName = [NSString stringWithFormat:@"static-%02ld",(long)indexPath.row];
    UIImage *cellImage = [UIImage imageNamed:imageName];
    cell.icyImage.image = cellImage;
    return cell;
}

@end
