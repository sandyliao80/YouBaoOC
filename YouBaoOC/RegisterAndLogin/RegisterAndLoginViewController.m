//
//  RegisterAndLoginViewController.m
//  YouBaoOC
//
//  Created by Licy on 14-7-24.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "RegisterAndLoginViewController.h"
#import "LCYCommon.h"
#import "AppDelegate.h"
#import "MainViewController.h"

typedef NS_ENUM(NSUInteger, RegisterAndLoginStatus) {
    RegisterAndLoginStatusRegister,
    RegisterAndLoginStatusLogin
};

@interface RegisterAndLoginViewController ()

@property (nonatomic) RegisterAndLoginStatus currentStatus;

@property (nonatomic) CGRect doneButtonFrame;

#pragma mark - 发送验证码
@property (weak, nonatomic) IBOutlet UIButton *sendAuthButton;
@property (strong, nonatomic) IBOutlet UIView *sendAuthView;

#pragma mark - 注册
@property (weak, nonatomic) IBOutlet UIButton *regDoneButton;
@property (weak, nonatomic) IBOutlet UIButton *passwordForgetButton;

#pragma mark - 各种textField

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UITextField *authTextField;

@property (nonatomic) NSInteger timeLeft;

@property (nonatomic) NSInteger authCode;

@property (strong, nonatomic) NSTimer *authTimer;


#pragma mark - Constraints

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *doneButtonY;


@end

