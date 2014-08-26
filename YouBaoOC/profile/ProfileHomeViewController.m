//
//  ProfileHomeViewController.m
//  YouBaoOC
//
//  Created by Licy on 14-7-28.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "ProfileHomeViewController.h"
#import "LCYCommon.h"
#import "AppDelegate.h"
#import "ProfileHomeAvatarCell.h"
#import "ProfileHomeLikeCell.h"
#import "ProfileHomeContentCell.h"
#import "ProfileHomePetCell.h"
#import "ProfileHomeButtonCell.h"
#import "ProfileHomeHeaderCell.h"
#import "AddPetViewController.h"
#import "GetUserInfo.h"
#import "AppDelegate.h"
#import "Region.h"
#import "CellImageDownloadOperation.h"
#import "moePetProfile/MoePetProfileViewController.h"
#import "ProfileEditingViewController.h"

@interface ProfileHomeViewController ()<UITableViewDelegate, UITableViewDataSource, AddPetDelegate, CellImageDownloadOperationDelegate>
@property (weak, nonatomic) IBOutlet UITableView *icyTableView;

@property (strong, nonatomic) GetUserInfoBase *baseInfo;

@property (strong, nonatomic) NSOperationQueue *queue;
@property (strong, nonatomic) CellImageDownloadOperation *operation;

@property (weak, nonatomic) NSManagedObjectContext *context;

@property (strong, nonatomic) GetUserInfoPetInfo *petToPass;

@property (nonatomic) BOOL isBack;

@end

