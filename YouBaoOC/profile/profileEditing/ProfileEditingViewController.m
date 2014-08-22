//
//  ProfileEditingViewController.m
//  YouBaoOC
//
//  Created by eagle on 14/8/19.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "ProfileEditingViewController.h"
#import "ProfileEditingHeadCell.h"
#import "ProfileEditingNameCell.h"
#import "ProfileEditingSignCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LCYCommon.h"
#import "ModifyTextViewController.h"
#import "Region.h"
#import "AppDelegate.h"
#import "UIImage+LCYResize.h"
#import "ModifyLocationViewController.h"


@interface ProfileEditingViewController ()<UITableViewDelegate, UITableViewDataSource, ModifyTextDelegate, ProfileEditingSignCellDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *icyTableView;

//@property (strong, nonatomic) NSString *titleForPassing;

@property (strong, nonatomic) NSIndexPath *indexPathForPassing;

@property (weak, nonatomic) NSManagedObjectContext *context;

@property (strong, nonatomic) UIImagePickerController *picker;

@end

@implementation ProfileEditingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.context = appDelegate.managedObjectContext;
    
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
    if ([segue.identifier isEqualToString:@"showModify"]) {
        ModifyTextViewController *modifyVC = [segue destinationViewController];
        modifyVC.modifyTitle = [self getTitleAt:self.indexPathForPassing];
        modifyVC.defaultText = [self getTextAt:self.indexPathForPassing];
        modifyVC.delegate = self;
    }
}


#pragma mark - Actions
- (void)navigationBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doneButtonPressed:(id)sender{
    [[LCYCommon sharedInstance] showTips:@"正在上传信息" inView:self.view];
    NSDictionary *parameters = @{@"user_name"       : self.userInfoBase.userInfo.userName!=nil?self.userInfoBase.userInfo.userName:@"",
                                 @"nick_name"       : self.userInfoBase.userInfo.nickName!=nil?self.userInfoBase.userInfo.nickName:@"",
                                 @"sex"             : self.userInfoBase.userInfo.sex!=nil?self.userInfoBase.userInfo.sex:@"",
                                 @"town"            : self.userInfoBase.userInfo.town!=nil?self.userInfoBase.userInfo.town:@"",
                                 @"city"            : self.userInfoBase.userInfo.city!=nil?self.userInfoBase.userInfo.city:@"",
                                 @"province"        : self.userInfoBase.userInfo.province!=nil?self.userInfoBase.userInfo.province:@"",
                                 @"email"           : self.userInfoBase.userInfo.email!=nil?self.userInfoBase.userInfo.email:@"",
                                 @"address"         : self.userInfoBase.userInfo.address!=nil?self.userInfoBase.userInfo.address:@"",
                                 @"tip"             : self.userInfoBase.userInfo.tip!=nil?self.userInfoBase.userInfo.tip:@"",
                                 @"qq"              : self.userInfoBase.userInfo.qq!=nil?self.userInfoBase.userInfo.qq:@"",
                                 @"telephone"       : self.userInfoBase.userInfo.telephone!=nil?self.userInfoBase.userInfo.telephone:@"",
                                 @"wechat"          : self.userInfoBase.userInfo.wechat!=nil?self.userInfoBase.userInfo.wechat:@"",
                                 @"weibo"           : self.userInfoBase.userInfo.weibo!=nil?self.userInfoBase.userInfo.weibo:@"",
                                 @"f_qq"            : self.userInfoBase.userInfo.fQq!=nil?self.userInfoBase.userInfo.fQq:@"0",
                                 @"f_telephone"     : self.userInfoBase.userInfo.fTelephone!=nil?self.userInfoBase.userInfo.fTelephone:@"0",
                                 @"f_wechat"        : self.userInfoBase.userInfo.fWechat!=nil?self.userInfoBase.userInfo.fWechat:@"0",
                                 @"f_weibo"         : self.userInfoBase.userInfo.fWeibo!=nil?self.userInfoBase.userInfo.fWeibo:@"0",
                                 @"f_cellphone"     : self.userInfoBase.userInfo.fCellphone!=nil?self.userInfoBase.userInfo.fCellphone:@"0",
                                 @"f_address"       : self.userInfoBase.userInfo.fAddress!=nil?self.userInfoBase.userInfo.fAddress:@"0",
                                 @"f_location"      : self.userInfoBase.userInfo.fLocation!=nil?self.userInfoBase.userInfo.fLocation:@"0",
                                 @"f_tip"           : self.userInfoBase.userInfo.fTip!=nil?self.userInfoBase.userInfo.fTip:@"0"};
    [[LCYNetworking sharedInstance] postRequestWithAPI:User_modifyInfo parameters:parameters successBlock:^(NSDictionary *object) {
        if ([object[@"result"] boolValue]) {
            // 上传成功
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"上传信息失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        [[LCYCommon sharedInstance] hideTipsInView:self.view];
    } failedBlock:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"上传信息失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self.icyTableView reloadData];
}

- (IBAction)imageTapped:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从照片中选择", @"拍照", nil];
    [actionSheet showInView:self.view];
}

- (NSString *)getTitleAt:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                return @"姓名";
                break;
            case 1:
                return @"性别";
                break;
                
            default:
                return @"";
                break;
        }
    } else if (indexPath.section == 2) {
        return @"签名";
    } else if (indexPath.section == 3) {
        switch (indexPath.row) {
            case 0:
                return @"QQ";
                break;
            case 1:
                return @"微信";
                break;
            case 2:
                return @"新浪微博";
                break;
            case 3:
                return @"固定电话";
                break;
            case 4:
                return @"详细地址";
                break;
                
            default:
                return @"";
                break;
        }
    } else {
        return @"";
    }
}

