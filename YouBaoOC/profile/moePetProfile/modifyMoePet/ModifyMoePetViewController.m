//
//  ModifyMoePetViewController.m
//  YouBaoOC
//
//  Created by eagle on 14/8/19.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "ModifyMoePetViewController.h"
#import "LCYCommon.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FilterViewController.h"
#import "QRScanViewController.h"
#import "UIImage+LCYResize.h"

@interface ModifyMoePetViewController ()<UITextFieldDelegate, UIScrollViewDelegate, SecondFilterDelegate, QRScanDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *corneredBGView;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;      /**< 头像 */

@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;    /**< 昵称 */

@property (weak, nonatomic) IBOutlet UITextField *categoryTextField;    /**< 品种 */

@property (weak, nonatomic) IBOutlet UITextField *signTextField;        /**< 签名 */

@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;         /**< 性别 */

@property (weak, nonatomic) IBOutlet UILabel *ageLabel;                 /**< 年龄 */

@property (weak, nonatomic) IBOutlet UIButton *breedingButton;          /**< 找配种 */

@property (weak, nonatomic) IBOutlet UIButton *adoptButton;             /**< 求领养 */

@property (weak, nonatomic) IBOutlet UIButton *entrustButton;           /**< 被寄养 */

@property (weak, nonatomic) IBOutlet UIButton *QRButton;                /**< 二维码扫描 */

@property (weak, nonatomic) IBOutlet UISwitch *QRSwitch;


@property (strong, nonatomic) IBOutlet UIPickerView *agePicker;
@property (strong, nonatomic) IBOutlet UIToolbar *pickerToolBar;



@property (strong, nonatomic) UITextField *zombieTextField;             /**< 站位 */

@property (nonatomic) CGRect originalFrame;

@property (strong, nonatomic) GetPetDetailBase *tpPetBase;              /**< 用于记录修改的内容，在按下确定之前，不会更新原始数据 */


@property (strong, nonatomic) NSArray *ageKeys;
@property (strong, nonatomic) NSDictionary *ageMap;

@property (strong, nonatomic) UIImagePickerController *imagePicker;


#pragma mark - 纪录存储信息
@property (strong, nonatomic) SearchDetailByIDChildStyle *category;

@end

@implementation ModifyMoePetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    // 带圆角的界面元素
    for (UIView *oneView in self.corneredBGView) {
        [oneView.layer setCornerRadius:5.0f];
        [oneView.layer setMasksToBounds:YES];
    }
    
    if (!self.petDetailBase) {
        // 需要加载宠物信息
        [[LCYCommon sharedInstance] showTips:@"加载宠物信息" inView:self.view];
        
        [self reloadPetData];
    } else {
        // 无需加载宠物信息
        self.tpPetBase = [[GetPetDetailBase alloc] initWithDictionary:[self.petDetailBase dictionaryRepresentation]];
        [self makeScene];
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
    if ([segue.identifier isEqualToString:@"pushFilter"]) {
        FilterViewController *filterVC = [segue destinationViewController];
        filterVC.delegate = self;
    } else if ([segue.identifier isEqualToString:@"presentQRVC"]) {
        QRScanViewController *qrVC = [segue destinationViewController];
        qrVC.delegate = self;
    }
}


