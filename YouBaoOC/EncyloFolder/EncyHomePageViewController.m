//
//  EncyHomePageViewController.m
//  YouBaoOC
//
//  Created by developer on 14-8-5.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "EncyHomePageViewController.h"
#import "EncyAllNeedHeader.h"
#import "EncyHomeCell/EncyHomeCellHeader.h"
#import "EncyCategoryVC.h"
#import "MJRefresh.h"
#import "SubPetSyle.h"
#import "ZXYScroller/ZXYScrollView.h"
#import "EncyMoreEncyListViewController.h"
#import "ZXYDownImageHelper.h"
#import "PeyStyleForEncy.h"
#import "EncyDetailPetWeb.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LCYCommon.h"
#import "LCYGlobal.h"
#import "EncyAllListFile.h"
//#import "UIScrollView+LCYRefresh.h"
@interface EncyHomePageViewController ()<UITableViewDelegate,UITableViewDataSource,EncyHomeTitleDelegate,EncyDogCatClassDelegate,EncyHomeImageCellDelegate>
{
    NSMutableArray *allDataForShow;
    NSDictionary   *jsonDic ;
    ZXYFileOperation *fileOperation ;
    ZXYNETHelper *netHelper;
    MBProgressHUD *mbProgress;
    MBProgressHUD *textHUD;
    NSString *currentTitle;
    NSInteger currentPage;
    BOOL isAdd;
    BOOL isFresh;
    NSNotificationCenter *datatnc;
    ZXYProvider *dataProvider;
    NSMutableDictionary *lunboDic;
    BOOL isFirstDown;
}
@property(nonatomic,strong)IBOutlet UITableView *currentTable;
@property(nonatomic,strong)IBOutlet UILabel *everyDayPush;
@property(nonatomic,strong)IBOutlet UIButton *moreInfo;
@end

@implementation EncyHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // !!!:为view注册通知
    isFirstDown = YES;
    isAdd = NO;
    isFresh = NO;
    dataProvider = [ZXYProvider sharedInstance];
    datatnc = [NSNotificationCenter defaultCenter];
    [datatnc addObserver:self selector:@selector(reloadDataMethod) name:@"ency_image" object:nil];
    currentPage = 0;
    lunboDic = [[NSMutableDictionary alloc] init];
    //实例化初始变量
    [self initObject];
    //实例化导航栏
    [self initNaviBar];
    //实例化标题颜色
    [self initColorOFTitle];
    
    [self initScrollHeader];
    if(currentTitle)
    {
        self.title = currentTitle;
    }
    
    if([ZXYNETHelper isNETConnect])
    {
        [self performSelectorInBackground:@selector(downLoadType) withObject:nil];
        [self performSelectorInBackground:@selector(downLunBo) withObject:nil];
    }
    else
    {
        UIAlertView *noConnect = [[UIAlertView alloc] initWithTitle:@"" message:@"没有连接网络" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [noConnect show];
    }
    currentPage = 1;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(!isFirstDown)
    {
        [mbProgress show:YES];
        [allDataForShow removeAllObjects];
        [self refreshData];
        currentPage=1;
        
    }
    isFirstDown = NO;
}

- (void)downLunBo
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZXY_HOSTURL,ZXY_ENCYLB];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *manager = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [manager setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",[operation responseString]);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:0 error:nil];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [manager start];
}

// !!!:所有的实例化方法
- (void)initObject
{
    netHelper = [[ZXYNETHelper alloc] init];
    fileOperation = [ZXYFileOperation sharedSelf];
    jsonDic = [[NSDictionary alloc] init];
    allDataForShow = [[NSMutableArray alloc] init];
    mbProgress = [[MBProgressHUD alloc] initWithView:self.view];
    textHUD    = [[MBProgressHUD alloc] initWithView:self.view];
    textHUD.mode = MBProgressHUDModeText;
    textHUD.labelText = @"已经是最后一页了";
    [self.view addSubview:textHUD];
    [self.view addSubview:mbProgress];
}

- (void)initNaviBar
{
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [leftBtn addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setImage:[UIImage imageNamed:@"en_leftNavi"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"en_leftNavi"] forState:UIControlStateHighlighted];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 36, 24)];
    leftLabel.text = @"收藏";
    [leftLabel setFont:[UIFont systemFontOfSize:15.0f]];
    leftLabel.textColor = THEME_COLOR;
    UIBarButtonItem *leftLabelItem = [[UIBarButtonItem alloc] initWithCustomView:leftLabel];
