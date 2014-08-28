//
//  EncyCategorySecondStyle.m
//  YouBaoOC
//
//  Created by developer on 14-8-22.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "EncyCategorySecondStyle.h"
#import "EN_PreDefine.h"
#import "EncyAllNeedHeader.h"
#import "PetStyle.h"
#import "SubPetSyle.h"
#import "EncySubCategoryCell.h"
#import "ZXYDownLoadImage.h"
#import "UIViewController+HideTabBar.h"
#import "EncySubCategoryVC.h"
#import "EncyCategoryCell.h"
@interface EncyCategorySecondStyle ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *allDataForShow;
    PetStyle *_petFather;
    ZXYProvider *dataProvider;
    __weak IBOutlet UITableView *currentTable;
    MBProgressHUD *progress;
    NSMutableDictionary *dataDic;
    ZXYFileOperation *fileOperation;
    ZXYDownLoadImage *downLoad;
    NSNotificationCenter *datatnc;
    NSString *_notiKey;
    BOOL isChild;
}

@end

@implementation EncyCategorySecondStyle

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWIthFather:(PetStyle *)petFather
{
    if(self = [super initWithNibName:@"EncySubCategoryVC" bundle:nil])
    {
        allDataForShow = [[NSMutableArray alloc] init];
        dataProvider = [ZXYProvider sharedInstance];
        _petFather = petFather;
        allDataForShow = [NSMutableArray arrayWithArray:[dataProvider readCoreDataFromDB:@"SubPetSyle" withContent:_petFather.cat_id andKey:@"f_id" orderBy:@"spell" isDes:YES] ];
        dataDic = [[NSMutableDictionary alloc] init];
        fileOperation = [ZXYFileOperation sharedSelf];
        downLoad = [[ZXYDownLoadImage alloc] init];
        [downLoad setTempDirectory:@"petStyle"];
        _notiKey = @"twoCateVC";
        [downLoad setNotiKey:_notiKey];
    }
    return  self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMB];
    [self initNavi];
    self.title =@"分类";
    datatnc = [NSNotificationCenter defaultCenter];
    [datatnc addObserver:self selector:@selector(reloadData) name:_notiKey object:nil];
    if([ZXYNETHelper isNETConnect])
    {
        [progress show:YES];
        [self performSelectorInBackground:@selector(downLoadData) withObject:nil];
    }
    else
    {
        UIAlertView *noConnect = [[UIAlertView alloc] initWithTitle:@"" message:@"没有连接网络" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [noConnect show];
        allDataForShow = [NSMutableArray arrayWithArray:[dataProvider readCoreDataFromDB:@"SubPetSyle" withContent:_petFather.cat_id andKey:@"f_id" orderBy:@"spell" isDes:YES] ];
        [self reloadData];
        
    }
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    NSLog(@"%f%f",currentTable.frame.origin.x,currentTable.frame.origin.y);
}

- (void)initNavi
{
    [self setNaviLeftItem];
     self.view.backgroundColor = BLUEINSI;
    currentTable.backgroundColor = BLUEINSI;
}

- (void)downLoadData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_petFather.cat_id,@"f_id", nil];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZXY_HOSTURL,ZXY_SUBPETSTYLE];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",[operation responseString]);
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:0 error:nil];
        if([jsonDic objectForKey:@"childStyle"]!=[NSNull null])
        {
            [dataProvider saveDataToCoreDataArr:[jsonDic objectForKey:@"childStyle"] withDBNam:@"SubPetSyle" isDelete:YES];
        }
        allDataForShow = [NSMutableArray arrayWithArray:[dataProvider readCoreDataFromDB:@"SubPetSyle" withContent:_petFather.cat_id andKey:@"f_id" orderBy:@"spell" isDes:YES] ];
        [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(loadImage) withObject:nil waitUntilDone:YES];
        [progress hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [progress hide:YES];
    }];
}

- (void)initMB
{
    progress = [[MBProgressHUD alloc] initWithView:[self view]];
    [self.view addSubview:progress];
}

- (void)reloadData
{
    [currentTable reloadData];
}

- (void)loadImage
{
    [downLoad startDownImage];
}

- (void)leftItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EncyCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"en_categoryIdentifier"];
    SubPetSyle *subPet = [allDataForShow objectAtIndex:indexPath.row];
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
    NSString *lastURL = [subPet.head_img componentsSeparatedByString:@"/"].lastObject;
    NSString *filePath = [fileOperation pathTempFile:@"petStyle" andURL:lastURL];
    if([fileOperation fileExistsAtPath:filePath])
    {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        cell.petHeadImage.image = [UIImage imageWithData:data];
    }
    else
    {
        NSString *urls = [NSString stringWithFormat:@"%@%@",ENCY_HOSTURL,subPet.head_img];
        [downLoad addImageURL:urls];
    }
    
    cell.petNameLbl.text = subPet.name;
    return cell;
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
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PetStyle *currentPet = [allDataForShow objectAtIndex:indexPath.row];
    EncySubCategoryVC *subView = [[EncySubCategoryVC alloc] initWIthFather:currentPet];
    [self.navigationController pushViewController:subView animated:YES];
}

- (void)dealloc
{
    [datatnc removeObserver:self name:_notiKey object:nil];
}
@end