#pragma mark - Actions
- (void)navigationBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doneButtonPressed:(id)sender{
    // 确定，上传宠物信息
    NSDictionary *parameters;
    NSString *petCode = self.QRSwitch.isOn?self.tpPetBase.petInfo.petCode:@"";
    if (self.category) {
        parameters = @{@"pet_id"    : self.tpPetBase.petInfo.petId,
                       @"pet_name"  : self.nickNameTextField.text,
                       @"cat_id"    : self.category.catId,
                       @"age"   : self.ageMap[self.ageLabel.text],
                       @"sex"   : self.tpPetBase.petInfo.petSex,
                       @"tip"       : self.signTextField.text,
                       @"f_hybridization"   : self.tpPetBase.petInfo.fHybridization,
                       @"f_adopt"   : self.tpPetBase.petInfo.fAdopt,
                       @"is_entrust": self.tpPetBase.petInfo.isEntrust,
                       @"pet_code"  : petCode};
    } else {
        parameters = @{@"pet_id"    : self.tpPetBase.petInfo.petId,
                       @"pet_name"  : self.nickNameTextField.text,
                       @"age"   : self.ageMap[self.ageLabel.text],
                       @"sex"   : self.tpPetBase.petInfo.petSex,
                       @"tip"       : self.signTextField.text,
                       @"f_hybridization"   : self.tpPetBase.petInfo.fHybridization,
                       @"f_adopt"   : self.tpPetBase.petInfo.fAdopt,
                       @"is_entrust": self.tpPetBase.petInfo.isEntrust,
                       @"pet_code"  : petCode};
    }
    [[LCYNetworking sharedInstance] postRequestWithAPI:Pet_updatePetInfo parameters:parameters successBlock:^(NSDictionary *object) {
        if ([object[@"result"] boolValue]) {
            NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
            [defaultCenter postNotificationName:@"MoePetReload" object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:@"" message:object[@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    } failedBlock:^{
        UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"修改失败，请检查您的网络状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }];
}

- (void)reloadPetData{
    NSDictionary *parameters = @{@"pet_id"  : self.userPetInfo.petId};
    [[LCYNetworking sharedInstance] postRequestWithAPI:Pet_GetPetDetailByID parameters:parameters successBlock:^(NSDictionary *object) {
        [[LCYCommon sharedInstance] hideTipsInView:self.view];
        self.petDetailBase = [GetPetDetailBase modelObjectWithDictionary:object];
        // 下载成功，加载界面
        self.tpPetBase = [[GetPetDetailBase alloc] initWithDictionary:[self.petDetailBase dictionaryRepresentation]];
        [self makeScene];
    } failedBlock:^{
        [[LCYCommon sharedInstance] hideTipsInView:self.view];
    }];
}

- (void)makeScene{
    // 加载场景内容
    NSString *avatarImageURLString = [hostImageURL stringByAppendingString:self.petDetailBase.petInfo.headImage];
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatarImageURLString]];
    
    // 昵称
    self.nickNameTextField.text = self.tpPetBase.petInfo.petName;
    
    // 性别
    self.sexImageView.image = [self.tpPetBase.petInfo.petSex isEqualToString:@"0"]?[UIImage imageNamed:@"icoMale"]:[UIImage imageNamed:@"icoFemale"];
    
    // 品种
    self.categoryTextField.text = self.tpPetBase.petInfo.cateName;
    
    // 签名
    self.signTextField.text = self.tpPetBase.petInfo.sign;
    
    // 年龄
    if ([self.tpPetBase.petInfo.age integerValue] == 0) {
        self.ageLabel.text = @"小于1岁";
    } else if ([self.tpPetBase.petInfo.age integerValue] == 11) {
        self.ageLabel.text = @"大于10岁";
    } else {
        self.ageLabel.text = [NSString stringWithFormat:@"%ld岁", (long)[self.tpPetBase.petInfo.age integerValue]];
    }
    
    // 三个状态
    if ([self.tpPetBase.petInfo.fHybridization isEqualToString:@"1"]) {
        [self.breedingButton setImage:[UIImage imageNamed:@"breedingDown"] forState:UIControlStateNormal];
    }
    
    if ([self.tpPetBase.petInfo.fAdopt isEqualToString:@"1"]) {
        [self.adoptButton setImage:[UIImage imageNamed:@"adoptDown"] forState:UIControlStateNormal];
    }
    
    if ([self.tpPetBase.petInfo.isEntrust isEqualToString:@"1"]) {
        [self.entrustButton setImage:[UIImage imageNamed:@"fosterDown"] forState:UIControlStateNormal];
    }
    
    // 二维码
    if (self.tpPetBase.petInfo.petCode &&
        [self.tpPetBase.petInfo.petCode length] > 0) {
        // 二维码存在
        [self.QRButton setBackgroundImage:[UIImage imageNamed:@"QRDuostec"] forState:UIControlStateNormal];
        [self.QRSwitch setEnabled:YES];
        [self.QRSwitch setOn:YES];
    }
    
}
- (IBAction)updateAvatar:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从照片库中选择",@"用手机拍照", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (!self.imagePicker) {
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    if (buttonIndex == 0) {
        [self.imagePicker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        [self.imagePicker setAllowsEditing:YES];
    } else if (buttonIndex == 1){
        [self.imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        return;
    }
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *resizedImage = [(UIImage *)info[UIImagePickerControllerOriginalImage] imageByScalingAndCroppingForSize:CGSizeMake(300, 300)];
    NSData *data = UIImagePNGRepresentation(resizedImage);
    
    
    __weak __typeof(self) weakSelf = self;
    [[LCYCommon sharedInstance] showTips:@"上传中" inView:self.view];
    [[LCYNetworking sharedInstance] postFileWithAPI:Pet_Update_Avatar parameters:@{@"pet_id":self.tpPetBase.petInfo.petId} fileKey:@"Filedata" fileData:data fileName:@"noname.png" mimeType:@"image/png" successBlock:^(NSDictionary *object) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [[LCYCommon sharedInstance] hideTipsInView:strongSelf.view];
        if ([object[@"result"] boolValue]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"上传成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [strongSelf.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",hostImageURL,object[@"msg"][@"cut_img"]]]];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"上传失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        
    } failedBlock:^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [[LCYCommon sharedInstance] hideTipsInView:strongSelf.view];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"上传失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }];
}

- (IBAction)sexButtonPressed:(id)sender {
    if ([self.tpPetBase.petInfo.petSex isEqualToString:@"1"]) {
        self.tpPetBase.petInfo.petSex = @"0";
    } else {
        self.tpPetBase.petInfo.petSex = @"1";
    }
    self.sexImageView.image = [self.tpPetBase.petInfo.petSex isEqualToString:@"0"]?[UIImage imageNamed:@"icoMale"]:[UIImage imageNamed:@"icoFemale"];
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

- (IBAction)ageDoneButtonPressed:(id)sender {
    NSInteger row = [self.agePicker selectedRowInComponent:0];
    self.ageLabel.text = self.ageKeys[row];
    [self.zombieTextField resignFirstResponder];
}

- (IBAction)breedingButtonPressed:(id)sender {
    if ([self.tpPetBase.petInfo.fHybridization isEqualToString:@"1"]) {
        self.tpPetBase.petInfo.fHybridization = @"0";
    } else {
        self.tpPetBase.petInfo.fHybridization = @"1";
    }
    if ([self.tpPetBase.petInfo.fHybridization isEqualToString:@"1"]) {
        [self.breedingButton setImage:[UIImage imageNamed:@"breedingDown"] forState:UIControlStateNormal];
    } else {
        [self.breedingButton setImage:[UIImage imageNamed:@"breedingButton"] forState:UIControlStateNormal];
    }
}

- (IBAction)adoptButtonPressed:(id)sender {
    if ([self.tpPetBase.petInfo.fAdopt isEqualToString:@"1"]) {
        self.tpPetBase.petInfo.fAdopt = @"0";
    } else {
        self.tpPetBase.petInfo.fAdopt = @"1";
    }
    if ([self.tpPetBase.petInfo.fAdopt isEqualToString:@"1"]) {
        [self.adoptButton setImage:[UIImage imageNamed:@"adoptDown"] forState:UIControlStateNormal];
    } else {
        [self.adoptButton setImage:[UIImage imageNamed:@"adoptButton"] forState:UIControlStateNormal];
    }
}

- (IBAction)entrustButtonPressed:(id)sender {
    if ([self.tpPetBase.petInfo.isEntrust isEqualToString:@"1"]) {
        self.tpPetBase.petInfo.isEntrust = @"0";
    } else {
        self.tpPetBase.petInfo.isEntrust = @"1";
    }
    if ([self.tpPetBase.petInfo.isEntrust isEqualToString:@"1"]) {
        [self.entrustButton setImage:[UIImage imageNamed:@"fosterDown"] forState:UIControlStateNormal];
    } else {
        [self.entrustButton setImage:[UIImage imageNamed:@"fosterButton"] forState:UIControlStateNormal];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self.nickNameTextField resignFirstResponder];
    [self.signTextField resignFirstResponder];
}

- (IBAction)backgroundTouchDown:(id)sender {
    [self.signTextField resignFirstResponder];
    [self.categoryTextField resignFirstResponder];
    [self.nickNameTextField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.categoryTextField) {
        [textField resignFirstResponder];
        [self.signTextField resignFirstResponder];
        [self.nickNameTextField resignFirstResponder];
        [self performSegueWithIdentifier:@"pushFilter" sender:nil];
    } else if (textField == self.signTextField) {
        CGRect frame = self.view.frame;
        frame.origin.y -= 100;
        [UIView animateWithDuration:0.35 animations:^{
            [self.view setFrame:frame];
        }];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.categoryTextField) {
        if ([self.nickNameTextField isFirstResponder]) {
            return NO;
        } else if ([self.signTextField isFirstResponder]) {
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
    self.category = category;
    self.categoryTextField.text = category.name;
}

#pragma mark - QRScan
- (void)QRScanViewController:(QRScanViewController *)QRScanVC didFinishScanned:(NSString *)info{
    self.tpPetBase.petInfo.petCode = info;
    [self.QRSwitch setEnabled:YES];
    [self.QRButton setBackgroundImage:[UIImage imageNamed:@"QRDuostec"] forState:UIControlStateNormal];
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

@end