- (NSString *)getImageNameAt:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                return @"profileSign";
                break;
            case 1:
                return @"profileGender";
                break;
            case 2:
                return @"profilePhone";
                break;
            case 3:
                return @"profileLoc";
                break;
                
            default:
                return @"";
                break;
        }
    }
    return @"";
}

- (NSString *)getTextAt:(NSIndexPath *)indexPath{
    
    // TODO: 返回该行显示的内容
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                return self.userInfoBase.userInfo.nickName;
                break;
            case 1:
                return [self.userInfoBase.userInfo.sex isEqualToString:@"0"]?@"男":@"女";
                break;
            case 2:
                return self.userInfoBase.userInfo.userName;
                break;
            case 3:
            {
                NSMutableString *regionString = [NSMutableString string];
                NSString *province = [self getRegionStringByID:self.userInfoBase.userInfo.province];
                if (province.length != 0) {
                    [regionString appendString:province];
                }
                NSString *city = [self getRegionStringByID:self.userInfoBase.userInfo.city];
                if (city.length != 0) {
                    [regionString appendFormat:@" %@",city];
                }
                NSString *town = [self getRegionStringByID:self.userInfoBase.userInfo.town];
                if (town.length != 0) {
                    [regionString appendFormat:@" %@",town];
                }
                return [NSString stringWithString:regionString];
                break;
            }
            default:
                return @"";
                break;
        }
    } else if (indexPath.section == 2) {
        return self.userInfoBase.userInfo.tip;
    } else if (indexPath.section == 3) {
        switch (indexPath.row) {
            case 0:
                return self.userInfoBase.userInfo.qq;
                break;
            case 1:
                return self.userInfoBase.userInfo.wechat;
                break;
            case 2:
                return self.userInfoBase.userInfo.weibo;
                break;
            case 3:
                return self.userInfoBase.userInfo.telephone;
                break;
            case 4:
                return self.userInfoBase.userInfo.address;
                break;
                
            default:
                return @"";
                break;
        }
    } else {
        return @"";
    }
}

- (NSString *)getRegionStringByID:(NSString *)regionID{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Region" inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"region_id = %@", regionID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    if (!fetchedObjects) {
        return @"";
    } else {
        Region *region = [fetchedObjects firstObject];
        return region.region_name;
    }
}

