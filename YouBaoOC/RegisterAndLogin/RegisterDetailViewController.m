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

@interface RegisterDetailViewController ()<UIActionSheetDelegate, UIImagePickerControllerDelegate ,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *icyImageView;

@property (strong, nonatomic) UIImagePickerController *picker;

@end

@implementation RegisterDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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

@end
