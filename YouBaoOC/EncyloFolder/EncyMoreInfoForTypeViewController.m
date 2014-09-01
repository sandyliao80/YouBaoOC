//
//  EncyMoreInfoForTypeViewController.m
//  YouBaoOC
//
//  Created by 周效宇 on 14-8-29.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "EncyMoreInfoForTypeViewController.h"
#import "EncyTouXiangTableViewCell.h"
#import "EncyTabThreeCell.h"
#import "EN_PreDefine.h"
#import "EncyHomePageTableViewCell.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "ZXYNETHelper.h"
#import "MJRefresh.h"
#import "EncyDetailPetWeb.h"
#import "LCYGlobal.h"
#import "LCYCommon.h"
#define TXCELLI @"ENCYTXI"
#define ENCYTABT @"ENCYTABT"
#define cellIdentifier @"cellIdentifier"
typedef enum
{
    Ency_JianKang = 1,
    Ency_YangHu   = 2,
    Ency_XunDao   = 3,
}EncyTypeChoose;
@interface EncyMoreInfoForTypeViewController ()<UITableViewDataSource,UITableViewDelegate,TabDelegate>
{
    NSMutableArray *allDataForShow;
    NSString *_petID;
    NSString *_imgURL;
    NSInteger currentPage;
    MBProgressHUD *progress;
    MBProgressHUD *textHUD;
    BOOL isAdd;
    __weak IBOutlet UITableView *currentTable;
    BOOL isFirstDown;
   EncyTypeChoose chooseType;
}
@end

@implementation EncyMoreInfoForTypeViewController

- (id)initWithPetID:(NSString *)petID andURL:(NSString *)imgUrl
{
    if(self = [super initWithNibName:@"EncyMoreInfoForTypeViewController" bundle:nil])
    {
        _petID = petID;
        _imgURL = imgUrl;
        currentPage = 1;
        isAdd = NO;
        chooseType = 2;
        allDataForShow = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isFirstDown = YES;
    [self initScrollHeader];
    [self initMBHUD];
    currentTable.backgroundColor = BLUEINSI;
    [self initNavi];
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

    // Do any additional setup after loading the view from its nib.
}

- (void)initNavi
{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 24)];
    rightBtn.layer.cornerRadius=4;
    rightBtn.layer.masksToBounds = YES;
    [rightBtn setTitle:@"详细" forState:UIControlStateNormal];
    [rightBtn setTitle:@"详细" forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(rightItemAction) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setBackgroundColor:[UIColor colorWithRed:0.3882 green:0.6235 blue:0.7569 alpha:1]];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:rightBtnItem];
}

