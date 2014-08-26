//
//  MoePetProfileViewController.m
//  YouBaoOC
//
//  Created by eagle on 14/8/13.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "MoePetProfileViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LCYCommon.h"
#import "GetPetDetail.h"
#import "MoeCameraCell.h"
#import "MoePictureCell.h"
#import "UIImage+LCYResize.h"
#import "modifyMoePet/ModifyMoePetViewController.h"
#import <IDMPhotoBrowser/IDMPhotoBrowser.h>

@interface MoePetProfileViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avatarLightBG;

@property (weak, nonatomic) IBOutlet UIImageView *avatarContent;

@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;


@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *miscLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imageOne;

@property (weak, nonatomic) IBOutlet UIImageView *imageTwo;

@property (weak, nonatomic) IBOutlet UIImageView *imageThree;

@property (weak, nonatomic) IBOutlet UILabel *signLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signBGHeight;

@property (weak, nonatomic) IBOutlet UICollectionView *icyCollectionView;

@property (weak, nonatomic) IBOutlet UIButton *editingButton;

#pragma mark - Properties

@property (strong, nonatomic) GetPetDetailBase *petDetailBase;

@property (strong, nonatomic) UIImagePickerController *picker;

@end

@implementation MoePetProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setTitle:@"萌宠信息"];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"navigationBack"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(navigationBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;
    
    CGFloat avatarBGRadius = MIN(self.avatarLightBG.bounds.size.height, self.avatarLightBG.bounds.size.width) / 2.0f;
    [self.avatarLightBG.layer setCornerRadius:avatarBGRadius];
    [self.avatarLightBG.layer setMasksToBounds:YES];
    [self.avatarLightBG setBackgroundColor:THEME_LIGHT_COLOR];
    
    CGFloat avatarContentRadius = MIN(self.avatarContent.bounds.size.width, self.avatarContent.bounds.size.height) / 2.0f;
    [self.avatarContent.layer setCornerRadius:avatarContentRadius];
    [self.avatarContent.layer setMasksToBounds:YES];
    
    [self.editingButton.layer setCornerRadius:BUTTON_CORNER_RADIUS];
    [self.editingButton.layer setMasksToBounds:YES];
    [self.editingButton setBackgroundColor:THEME_LIGHT_COLOR];
    
    if (!self.petInfo) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"宠物信息获取失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    } else {
        NSURL *avatarURL = [NSURL URLWithString:[hostImageURL stringByAppendingString:self.petInfo.headImage]];
        [self.avatarContent sd_setImageWithURL:avatarURL];
        
        // 宠物性别
        self.sexImageView.image = [self.petInfo.petSex isEqualToString:@"1"]?[UIImage imageNamed:@"icoFemale"]:[UIImage imageNamed:@"icoMaleDark"];
        
        // 三个状态图标
        BOOL breeding = [self.petInfo.fHybridization isEqualToString:@"1"]?YES:NO;
        BOOL adopt = [self.petInfo.fAdopt isEqualToString:@"1"]?YES:NO;
        BOOL entrust = [self.petInfo.isEntrust isEqualToString:@"1"]?YES:NO;
        [self petTypeBreeding:breeding adopting:adopt entrust:entrust];
        
        // 昵称
        self.nickNameLabel.text = self.petInfo.petName;
        
        // 种类、年龄
        [self.miscLabel.layer setCornerRadius:5.0f];
        [self.miscLabel.layer setMasksToBounds:YES];
        [self.miscLabel setBackgroundColor:THEME_LIGHT_COLOR];
        
        NSMutableString *misc = [NSMutableString string];
        if ([self.petInfo.age integerValue] == 0) {
            [misc appendString:@"小于1岁"];
        } else if ([self.petInfo.age integerValue] == 11) {
            [misc appendString:@"大于10岁"];
        } else {
            [misc appendString:self.petInfo.age];
            [misc appendString:@"岁"];
        }
        [misc appendString:@" "];
        [misc appendString:self.petInfo.name];
        [misc appendString:@" "];
        [misc insertString:@" " atIndex:0];
        self.miscLabel.text = misc;
        
        // 下载宠物信息
        [[LCYCommon sharedInstance] showTips:@"加载宠物信息" inView:self.view];
        [self reloadPetData];
    }
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
    if ([segue.identifier isEqualToString:@"showEditing"]) {
        ModifyMoePetViewController *modifyMPVC = [segue destinationViewController];
        if (!self.petDetailBase) {
            modifyMPVC.userPetInfo = self.petInfo;
        } else {
            modifyMPVC.petDetailBase = self.petDetailBase;
        }
    }
}


