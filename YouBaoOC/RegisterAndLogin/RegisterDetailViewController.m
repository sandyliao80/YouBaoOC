//
//  RegisterDetailViewController.m
//  YouBaoOC
//
//  Created by Licy on 14-7-25.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "RegisterDetailViewController.h"
#import "UIImage+LCYResize.h"
#import "LCYCommon.h"
#import "AppDelegate.h"
#import "Region.h"

typedef NS_ENUM(NSUInteger, RegisterDetailGender) {
    RegisterDetailGenderMale,
    RegisterDetailGenderFemale
};

@interface RegisterDetailViewController ()<UIActionSheetDelegate, UIImagePickerControllerDelegate ,UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *icyImageView;

@property (strong, nonatomic) UIImagePickerController *picker;

@property (weak, nonatomic) IBOutlet UIButton *genderButton;

@property (nonatomic) RegisterDetailGender currentGender;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UITextField *cityTextField;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (strong, nonatomic) IBOutlet UIToolbar *myToolBar;

@property (weak, nonatomic) NSManagedObjectContext *context;

@property (strong, nonatomic) NSArray *pickerData0;
@property (strong, nonatomic) NSArray *pickerData1;
@property (strong, nonatomic) NSArray *pickerData2;

@property (nonatomic) NSInteger regionResult;

@property (nonatomic) BOOL avatarOK;
@property (nonatomic) BOOL nameOK;
@property (nonatomic) BOOL placeOK;

@end

@implementation RegisterDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.context = appDelegate.managedObjectContext;
    self.regionResult = -1;
    
    self.avatarOK = NO;
    self.nameOK = NO;
    self.placeOK = NO;
    
    self.currentGender = RegisterDetailGenderMale;
    self.cityTextField.inputView = self.pickerView;
    self.cityTextField.inputAccessoryView = self.myToolBar;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"navigationBack"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(navigationBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;
    
    CGFloat radius = MIN(self.icyImageView.bounds.size.width, self.icyImageView.bounds.size.height) / 2.0;
    self.icyImageView.layer.cornerRadius = radius;
    self.icyImageView.layer.masksToBounds = YES;
    self.icyImageView.image = [UIImage imageNamed:@"avatarDefault"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigationBack:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)imageTapped:(UITapGestureRecognizer *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从照片中选择", @"拍照", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        // 从照片中选择
        [self callPickerWith:UIImagePickerControllerSourceTypePhotoLibrary];
    } else if (buttonIndex == 1) {
        // 拍照
        [self callPickerWith:UIImagePickerControllerSourceTypeCamera];
    } else {
        // 取消
    }
}

- (void)callPickerWith:(UIImagePickerControllerSourceType)sourceType{
    if (!self.picker) {
        self.picker = [[UIImagePickerController alloc] init];
        self.picker.delegate = self;
        self.picker.allowsEditing = YES;
    }
    self.picker.sourceType = sourceType;
    [self presentViewController:self.picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[LCYCommon sharedInstance] showTips:@"图片上传中" inView:self.view];
    UIImage *originalImage = info[UIImagePickerControllerEditedImage];
    UIImage *scaledImage = [originalImage imageByScalingAndCroppingForSize:CGSizeMake(200, 200)];
    
    // 上传图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 100, 100)];
    imageView.image = scaledImage;
    [self.view addSubview:imageView];
}

- (IBAction)backgroundTouched:(id)sender {
    [self.nameTextField resignFirstResponder];
    [self.cityTextField resignFirstResponder];
}


- (IBAction)genderButtonPressed:(UIButton *)sender {
    switch (self.currentGender) {
        case RegisterDetailGenderMale:
            self.currentGender = RegisterDetailGenderFemale;
            [self.genderButton setImage:[UIImage imageNamed:@"icoFemale"] forState:UIControlStateNormal];
            [self.genderButton setImage:[UIImage imageNamed:@"icoFemale"] forState:UIControlStateHighlighted];
            break;
        case RegisterDetailGenderFemale:
            self.currentGender = RegisterDetailGenderMale;
            [self.genderButton setImage:[UIImage imageNamed:@"icoMale"] forState:UIControlStateNormal];
            [self.genderButton setImage:[UIImage imageNamed:@"icoMale"] forState:UIControlStateHighlighted];
            break;
        default:
            break;
    }
}


- (IBAction)regionButtonPressed:(UIButton *)sender {
    [self.cityTextField becomeFirstResponder];
}

- (IBAction)pickerDoneButtonPressed:(UIBarButtonItem *)sender {
    NSMutableString *regionString = [NSMutableString string];
    Region *province = self.pickerData0[[self.pickerView selectedRowInComponent:0]];
    [regionString appendString:province.region_name];
    self.regionResult = [province.region_id integerValue];
    
    if (self.pickerData1.count > [self.pickerView selectedRowInComponent:1]) {
        Region *city = self.pickerData1[[self.pickerView selectedRowInComponent:1]];
        [regionString appendString:@" "];
        [regionString appendString:city.region_name];
        self.regionResult = [city.region_id integerValue];
    }
    
    if (self.pickerData2.count > [self.pickerView selectedRowInComponent:2]) {
        Region *district = self.pickerData2[[self.pickerView selectedRowInComponent:2]];
        [regionString appendString:@" "];
        [regionString appendString:district.region_name];
        self.regionResult = [district.region_id integerValue];
    }
    
    self.cityTextField.text = regionString;
    [self.cityTextField resignFirstResponder];
}

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
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parent_id = %@", @"500"];
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
        [self.pickerView reloadComponent:1];
        
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
        [self.pickerView reloadComponent:2];
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
        [self.pickerView reloadComponent:2];
    }
}

@end
