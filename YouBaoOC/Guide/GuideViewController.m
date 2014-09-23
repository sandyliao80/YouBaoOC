//
//  GuideViewController.m
//  YouBaoOC
//
//  Created by eagle on 14/8/13.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "GuideViewController.h"
#import "AppDelegate.h"
#import "LCYCommon.h"

#define PAGECOUNT 4

@interface GuideViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *icyScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *icyPageControl;

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect frame = self.view.bounds;
    frame.size.width = frame.size.width * 4;
    UIView *contentView = [[UIView alloc] initWithFrame:frame];
    [self.icyScrollView addSubview:contentView];
    
    BOOL isIPhone5OrLater = NO;
    
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat r = height / width;
    if (r > (1000.0f / 640.0f)) {
        isIPhone5OrLater = YES;
    }
    
    for (int i = 1; i <= 4; i++) {
        CGRect imageFrame = CGRectMake(self.view.frame.size.width * (i - 1), 0, self.view.frame.size.width, self.view.frame.size.height);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
        NSString *imageName = isIPhone5OrLater?[NSString stringWithFormat:@"Guide-568-%d",i]:[NSString stringWithFormat:@"Guide%d",i];
        [imageView setImage:[UIImage imageNamed:imageName]];
        [contentView addSubview:imageView];
    }
    self.icyScrollView.contentSize = contentView.frame.size;
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat x = self.view.frame.size.width * 3.5 - 100.0;
    [doneButton setFrame:CGRectMake(x, self.view.frame.size.height - 120.0f, 200.0, 38.0f)];
    [doneButton setTitle:@"注册/登录嗨宠社区" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(startButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [doneButton setBackgroundColor:[UIColor blackColor]];
    [doneButton setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.5f]];
    [doneButton.layer setCornerRadius:3.0f];
    [contentView addSubview:doneButton];
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

- (void)startButtonPressed:(id)sender{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    // 判断登录状态
    if (![[LCYCommon sharedInstance] isUserLogin]) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"RegisterAndLogin" bundle:nil];
        UINavigationController *navigationVC = storyBoard.instantiateInitialViewController;
        appDelegate.window.rootViewController = navigationVC;
    } else {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *navigationVC = storyBoard.instantiateInitialViewController;
        appDelegate.window.rootViewController = navigationVC;
    }
}

#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger pageNumber = (scrollView.contentOffset.x + 1) / self.view.bounds.size.width;
    [self.icyPageControl setCurrentPage:pageNumber];
}

@end
