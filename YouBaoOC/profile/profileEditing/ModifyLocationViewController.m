//
//  ModifyLocationViewController.m
//  YouBaoOC
//
//  Created by eagle on 14/8/22.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "ModifyLocationViewController.h"
#import "AppDelegate.h"
#import "Region.h"
#import "LCYCommon.h"

@interface ModifyLocationViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *icyTextField;

@property (strong, nonatomic) IBOutlet UIPickerView *icyPickerView;

@property (strong, nonatomic) IBOutlet UIToolbar *icyToolBar;

@property (weak, nonatomic) NSManagedObjectContext *context;


@property (strong, nonatomic) NSArray *pickerData0;
@property (strong, nonatomic) NSArray *pickerData1;
@property (strong, nonatomic) NSArray *pickerData2;

@property (nonatomic) NSInteger regionResult;
@property (nonatomic) NSInteger regionTown;
@property (nonatomic) NSInteger regionCity;
@property (nonatomic) NSInteger regionProvince;


@property (nonatomic) BOOL isOK;

@end

@implementation ModifyLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.context = appDelegate.managedObjectContext;
    
    self.isOK = NO;
    
    self.regionResult = -1;
    self.regionTown = 0;
    self.regionCity = 0;
    self.regionProvince = 0;
    
    // 返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"navigationBack"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(navigationBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;
    
    // 确定按钮
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setFrame:CGRectMake(0, 0, 40, 24)];
    [doneButton setTitle:@" 确定 " forState:UIControlStateNormal];
    [doneButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    doneButton.layer.cornerRadius = 4.0f;
    doneButton.layer.masksToBounds = YES;
    [doneButton setBackgroundColor:THEME_DARK_BLUE];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    [doneButton addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.icyTextField setInputView:self.icyPickerView];
    [self.icyTextField setInputAccessoryView:self.icyToolBar];
    [self.icyTextField becomeFirstResponder];
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

#pragma mark - Actions


- (void)navigationBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doneButtonPressed:(id)sender{
    if (self.isOK) {
        NSDictionary *parameters = @{@"user_name"   : [LCYGlobal sharedInstance].currentUserID,
                                     @"province"    : [NSNumber numberWithInteger:self.regionProvince],
                                     @"city"        : [NSNumber numberWithInteger:self.regionCity],
                                     @"town"        : [NSNumber numberWithInteger:self.regionTown]};
        [[LCYCommon sharedInstance] showTips:@"正在上传修改" inView:self.view];
        [[LCYNetworking sharedInstance] postRequestWithAPI:User_modifyLocation parameters:parameters successBlock:^(NSDictionary *object) {
            if ([object[@"result"] boolValue]) {
                [self.navigationController popViewControllerAnimated:YES];
                NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
                [defaultCenter postNotificationName:@"reloadProfile" object:nil];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:object[@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
            [[LCYCommon sharedInstance] hideTipsInView:self.view];
        } failedBlock:^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"修改失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [[LCYCommon sharedInstance] hideTipsInView:self.view];
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请选择地理位置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
}

- (IBAction)toolBarDonePressed:(id)sender {
    NSMutableString *regionString = [NSMutableString string];
    Region *province = self.pickerData0[[self.icyPickerView selectedRowInComponent:0]];
    [regionString appendString:province.region_name];
    self.regionResult = [province.region_id integerValue];
    self.regionProvince = self.regionResult;
    
    if (self.pickerData1.count > [self.icyPickerView selectedRowInComponent:1]) {
        Region *city = self.pickerData1[[self.icyPickerView selectedRowInComponent:1]];
        [regionString appendString:@" "];
        [regionString appendString:city.region_name];
        self.regionResult = [city.region_id integerValue];
        self.regionCity = self.regionResult;
    }
    
    if (self.pickerData2.count > [self.icyPickerView selectedRowInComponent:2]) {
        Region *district = self.pickerData2[[self.icyPickerView selectedRowInComponent:2]];
        [regionString appendString:@" "];
        [regionString appendString:district.region_name];
        self.regionResult = [district.region_id integerValue];
        self.regionTown = self.regionResult;
    }
    
    self.icyTextField.text = regionString;
    [self.icyTextField resignFirstResponder];
    
    self.isOK = YES;
    
}


#pragma mark - UIPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Region" inManagedObjectContext:self.context];
        [fetchRequest setEntity:entity];
        // Specify criteria for filtering which objects to fetch
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"region_type = %@", @"1"];
        [fetchRequest setPredicate:predicate];
        // Specify how the fetched objects should be sorted
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"region_id"
                                                                       ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
        
        NSError *error = nil;
        NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects == nil) {
            return 0;
        } else {
            NSLog(@"fetched %ld",(long)fetchedObjects.count);
            self.pickerData0 = [NSArray arrayWithArray:fetchedObjects];
            return [self.pickerData0 count];
        }
    } else if (component == 1) {
        if (!self.pickerData1) {
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Region" inManagedObjectContext:self.context];
            [fetchRequest setEntity:entity];
            // Specify criteria for filtering which objects to fetch
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parent_id = %@", @"2"];
            [fetchRequest setPredicate:predicate];
            // Specify how the fetched objects should be sorted
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"region_id"
                                                                           ascending:YES];
            [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
            
            NSError *error = nil;
            NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
            if (fetchedObjects == nil) {
                return 0;
            } else {
                self.pickerData1 = [NSArray arrayWithArray:fetchedObjects];
                return [self.pickerData1 count];
            }
        } else {
            return [self.pickerData1 count];
        }
    } else {
        if (!self.pickerData2) {
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Region" inManagedObjectContext:self.context];
            [fetchRequest setEntity:entity];
            // Specify criteria for filtering which objects to fetch
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parent_id = %@", @"52"];
            [fetchRequest setPredicate:predicate];
            // Specify how the fetched objects should be sorted
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"region_id"
                                                                           ascending:YES];
            [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
            
            NSError *error = nil;
            NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
            if (fetchedObjects == nil) {
                return 0;
            } else {
                self.pickerData2 = [NSArray arrayWithArray:fetchedObjects];
                return [self.pickerData2 count];
            }
        } else {
            return [self.pickerData2 count];
        }
    }
}
- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {
        case 0:
        {
            Region *region = self.pickerData0[row];
            return region.region_name;
        }
            break;
        case 1:
        {
            Region *region = self.pickerData1[row];
            return region.region_name;
        }
            break;
        case 2:
        {
            Region *region = self.pickerData2[row];
            return region.region_name;
        }
            break;
        default:
            return @"";
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        Region *provinceRegion = self.pickerData0[row];
        NSNumber *provinceID = provinceRegion.region_id;
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Region" inManagedObjectContext:self.context];
        [fetchRequest setEntity:entity];
        // Specify criteria for filtering which objects to fetch
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parent_id = %@", provinceID];
        [fetchRequest setPredicate:predicate];
        // Specify how the fetched objects should be sorted
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"region_id"
                                                                       ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
        
        NSError *error = nil;
        NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects == nil) {
            self.pickerData1 = [NSArray array];
        } else {
            self.pickerData1 = [NSArray arrayWithArray:fetchedObjects];
        }
        [self.icyPickerView reloadComponent:1];
        
        NSInteger selectedIndex = [pickerView selectedRowInComponent:1];
        if (self.pickerData1.count > selectedIndex) {
            Region *cityRegion = self.pickerData1[selectedIndex];
            NSFetchRequest *gpRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *gpEntity = [NSEntityDescription entityForName:@"Region" inManagedObjectContext:self.context];
            [gpRequest setEntity:gpEntity];
            NSPredicate *gpPredicate = [NSPredicate predicateWithFormat:@"parent_id = %@", cityRegion.region_id];
            [gpRequest setPredicate:gpPredicate];
            NSSortDescriptor *gpSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"region_id" ascending:YES];
            [gpRequest setSortDescriptors:@[gpSortDescriptor]];
            error = nil;
            NSArray *gpFetchObjects = [self.context executeFetchRequest:gpRequest error:&error];
            if (gpFetchObjects == nil) {
                self.pickerData2 = [NSArray array];
            } else {
                self.pickerData2 = [NSArray arrayWithArray:gpFetchObjects];
            }
        } else {
            self.pickerData2 = [NSArray array];
        }
        [self.icyPickerView reloadComponent:2];
    } else if (component == 1) {
        Region *cityRegion = self.pickerData1[row];
        NSFetchRequest *gpRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *gpEntity = [NSEntityDescription entityForName:@"Region" inManagedObjectContext:self.context];
        [gpRequest setEntity:gpEntity];
        NSPredicate *gpPredicate = [NSPredicate predicateWithFormat:@"parent_id = %@", cityRegion.region_id];
        [gpRequest setPredicate:gpPredicate];
        NSSortDescriptor *gpSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"region_id" ascending:YES];
        [gpRequest setSortDescriptors:@[gpSortDescriptor]];
        NSError *error = nil;
        NSArray *gpFetchObjects = [self.context executeFetchRequest:gpRequest error:&error];
        if (gpFetchObjects == nil) {
            self.pickerData2 = [NSArray array];
        } else {
            self.pickerData2 = [NSArray arrayWithArray:gpFetchObjects];
        }
        [self.icyPickerView reloadComponent:2];
    }
}

@end
