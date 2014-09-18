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
#import "ZXYNETHelper.h"
#import "MJRefresh.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "EncySearchVC.h"
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "EncyDetailPetWeb.h"
#import "EncyCategoryVC.h"
#import "LCYCommon.h"
#import "LCYGlobal.h"
#import "UIViewController+HideTabBar.h"
#import "UIScrollView+LCYRefresh.h"

typedef enum
{
    Ency_JianKang = 1,
    Ency_YangHu   = 2,
    Ency_XunDao   = 3,
}EncyTypeChoose;

@interface EncyMoreEncyListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _petID;
    IBOutletCollection(UIButton) NSArray *allBtns;
    NSInteger currentPage;
    IBOutletCollection(UIImageView) NSArray *allImages;
    __weak IBOutlet UITableView *currentTable;
    MBProgressHUD *progress;
    MBProgressHUD *textHUD;
    NSString *currentTitle;
    BOOL isSearchHidden;
    NSMutableArray *allDataForShow;
    EncyTypeChoose chooseType;
    BOOL isAdd;
    BOOL isFirstDown;
}
- (IBAction)selectOneBtn:(id)sender;
@end

@implementation EncyMoreEncyListViewController
-(id)initWithPetId:(NSInteger )petID
{
    if(self = [super initWithNibName:@"EncyMoreEncyListViewController" bundle:nil])
    {
        _petID = petID;
        
    }
    return self;
}

- (void)setPetID:(NSInteger)petID
{
    _petID = petID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isAdd = NO;
    chooseType = 2;
    currentPage = 1;
    allDataForShow = [[NSMutableArray alloc] init];
    isFirstDown = YES;
    [self initNavi];
    [self initImageSlide];
//    [self hideTabBar];
    [self initScrollHeader];
    [self initMBHUD];
    
    currentTable.backgroundColor = BLUEINSI;
    if(currentTitle)
    {
        self.title = currentTitle;
    }
    
    if(!isSearchHidden)
    {
        [self setNaviRightItem:@"en_search"];
    }
    else
    {
        UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 24)];
        rightBtn.layer.cornerRadius=4;
        rightBtn.layer.masksToBounds = YES;
        [rightBtn setTitle:@"分类" forState:UIControlStateNormal];
        [rightBtn setTitle:@"分类" forState:UIControlStateHighlighted];
        [rightBtn addTarget:self action:@selector(rightItemAction) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [rightBtn setBackgroundColor:[UIColor colorWithRed:0.3882 green:0.6235 blue:0.7569 alpha:1]];
        UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        [self.navigationItem setRightBarButtonItem:rightBtnItem];
    }
    
    if([ZXYNETHelper isNETConnect])
    {
        [progress show:YES];
        [self performSelectorInBackground: @selector(downLoadMoreData:) withObject:[NSNumber numberWithInt:chooseType] ];
    }
    else
    {
        textHUD.labelText = @"没有连接网络";
        [self performSelector:@selector(hideTextHUD) withObject:nil afterDelay:2];
    }
}