@implementation ProfileHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isBack = NO;
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.context = appDelegate.managedObjectContext;
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 0.0f;
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingButton setFrame:CGRectMake(0, 0, 44.0f, 44.0f)];
    [settingButton setImage:[UIImage imageNamed:@"profileSetting"] forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(settingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    [self.navigationItem setLeftBarButtonItems:@[fixedSpace, leftButtonItem]];
    
    UIBarButtonItem *rightFixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightFixedSpace.width = 0.0f;
    UIButton *editingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editingButton setFrame:CGRectMake(0, 0, 44.0f, 44.0f)];
    [editingButton setImage:[UIImage imageNamed:@"profileEdit"] forState:UIControlStateNormal];
    [editingButton addTarget:self action:@selector(editingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editingButton];
    [self.navigationItem setRightBarButtonItems:@[rightFixedSpace, rightButtonItem]];
    
    [self.icyTableView setBackgroundColor:[UIColor clearColor]];
    
    // 加载用户所有信息
    [[LCYCommon sharedInstance] showTips:@"正在加载用户信息" inView:self.view];
    NSDictionary *parameters = @{@"user_name"   : [LCYGlobal sharedInstance].currentUserID};
    [[LCYNetworking sharedInstance] postRequestWithAPI:User_getUserInfoByID parameters:parameters successBlock:^(NSDictionary *object) {
        self.baseInfo = [GetUserInfoBase modelObjectWithDictionary:object];
        if (self.baseInfo.result) {
            // 加载成功
            self.navigationItem.title = self.baseInfo.userInfo.nickName;
            [self.icyTableView reloadData];
        } else {
            // 加载失败
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"个人信息加载失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        [[LCYCommon sharedInstance] hideTipsInView:self.view];
    } failedBlock:^{
        [[LCYCommon sharedInstance] hideTipsInView:self.view];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    if (self.isBack) {
        [self.icyTableView reloadData];
        self.isBack = NO;
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"addPetIdentifier"]) {
        AddPetViewController *addPetVC = [segue destinationViewController];
        addPetVC.delegate = self;
    } else if ([segue.identifier isEqualToString:@"showMoePet"]) {
        MoePetProfileViewController *moePetVC = [segue destinationViewController];
        moePetVC.petInfo = self.petToPass;
    } else if ([segue.identifier isEqualToString:@"showEditing"]) {
        ProfileEditingViewController *profileEditingVC = [segue destinationViewController];
        profileEditingVC.userInfoBase = self.baseInfo;
        self.isBack = YES;
    }
}


#pragma mark - Actions

- (void)settingButtonPressed:(id)sender{
    [self performSegueWithIdentifier:@"ProfileToSetting" sender:nil];
}

- (void)editingButtonPressed:(id)sender{
    if (self.baseInfo) {
        [self performSegueWithIdentifier:@"showEditing" sender:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请等待获取用户信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}


#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.baseInfo) {
        if ([self.baseInfo.petInfo count] == 0) {
            return 5;
        } else {
            return 6 + [self.baseInfo.petInfo count];
        }
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        // 头像
        ProfileHomeAvatarCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileHomeAvatarCellIdentifier];
        
        NSString *imageRelativePath = self.baseInfo.userInfo.headImage;
        if (![[LCYFileManager sharedInstance] imageExistAt:imageRelativePath]) {
            cell.icyImageView.image = [UIImage imageNamed:@"avatarDefault"];
            // 头像不存在，进行下载
            if (!self.queue) {
                self.queue = [[NSOperationQueue alloc] init];
            }
            if (!self.operation) {
                self.operation = [[CellImageDownloadOperation alloc] init];
                self.operation.delegate = self;
                [self.queue addOperation:self.operation];
            }
            [self.operation addImageName:imageRelativePath atIndexPath:indexPath];
        } else {
            // 头像存在，直接显示
            cell.icyImageView.image = [UIImage imageWithContentsOfFile:[[LCYFileManager sharedInstance] absolutePathFor:imageRelativePath]];
        }
        
        return cell;
    } else if (indexPath.row == 1) {
        // 喜欢
        ProfileHomeLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileHomeLikeCellIdentifier];
        cell.xihuan.text = @"0";
        cell.fensi.text = @"0";
        cell.guanzhu.text = @"0";
        return cell;
    } else if (indexPath.row == 2) {
        // 个人信息 - 签名
        ProfileHomeContentCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileHomeContentCellIdentifier];
        cell.icyImageView.image = [UIImage imageNamed:@"profileSign"];
        [cell setBackgroundColor:THEME_CELL_LIGHT_GREY];
        cell.icyLabel.text = self.baseInfo.userInfo.tip;
        if (cell.icyLabel.text.length == 0) {
            cell.icyLabel.text = @"这家伙很懒，什么也没有留下。";
        }
        return cell;
    } else if (indexPath.row == 3) {
        // 个人信息 - 地址
        ProfileHomeContentCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileHomeContentCellIdentifier];
        cell.icyImageView.image = [UIImage imageNamed:@"profileLoc"];
        [cell setBackgroundColor:THEME_CELL_LIGHT_BLUE];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Region" inManagedObjectContext:self.context];
        [fetchRequest setEntity:entity];
        // Specify criteria for filtering which objects to fetch
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"region_id = %@ OR region_id = %@ OR region_id = %@", self.baseInfo.userInfo.town, self.baseInfo.userInfo.city, self.baseInfo.userInfo.province];
        [fetchRequest setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
        
        NSMutableString *district = [NSMutableString string];
        for (Region *region in fetchedObjects) {
            if ([region.region_id integerValue] == [self.baseInfo.userInfo.province integerValue]) {
                [district appendString:region.region_name];
            }
        }
        for (Region *region in fetchedObjects) {
            if ([region.region_id integerValue] == [self.baseInfo.userInfo.city integerValue]) {
                [district appendString:@" "];
                [district appendString:region.region_name];
            }
        }
        for (Region *region in fetchedObjects) {
            if ([region.region_id integerValue] == [self.baseInfo.userInfo.town integerValue]) {
                [district appendString:@" "];
                [district appendString:region.region_name];
            }
        }
        cell.icyLabel.text = district;
        
        return cell;
    }else if ([self.baseInfo.petInfo count] == 0) {
        // 按钮
        ProfileHomeButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileHomeButtonCellIdentifier];
        return cell;
    } else {
        if (indexPath.row == [self.baseInfo.petInfo count] + 5) {
            // 按钮
            ProfileHomeButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileHomeButtonCellIdentifier];
            return cell;
        } else if (indexPath.row == 4) {
            // header view
            ProfileHomeHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileHomeHeaderCellIdentifier];
            cell.icyLabel.text = @"我的宠物";
            cell.backgroundColor = THEME_CELL_LIGHT_GREY;
            return cell;
        }else {
            // 宠物
            ProfileHomePetCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileHomePetCellIdentifier];
            
