//
//  SquareListViewController.m
//  YouBaoOC
//
//  Created by eagle on 14/10/16.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "SquareListViewController.h"
#import "SquareListCell.h"
#import "GetSquareList.h"
#import "LCYNetworking.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Region.h"

typedef NS_ENUM(NSUInteger, SquareListOrder) {
    SquareListOrderDistance,
    SquareListOrderScore,
};

@interface SquareListViewController ()<UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>

// 顶部两个按钮
@property (weak, nonatomic) IBOutlet UIButton *orderByDistanceButton;
@property (weak, nonatomic) IBOutlet UIButton *orderByScoreButton;
@property (weak, nonatomic) IBOutlet UIImageView *orderByDistanceImageView;
@property (weak, nonatomic) IBOutlet UIImageView *orderByScoreImageView;
@property (nonatomic) SquareListOrder currentOrder;

// 数据
@property (strong, nonatomic) LCYGetSquareListBase *messageListByDistance;
@property (strong, nonatomic) LCYGetSquareListBase *messageListByScore;
// 避免重复加载数据
@property (nonatomic) BOOL bDictance;   // 正在加载按距离排序
@property (nonatomic) BOOL bScore;      // 正在加载按评分排序

// 定位系统
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) NSNumber *currentCityID;
@property (copy, nonatomic) NSString *locatedCityString;
@property (weak, nonatomic) NSManagedObjectContext *context;

// 主界面
@property (weak, nonatomic) IBOutlet UITableView *icyTableView;

@end

@implementation SquareListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 数据初始化
    self.bDictance = NO;
    self.bScore = NO;
    
    // 界面初始化
    self.currentOrder = SquareListOrderDistance;
    [self.icyTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    if (![CLLocationManager locationServicesEnabled]) {
        UIAlertView *locationNotReachableAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"无法访问位置信息，请您允许定位。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [locationNotReachableAlert show];
        return;
    }
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.context = appDelegate.managedObjectContext;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager startUpdatingLocation];
    
//    NSDictionary *distanceParameter = @{};
//    [[LCYNetworking sharedInstance] postRequestWithAPI:Square_getSquareList parameters:distanceParameter successBlock:^(NSDictionary *object) {
//        ;
//    } failedBlock:^{
//        ;
//    }];
//    
//    NSDictionary *scoreParameter = @{};
//    [[LCYNetworking sharedInstance] postRequestWithAPI:Square_getSquareList parameters:scoreParameter successBlock:^(NSDictionary *object) {
//        ;
//    } failedBlock:^{
//        ;
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Properties
- (void)setCurrentOrder:(SquareListOrder)currentOrder{
    _currentOrder = currentOrder;
    if (_currentOrder == SquareListOrderDistance) {
        [self.orderByDistanceButton setTitleColor:THEME_PINK forState:UIControlStateNormal];
        [self.orderByDistanceImageView setBackgroundColor:THEME_PINK];
        [self.orderByScoreButton setTitleColor:THEME_DARK_BLUE forState:UIControlStateNormal];
        [self.orderByScoreImageView setBackgroundColor:THEME_DARK_BLUE];
    } else {
        [self.orderByDistanceButton setTitleColor:THEME_DARK_BLUE forState:UIControlStateNormal];
        [self.orderByDistanceImageView setBackgroundColor:THEME_DARK_BLUE];
        [self.orderByScoreButton setTitleColor:THEME_PINK forState:UIControlStateNormal];
        [self.orderByScoreImageView setBackgroundColor:THEME_PINK];
    }
}

#pragma mark - Actions
- (IBAction)orderByDistanceButtonPressed:(id)sender {
    self.currentOrder = SquareListOrderDistance;
}
- (IBAction)orderByScoreButtonPressed:(id)sender {
    self.currentOrder = SquareListOrderScore;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.currentOrder == SquareListOrderDistance) {
        if (self.messageListByDistance) {
            return [self.messageListByDistance.msg count];
        } else {
            return 0;
        }
    } else if (self.currentOrder == SquareListOrderScore) {
        if (self.messageListByScore) {
            return [self.messageListByScore.msg count];
        } else {
            return 0;
        }
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SquareListCell *cell = [tableView dequeueReusableCellWithIdentifier:SquareListCellIdentifier];
    return cell;
}

#pragma mark - CLLocation
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    [manager stopUpdatingLocation];
    self.currentLocation = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    __weak __typeof(self)weakSelf = self;
    [geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placeMark = [placemarks firstObject];
        weakSelf.locatedCityString = placeMark.locality;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf translateCityLocation];
        });
    }];
}

- (void)translateCityLocation{
    NSString *city;
    NSRange range = [self.locatedCityString rangeOfString:@"市"];
    if (range.location!=NSNotFound) {
        city = [self.locatedCityString substringToIndex:range.location];
    } else {
        city = [NSString stringWithFormat:@"未找到城市"];
    }
    // 查找city id
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Region" inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"region_name CONTAINS %@", city];
    [fetchRequest setPredicate:predicate];
    NSError *coreDataError = nil;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&coreDataError];
    
    if (fetchedObjects == nil ||
        [fetchedObjects count] == 0) {
        // 无法定位到城市
        [self failToLocateCity];
    } else {
        // 成功定位到城市
        Region *LocRegion = [fetchedObjects firstObject];
        self.currentCityID = [NSNumber numberWithInteger:[LocRegion.region_id integerValue]];
        [self loadData:self.currentOrder];
    }
}

- (void)loadData:(SquareListOrder)dataType{
    if (dataType == SquareListOrderDistance) {
        if (!self.bDictance) {
            self.bDictance = YES;
            // 开始加载按距离排序
            NSDictionary *distanceParameter = @{@"category" : self.categoryID,
                                                @"type"     : @1,
                                                @"longitude": [NSNumber numberWithDouble:self.currentLocation.coordinate.longitude],
                                                @"latitude" : [NSNumber numberWithDouble:self.currentLocation.coordinate.latitude],
                                                @"city"     : self.currentCityID,
                                                @"page"     : @0,
                                                @"count"    : @12,
                                                };
            __weak __typeof(self)weakSelf = self;
            [[LCYNetworking sharedInstance] postRequestWithAPI:Square_getSquareList parameters:distanceParameter successBlock:^(NSDictionary *object) {
                weakSelf.bDictance = NO;
                weakSelf.messageListByDistance = [LCYGetSquareListBase modelObjectWithDictionary:object];
                [weakSelf.icyTableView reloadData];
            } failedBlock:^{
                weakSelf.bDictance = NO;
            }];
        }
    }
}

- (void)failToLocateCity{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"无法定位到您的城市" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

@end