//    [self.navigationItem setLeftBarButtonItem:leftBtnItem];
    self.navigationItem.leftBarButtonItems = @[leftBtnItem, leftLabelItem];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 24)];
    rightBtn.layer.cornerRadius=4;
    rightBtn.layer.masksToBounds = YES;
    [rightBtn setTitle:@"分类" forState:UIControlStateNormal];
    [rightBtn setTitle:@"分类" forState:UIControlStateHighlighted];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [rightBtn addTarget:self action:@selector(rightItemAction) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setBackgroundColor:[UIColor colorWithRed:0.3882 green:0.6235 blue:0.7569 alpha:1]];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:rightBtnItem];
}

- (void)initColorOFTitle
{
    self.title = @"百科";
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.3882 green:0.6235 blue:0.7569 alpha:1],NSForegroundColorAttributeName, nil];
    self.everyDayPush.textColor = [UIColor colorWithRed:0.3882 green:0.6235 blue:0.7569 alpha:1];
    [self.moreInfo setTitleColor:[UIColor colorWithRed:0.3882 green:0.6235 blue:0.7569 alpha:1] forState:UIControlStateNormal];
    [self.moreInfo setTitleColor:[UIColor colorWithRed:0.3882 green:0.6235 blue:0.7569 alpha:1] forState:UIControlStateHighlighted];
    self.currentTable.backgroundColor = BLUEINSI;
}

- (void)initScrollHeader
{
   
//    __block EncyHomePageViewController *blockSelf = self;
    __weak __typeof(self) weakSelf = self;
    [self.currentTable addHeaderWithCallback:^{
        __strong __typeof(weakSelf) blockSelf = weakSelf;
        [blockSelf.currentTable setHeaderPullToRefreshText:@"刷新信息"];
        [blockSelf.currentTable setHeaderRefreshingText:@"正在刷新"];
        [blockSelf.currentTable setHeaderReleaseToRefreshText:@"刷新完成"];
        [blockSelf performSelector:@selector(refreshData) withObject:nil];
    }];
//    [self.currentTable setContentInset:UIEdgeInsetsMake(64.0f, 0, 0, 0)];
//    NSArray *image1 = @[[UIImage imageNamed:@"Red1"],[UIImage imageNamed:@"Red2"]];
//    NSArray *image2 = @[[UIImage imageNamed:@"Red1"]];
//    [self.currentTable addPullToRefreshActionHandler:^{
//         [blockSelf performSelector:@selector(refreshData) withObject:nil];
//    }
//                                      ProgressImages:image2
//                                       LoadingImages:image1
//                             ProgressScrollThreshold:0
//                              LoadingImagesFrameRate:9];
    [self.currentTable addFooterWithCallback:^{
        __strong __typeof(weakSelf) blockSelf = weakSelf;
        [blockSelf.currentTable setFooterPullToRefreshText:@"加载数据"];
        [blockSelf.currentTable setFooterRefreshingText:@"正在加载数据"];
        [blockSelf.currentTable setFooterReleaseToRefreshText:@"加载数据"];
        [blockSelf performSelector:@selector(addLoadData:) withObject:nil ];
    }];
}
// !!!:实例化方法结束

- (void)addLoadData:(NSString *)param
{
    isAdd = YES;
    currentPage += 1;
    [self downLoadData:nil];
}

- (void)refreshData
{
    if(isAdd)
    {
        isAdd = NO;
    }
    
    isFresh = YES;
    currentPage = 1;
    [self downLoadData:nil];
}

- (void)downLoadType
{
    [mbProgress show:YES];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZXY_HOSTURL,ZXY_GETTYPE];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *manager = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",[operation responseString]);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:0 error:nil];
        if([dic objectForKey:@"msg"]!=[NSNull null])
        {
            [dataProvider saveDataToCoreDataArr:[dic objectForKey:@"msg"] withDBNam:@"PeyStyleForEncy" withDeletePredict:@"cate_name"];
        }
        [self downLoadData:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [manager start];
}

