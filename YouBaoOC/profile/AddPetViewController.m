//
//  AddPetViewController.m
//  YouBaoOC
//
//  Created by Licy on 14-8-4.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "AddPetViewController.h"
#import "FilterViewController.h"
#import "UIImage+LCYResize.h"

@interface AddPetViewController ()<UITextFieldDelegate, SecondFilterDelegate, UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

#pragma mark - View

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *corneredBGView;
@property (weak, nonatomic) IBOutlet UITextField *nicknameLabel;

@property (weak, nonatomic) IBOutlet UITextField *catagoryLabel;

@property (weak, nonatomic) IBOutlet UITextField *signLabel;


@property (weak, nonatomic) IBOutlet UIImageView *sexImage;

@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

@property (strong, nonatomic) IBOutlet UIPickerView *agePicker;
@property (strong, nonatomic) UITextField *zombieTextField;
@property (strong, nonatomic) IBOutlet UIToolbar *pickerToolBar;

@property (weak, nonatomic) IBOutlet UIImageView *icyImageView;

#pragma mark - Properties

@property (nonatomic) PetSex currentSex;

@property (nonatomic) CGRect originalFrame;

@property (nonatomic) NSUInteger currentPetMisc;

@property (strong, nonatomic) NSArray *ageKeys;
@property (strong, nonatomic) NSDictionary *ageMap;

@property (strong, nonatomic) UIImagePickerController *picker;

@end

@implementation AddPetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.currentSex = PetSexMale;
    self.currentPetMisc = 0;
    self.ageMap = @{@"小于1岁" : @0,
                    @"1岁"   : @1,
                    @"2岁"   : @2,
                    @"3岁"   : @3,
                    @"4岁"   : @4,
                    @"5岁"   : @5,
                    @"6岁"   : @6,
                    @"7岁"   : @7,
                    @"8岁"   : @8,
                    @"9岁"   : @9,
                    @"10岁"   : @10,
                    @"大于10岁": @11};
    self.ageKeys = @[@"小于1岁", @"1岁", @"2岁", @"3岁", @"4岁", @"5岁", @"6岁", @"7岁", @"8岁", @"9岁", @"10岁", @"大于10岁"];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"navigationBack"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(navigationBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 50, 44)];
    [rightBtn setImage:[UIImage imageNamed:@"addPetSave"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(saveButtonPressed:) forControlEvents:UIControlEventTouchUpInside];;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    for (UIView *view in self.corneredBGView) {
        [view.layer setCornerRadius:5.0f];
        [view.layer setMasksToBounds:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.originalFrame = self.view.frame;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"addPetPushFilter"]) {
        FilterViewController *filterVC = [segue destinationViewController];
        filterVC.delegate = self;
    }
}

#pragma mark - UIScrollViewDelegate

- (IBAction)contentTouchDown:(id)sender {
    [self.nicknameLabel resignFirstResponder];
    [self.signLabel resignFirstResponder];
}

#pragma mark - Actions
- (void)navigationBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveButtonPressed:(id)sender{
}

- (IBAction)sexButtonPressed:(id)sender {
    if (self.currentSex == PetSexMale) {
        self.currentSex = PetSexFemale;
        self.sexImage.image = [UIImage imageNamed:@"icoFemale"];
    } else {
        self.currentSex = PetSexMale;
        self.sexImage.image = [UIImage imageNamed:@"icoMale"];
    }
}

- (IBAction)breedingButtonPressed:(UIButton *)sender {
    if ((self.currentPetMisc&PetMiscOptionBreeding)!=0) {
        self.currentPetMisc^=PetMiscOptionBreeding;
        sender.backgroundColor = THEME_LIGHT_COLOR;
    } else {
        self.currentPetMisc^=PetMiscOptionBreeding;
        sender.backgroundColor = THEME_PINK;
    }
}

- (IBAction)adoptButtonPressed:(UIButton *)sender {
    if ((self.currentPetMisc&PetMiscOptionAdopt)!=0) {
        self.currentPetMisc^=PetMiscOptionAdopt;
        sender.backgroundColor = THEME_LIGHT_COLOR;
    } else {
        self.currentPetMisc^=PetMiscOptionAdopt;
        sender.backgroundColor = THEME_PINK;
    }
}
- (IBAction)fosterredButtonPressed:(UIButton *)sender {
    if ((self.currentPetMisc&PetMiscOptionFostered)!=0) {
        self.currentPetMisc^=PetMiscOptionFostered;
        sender.backgroundColor = THEME_LIGHT_COLOR;
    } else {
        self.currentPetMisc^=PetMiscOptionFostered;
        sender.backgroundColor = THEME_PINK;
    }
}

- (IBAction)ageButtonPressed:(id)sender {
    if (!self.zombieTextField) {
        self.zombieTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        self.zombieTextField.inputView = self.agePicker;
        self.zombieTextField.inputAccessoryView = self.pickerToolBar;
        [self.view addSubview:self.zombieTextField];
    }
    [self.zombieTextField becomeFirstResponder];
}

- (IBAction)agePickDone:(id)sender {
    NSInteger row = [self.agePicker selectedRowInComponent:0];
    self.ageLabel.text = self.ageKeys[row];
    [self.zombieTextField resignFirstResponder];
}

- (IBAction)imageTap:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从照片中选择", @"拍照", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - UITextField
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.catagoryLabel) {
        [textField resignFirstResponder];
        [self.signLabel resignFirstResponder];
        [self.nicknameLabel resignFirstResponder];
        [self performSegueWithIdentifier:@"addPetPushFilter" sender:nil];
    } else if (textField == self.signLabel) {
        CGRect frame = self.view.frame;
        frame.origin.y -= 100;
        [UIView animateWithDuration:0.35 animations:^{
            [self.view setFrame:frame];
        }];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.catagoryLabel) {
        if ([self.nicknameLabel isFirstResponder]) {
            return NO;
        } else if ([self.signLabel isFirstResponder]) {
            return NO;
        } else if ([self.zombieTextField isFirstResponder]) {
            return NO;
        }
        return YES;
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.35 animations:^{
        [self.view setFrame:self.originalFrame];
    }];
}

#pragma mark - FilterDelegate
- (void)filterDidSelected:(SearchDetailByIDChildStyle *)category{
    self.catagoryLabel.text = category.name;
}

#pragma mark - UIPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.ageKeys count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.ageKeys objectAtIndex:row];
}

#pragma mark - UIActionSheet
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
    UIImage *originalImage = info[UIImagePickerControllerEditedImage];
    UIImage *scaledImage = [originalImage imageByScalingAndCroppingForSize:CGSizeMake(200, 200)];
    
    self.icyImageView.image = scaledImage;
}

@end
