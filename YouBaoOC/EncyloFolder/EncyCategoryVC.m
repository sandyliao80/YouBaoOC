//
//  EncyCategoryVC.m
//  YouBaoOC
//
//  Created by developer on 14-8-6.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "EncyCategoryVC.h"
#import "EncyCategoryCell.h"
#import "EncyAllNeedHeader.h"
#import "EN_PreDefine.h"
#import "PetStyle.h"
#import "EncySubCategoryVC.h"
#import "ZXYDownImageHelper.h"
#import "UIViewController+HideTabBar.h"
#import "EncyCategorySecondStyle.h"
@interface EncyCategoryVC ()<UITableViewDelegate,UITableViewDataSource>
{
    MBProgressHUD *progress;
    NSMutableArray *allDataForShow;
    ZXYProvider    *dataProvider;
    __weak IBOutlet UITableView *currentTable;
    ZXYFileOperation *fileOperation;
    NSNotificationCenter *datatnc;
    ZXYDownImageHelper *downLoad;
    NSString *_notiKey;
    BOOL isDataDown;
}
@end

@implementation EncyCategoryVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        dataProvider = [ZXYProvider sharedInstance];
        fileOperation = [ZXYFileOperation sharedSelf];
        _notiKey = @"EncyCategoryVC";
        isDataDown = NO;
        downLoad = [[ZXYDownImageHelper alloc] initWithDirect:@"petStyle" andNotiKey:_notiKey];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavi];
    [self initMB];
    self.title = @"科目";
    datatnc = [NSNotificationCenter defaultCenter];
    [datatnc addObserver:self selector:@selector(reloadDataRow:) name:_notiKey object:nil];

    if([ZXYNETHelper isNETConnect])
    {
        [progress show:YES];
        [self performSelectorInBackground:@selector(startDownData) withObject:nil];
    }
    else
    {
        UIAlertView *noConnect = [[UIAlertView alloc] initWithTitle:@"" message:@"没有连接网络" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [noConnect show];
        allDataForShow =[NSMutableArray arrayWithArray:[dataProvider readCoreDataFromDB:@"PetStyle" isDes:YES orderByKey:@"spell",nil] ];
        [self reloadData];
    }
        // Do any additional setup after loading the view.
}

- (void)initNavi
{
    [self setNaviLeftItem];
    //self.view.backgroundColor = BLUEINSI;
    currentTable.backgroundColor = BLUEINSI;
}



- (void)initMB
{
    progress = [[MBProgressHUD alloc] initWithView:[self view]];
    [self.view addSubview:progress];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leftItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startDownData
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZXY_HOSTURL,ZXY_PETSTYLE]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        [progress hide:YES];
        NSLog(@"%@",[operation responseString]);
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:0 error:nil];
        NSArray *dataToCore = [jsonDic objectForKey:@"fatherStyle"];
        if(dataToCore!=[NSNull null])
        {
            [dataProvider saveDataToCoreDataArr:[jsonDic objectForKey:@"fatherStyle"] withDBNam:@"PetStyle" isDelete:YES];
        }
        isDataDown = YES;
        allDataForShow =[NSMutableArray arrayWithArray:[dataProvider readCoreDataFromDB:@"PetStyle" isDes:YES orderByKey:@"spell",nil] ];
        [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [progress hide:YES];
        NSLog(@"%@",[operation error]);
    }];
    [operation start];
}

- (void)reloadData
{
    [currentTable reloadData];
    [self startLoadImage];
}

- (void)reloadDataRow:(NSNotification *)noti
{
    [currentTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[noti.userInfo objectForKey:@"index"], nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)startLoadImage
{
     [downLoad startDownLoadImage];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EncyCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"en_categoryIdentifier"];
    PetStyle *currentPet = [allDataForShow objectAtIndex:indexPath.row];
    NSIndexPath *indexP = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.
                                section];
    NSLog(@"index is %d",indexP.row);

    if(cell == nil)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"EncyCategoryCell" owner:self options:nil];
        for(id oneObject in nibs)
        {
            if([oneObject isKindOfClass:[EncyCategoryCell class]])
            {
                cell = (EncyCategoryCell *)oneObject;
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
    NSString *lastURL = [currentPet.head_img componentsSeparatedByString:@"/"].lastObject;
    NSString *filePath = [fileOperation pathTempFile:@"petStyle" andURL:lastURL];
    if([fileOperation fileExistsAtPath:filePath])
    {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        cell.petHeadImage.image = [UIImage imageWithData:data];
    }
    else
    {
        NSString *urls = [NSString stringWithFormat:@"%@%@",ENCY_HOSTURL,currentPet.head_img];
       
        [downLoad addImageURLWithIndexDic:[NSDictionary dictionaryWithObjectsAndKeys:urls,@"url",indexP,@"index", nil]];
    }
    cell.petNameLbl.text = currentPet.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PetStyle *currentPet = [allDataForShow objectAtIndex:indexPath.row];
    EncyCategorySecondStyle *subView = [[EncyCategorySecondStyle alloc] initWIthFather:currentPet];
    [self.navigationController pushViewController:subView animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return allDataForShow.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void)dealloc
{
    [datatnc removeObserver:self name:_notiKey object:nil];
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