- (void)downLoadData:(NSString *)typeID
{
    if([mbProgress isHidden])
    {
        [mbProgress show:YES];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1001],@"petStyleID", nil];
    if(typeID != nil)
    {
        [parameters setObject:typeID forKey:@"petStyleID"];
        [parameters setObject:@"yes" forKey:@"isSubPet"];
    }
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    NSString *urlString = [NSString stringWithFormat:@"%@%@?p=%ld",ZXY_HOSTURL,ZXY_GETTODYPUSH,(long)currentPage];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"operation is %@",[operation responseString]);
        NSData *jsonData = [operation responseData];
        NSDictionary *allDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        jsonDic = allDic;
        if([allDic objectForKey:@"data"] == [NSNull null])
        {
            if([allDic objectForKey:@"data"])
            {
                [self performSelectorOnMainThread:@selector(isLastPage) withObject:nil waitUntilDone:YES];
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
    if(isAdd)
    {
        isAdd = NO;
    }
    currentPage -=1;
    [mbProgress hide:YES];
    [textHUD show:YES];
    [self performSelector:@selector(hideMB) withObject:nil afterDelay:1];
    [self.currentTable footerEndRefreshing];
}

- (void)selectTypeIS:(NSString *)typeID
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"EncyMoreEncyListSB" bundle:nil];
   
    PeyStyleForEncy *currentPet;
    
    NSString *titleString;
    NSInteger currentInt = typeID.integerValue;
    switch (currentInt) {
        case 101:
        {
            titleString = @"大型犬";
            NSArray *suchArr = [dataProvider readCoreDataFromDB:@"PeyStyleForEncy" withContent:@"大型犬" andKey:@"cate_name"];
            if(suchArr.count)
            {
                currentPet = [suchArr objectAtIndex:0];
            }
            break;
        }
        case 102:
        {
            titleString = @"中型犬";
            NSArray *suchArr = [dataProvider readCoreDataFromDB:@"PeyStyleForEncy" withContent:@"中型犬" andKey:@"cate_name"];
            if(suchArr.count)
            {
                currentPet = [suchArr objectAtIndex:0];
            }

            break;
        }
        case 103:
        {
            titleString = @"小型犬";
            
            NSArray *suchArr = [dataProvider readCoreDataFromDB:@"PeyStyleForEncy" withContent:@"小型犬" andKey:@"cate_name"];
            if(suchArr.count)
            {
                currentPet = [suchArr objectAtIndex:0];
            }

            break;
        }
        case 104:
        {
            
            NSArray *suchArr = [dataProvider readCoreDataFromDB:@"PeyStyleForEncy" withContent:@"猫咪" andKey:@"cate_name"];
            if(suchArr.count)
            {
                currentPet = [suchArr objectAtIndex:0];
            }

            titleString = @"猫咪";
            break;
        }
        default:
        {
            titleString = @"";
            break;
        }
    }
    EncyMoreEncyListViewController *moreVC = [story instantiateInitialViewController];
    [moreVC hideSearchBtn];
    [moreVC setTitles:titleString];
    [moreVC setPetID:currentPet.cate_id.intValue];
    [self.navigationController pushViewController:moreVC animated:YES];
}

- (void)hideMB
{
    if(isAdd)
    {
        isAdd = NO;
    }
    [mbProgress hide:YES];
    [textHUD hide:YES];
    [self.currentTable headerEndRefreshing];
    [self.currentTable footerEndRefreshing];
//    [self.currentTable stopRefreshAnimation];
}

