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
@interface EncyHomePageViewController ()<UITableViewDelegate,UITableViewDataSource,EncyHomeTitleDelegate,EncyDogCatClassDelegate>
{
    NSMutableArray *allDataForShow;
    NSDictionary   *jsonDic ;
    ZXYFileOperation *fileOperation ;
    ZXYNETHelper *netHelper;
    MBProgressHUD *mbProgress;
    NSString *currentTitle;
    NSInteger *currentPage;
    ZXYDownImageHelper *downImage;
    NSNotificationCenter *datatnc;
}
@property(nonatomic,strong)IBOutlet UITableView *currentTable;
@property(nonatomic,strong)IBOutlet UILabel *everyDayPush;
@property(nonatomic,strong)IBOutlet UIButton *moreInfo;
@end

@implementation EncyHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // !!!:为view注册通知
    datatnc = [NSNotificationCenter defaultCenter];
    [datatnc addObserver:self selector:@selector(reloadDataMethod) name:@"ency_image" object:nil];
    
    
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
        [self performSelectorInBackground:@selector(downLoadData:) withObject:nil];
    }
    else
    {
        UIAlertView *noConnect = [[UIAlertView alloc] initWithTitle:@"" message:@"没有连接网络" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [noConnect show];
    }
    currentPage = 0;
    
}

// !!!:所有的实例化方法
- (void)initObject
{
    netHelper = [[ZXYNETHelper alloc] init];
    fileOperation = [ZXYFileOperation sharedSelf];
    jsonDic = [[NSDictionary alloc] init];
    allDataForShow = [[NSMutableArray alloc] init];
    mbProgress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:mbProgress];
    downImage = [[ZXYDownImageHelper alloc] initWithDirect:@"ency_image" andNotiKey:@"ency_image"];
}

- (void)initNaviBar
{
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [leftBtn addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setImage:[UIImage imageNamed:@"en_leftNavi"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"en_leftNavi"] forState:UIControlStateHighlighted];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    [self.navigationItem setLeftBarButtonItem:leftBtnItem];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 24)];
    rightBtn.layer.cornerRadius=4;
    rightBtn.layer.masksToBounds = YES;
    [rightBtn setTitle:@"分类" forState:UIControlStateNormal];
    [rightBtn setTitle:@"分类" forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(rightItemAction) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setBackgroundColor:[UIColor colorWithRed:0.3882 green:0.6235 blue:0.7569 alpha:1]];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:rightBtnItem];
}

- (void)initColorOFTitle
{
    self.title = @"宠物百科";
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.3882 green:0.6235 blue:0.7569 alpha:1],NSForegroundColorAttributeName, nil];
    self.everyDayPush.textColor = [UIColor colorWithRed:0.3882 green:0.6235 blue:0.7569 alpha:1];
    [self.moreInfo setTitleColor:[UIColor colorWithRed:0.3882 green:0.6235 blue:0.7569 alpha:1] forState:UIControlStateNormal];
    [self.moreInfo setTitleColor:[UIColor colorWithRed:0.3882 green:0.6235 blue:0.7569 alpha:1] forState:UIControlStateHighlighted];
    self.currentTable.backgroundColor = BLUEINSI;
}

- (void)initScrollHeader
{
   
    __block EncyHomePageViewController *blockSelf = self;
    [self.currentTable addHeaderWithCallback:^{
        [blockSelf.currentTable setHeaderPullToRefreshText:@"刷新信息"];
        [blockSelf.currentTable setHeaderRefreshingText:@"正在刷新"];
        [blockSelf.currentTable setHeaderReleaseToRefreshText:@"刷新完成"];
        [blockSelf performSelectorInBackground:@selector(downLoadData:) withObject:nil];
    }];
}
// !!!:实例化方法结束

- (void)downLoadData:(NSString *)typeID
{
    [mbProgress show:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1001],@"petStyleID", nil];
    if(typeID != nil)
    {
        [parameters setObject:typeID forKey:@"petStyleID"];
        [parameters setObject:@"yes" forKey:@"isSubPet"];
    }
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZXY_HOSTURL,ZXY_GETTODYPUSH];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //[allDataForShow removeAllObjects];
        NSLog(@"operation is %@",[operation responseString]);
        NSData *jsonData = [operation responseData];
        NSDictionary *allDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        jsonDic = allDic;
        NSArray *allArr = [allDic objectForKey:@"data"];
        if(allArr)
        {
            for(int i =0;i<allArr.count;i++)
            {
                [allDataForShow addObject:allArr[i]];
            }
        }
        [self performSelectorOnMainThread:@selector(hideMB) withObject:nil waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self performSelectorOnMainThread:@selector(hideMB) withObject:nil waitUntilDone:YES];
        NSLog(@"operation is %@",error);
    }];

}

- (void)selectTypeIS:(NSString *)typeID
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"EncyMoreEncyListSB" bundle:nil];
    EncyMoreEncyListViewController *moreVC = [story instantiateInitialViewController];
    [moreVC hideSearchBtn];
    NSString *titleString;
    NSInteger currentInt = typeID.integerValue;
    switch (currentInt) {
        case 101:
            titleString = @"大型犬";
            break;
        case 102:
            titleString = @"中型犬";
            break;
        case 103:
            titleString = @"小型犬";
            break;
        case 104:
            titleString = @"猫咪";
            break;
            
        default:
            titleString = @"";
            break;
    }
    [moreVC setTitles:titleString];
    [self.navigationController pushViewController:moreVC animated:YES];
}

- (void)hideMB
{
    [mbProgress hide:YES];
    [self.currentTable headerEndRefreshing];
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
        NSString *imageUrl = [dataDic objectForKey:@"image_path"];
        NSString *filePath = [fileOperation pathTempFile:@"ency_image" andURL:imageUrl];
        if(indexPath.row%2 == 0)
        {
            cell.backgroundColor = BLUEINSI;
        }
        else
        {
            cell.backgroundColor = ORIGINSI;
        }
        
        if([fileOperation fileExistsAtPath:filePath])
        {
            cell.titleImage.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
        }
        else
        {
            [downImage addImageURLWithIndexDic:[NSDictionary dictionaryWithObjectsAndKeys:imageUrl,@"url",indexPath,@"index", nil]];
            cell.titleImage.image = [UIImage imageNamed:@"placePage_placeHod"];
        }
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

- (void)reloadDataRow:(NSNotification *)noti
{
    [self.currentTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[noti.userInfo objectForKey:@"index"], nil] withRowAnimation:UITableViewRowAnimationNone];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [downImage startDownLoadImage];
}


- (void)moreInfoBtnClick
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"EncyMoreEncyListSB" bundle:nil];
    EncyMoreEncyListViewController *more = [story instantiateInitialViewController];
    [more setTitles:@"宠物百科"];
    [self.navigationController pushViewController:more animated:YES];
}

- (void)dealloc
{
    [datatnc removeObserver:self name:@"ency_image" object:nil];
}

@end
