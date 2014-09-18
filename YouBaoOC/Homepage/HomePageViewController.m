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
#import "LCYCommon.h"
#import "PetRecommend.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <IDMPhotoBrowser/IDMPhotoBrowser.h>
#import "UIScrollView+LCYRefresh.h"

#define HOME_NUMBER_PER_PAGE @15

@interface HomePageViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, SecondFilterDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *icyCollectionView;

@property (strong, nonatomic) SearchDetailByIDChildStyle *filterStyle;

@property (strong, nonatomic) PetRecommendBase *recommendBase;

@property (strong, nonatomic) NSMutableArray *baseArray;


@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.baseArray = [NSMutableArray array];
    
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
    
    // 初始化信息
//    [self loadInitData];
    
    __weak HomePageViewController *weakSelf = self;
//    [self.icyCollectionView addHeaderWithCallback:^{
//        [self loadInitData];
//    }];
    [self.icyCollectionView setContentInset:UIEdgeInsetsMake(64.0f, 0, 0, 0)];
    NSArray *image1 = @[[UIImage imageNamed:@"Red1"],[UIImage imageNamed:@"Red2"]];
    NSArray *image2 = @[[UIImage imageNamed:@"Red1"]];
    [self.icyCollectionView addPullToRefreshActionHandler:^{
        [weakSelf loadInitData];
    }
                                   ProgressImages:image2
                                    LoadingImages:image1
                          ProgressScrollThreshold:0
                           LoadingImagesFrameRate:9];
    
    [self.icyCollectionView addFooterWithCallback:^{
        [weakSelf loadMoreData];
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
        FilterViewController *filterVC = [segue destinationViewController];
        filterVC.delegate = self;
    }
}


- (void)filterButtonPressed:(id)sender{
    [self performSegueWithIdentifier:@"homePushFilter" sender:nil];
}

#pragma mark - Actions

- (void)loadInitData{
    NSDictionary *parameters;
    if (self.filterStyle) {
        parameters = @{@"cat_id"    : self.filterStyle.catId,
                       @"number"    : HOME_NUMBER_PER_PAGE};
    } else {
        parameters = @{@"number"    : HOME_NUMBER_PER_PAGE};
    }
    [[LCYNetworking sharedInstance] postRequestWithAPI:Pet_recommend parameters:parameters successBlock:^(NSDictionary *object) {
        if ([object[@"result"] boolValue]) {
            // 加载成功
            self.recommendBase = [PetRecommendBase modelObjectWithDictionary:object];
            self.baseArray = [NSMutableArray array];
            [self.baseArray addObjectsFromArray:self.recommendBase.listInfo];
            [self.icyCollectionView reloadData];
//            [self.icyCollectionView headerEndRefreshing];
            [self.icyCollectionView stopRefreshAnimation];
        } else {
            // 加载失败
//            [self.icyCollectionView headerEndRefreshing];
            [self.icyCollectionView stopRefreshAnimation];
        }
    } failedBlock:^{
        // 网络问题
//        [self.icyCollectionView headerEndRefreshing];
            [self.icyCollectionView stopRefreshAnimation];
    }];
}

- (void)loadMoreData{
    NSDictionary *parameters;
    PetRecommendListInfo *listInfo = [self.baseArray lastObject];
    if (self.filterStyle) {
        parameters = @{@"cat_id"    : self.filterStyle.catId,
                       @"number"    : HOME_NUMBER_PER_PAGE,
                       @"last_time" : listInfo.time};
    } else {
        parameters = @{@"number"    : HOME_NUMBER_PER_PAGE,
                       @"last_time" : listInfo.time};
    }
    [[LCYNetworking sharedInstance] postRequestWithAPI:Pet_recommend parameters:parameters successBlock:^(NSDictionary *object) {
        if ([object[@"result"] boolValue]) {
            // 加载成功
            self.recommendBase = [PetRecommendBase modelObjectWithDictionary:object];
            if ([self.recommendBase.listInfo count] == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"没有更多图片了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            } else {
                [self.baseArray addObjectsFromArray:self.recommendBase.listInfo];
                [self.icyCollectionView reloadData];
            }
            [self.icyCollectionView footerEndRefreshing];
        } else {
            // 加载失败
            [self.icyCollectionView footerEndRefreshing];
        }
    } failedBlock:^{
        // 网络问题
        [self.icyCollectionView footerEndRefreshing];
    }];
}


#pragma mark - CollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.baseArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:RecommendCellIdentifier forIndexPath:indexPath];
    PetRecommendListInfo *listInfo = self.baseArray[indexPath.row];
    NSString *iURLString = [hostImageURL stringByAppendingString:listInfo.imagePath];
    NSString *siURLString = [hostImageURL stringByAppendingString:listInfo.userImagePath];
    [cell.icyMainImage sd_setImageWithURL:[NSURL URLWithString:iURLString] placeholderImage:[UIImage imageNamed:@"profilePetPlaceHolder"]];
    [cell.icySmallImage sd_setImageWithURL:[NSURL URLWithString:siURLString] placeholderImage:[UIImage imageNamed:@"avatarDefault"]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PetRecommendListInfo *listInfo = self.baseArray[indexPath.row];
    NSString *iURLString = [hostImageURL stringByAppendingString:listInfo.imagePath];
    
    NSArray *photosURL = @[[NSURL URLWithString:iURLString]];
    
    NSArray *photos = [IDMPhoto photosWithURLs:photosURL];
    
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos];
    
    browser.useWhiteBackgroundColor = YES;
    browser.doneButtonImage = [UIImage imageNamed:@"idmDoneButton"];
    
    [self presentViewController:browser animated:YES completion:nil];
}

#pragma mark - FilterDelegate
- (void)filterDidSelected:(SearchDetailByIDChildStyle *)category{
    self.filterStyle = category;
    [self loadInitData];
}

@end
