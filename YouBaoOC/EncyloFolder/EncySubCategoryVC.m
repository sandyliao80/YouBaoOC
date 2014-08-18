//
//  EncySubCategoryVC.m
//  YouBaoOC
//
//  Created by developer on 14-8-7.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "EncySubCategoryVC.h"
#import "EN_PreDefine.h"
#import "EncyAllNeedHeader.h"
#import "PetStyle.h"
#import "SubPetSyle.h"
#import "EncySubCategoryCell.h"
#import "ZXYDownLoadImage.h"
@interface EncySubCategoryVC ()<UITableViewDelegate,UITableViewDataSource>
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
    NSArray *allKeys;
    NSString *_notiKey;
}
@end

@implementation EncySubCategoryVC

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
        allKeys = [[NSArray alloc] init];
        _notiKey = @"threeCateVC";
        [downLoad setNotiKey:_notiKey];
        [self toPYSection];
    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMB];
    [self initNavi];
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
        [self toPYSection];
        [self reloadData];

    }
    

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavi
{
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
    [leftBtn setImage:[UIImage imageNamed:@"navigationBack"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"navigationBack"] forState:UIControlStateHighlighted];
    [leftBtn addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    [self.navigationItem setLeftBarButtonItem:leftBtnItem];
   // self.view.backgroundColor = BLUEINSI;
   //currentTable.backgroundColor = BLUEINSI;
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
        [self toPYSection];
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
    EncySubCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:SUBCATCELLIDENTIFIER];
    NSString *keyNow = [allKeys objectAtIndex:indexPath.section];
    NSMutableArray *arr = [dataDic objectForKey:keyNow];
    SubPetSyle *subPet = [arr objectAtIndex:indexPath.row];
    if(cell == nil)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"EncySubCategoryCell" owner:self options:nil];
        for(id oneObject in nibs)
        {
            if([oneObject isKindOfClass:[EncySubCategoryCell class]])
            {
                cell = (EncySubCategoryCell *)oneObject;
            }
        }
    }
    NSString *lastURL = [subPet.head_img componentsSeparatedByString:@"/"].lastObject;
    NSString *filePath = [fileOperation pathTempFile:@"petStyle" andURL:lastURL];
    if([fileOperation fileExistsAtPath:filePath])
    {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        cell.head_image.image = [UIImage imageWithData:data];
    }
    else
    {
        NSString *urls = [NSString stringWithFormat:@"%@%@",ENCY_HOSTURL,subPet.head_img];
        [downLoad addImageURL:urls];
    }

    cell.petNameLbl.text = subPet.name;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
     NSString *keyNow = [allKeys objectAtIndex:section];
    return keyNow;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *keyNow = [allKeys objectAtIndex:section];
    NSMutableArray *arr = [dataDic objectForKey:keyNow];
    return arr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return allKeys.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)toPYSection
{
    NSMutableDictionary *allDataAtPY = [[NSMutableDictionary alloc] init];
    NSArray *afterSort = [[NSArray alloc] init];
    afterSort = [allDataForShow sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        SubPetSyle *pet = (SubPetSyle *)obj1;
        SubPetSyle *pet2 = (SubPetSyle *)obj2;
        NSLog(@"pet %@ pet2 %@",pet.spell,pet2.spell);
        if(pet.spell > pet2.spell)
        {
            return -1;
        }
        else
        {
            return 1;
        }
    }];
    for(SubPetSyle *sub in afterSort)
    {
        NSString *py = sub.spell;
        if([allDataAtPY objectForKey:py])
        {
            NSMutableArray *arr = [allDataAtPY objectForKey:py];
            [arr addObject:sub];
        }
        else
        {
            NSMutableArray *pyArr = [[NSMutableArray alloc] init];
            [pyArr addObject:sub];
            [allDataAtPY setObject:pyArr forKey:py];
        }
    }
    allKeys = [allDataAtPY.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *str1 = obj1;
        NSString *str2 = obj2;
        char one = [str1 characterAtIndex:0];
        char two = [str2 characterAtIndex:0];
        return one>two;
    }];
    dataDic = allDataAtPY;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return allKeys;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *keyNow = [allKeys objectAtIndex:indexPath.section];
    NSMutableArray *arr = [dataDic objectForKey:keyNow];
    SubPetSyle *subPet = [arr objectAtIndex:indexPath.row];
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:subPet,@"subPet", nil];
    NSNotification *addNoti = [[NSNotification alloc] initWithName:@"ency_noti_type" object:self userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:addNoti];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
