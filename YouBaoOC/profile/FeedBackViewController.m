//
//  FeedBackViewController.m
//  YouBaoOC
//
//  Created by eagle on 14/9/28.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "FeedBackViewController.h"

NSString *const FeedBackViewControllerIdentifier = @"FeedBackViewControllerIdentifier";

@interface FeedBackViewController ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *icyTextView;

@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    [doneButton addTarget:self action:@selector(saveButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = rightItem;
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

- (IBAction)backgroundTouchDown:(id)sender {
    [self.icyTextView resignFirstResponder];
}

- (void)saveButtonPressed:(id)sender{
    UIAlertView *confirmAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"感谢您提供宝贵的意见。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [confirmAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
