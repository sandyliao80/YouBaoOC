//
//  EncyMoreEncyListViewController.m
//  YouBaoOC
//
//  Created by developer on 14-8-19.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "EncyMoreEncyListViewController.h"
#import "UIViewController+HideTabBar.h"
#import "EncyHomePageTableViewCell.h"
#import "EN_PreDefine.h"
#import "MJRefresh.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "EncySearchVC.h"
typedef enum
{
    Ency_JianKang = 0,
    Ency_YangHu   = 1,
    Ency_XunDao   = 2,
}EncyTypeChoose;

@interface EncyMoreEncyListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *_petID;
    IBOutletCollection(UIButton) NSArray *allBtns;
    
    IBOutletCollection(UIImageView) NSArray *allImages;
    __weak IBOutlet UITableView *currentTable;
    MBProgressHUD *progress;
    NSString *currentTitle;
    BOOL isSearchHidden;
}
- (IBAction)selectOneBtn:(id)sender;
@end

@implementation EncyMoreEncyListViewController
-(id)initWithPetId:(NSString *)petID
{
    if(self = [super initWithNibName:@"EncyMoreEncyListViewController" bundle:nil])
    {
        _petID = petID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavi];
    [self initImageSlide];
    [self hideTabBar];
    [self initScrollHeader];
    [self initMBHUD];
    if(currentTitle)
    {
        self.title = currentTitle;
    }
    
    if(!isSearchHidden)
    {
        [self setNaviRightItem:@"en_search"];
    }
}

- (void)setTitles:(NSString *)title
{
    currentTitle = title;
}

- (void)hideSearchBtn
{
    isSearchHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initMBHUD
{
    progress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progress];
    [progress setMinShowTime:3];
}

- (void)initScrollHeader
{
    
    __block EncyMoreEncyListViewController *blockSelf = self;
    [currentTable addHeaderWithCallback:^{
        [currentTable setHeaderPullToRefreshText:@"刷新信息"];
        [currentTable setHeaderRefreshingText:@"正在刷新"];
        [currentTable setHeaderReleaseToRefreshText:@"刷新完成"];
        [blockSelf performSelector:@selector(downLoadData:) withObject:nil];
    }];
    
    [currentTable addFooterWithCallback:^{
        [currentTable setFooterPullToRefreshText:@"加载数据"];
        [currentTable setFooterRefreshingText:@"正在加载数据"];
        [currentTable setFooterReleaseToRefreshText:@"加载数据"];
        [blockSelf performSelector:@selector(addLoadData:) withObject:nil ];
    }];
}

- (void)downLoadData:(NSString *)param
{
    [self performSelector:@selector(finishLoad) withObject:nil afterDelay:3];
}

- (void)addLoadData:(NSString *)param
{
    [self performSelector:@selector(finishLoad) withObject:nil afterDelay:3];
}

- (void)finishLoad
{
    
    [self performSelectorOnMainThread:@selector(mainFinish) withObject:nil waitUntilDone:YES];
    NSLog(@"haha");
}

- (void)mainFinish
{
    [currentTable headerEndRefreshing];
    [currentTable footerEndRefreshing];
}

- (void)initNavi
{
    [self setNaviLeftItem];
    
    //self.view.backgroundColor = BLUEINSI;
}

- (void)initImageSlide
{
    for(UIImageView *slideView in allImages)
    {
        if(slideView.tag == 1002)
        {
            slideView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:125.0/255.0 blue:105.0/255.0 alpha:1];
        }
        else
        {
            slideView.backgroundColor = [UIColor colorWithRed:53.0/255.0 green:135.0/255.0 blue:175.0/255.0 alpha:1];
        }
    }
}

- (void)leftItemAction
{
    [self showTabBarWithSelector];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setRightItemAction
{
    [self performSegueWithIdentifier:@"EN_moreToSearch" sender:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EncyHomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    if(cell == nil)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"EncyHomePageTableViewCell" owner:self options:nil];
        for(id oneObject in nibs)
        {
            if([oneObject isKindOfClass:[EncyHomePageTableViewCell class]])
            {
                cell = (EncyHomePageTableViewCell *)oneObject;
            }
        }
    }
    if(indexPath.row%2==0)
    {
        cell.backgroundColor = BLUEINSI;
    }
    else
    {
        cell.backgroundColor = ORIGINSI;
    }
    return cell;
}

- (IBAction)selectOneBtn:(id)sender
{
    UIButton *selectedBtn = (UIButton *)sender;
    for(UIButton *oneBtn in allBtns)
    {
        if(oneBtn == selectedBtn)
        {
            [oneBtn setSelected:YES];
            [oneBtn setUserInteractionEnabled:NO];
            NSInteger index = [allBtns indexOfObject:oneBtn];
            UIImageView *currentView = [allImages objectAtIndex:index];
            currentView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:125.0/255.0 blue:105.0/255.0 alpha:1];
        }
        else
        {
            [oneBtn setSelected:NO];
            [oneBtn setUserInteractionEnabled:YES];
            NSInteger index = [allBtns indexOfObject:oneBtn];
            UIImageView *currentView = [allImages objectAtIndex:index];
            currentView.backgroundColor = [UIColor colorWithRed:53.0/255.0 green:135.0/255.0 blue:175.0/255.0 alpha:1];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
}
@end
