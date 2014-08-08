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
#import "AddPetViewController.h"
#import "GetUserInfo.h"
#import <AFNetworking/AFNetworking.h>
#import "AppDelegate.h"
#import "Region.h"

@interface ProfileHomeViewController ()<UITableViewDelegate, UITableViewDataSource, AddPetDelegate, ProfileImageDownloadOperationDelegate>
@property (weak, nonatomic) IBOutlet UITableView *icyTableView;

@property (strong, nonatomic) GetUserInfoBase *baseInfo;

@property (strong, nonatomic) NSOperationQueue *queue;
@property (strong, nonatomic) ProfileImageDownloadOperation *operation;

@property (weak, nonatomic) NSManagedObjectContext *context;

@end

@implementation ProfileHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"addPetIdentifier"]) {
        AddPetViewController *addPetVC = [segue destinationViewController];
        addPetVC.delegate = self;
    }
}


#pragma mark - Actions

- (void)settingButtonPressed:(id)sender{
    [self performSegueWithIdentifier:@"ProfileToSetting" sender:nil];
}

- (void)editingButtonPressed:(id)sender{
    
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.baseInfo) {
        return 5 + [self.baseInfo.petInfo count];
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
                self.operation = [[ProfileImageDownloadOperation alloc] init];
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
        cell.icyLabel.text = self.baseInfo.userInfo.tip;
        if (cell.icyLabel.text.length == 0) {
            cell.icyLabel.text = @"这家伙很懒，什么也没有留下。";
        }
        return cell;
    } else if (indexPath.row == 3)
    {
        // 个人信息 - 地址
        ProfileHomeContentCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileHomeContentCellIdentifier];
        cell.icyImageView.image = [UIImage imageNamed:@"profileLoc"];
        
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
    }else if (indexPath.row == [self.baseInfo.petInfo count] + 4) {
        // 按钮
        ProfileHomeButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileHomeButtonCellIdentifier];
        return cell;
    } else {
        // 宠物
        ProfileHomePetCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileHomePetCellIdentifier];
        
        NSInteger petIndex = indexPath.row - 4;
        GetUserInfoPetInfo *petInfo = self.baseInfo.petInfo[petIndex];
        NSString *imageRelativePath = petInfo.headImage;
        if (![[LCYFileManager sharedInstance] imageExistAt:imageRelativePath]) {
            cell.icyImageView.image = nil;
            // 头像不存在，进行下载
            if (!self.queue) {
                self.queue = [[NSOperationQueue alloc] init];
            }
            if (!self.operation) {
                self.operation = [[ProfileImageDownloadOperation alloc] init];
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
        [misc appendString:@" "];
        [misc appendString:petInfo.name];
        cell.signLabel.text = misc;
        
        return cell;
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
        return 44.0f;
    }
    else if (indexPath.row == 6) {
        // 按钮
        return 60.0f;
    } else {
        // 宠物
        return 70.0f;
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
- (void)imageDownloadOperation:(ProfileImageDownloadOperation *)operation didFinishedDownloadImageAt:(NSIndexPath *)indexPath{
    [self.icyTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

@end


#pragma mark - ImageDownloadOperation

@interface ProfileImageDownloadOperation ()
@property (strong, atomic) NSMutableArray *imageInfoArray;
@property (strong, atomic) NSCondition *arrayCondition;
@end
@implementation ProfileImageDownloadOperation

- (instancetype)init{
    if (self = [super init]) {
        self.imageInfoArray = [NSMutableArray array];
        self.arrayCondition = [[NSCondition alloc] init];
    }
    return self;
}

- (void)main{
    while (YES) {
        // 检查线程是否已经结束
        if (self.isCancelled) {
            break;
        }
        // 检查需要下载的列表
        [self.arrayCondition lock];
        if (self.imageInfoArray.count == 0) {
            [self.arrayCondition wait];
            [self.arrayCondition unlock];
        } else {
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            NSDictionary *imageInfo = [self.imageInfoArray lastObject];
            NSString *imageName = imageInfo[@"imageName"];
            [self.imageInfoArray removeLastObject];
            NSLog(@"pop object:%@",imageName);
            NSLog(@"current object count = %ld",(long)self.imageInfoArray.count);
            [self.arrayCondition unlock];
            // 开启异步下载，完成后发送signal
            NSString *imageURL = [hostImageURL stringByAppendingString:imageName];
            NSURL *url = [NSURL URLWithString:imageURL];
            NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
            AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
            requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
            [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                UIImage *downImg = (UIImage *)responseObject;
                NSData *imageData = UIImageJPEGRepresentation(downImg, 1.0);
                [[LCYFileManager sharedInstance] saveData:imageData atRelativePath:imageName];
                if (self.delegate &&
                    [self.delegate respondsToSelector:@selector(imageDownloadOperation:didFinishedDownloadImageAt:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate imageDownloadOperation:self didFinishedDownloadImageAt:imageInfo[@"indexPath"]];
                    });
                }
                dispatch_semaphore_signal(sema);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"下载图片失败 error is %@",error);
                dispatch_semaphore_signal(sema);
            }];
            [requestOperation start];
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        }
    }
}

- (void)addImageName:(NSString *)imageName atIndexPath:(NSIndexPath *)indexPath{
    [self.arrayCondition lock];
    NSDictionary *imageInfo = @{@"imageName"    : imageName,
                                @"indexPath"    : indexPath};
    [self.imageInfoArray addObject:imageInfo];
    NSLog(@"push object:%@",imageInfo);
    [self.arrayCondition signal];
    [self.arrayCondition unlock];
}

@end