@implementation RegisterAndLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentStatus = RegisterAndLoginStatusRegister;
    self.timeLeft = 60;
    self.authCode = 0;
    // 导航栏
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"手机号注册", @"手机号登录"]];
    [segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.tintColor = THEME_COLOR;
    [segmentedControl setSelectedSegmentIndex:0];
    [self.navigationItem setTitleView:segmentedControl];
    
    // 按钮圆角
    self.sendAuthButton.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    self.regDoneButton.layer.cornerRadius = BUTTON_CORNER_RADIUS;

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"navigationBack"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(navigationBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;
    
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

- (void)navigationBack:(UIButton *)sender{
    [self.authTimer invalidate];
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)segmentedControlValueChanged:(UISegmentedControl *)sender{
    if (sender.selectedSegmentIndex == 0) {
        self.currentStatus = RegisterAndLoginStatusRegister;
        [UIView animateWithDuration:0.35 animations:^{
            self.regDoneButton.frame = self.doneButtonFrame;
            self.doneButtonY.constant += 45.0f;
            [self.regDoneButton setTitle:@"注册" forState:UIControlStateNormal];
            [self.regDoneButton setTitle:@"注册" forState:UIControlStateHighlighted];
            [self.passwordForgetButton setHidden:YES];
        } completion:^(BOOL finished) {
            [self.sendAuthView setHidden:NO];
        }];
    } else {
        self.doneButtonFrame = self.regDoneButton.frame;
        self.currentStatus = RegisterAndLoginStatusLogin;
        [UIView animateWithDuration:0.35 animations:^{
            [self.sendAuthView setHidden:YES];
            CGRect frame = self.doneButtonFrame;
//            NSLog(@"current frame = %@", NSStringFromCGRect(frame));
            frame.origin.y -= 45.0f;
            self.regDoneButton.frame = frame;
            
            self.doneButtonY.constant -= 45.0f;
            
            [self.regDoneButton setTitle:@"登录" forState:UIControlStateNormal];
            [self.regDoneButton setTitle:@"登录" forState:UIControlStateHighlighted];
        } completion:^(BOOL finished) {
            [self.passwordForgetButton setHidden:NO];
        }];
    }
}

- (IBAction)backgroundTouchDown:(UIControl *)sender {
    [self.phoneTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.authTextField resignFirstResponder];
}

- (IBAction)authButtonPressed:(UIButton *)sender {
    if ([self.phoneTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    } else if (self.phoneTextField.text.length != 11) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入正确的手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    } else {
        // 发送验证码
        // 禁用按钮，设置一分钟后发送
        [self.sendAuthButton setEnabled:NO];
        [self.sendAuthButton setBackgroundColor:[UIColor lightGrayColor]];
        self.authTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
        [self.authTimer fire];
        // 请求验证码
        NSDictionary *parameters = @{@"user_name" : self.phoneTextField.text};
        [[LCYNetworking sharedInstance] postRequestWithAPI:User_authcode parameters:parameters successBlock:^(NSDictionary *object) {
            if (![object[@"result"] boolValue]) {
                // 验证码发送失败
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:object[@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                // 发送失败
                self.timeLeft = 60;
                [self.sendAuthButton setTitle:@"发送验证码" forState:UIControlStateNormal];
                [self.sendAuthButton setTitle:@"发送验证码" forState:UIControlStateHighlighted];
                [self.authTimer invalidate];
                [self.sendAuthButton setEnabled:YES];
                [self.sendAuthButton setBackgroundColor:THEME_PINK];
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
            [self.sendAuthButton setTitle:@"发送验证码" forState:UIControlStateNormal];
            [self.sendAuthButton setTitle:@"发送验证码" forState:UIControlStateHighlighted];
            [self.authTimer invalidate];
            [self.sendAuthButton setEnabled:YES];
            [self.sendAuthButton setBackgroundColor:THEME_PINK];
            [self.authTimer invalidate];
        }];
    }
}

- (IBAction)doneButtonPressed:(UIButton *)sender {
    if (self.currentStatus == RegisterAndLoginStatusRegister) {
        // 注册
        if ([self.phoneTextField.text isEqualToString:@""]) {
            // 无手机号
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        } else if (self.phoneTextField.text.length != 11) {
            // 手机号格式不正确
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入正确的手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        } else if ([self.passwordTextField.text isEqualToString:@""]) {
            // 没填密码
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入6-18位的密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        } else if (self.passwordTextField.text.length < 6 || self.passwordTextField.text.length > 16) {
            // 密码格式不正确
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入6-18位的密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        } else if ([self.authTextField.text isEqualToString:@""]) {
            // 没填验证码
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        } else if (self.authTextField.text.length != 4) {
            // 验证码格式错误
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入四位验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        } else{
            if (self.authCode == [self.authTextField.text integerValue]) {
                // 正确输入
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:self.phoneTextField.text forKey:UserDefaultUserName];
                [LCYGlobal sharedInstance].currentUserID = self.phoneTextField.text;
                [[LCYCommon sharedInstance] savePassword:self.passwordTextField.text];
                
                [self performSegueWithIdentifier:@"ShowDetail" sender:nil];
            } else {
                // 验证码不正确
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"验证码不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
        }
    } else {
        // 登录
        if ([self.phoneTextField.text isEqualToString:@""]) {
            // 无手机号
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        } else if (self.phoneTextField.text.length != 11) {
            // 手机号格式不正确
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入正确的手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        } else if ([self.passwordTextField.text isEqualToString:@""]) {
            // 没填密码
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入6-18位的密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        } else if (self.passwordTextField.text.length < 6 || self.passwordTextField.text.length > 16) {
            // 密码格式不正确
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入6-18位的密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        } else {
            [[LCYCommon sharedInstance] showTips:@"登录中" inView:self.view];
            [self.regDoneButton setEnabled:NO];
            // 发送登录请求，如果登录成功则跳转到主页
            NSDictionary *parameters = @{@"user_name"   : self.phoneTextField.text,
                                         @"password"    : self.passwordTextField.text};
            [[LCYNetworking sharedInstance] postRequestWithAPI:User_login parameters:parameters successBlock:^(NSDictionary *object) {
                [[LCYCommon sharedInstance] hideTipsInView:self.view];
                [self.regDoneButton setEnabled:YES];
                // 验证是否登录成功
                if ([object[@"result"] boolValue]) {
                    // 登录成功，写入持久化数据
                    [[LCYCommon sharedInstance] login:parameters[@"user_name"]];
                    // 登录成功，跳转到主页
                    UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    MainViewController *tabbarVC = mainBoard.instantiateInitialViewController;
                    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
                    delegate.window.rootViewController = tabbarVC;
                } else {
                    // 验证失败
                    NSString *message = object[@"msg"];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                }
            } failedBlock:^{
                [[LCYCommon sharedInstance] hideTipsInView:self.view];
                [self.regDoneButton setEnabled:YES];
                // 请求发送失败
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"登录失败，请检查网络状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }];
        }
    }
}

- (void)timerFired:(NSTimer *)timer{
    if (self.timeLeft <= 0) {
        self.timeLeft = 60;
        [self.sendAuthButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        [self.sendAuthButton setTitle:@"发送验证码" forState:UIControlStateHighlighted];
        [timer invalidate];
        [self.sendAuthButton setEnabled:YES];
        [self.sendAuthButton setBackgroundColor:THEME_PINK];
        return;
    }
    self.sendAuthButton.titleLabel.text = [NSString stringWithFormat:@"(%ld)秒重发",(long)self.timeLeft];
    self.timeLeft--;
}

@end
