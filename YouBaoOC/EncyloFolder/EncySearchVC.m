//
//  EncySearchVC.m
//  YouBaoOC
//
//  Created by developer on 14-8-26.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "EncySearchVC.h"
#import "UIViewController+HideTabBar.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "MJRefresh.h"
#import "EncyHomePageTableViewCell.h"
#import "EncyDetailPetWeb.h"
#import "ZXYNETHelper.h"
#import "LCYCommon.h"
#import "LCYGlobal.h"
@interface EncySearchVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIToolbar *topBar;
    NSMutableArray *allDataForShow;
    NSInteger currentPage;
    MBProgressHUD *progress;
    MBProgressHUD *textHUD;
    __weak IBOutlet UITableView *currentTable;
    BOOL isFirstDown;
    BOOL needFirst;
    BOOL isAdd;
}

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)backView:(id)sender;
@end

@implementation EncySearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    isAdd = NO;
    isFirstDown = YES;
    [self initScrollHeader];
    [self initMBHUD];
    currentTable.backgroundColor = BLUEINSI;
    topBar = [[UIToolbar alloc] init];
    currentPage = 1;
    topBar = [self forKeyBoardHide:@"取消"];
    self.title = @"搜索";
    [self.searchBar setInputAccessoryView:topBar];
    UIView *views = [self.searchBar.subviews objectAtIndex:0];
    for(UIView *oneObject in views.subviews)
    {
        NSLog(@"class is %@",NSStringFromClass(oneObject.class));
        if([oneObject isKindOfClass:[UITextField class]])
        {
            UITextField *textField = (UITextField *)oneObject;
            textField.returnKeyType = UIReturnKeySearch;
        }
    }
    allDataForShow = [[NSMutableArray alloc] init];
    self.searchBar.delegate = self;
    
        // Do any additional setup after loading the view from its nib.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)viewDidAppear:(BOOL)animated
{
    if(![self.navigationController isNavigationBarHidden])
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    needFirst = YES;
    [super viewDidAppear:animated];
    if(!isFirstDown)
    {
        [progress show:YES];
        [allDataForShow removeAllObjects];
        [self performSelectorInBackground: @selector(downLoadMoreData:) withObject:self.searchBar.text];
        currentPage=1;
        
    }
    isFirstDown = NO;
}

- (void)initScrollHeader
{
    
    __block EncySearchVC *blockSelf = self;
    [currentTable addFooterWithCallback:^{
        [currentTable setFooterPullToRefreshText:@"加载数据"];
        [currentTable setFooterRefreshingText:@"正在加载数据"];
        [currentTable setFooterReleaseToRefreshText:@"加载数据"];
        [blockSelf performSelector:@selector(addLoadData:) withObject:nil ];
    }];
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
    [self downLoadMoreData:self.searchBar.text];
}

- (void)isLastPage
{
    if(isAdd)
    {
        [textHUD setLabelText:@"已经是最后一页了"];
        [textHUD show:YES];
        isAdd = NO;
    }
    [self performSelector:@selector(hideTextHUD) withObject:nil afterDelay:1];
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


- (void)hideKeyBoard:(id)sender
{
    [self.searchBar resignFirstResponder];
}

- (void)downLoadMoreData:(NSString *)searchContent
{
   
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZXY_HOSTURL,ZXY_GETMORE];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:searchContent,@"keyword",[NSNumber numberWithInt:currentPage],@"p", nil];
    [manager GET:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //[allDataForShow removeAllObjects];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [allDataForShow removeAllObjects];
    currentPage = 1;
    [self downLoadMoreData:self.searchBar.text];
    [searchBar resignFirstResponder];
}

- (IBAction)backView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
    return  64;
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
    [progress show:YES];
    
    if([ZXYNETHelper isNETConnect])
    {
        if([[LCYCommon sharedInstance] isUserLogin])
        {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            NSString *urlString = [ZXY_HOSTURL stringByAppendingString:ZXY_ISCOLLECT];
            NSString *phoneNum = [[LCYGlobal sharedInstance] currentUserID];
            [manager POST:urlString parameters:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:phoneNum.intValue], @"user_name",[NSNumber numberWithInt:petID.intValue],@"ency_id",nil] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if(![progress isHidden])
                {
                    [progress hide:YES];
                }
                               NSLog(@"%@",[operation responseString]);
                EncyDetailPetWeb *detailWeb = [[EncyDetailPetWeb alloc] initWithPetID:petID.integerValue andType:NO];
                if([[operation responseString] isEqualToString:@"true"])
                {
                    [detailWeb setIsSelected:YES];
                }
                else
                {
                    [detailWeb setIsSelected:NO];
                }
                [progress hide:YES];
                [self.navigationController pushViewController:detailWeb animated:YES];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@",error);
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

@end
