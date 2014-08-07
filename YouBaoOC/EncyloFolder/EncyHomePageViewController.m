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
@interface EncyHomePageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *allDataForShow;
    NSDictionary   *jsonDic ;
    ZXYFileOperation *fileOperation ;
    ZXYNETHelper *netHelper;
    MBProgressHUD *mbProgress;
}
@property(nonatomic,strong)IBOutlet UITableView *currentTable;
@property(nonatomic,strong)IBOutlet UILabel *everyDayPush;
@property(nonatomic,strong)IBOutlet UIButton *moreInfo;
@end

@implementation EncyHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // !!!:为view注册通知
    NSNotificationCenter *datatnc = [NSNotificationCenter defaultCenter];
    [datatnc addObserver:self selector:@selector(reloadDataMethod) name:@"ency_noti" object:nil];
    //实例化初始变量
    [self initObject];
    //实例化导航栏
    [self initNaviBar];
    //实例化标题颜色
    [self initColorOFTitle];
    [mbProgress show:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1001],@"petStyleID", nil];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager POST:@"http://localhost/pet/pet/index.php/Api/EncyType/getTodayEncy" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"operation is %@",[operation responseString]);
        NSData *jsonData = [operation responseData];
        NSDictionary *allDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        jsonDic = allDic;
        NSArray *allArr = [allDic objectForKey:@"todayPush"];
        for(int i =0;i<allArr.count;i++)
        {
            NSDictionary *allDic = [allArr objectAtIndex:i];
            NSArray *allContent  = [allDic objectForKey:@"allContent"];
            for(int j = 0;j<allContent.count;j++)
            {
                NSMutableDictionary *content = [NSMutableDictionary dictionaryWithDictionary: [allContent objectAtIndex:j] ];
                [content setObject:[allDic objectForKey:@"enImage_U"] forKey:@"enImage_U"];
                [allDataForShow addObject:content];
                NSLog(@"all DIC %@",[content objectForKey:@"ency_childC"]);
            }
            
        }
        [self.currentTable reloadData];
        [mbProgress hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [mbProgress hide:YES];
        NSLog(@"operation is %@",error);
    }];
    
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
// !!!:实例化方法结束

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)leftItemAction
{
    
}

// !!!:分类
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
    return 3;
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
    else if(indexPath.section == 1)
    {
        EncyHomeTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:EN_HOMETITLECELLIDENTIFIER];
        cell.backgroundColor = BLUEINSI;
        return cell;
    }
    else
    {
        NSDictionary *dataDic = [allDataForShow objectAtIndex:indexPath.row];
        EncyHomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EN_HOMEPAGECELLIDENTIFIER];
        cell.readNum.text = [dataDic objectForKey:@"ency_read"];
        cell.titleLbl.text = [dataDic objectForKey:@"ency_childN"];
        cell.collectNum.text = [dataDic objectForKey:@"ency_collect"];
        NSString *imageUrl = [dataDic objectForKey:@"enImage_U"];
        NSString *lastURL = [imageUrl componentsSeparatedByString:@"/"].lastObject;
        NSString *filePath = [fileOperation cidImagePath:lastURL];
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
            NSString *urlString = [NSString stringWithFormat:@"%@%@",ENCY_HOSTURL,imageUrl];
            [netHelper placeURLADD:urlString];
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
    else if(indexPath.section ==1)
    {
        return 37;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [netHelper startDownPlaceImage];
}

@end