#pragma mark - Actions
- (void)reloadPetData{
    NSDictionary *parameters = @{@"pet_id"  : self.petInfo.petId};
    [[LCYNetworking sharedInstance] postRequestWithAPI:Pet_GetPetDetailByID parameters:parameters successBlock:^(NSDictionary *object) {
        [[LCYCommon sharedInstance] hideTipsInView:self.view];
        self.petDetailBase = [GetPetDetailBase modelObjectWithDictionary:object];
        if (self.petDetailBase.petInfo.sign.length == 0) {
            self.signLabel.text = @"这家伙很懒，什么也没有留下";
        } else {
            self.signLabel.text = self.petDetailBase.petInfo.sign;
        }
        [self.icyCollectionView reloadData];
    } failedBlock:^{
        [[LCYCommon sharedInstance] hideTipsInView:self.view];
    }];
}

- (void)petTypeBreeding:(BOOL)breeding adopting:(BOOL)adopting entrust:(BOOL)entrust{
    NSInteger index = 0;
    self.imageOne.image = nil;
    self.imageTwo.image = nil;
    self.imageThree.image = nil;
    if (breeding) {
        self.imageOne.image = [UIImage imageNamed:@"profileBreedingColor"];
        index++;
    }
    if (adopting) {
        if (index == 0) {
            self.imageOne.image = [UIImage imageNamed:@"profileAdoptColor"];
        } else {
            self.imageTwo.image = [UIImage imageNamed:@"profileAdoptColor"];
        }
        index++;
    }
    if (entrust) {
        if (index == 0) {
            self.imageOne.image = [UIImage imageNamed:@"profileEntrustColor"];
        } else if (index == 1) {
            self.imageTwo.image = [UIImage imageNamed:@"profileEntrustColor"];
        } else {
            self.imageThree.image = [UIImage imageNamed:@"profileEntrustColor"];
        }
        index++;
    }
}

- (void)navigationBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (!self.petDetailBase) {
        return 0;
    } else {
        return 1 + [self.petDetailBase.petImages count];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        MoeCameraCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MoeCameraCellIdentifier forIndexPath:indexPath];
        return cell;
    } else {
        NSInteger petIndex= indexPath.row - 1;
        MoePictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MoePictureCellIdentifier forIndexPath:indexPath];
        GetPetDetailPetImages *petDetailPetImage = self.petDetailBase.petImages[petIndex];
        NSString *urlString = [hostImageURL stringByAppendingString:petDetailPetImage.imagePath];
        [cell.icyImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"profilePetPlaceHolder"]];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从照片中选择", @"拍照", nil];
        [actionSheet showInView:self.view];
    } else {
        NSInteger petIndex= indexPath.row - 1;
        GetPetDetailPetImages *petDetailPetImage = self.petDetailBase.petImages[petIndex];
        NSString *urlString = [hostImageURL stringByAppendingString:petDetailPetImage.imagePath];
        NSArray *photosURL = @[[NSURL URLWithString:urlString]];
        
        NSArray *photos = [IDMPhoto photosWithURLs:photosURL];
        
        IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos];
        
        [self presentViewController:browser animated:YES completion:nil];
    }
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
    
//    CGSize originalSize = originalImage.size;
    
    [[LCYCommon sharedInstance] showTips:@"正在上传图片" inView:self.view];
    NSDictionary *parameters = @{@"pet_id"      : self.petInfo.petId};
    [[LCYNetworking sharedInstance] postFileWithAPI:Pet_UploadPetImage parameters:parameters fileKey:@"Filedata" fileData:UIImagePNGRepresentation(originalImage) fileName:@"icylydiaPet.png" mimeType:@"image/png" successBlock:^(NSDictionary *object) {
        [[LCYCommon sharedInstance] hideTipsInView:self.view];
        if ([[object objectForKey:@"result"] boolValue]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"上传成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            [self reloadPetData];
        } else {
            NSString *message = object[@"msg"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
    } failedBlock:^{
        [[LCYCommon sharedInstance] hideTipsInView:self.view];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"上传失败，请检查网络状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }];
}

@end
