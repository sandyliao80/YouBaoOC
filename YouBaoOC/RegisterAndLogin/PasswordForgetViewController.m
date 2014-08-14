//
//  PasswordForgetViewController.m
//  YouBaoOC
//
//  Created by eagle on 14/8/14.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "PasswordForgetViewController.h"
#import "LCYCommon.h"

@interface PasswordForgetViewController ()

#pragma mark - IBOutlets

@property (weak, nonatomic) IBOutlet UIButton *sendAutoButton;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;

@property (weak, nonatomic) IBOutlet UITextField *authNumberTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

#pragma mark - Properties

@property (strong, nonatomic) NSTimer *authTimer;

@property (nonatomic) NSInteger timeLeft;

@property (nonatomic) NSInteger authCode;

@end

@implementation PasswordForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.timeLeft = 60;
    self.authCode = -1;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"navigationBack"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(navigationBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;
    
    // 按钮圆角
    [self.sendAutoButton.layer setCornerRadius:BUTTON_CORNER_RADIUS];
    [self.saveButton.layer setCornerRadius:BUTTON_CORNER_RADIUS];
    
    [self.navigationItem setTitle:@"找回密码"];
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

- (IBAction)backgroundTapped:(id)sender {
    [self.phoneNumberTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.authNumberTextField resignFirstResponder];
}

- (void)timerFired:(NSTimer *)sender{
    if (self.timeLeft <= 0) {
        self.timeLeft = 60;
        [self.sendAutoButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        [self.sendAutoButton setTitle:@"发送验证码" forState:UIControlStateHighlighted];
        [sender invalidate];
        [self.sendAutoButton setEnabled:YES];
        [self.sendAutoButton setBackgroundColor:THEME_PINK];
        return;
    }
    self.sendAutoButton.titleLabel.text = [NSString stringWithFormat:@"(%ld)秒重发",(long)self.timeLeft];
    self.timeLeft--;
}

- (IBAction)authButtonPressed:(UIButton *)sender {
    if ([self.phoneNumberTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    } else if (self.phoneNumberTextField.text.length != 11) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入正确的手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    } else {
        // 发送验证码
        // 禁用按钮，设置一分钟后发送
        [self.sendAutoButton setEnabled:NO];
        [self.sendAutoButton setBackgroundColor:[UIColor lightGrayColor]];
        self.authTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
        [self.authTimer fire];
        // 请求验证码
        NSDictionary *parameters = @{@"user_name" : self.phoneNumberTextField.text};
        [[LCYNetworking sharedInstance] postRequestWithAPI:User_authcode parameters:parameters successBlock:^(NSDictionary *object) {
            if (![object[@"result"] boolValue]) {
                // 验证码发送失败
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:object[@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                // 发送失败
                self.timeLeft = 60;
                [self.sendAutoButton setTitle:@"发送验证码" forState:UIControlStateNormal];
                [self.sendAutoButton setTitle:@"发送验证码" forState:UIControlStateHighlighted];
                [self.authTimer invalidate];
                [self.sendAutoButton setEnabled:YES];
                [self.sendAutoButton setBackgroundColor:THEME_PINK];
                [self.authTimer invalidate];
            } else {
                // 发送成功，记录验证码
                self.authCode = [object[@"code"] integerValue];
            }
        } failedBlock:^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"验证码发送失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            // 发送失败
            self.timeLeft = 60;
            [self.sendAutoButton setTitle:@"发送验证码" forState:UIControlStateNormal];
            [self.sendAutoButton setTitle:@"发送验证码" forState:UIControlStateHighlighted];
            [self.authTimer invalidate];
            [self.sendAutoButton setEnabled:YES];
            [self.sendAutoButton setBackgroundColor:THEME_PINK];
            [self.authTimer invalidate];
        }];
    }
}


@end
