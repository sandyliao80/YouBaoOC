//
//  LaunchViewController.m
//  YouBaoOC
//
//  Created by eagle on 14/9/23.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LaunchViewController.h"
#import "LCYCommon.h"
#import "AppDelegate.h"
#import "GuideViewController.h"

@interface LaunchViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *icyImageView;

@property (weak, nonatomic) UIWindow *window;

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    BOOL isIPhone5OrLater = NO;
    
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat r = height / width;
    if (r > (1000.0f / 640.0f)) {
        isIPhone5OrLater = YES;
    }
    
    NSString *imageName = isIPhone5OrLater?@"Guide-568-1":@"Guide1";
    self.icyImageView.image = [UIImage imageNamed:imageName];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.window = appDelegate.window;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 判断是否需要引导页
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if (![userDefaults boolForKey:@"skipIntroduction"]) {
            // 第一次运行会跳转到引导页
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Introduction" bundle:nil];
            GuideViewController *guideVC = storyBoard.instantiateInitialViewController;
            self.window.rootViewController = guideVC;
            [userDefaults setBool:YES forKey:@"skipIntroduction"];
        }
        
        // 判断登录状态
        else if (![[LCYCommon sharedInstance] isUserLogin]) {
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"RegisterAndLogin" bundle:nil];
            UINavigationController *navigationVC = storyBoard.instantiateInitialViewController;
            self.window.rootViewController = navigationVC;
        } else {
            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            self.window.rootViewController = mainStoryBoard.instantiateInitialViewController;
        }
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