- (BOOL)getSwitchStatusAt:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        return [self.userInfoBase.userInfo.fTip isEqualToString:@"1"]?YES:NO;
    } else if (indexPath.section == 3) {
        switch (indexPath.row) {
            case 0:
                return [self.userInfoBase.userInfo.fQq isEqualToString:@"1"]?YES:NO;
                break;
            case 1:
                return [self.userInfoBase.userInfo.fWechat isEqualToString:@"1"]?YES:NO;
                break;
            case 2:
                return [self.userInfoBase.userInfo.fWeibo isEqualToString:@"1"]?YES:NO;
                break;
            case 3:
                return [self.userInfoBase.userInfo.fTelephone isEqualToString:@"1"]?YES:NO;
                break;
            case 4:
                return [self.userInfoBase.userInfo.fAddress isEqualToString:@"1"]?YES:NO;
                break;
                
            default:
                return YES;
                break;
        }
    }
    return YES;
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:         /**< 头像 */
            return 1;
            break;
        case 1:         /**< 姓名、性别、电话、住址 */
            return 4;
            break;
        case 2:         /**< 签名 */
            return 1;
            break;
        case 3:         /**< QQ、微信、微博、固定电话、详细地址 */
            return 5;
            break;
            
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 80.0f;
    } else if(indexPath.section == 1){
        return 44.0f;
    } else {
        return 52.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return CGFLOAT_MIN;
    } else {
        return 10.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ProfileEditingHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileEditingHeadCellIdentifier];
        NSString *URLString = [hostImageURL stringByAppendingString:self.userInfoBase.userInfo.headImage];
        [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:URLString] placeholderImage:[UIImage imageNamed:@"avatarDefault"]];
        return cell;
    } else if(indexPath.section == 1) {
        ProfileEditingNameCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileEditingNameCellIdentifier];
        cell.icyImage.image = [UIImage imageNamed:[self getImageNameAt:indexPath]];
        cell.icyLabel.text = [self getTextAt:indexPath];
        [cell.icyLabel setTextColor:[UIColor darkGrayColor]];
        if (cell.icyLabel.text.length == 0) {
            [cell.icyLabel setTextColor:[UIColor lightGrayColor]];
            cell.icyLabel.text = @"未填写";
        }
        return cell;
    } else {
        ProfileEditingSignCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileEditingSignCellIdentifier];
        cell.icyLabel.text = [self getTitleAt:indexPath];
        cell.icyDetailLabel.text = [self getTextAt:indexPath];
        cell.indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        cell.delegate = self;
        [cell.icyDetailLabel setTextColor:[UIColor darkGrayColor]];
        if (cell.icyDetailLabel.text.length == 0) {
            [cell.icyDetailLabel setTextColor:[UIColor lightGrayColor]];
            cell.icyDetailLabel.text = @"未填写";
        }
        [cell.icySwitch setOn:[self getSwitchStatusAt:indexPath]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(tintColor)]) {
        if (tableView == self.icyTableView) {
            if (indexPath.section != 0) {
                CGFloat cornerRadius = 5.f;
                cell.backgroundColor = UIColor.clearColor;
                CAShapeLayer *layer = [[CAShapeLayer alloc] init];
                CGMutablePathRef pathRef = CGPathCreateMutable();
                CGRect bounds = CGRectInset(cell.bounds, 10, 0);
                BOOL addLine = NO;
                if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                    CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
                } else if (indexPath.row == 0) {
                    CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                    CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
                    addLine = YES;
                } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                    CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                    CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
                } else {
                    CGPathAddRect(pathRef, nil, bounds);
                    addLine = YES;
                }
                layer.path = pathRef;
                CFRelease(pathRef);
                layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
                
                if (addLine == YES) {
                    CALayer *lineLayer = [[CALayer alloc] init];
                    CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
                    lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+0, bounds.size.height-lineHeight, bounds.size.width-0, lineHeight);
                    lineLayer.backgroundColor = tableView.separatorColor.CGColor;
                    [layer addSublayer:lineLayer];
                }
                UIView *testView = [[UIView alloc] initWithFrame:bounds];
                [testView.layer insertSublayer:layer atIndex:0];
                testView.backgroundColor = UIColor.clearColor;
                cell.backgroundView = testView;
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return;
    }
    if (indexPath.section == 1 &&
        indexPath.row == 2) {
        // 手机号
        return;
    }
    if (indexPath.section == 1 &&
        indexPath.row == 3) {
        // 所在城市
        UIStoryboard *locationSB = [UIStoryboard storyboardWithName:@"ModifyLocation" bundle:nil];
        ModifyLocationViewController *modifyLocationVC = [locationSB instantiateInitialViewController];
        [self.navigationController pushViewController:modifyLocationVC animated:YES];
        return;
    }
    if (indexPath.section == 1 &&
        indexPath.row == 1) {
        // 性别
        return;
    }