- (void)setRightItemAction
{
    [self performSegueWithIdentifier:@"EN_moreToSearch" sender:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(!isFirstDown)
    {
        [allDataForShow removeAllObjects];
        [progress show:YES];
        [self performSelectorInBackground: @selector(downLoadMoreData:) withObject:[NSNumber numberWithInt:chooseType] ];
        currentPage=1;
        
    }
    isFirstDown = NO;
}

- (void)refreshData:(NSString *)param
{
    //[allDataForShow removeAllObjects];
    currentPage = 1;
    [self downLoadMoreData:[NSNumber numberWithInt:chooseType]];
}

- (void)addLoadData:(NSString *)param
{
    isAdd = YES;
    currentPage += 1;
    [self downLoadMoreData:[NSNumber numberWithInt:chooseType]];
}

- (void)hideTextHUD
{
    [textHUD hide:YES];
}

- (void)downLoadMoreData:(NSNumber *)typeIDNum
{
    NSInteger typeID = [typeIDNum integerValue];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    if(!_petID)
    {
        _petID=0;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@?cate_id=%ld&type_id=%ld&p=%ld",ZXY_HOSTURL,ZXY_GETMORE,_petID,typeID,(long)currentPage];
    [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //[allDataForShow removeAllObjects];
        NSLog(@"operation is %@",[operation responseString]);
        NSData *jsonData = [operation responseData];
        NSDictionary *allDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        if([allDic objectForKey:@"data"] == [NSNull null])
        {
            if(isAdd)
            {
                [self performSelectorOnMainThread:@selector(isLastPage) withObject:nil waitUntilDone:YES];
            }
            else
            {
                [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                [self performSelectorOnMainThread:@selector(hideMB) withObject:nil waitUntilDone:YES];
            }
        }
        else
        {
            if(!isAdd)
            {
                [allDataForShow removeAllObjects];
            }
            @try {
                NSArray *allArr = [allDic objectForKey:@"data"];
                if(allArr)
                {
                    for(int i =0;i<allArr.count;i++)
                    {
                        [allDataForShow addObject:allArr[i]];
                    }
                }

            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
            
            [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            [self performSelectorOnMainThread:@selector(hideMB) withObject:nil waitUntilDone:YES];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self performSelectorOnMainThread:@selector(hideMB) withObject:nil waitUntilDone:YES];
        NSLog(@"operation is %@",error);
    }];

}

- (void)isLastPage
{
    isAdd = NO;
    [textHUD setLabelText:@"已经是最后一页了"];
    [textHUD show:YES];
    [self performSelector:@selector(hideTextHUD) withObject:nil afterDelay:2];
    [self hideMB];
}

- (void)reloadData
{
    if(isAdd)
    {
        isAdd = NO;
    }
    [currentTable reloadData];
}

- (void)hideMB
{
    if(isAdd)
    {
        isAdd = NO;
    }
    [progress hide:YES];
    [currentTable footerEndRefreshing];
    [currentTable headerEndRefreshing];
    [currentTable stopRefreshAnimation];
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
    textHUD = [[MBProgressHUD alloc] initWithView:self.view];
    progress = [[MBProgressHUD alloc] initWithView:self.view];
    textHUD.mode = MBProgressHUDModeText;
    textHUD.labelText = @"已经是最后一页了";
    [self.view addSubview:textHUD];
    [self.view addSubview:progress];
}

- (void)initScrollHeader
{
    
    __block EncyMoreEncyListViewController *blockSelf = self;
//    [currentTable addHeaderWithCallback:^{
//        [currentTable setHeaderPullToRefreshText:@"刷新信息"];
//        [currentTable setHeaderRefreshingText:@"正在刷新"];
//        [currentTable setHeaderReleaseToRefreshText:@"刷新完成"];
//        [blockSelf performSelector:@selector(refreshData:) withObject:nil];
//    }];
    NSArray *image1 = @[[UIImage imageNamed:@"Red1"],[UIImage imageNamed:@"Red2"]];
    NSArray *image2 = @[[UIImage imageNamed:@"Red1"]];
    [currentTable addPullToRefreshActionHandler:^{
        [blockSelf performSelector:@selector(refreshData:) withObject:nil];
    }
                                      ProgressImages:image2
                                       LoadingImages:image1
                             ProgressScrollThreshold:0
                              LoadingImagesFrameRate:9];
    [currentTable addFooterWithCallback:^{
        [currentTable setFooterPullToRefreshText:@"加载数据"];
        [currentTable setFooterRefreshingText:@"正在加载数据"];
        [currentTable setFooterReleaseToRefreshText:@"加载数据"];
        [blockSelf performSelector:@selector(addLoadData:) withObject:nil ];
    }];
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

- (void)rightItemAction
{
    if(isSearchHidden)
    {
        EncyCategoryVC *categoryVC = [[EncyCategoryVC alloc] initWithNibName:@"EncyCategoryVC" bundle:nil];
        [self.navigationController pushViewController:categoryVC animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return allDataForShow.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EncyHomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    NSDictionary *dataDic = [allDataForShow objectAtIndex:indexPath.row];
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
    cell.readNum.text = [dataDic objectForKey:@"ency_read"];
    cell.titleLbl.text = [dataDic objectForKey:@"title"];
    cell.collectNum.text = [dataDic objectForKey:@"ency_collect"];
    if([dataDic objectForKey:@"keyword"]==[NSNull null])
    {
        cell.firstKey.text  = @"";
    }
    else
    {
        cell.firstKey.text  = [dataDic objectForKey:@"keyword"];
    }
    
    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ENCY_HOSTURL,[dataDic objectForKey:@"head_img"] ]];
    [cell.titleImage sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"static-00"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dataDic = [allDataForShow objectAtIndex:indexPath.row];
    NSString *petID = [dataDic objectForKey:@"ency_id"];
    
    
    if([ZXYNETHelper isNETConnect])
    {
        [progress show:YES];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSString *urlString = [ZXY_HOSTURL stringByAppendingString:ZXY_ISCOLLECT];
        if([[LCYCommon sharedInstance] isUserLogin])
        {
            NSString *phoneNum = [[LCYGlobal sharedInstance] currentUserID];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager POST:urlString parameters:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:phoneNum.intValue], @"user_name",[NSNumber numberWithInt:petID.intValue],@"ency_id",nil] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self performSelectorOnMainThread:@selector(hideMB) withObject:nil waitUntilDone:YES];
                EncyDetailPetWeb *detailWeb = [[EncyDetailPetWeb alloc] initWithPetID:petID.integerValue andType:NO];
                detailWeb.title = [dataDic objectForKey:@"cate_name"];
                if([[operation responseString] isEqualToString:@"true"])
                {
                    [detailWeb setIsSelected:YES];
                }
                else
                {
                    [detailWeb setIsSelected:NO];
                }
                [self.navigationController pushViewController:detailWeb animated:YES];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [progress hide:YES];
            }];
            
        }
        else
        {
            [progress hide:YES];
            EncyDetailPetWeb *detailWeb = [[EncyDetailPetWeb alloc] initWithPetID:petID.integerValue andType:NO];
            [detailWeb setIsSelected:NO];
            [self.navigationController pushViewController:detailWeb animated:YES];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"没有连接网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }}


- (IBAction)selectOneBtn:(id)sender
{
    if(![ZXYNETHelper isNETConnect])
    {
        return;
    }
    currentPage = 1;
    [allDataForShow removeAllObjects];
    [progress show:YES];
    UIButton *selectedBtn = (UIButton *)sender;
    switch (selectedBtn.tag) {
        case 1:
            chooseType=1;
            break;
        case 2:
            chooseType=2;
            break;
        case 3:
            chooseType = 3;
            break;
        default:
            chooseType = 2;
            break;
    }
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
    [self performSelectorInBackground:@selector(downLoadMoreData:) withObject:[NSNumber numberWithInt:chooseType]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
}
@end
