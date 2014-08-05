//
//  EncyHomePageViewController.m
//  YouBaoOC
//
//  Created by developer on 14-8-5.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "EncyHomePageViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "EncyHomePageTableViewCell.h"
#import "ZXYNETHelper.h"
#import "ZXYFileOperation.h"
#import "EncyHomePageTableViewCell.h"
@interface EncyHomePageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *allDataForShow;
    NSDictionary   *jsonDic ;
    ZXYFileOperation *fileOperation ;
    ZXYNETHelper *netHelper;
}
@property(nonatomic,strong)IBOutlet UITableView *currentTable;
@property(nonatomic,strong)IBOutlet UILabel *everyDayPush;
@property(nonatomic,strong)IBOutlet UIButton *moreInfo;
@end

@implementation EncyHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSNotificationCenter *datatnc = [NSNotificationCenter defaultCenter];
    [datatnc addObserver:self selector:@selector(reloadDataMethod) name:@"ency_noti" object:nil];
    netHelper = [[ZXYNETHelper alloc] init];
    fileOperation = [ZXYFileOperation sharedSelf];
    jsonDic = [[NSDictionary alloc] init];
    allDataForShow = [[NSMutableArray alloc] init];
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [leftBtn addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setImage:[UIImage imageNamed:@"en_leftNavi"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"en_leftNavi"] forState:UIControlStateHighlighted];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    [self.navigationItem setLeftBarButtonItem:leftBtnItem];
    MBProgressHUD *mbProgress = [[MBProgressHUD alloc] initWithView:self.view];
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
    [self initColorOFTitle];
}

- (void)initColorOFTitle
{
    self.title = @"宠物百科";
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.3882 green:0.6235 blue:0.7569 alpha:1],NSForegroundColorAttributeName, nil];
    self.everyDayPush.textColor = [UIColor colorWithRed:0.3882 green:0.6235 blue:0.7569 alpha:1];
    [self.moreInfo setTitleColor:[UIColor colorWithRed:0.3882 green:0.6235 blue:0.7569 alpha:1] forState:UIControlStateNormal];
    [self.moreInfo setTitleColor:[UIColor colorWithRed:0.3882 green:0.6235 blue:0.7569 alpha:1] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)zouQI
{
    UIStoryboard *stroyCurrent = [UIStoryboard storyboardWithName:@"Encyclope" bundle:nil];
    UIViewController *inTo     = [stroyCurrent instantiateInitialViewController];
    [self.navigationController pushViewController:inTo animated:YES];
}

- (void)leftItemAction
{
    
}

- (void)reloadDataMethod
{
    [self.currentTable reloadData];
}

// !!!:tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return allDataForShow.count;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dataDic = [allDataForShow objectAtIndex:indexPath.row];
    EncyHomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EncyHomeIdentifier"];
    cell.readNum.text = [dataDic objectForKey:@"ency_read"];
    cell.titleLbl.text = [dataDic objectForKey:@"ency_childN"];
    cell.collectNum.text = [dataDic objectForKey:@"ency_collect"];
    NSString *imageUrl = [dataDic objectForKey:@"enImage_U"];
    NSString *lastURL = [imageUrl componentsSeparatedByString:@"/"].lastObject;
    NSString *filePath = [fileOperation cidImagePath:lastURL];
    if([fileOperation fileExistsAtPath:filePath])
    {
        cell.titleImage.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
    }
    else
    {
        
//        NSString *urlString=[NSString stringWithFormat:@"%@%@",ENCY_HOSTURL,filePath];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",ENCY_HOSTURL,imageUrl];
        [netHelper placeURLADD:urlString];
        cell.titleImage.image = [UIImage imageNamed:@"placePage_placeHod"];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
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