- (void)reloadData
{
    [self.currentTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)leftItemAction
{
    EncyAllListFile *listFile = [[EncyAllListFile alloc] initWithNibName:@"EncyAllListFile" bundle:nil];
    [listFile isFavorite];
    [self.navigationController pushViewController:listFile animated:YES];
}


- (void)rightItemAction
{
    NSLog(@"haha");
    EncyCategoryVC *categoryVC = [[EncyCategoryVC alloc] initWithNibName:@"EncyCategoryVC" bundle:nil];
    [self.navigationController pushViewController:categoryVC animated:YES];
}

- (void)reloadDataMethod
{
    [self.currentTable reloadData];
}

// !!!:tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
    {
        return 1;
    }
    else if(section == 1)
    {
        return 1;
    }
    else if(section == 2)
    {
        return 1;
    }
    else
    {
        return allDataForShow.count;
    }
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section==0)
    {
        EncyHomeImageCell *cell = [tableView dequeueReusableCellWithIdentifier:EN_HOMEIMAGECELLIDENTIFIER];
        cell.delegate= self;
        if(isFresh)
        {
            [cell reloadImageViews];
            isFresh = NO;
        }
        return cell;
    }
    else if(indexPath.section == 2)
    {
        EncyHomeTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:EN_HOMETITLECELLIDENTIFIER];
        cell.delegate = self;
        cell.backgroundColor = BLUEINSI;
        return cell;
    }
    else if(indexPath.section == 1)
    {
        EncyDogCatCategoryCellTable *cell = [tableView dequeueReusableCellWithIdentifier:EN_HOMEDOGCAT];
        cell.delegate = self;
        return cell;
    }
    else
    {
        NSDictionary *dataDic = [allDataForShow objectAtIndex:indexPath.row];
        EncyHomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EN_HOMEPAGECELLIDENTIFIER];
        cell.readNum.text = [dataDic objectForKey:@"ency_read"];
        cell.titleLbl.text = [dataDic objectForKey:@"title"];
        cell.collectNum.text = [dataDic objectForKey:@"ency_collect"];
        cell.firstKey.text = [dataDic objectForKey:@"keyword"];
        NSString *imageUrl = [dataDic objectForKey:@"head_img"];
        if(indexPath.row%2 == 0)
        {
            cell.backgroundColor = BLUEINSI;
        }
        else
        {
            cell.backgroundColor = ORIGINSI;
        }
        NSString *stringURL = [NSString stringWithFormat:@"%@%@",ENCY_HOSTURL,imageUrl];
        NSURL *urls = [NSURL URLWithString:stringURL];
        [cell.titleImage sd_setImageWithURL:urls placeholderImage:[UIImage imageNamed:@"placePage_placeHod"]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        return 120;
    }
    else if(indexPath.section ==2)
    {
        return 37;
    }
    else if(indexPath.section == 1)
    {
        return 100;
    }
    else
    {
        return 64;
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return  NO;
    }
    else if(indexPath.section ==1)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 3)
    {
        NSDictionary *dataDic = [allDataForShow objectAtIndex:indexPath.row];
        NSString *petID = [dataDic objectForKey:@"ency_id"];
        [mbProgress show:YES];
        
        if([ZXYNETHelper isNETConnect])
        {
            if([[LCYCommon sharedInstance] isUserLogin])
            {
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                NSString *urlString = [ZXY_HOSTURL stringByAppendingString:ZXY_ISCOLLECT];
                NSString *phoneNum = [[LCYGlobal sharedInstance] currentUserID];
                [manager POST:urlString parameters:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:phoneNum.intValue], @"user_name",[NSNumber numberWithInt:petID.intValue],@"ency_id",nil] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    if(![mbProgress isHidden])
                    {
                        [mbProgress hide:YES];
                    }
                    NSLog(@"%@",[operation responseString]);
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
                    [mbProgress hide:YES];
                    [self.navigationController pushViewController:detailWeb animated:YES];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"%@",error);
                    [mbProgress hide:YES];
                }];
                
            }
            else
            {
                [mbProgress hide:YES];
                EncyDetailPetWeb *detailWeb = [[EncyDetailPetWeb alloc] initWithPetID:petID.integerValue andType:NO];
                [detailWeb setIsSelected:NO];
                [self.navigationController pushViewController:detailWeb animated:YES];
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"没有连接网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

- (void)reloadDataRow:(NSNotification *)noti
{
    [self.currentTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[noti.userInfo objectForKey:@"index"], nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)moreInfoBtnClick
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"EncyMoreEncyListSB" bundle:nil];
    EncyMoreEncyListViewController *more = [story instantiateInitialViewController];
    [more setTitles:@"百科"];
    [self.navigationController pushViewController:more animated:YES];
}

- (void)dealloc
{
    [datatnc removeObserver:self name:@"ency_image" object:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"hello");
}

-(void)selectADImageWithEncy_ID:(NSString *)ency_id andTitle:(NSString *)title
{
    EncyDetailPetWeb *webView = [[EncyDetailPetWeb alloc] initWithPetID:ency_id.integerValue andType:NO];
    if([ZXYNETHelper isNETConnect])
    {
        webView.title = title;
        [self.navigationController pushViewController:webView animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"没有连接网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }

}
@end
