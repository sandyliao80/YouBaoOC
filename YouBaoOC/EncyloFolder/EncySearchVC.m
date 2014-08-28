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
@interface EncySearchVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIToolbar *topBar;
    NSMutableArray *allDataForShow;
    NSInteger currentPage;
    MBProgressHUD *progress;
    MBProgressHUD *textHUD;
    __weak IBOutlet UITableView *currentTable;
    
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)backView:(id)sender;
@end

@implementation EncySearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initScrollHeader];
    [self initMBHUD];
    currentTable.backgroundColor = BLUEINSI;
    topBar = [[UIToolbar alloc] init];
    currentPage = 1;
    topBar = [self forKeyBoardHide:@"取消"];
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
    currentPage += 1;
    [self downLoadMoreData:self.searchBar.text];
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
    return  96;
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


- (BOOL)prefersStatusBarHidden
{
    return YES;
}
@end
