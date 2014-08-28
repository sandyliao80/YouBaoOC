//
//  EncyAllListFile.m
//  YouBaoOC
//
//  Created by developer on 14-8-27.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "EncyAllListFile.h"
#import "EncyHomePageTableViewCell.h"
#import "UIViewController+HideTabBar.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "MJRefresh.h"
#import "EncyDetailPetWeb.h"
#import "ZXYNetHelper/ZXYNETHelper.h"
@interface EncyAllListFile ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *allDataForShow;
    NSString *_petID;
    NSString *_typeID;
    NSInteger currentPage;
    MBProgressHUD *progress;
    MBProgressHUD *textHUD;
      __weak IBOutlet UITableView *currentTable;
    BOOL isFirstDown;
}
@end

@implementation EncyAllListFile
- (id)initPetID:(NSString *)petID andTypeID:(NSString *)typeID
{
    if(self = [super initWithNibName:@"EncyAllListFile" bundle:nil])
    {
        allDataForShow = [[NSMutableArray alloc] init];
        _petID = petID;
        _typeID = typeID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initScrollHeader];
    [self initMBHUD];
    currentPage = 1;
    allDataForShow = [[NSMutableArray alloc] init];
    isFirstDown = YES;
    [self downLoadMoreData];
    currentTable.backgroundColor = BLUEINSI;
    // Do any additional setup after loading the view from its nib.
}

- (void)initScrollHeader
{
    
    __block EncyAllListFile *blockSelf = self;
    [currentTable addFooterWithCallback:^{
        [currentTable setFooterPullToRefreshText:@"加载数据"];
        [currentTable setFooterRefreshingText:@"正在加载数据"];
        [currentTable setFooterReleaseToRefreshText:@"加载数据"];
        [blockSelf performSelector:@selector(addLoadData:) withObject:nil ];
    }];
}

- (void)addLoadData:(NSString *)param
{
    currentPage += 1;
    [self downLoadMoreData];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  96;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return allDataForShow.count;
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

- (void)isLastPage
{
    [textHUD setLabelText:@"已经是最后一页了"];
    [textHUD show:YES];
    [self performSelector:@selector(hideTextHUD) withObject:nil afterDelay:2];
    [self hideMB];
}

- (void)reloadData
{
    [currentTable reloadData];
}

- (void)hideMB
{
    [progress hide:YES];
    [currentTable footerEndRefreshing];
    [currentTable headerEndRefreshing];
}


- (void)hideTextHUD
{
    [textHUD hide:YES];
}


- (void)downLoadMoreData
{
    [progress show:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZXY_HOSTURL,ZXY_GETMORE];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_petID,@"cate_id",_typeID,@"type_id",[NSNumber numberWithInt:currentPage],@"p", nil];
    [manager GET:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"operation is %@",[operation responseString]);
        NSData *jsonData = [operation responseData];
        NSDictionary *allDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        if([allDic objectForKey:@"data"] == [NSNull null])
        {
            [self performSelectorOnMainThread:@selector(isLastPage) withObject:nil waitUntilDone:YES];
        }
        else
        {
            NSArray *allArr = [allDic objectForKey:@"data"];
            if(allArr)
            {
                for(int i =0;i<allArr.count;i++)
                {
                    [allDataForShow addObject:allArr[i]];
                }
            }
            
            [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            [self performSelectorOnMainThread:@selector(hideMB) withObject:nil waitUntilDone:YES];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self performSelectorOnMainThread:@selector(hideMB) withObject:nil waitUntilDone:YES];
        NSLog(@"operation is %@",error);
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dataDic = [allDataForShow objectAtIndex:indexPath.row];
    NSString *petID = [dataDic objectForKey:@"ency_id"];
    EncyDetailPetWeb *webView = [[EncyDetailPetWeb alloc] initWithPetID:petID.integerValue andType:NO];
    if([ZXYNETHelper isNETConnect])
    {
        [self.navigationController pushViewController:webView animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"没有连接网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(!isFirstDown)
    {
        [allDataForShow removeAllObjects];
        isFirstDown = NO;
        [self performSelectorInBackground:@selector(downLoadMoreData) withObject:nil];
    }
}
@end