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


@interface ProfileEditingViewController ()<UITableViewDelegate, UITableViewDataSource, ModifyTextDelegate, ProfileEditingSignCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *icyTableView;

//@property (strong, nonatomic) NSString *titleForPassing;

@property (strong, nonatomic) NSIndexPath *indexPathForPassing;

@end

@implementation ProfileEditingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
        modifyVC.defaultText = @"你好";
    }
}


#pragma mark - Actions
- (void)navigationBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doneButtonPressed:(id)sender{
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self.icyTableView reloadData];
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
            case 3:
                return @"常用地址";
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
                return @"性别";
                break;
            case 3:
                return @"常用地址";
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

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4.0;
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
        return cell;
    } else {
        ProfileEditingSignCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileEditingSignCellIdentifier];
        cell.icyLabel.text = [self getTitleAt:indexPath];
        cell.detailTextLabel.text = [self getTextAt:indexPath];
        cell.indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        cell.delegate = self;
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
//    self.titleForPassing = [self getTitleAt:indexPath];
    self.indexPathForPassing = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    [self performSegueWithIdentifier:@"showModify" sender:nil];
    
}

#pragma mark - ModifyText
- (void)didModifyText:(NSString *)textTitle textInfo:(NSString *)info{
    NSLog(@"modify %@ to %@",textTitle, info);
}

#pragma mark - SignCellDelegate
- (void)profileEditingSignCell:(ProfileEditingSignCell *)cell didChangeSwichStateAt:(NSIndexPath *)indexPath toState:(BOOL)state{
    NSLog(@"changed %@ to %@",indexPath, state?@"1":@"0");
}

@end