//            if (indexPath.row % 2 == 0) {
//                [cell setBackgroundColor:THEME_CELL_LIGHT_BLUE];
//            } else {
//                [cell setBackgroundColor:THEME_CELL_LIGHT_GREY];
//            }
            
            NSInteger petIndex = indexPath.row - 5;
            GetUserInfoPetInfo *petInfo = self.baseInfo.petInfo[petIndex];
            NSString *imageRelativePath = petInfo.headImage;
            if (![[LCYFileManager sharedInstance] imageExistAt:imageRelativePath]) {
                cell.icyImageView.image = nil;
                // 头像不存在，进行下载
                if (!self.queue) {
                    self.queue = [[NSOperationQueue alloc] init];
                }
                if (!self.operation) {
                    self.operation = [[CellImageDownloadOperation alloc] init];
                    self.operation.delegate = self;
                    [self.queue addOperation:self.operation];
                }
                [self.operation addImageName:imageRelativePath atIndexPath:indexPath];
            } else {
                // 头像存在，直接显示
                cell.icyImageView.image = [UIImage imageWithContentsOfFile:[[LCYFileManager sharedInstance] absolutePathFor:imageRelativePath]];
            }
            cell.nameLabel.text = petInfo.petName;
            NSMutableString *misc = [NSMutableString string];
            if ([petInfo.age integerValue] == 0) {
                [misc appendString:@"小于1岁"];
            } else if ([petInfo.age integerValue] == 11) {
                [misc appendString:@"大于10岁"];
            } else {
                [misc appendString:petInfo.age];
                [misc appendString:@"岁"];
            }
            if (petInfo.name) {
                [misc appendString:@" "];
                [misc appendString:petInfo.name];
            }
            [misc appendString:@" "];
            [misc insertString:@" " atIndex:0];
            cell.signLabel.text = misc;
            
            
            // 宠物性别
            cell.sexImageView.image = [petInfo.petSex isEqualToString:@"1"]?[UIImage imageNamed:@"icoFemale"]:[UIImage imageNamed:@"icoMaleDark"];
            
            cell.breakLineImageView.backgroundColor = THEME_CELL_LIGHT_GREY;
            BOOL breeding = [petInfo.fHybridization isEqualToString:@"1"]?YES:NO;
            BOOL adopt = [petInfo.fAdopt isEqualToString:@"1"]?YES:NO;
            BOOL entrust = [petInfo.isEntrust isEqualToString:@"1"]?YES:NO;
            [cell cellTypeBreeding:breeding adopting:adopt entrust:entrust];
            
            return cell;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        // 头像
        return 80.0f;
    } else if (indexPath.row == 1) {
        // 喜欢
        return 44.0f;
    } else if (indexPath.row == 2 || indexPath.row == 3) {
        // 个人信息
        return 50.0f;
    } else {
        if ([self.baseInfo.petInfo count] == 0) {
            if (indexPath.row == 6) {
                // 按钮
                return 60.0f;
            } else {
                // 宠物
                return 70.0f;
            }
        } else {
            if (indexPath.row == [self.baseInfo.petInfo count] + 5) {
                // 按钮
                return 60.0f;
            } else if (indexPath.row == 4) {
                // 我的宠物Label
                return 25.0f;
            } else {
                // 各种宠物
                return 70.0f;
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row <= 3) {
        return;
    }
    if (([self.baseInfo.petInfo count]) != 0 &&
        (indexPath.row != ([self.baseInfo.petInfo count] + 5))) {
        NSInteger petIndex = indexPath.row - 5;
        self.petToPass = self.baseInfo.petInfo[petIndex];
        [self performSegueWithIdentifier:@"showMoePet" sender:nil];
    }
}

#pragma mark - AddPetDelegate
- (void)AddPetDidFinished:(AddPetViewController *)viewController{
    [[LCYCommon sharedInstance] showTips:@"正在加载用户信息" inView:self.view];
    NSDictionary *parameters = @{@"user_name"   : [LCYGlobal sharedInstance].currentUserID};
    [[LCYNetworking sharedInstance] postRequestWithAPI:User_getUserInfoByID parameters:parameters successBlock:^(NSDictionary *object) {
        self.baseInfo = [GetUserInfoBase modelObjectWithDictionary:object];
        if (self.baseInfo.result) {
            // 加载成功
            [self.icyTableView reloadData];
        } else {
            // 加载失败
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"个人信息加载失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        [[LCYCommon sharedInstance] hideTipsInView:self.view];
    } failedBlock:^{
        [[LCYCommon sharedInstance] hideTipsInView:self.view];
    }];
}

#pragma mark - ImageDownloadDelegate
- (void)imageDownloadOperation:(CellImageDownloadOperation *)operation didFinishedDownloadImageAt:(NSIndexPath *)indexPath{
    [self.icyTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

@end
