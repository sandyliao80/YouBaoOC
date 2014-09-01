//
//  ModifyGenderViewController.m
//  YouBaoOC
//
//  Created by eagle on 14/9/1.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "ModifyGenderViewController.h"
#import "LCYCommon.h"

@interface ModifyGenderViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *genderTextField;

@property (strong, nonatomic) IBOutlet UIPickerView *icyPickerView;

@property (strong, nonatomic) IBOutlet UIToolbar *icyToolBar;

@property (nonatomic) NSInteger gender;

@property (nonatomic) BOOL isOK;

@end

@implementation ModifyGenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isOK = NO;
    self.gender = -1;
    
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
    
    [self.genderTextField setInputView:self.icyPickerView];
    [self.genderTextField setInputAccessoryView:self.icyToolBar];
    [self.genderTextField becomeFirstResponder];
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
- (void)doneButtonPressed:(id)sender{
    if (self.isOK) {
        NSDictionary *parameters = @{@"user_name"   : [LCYGlobal sharedInstance].currentUserID,
                                     @"key"         : @"sex",
                                     @"value"       : [NSNumber numberWithInteger:self.gender]};
        [[LCYCommon sharedInstance] showTips:@"正在上传修改" inView:self.view];
        [[LCYNetworking sharedInstance] postRequestWithAPI:User_modifySingleProperty parameters:parameters successBlock:^(NSDictionary *object) {
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请选择性别" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
}
- (IBAction)toolDone:(id)sender {
    self.gender = [self.icyPickerView selectedRowInComponent:0];
    if (self.gender == 0) {
        self.genderTextField.text = @"男";
    } else {
        self.genderTextField.text = @"女";
    }
    [self.genderTextField resignFirstResponder];
    self.isOK = YES;
}


#pragma mark - UIPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (row == 0) {
        return @"男";
    } else {
        return @"女";
    }
}

@end