- (void)rightItemAction
{
    EncyDetailPetWeb *webView = [[EncyDetailPetWeb alloc] initWithPetID:_petID.integerValue andType:YES];
    webView.title = self.title;
    [self.navigationController pushViewController:webView animated:YES];
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


- (void)downLoadMoreData:(NSNumber *)typeIDNum
{
    NSInteger typeID = [typeIDNum integerValue];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    if(!_petID)
    {
        _petID=0;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@?cate_id=%ld&type_id=%ld&p=%ld",ZXY_HOSTURL,ZXY_GETMORE,_petID.integerValue,typeID,currentPage];
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

- (void)isLastPage
{
    isAdd = NO;
    [textHUD setLabelText:@"已经是最后一页了"];
    [textHUD show:YES];
    [self performSelector:@selector(hideTextHUD) withObject:nil afterDelay:2];
    [self hideMB];
}

- (void)initScrollHeader
{
    
    __block EncyMoreInfoForTypeViewController *blockSelf = self;
    [currentTable addHeaderWithCallback:^{
        [currentTable setHeaderPullToRefreshText:@"刷新信息"];
        [currentTable setHeaderRefreshingText:@"正在刷新"];
        [currentTable setHeaderReleaseToRefreshText:@"刷新完成"];
        [blockSelf performSelector:@selector(refreshData:) withObject:nil];
    }];
    
    [currentTable addFooterWithCallback:^{
        [currentTable setFooterPullToRefreshText:@"加载数据"];
        [currentTable setFooterRefreshingText:@"正在加载数据"];
        [currentTable setFooterReleaseToRefreshText:@"加载数据"];
        [blockSelf performSelector:@selector(addLoadData:) withObject:nil ];
    }];
}

- (void)refreshData:(NSString *)param
{
    [allDataForShow removeAllObjects];
    currentPage = 1;
    [self downLoadMoreData:[NSNumber numberWithInt:chooseType]];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 80;
    }
    else if (indexPath.section == 1)
    {
        return 44;
    }
    else
    {
        return 96;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSString *bundleName;
    NSString *cellIdenti;
    switch (section) {
        case 0:
            bundleName = @"EncyTouXiangTableViewCell";
            cellIdenti = TXCELLI;
            break;
        case 1:
            bundleName = @"EncyTabThreeCell";
            cellIdenti = ENCYTABT;
            break;
        case 2:
            bundleName = @"EncyHomePageTableViewCell";
            cellIdenti = cellIdentifier;
            break;
        default:
            break;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenti];
    if(cell == nil)
    {
        NSArray *arrNibs = [[NSBundle mainBundle] loadNibNamed:bundleName owner:self options:nil];
        for(id oneObject in arrNibs)
        {
            if([oneObject isKindOfClass:NSClassFromString(bundleName)])
            {
                if(section == 0)
                {
                    EncyTouXiangTableViewCell *tCell = (EncyTouXiangTableViewCell *)oneObject;
                    NSString *stringURL = [ENCY_HOSTURL stringByAppendingString:_imgURL];
                    [tCell.smallImage sd_setImageWithURL:[NSURL URLWithString:stringURL] placeholderImage:[UIImage imageNamed:@"static-00"]];
                    cell = tCell;
                }
                else if (section == 1)
                {
                    EncyTabThreeCell *tbCell = (EncyTabThreeCell *)oneObject;
                    tbCell.delegate = self;
                    cell = tbCell;
                }
                else
                {
                   
                    EncyHomePageTableViewCell *hCell = (EncyHomePageTableViewCell *)oneObject;
                    cell = hCell;
                }
            }
        }
    }
    if(section == 2)
    {
         NSDictionary *dataDic = [allDataForShow objectAtIndex:indexPath.row];
        EncyHomePageTableViewCell *hCell = (EncyHomePageTableViewCell *)cell;
        if(indexPath.row%2==0)
        {
            hCell.backgroundColor = BLUEINSI;
        }
        else
        {
            hCell.backgroundColor = ORIGINSI;
        }
        hCell.readNum.text = [dataDic objectForKey:@"ency_read"];
        hCell.titleLbl.text = [dataDic objectForKey:@"title"];
        hCell.collectNum.text = [dataDic objectForKey:@"ency_collect"];
        if([dataDic objectForKey:@"keyword"]==[NSNull null])
        {
            hCell.firstKey.text  = @"";
        }
        else
        {
            hCell.firstKey.text  = [dataDic objectForKey:@"keyword"];
        }
        
        NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ENCY_HOSTURL,[dataDic objectForKey:@"head_img"] ]];
        [hCell.titleImage sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"static-00"]];
    }
    return cell;
}

- (void)selectTabBtn:(NSInteger)currentTag
{
    [allDataForShow removeAllObjects];
    currentPage = 1;
    switch (currentTag) {
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
    [progress show:YES];
   [self performSelectorInBackground:@selector(downLoadMoreData:) withObject:[NSNumber numberWithInt:chooseType]];;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section != 2)
    {
        return;
    }
    NSDictionary *dataDic = [allDataForShow objectAtIndex:indexPath.row];
    NSString *petID = [dataDic objectForKey:@"ency_id"];
    [progress show:YES];
    
    if([ZXYNETHelper isNETConnect])
    {
        
        if([[LCYCommon sharedInstance] isUserLogin])
        {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSString *urlString = [ZXY_HOSTURL stringByAppendingString:ZXY_ISCOLLECT];
            [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
            NSString *phoneNum = [[LCYGlobal sharedInstance] currentUserID];
            [manager POST:urlString parameters:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:phoneNum.intValue], @"user_name",[NSNumber numberWithInt:petID.intValue],@"ency_id",nil] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [progress hide:YES];
                EncyDetailPetWeb *detailWeb = [[EncyDetailPetWeb alloc] initWithPetID:petID.integerValue andType:NO];
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

@end