//    self.titleForPassing = [self getTitleAt:indexPath];
    self.indexPathForPassing = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    [self performSegueWithIdentifier:@"showModify" sender:nil];
    
}

#pragma mark - ModifyText
- (void)didModifyText:(NSString *)textTitle textInfo:(NSString *)info{
    NSLog(@"modify %@ to %@",textTitle, info);
    if ([textTitle isEqualToString:@"姓名"]) {
        self.userInfoBase.userInfo.nickName = info;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        [self.icyTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    } else if ([textTitle isEqualToString:@"签名"]) {
        self.userInfoBase.userInfo.tip = info;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
        [self.icyTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }else if ([textTitle isEqualToString:@"QQ"]) {
        self.userInfoBase.userInfo.qq = info;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:3];
        [self.icyTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }else if ([textTitle isEqualToString:@"微信"]) {
        self.userInfoBase.userInfo.wechat = info;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:3];
        [self.icyTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }else if ([textTitle isEqualToString:@"新浪微博"]) {
        self.userInfoBase.userInfo.weibo = info;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:3];
        [self.icyTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }else if ([textTitle isEqualToString:@"固定电话"]) {
        self.userInfoBase.userInfo.telephone = info;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:3];
        [self.icyTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }else if ([textTitle isEqualToString:@"详细地址"]) {
        self.userInfoBase.userInfo.address = info;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:3];
        [self.icyTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - SignCellDelegate
- (void)profileEditingSignCell:(ProfileEditingSignCell *)cell didChangeSwichStateAt:(NSIndexPath *)indexPath toState:(BOOL)state{
    NSLog(@"changed %@ to %@",indexPath, state?@"1":@"0");
    if (indexPath.section == 2) {
        self.userInfoBase.userInfo.fTip = state?@"1":@"0";
        [self.icyTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    } else if (indexPath.section == 3) {
        switch (indexPath.row) {
            case 0:
                self.userInfoBase.userInfo.fQq = state?@"1":@"0";
                [self.icyTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                break;
            case 1:
                self.userInfoBase.userInfo.fWechat = state?@"1":@"0";
                [self.icyTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                break;
            case 2:
                self.userInfoBase.userInfo.fWeibo = state?@"1":@"0";
                [self.icyTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                break;
            case 3:
                self.userInfoBase.userInfo.fTelephone = state?@"1":@"0";
                [self.icyTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                break;
            case 4:
                self.userInfoBase.userInfo.fAddress = state?@"1":@"0";
                [self.icyTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                break;
                
            default:
                break;
        }
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
    UIImage *scaledImage = [originalImage imageByScalingAndCroppingForSize:CGSizeMake(200, 200)];
    
    [[LCYCommon sharedInstance] showTips:@"正在上传头像" inView:self.view];
    NSDictionary *parameters = @{@"user_name"   : self.userInfoBase.userInfo.userName};
    [[LCYNetworking sharedInstance] postFileWithAPI:User_modifyImage parameters:parameters fileKey:@"filedata" fileData:UIImagePNGRepresentation(scaledImage) fileName:@"icylydia.png" mimeType:@"image/png" successBlock:^(NSDictionary *object) {
        if ([object[@"result"] boolValue]) {
            self.userInfoBase.userInfo.headImage = object[@"head_image"];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.icyTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"上传头像失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        [[LCYCommon sharedInstance] hideTipsInView:self.view];
    } failedBlock:^{
        [[LCYCommon sharedInstance] hideTipsInView:self.view];
    }];
}


@end
