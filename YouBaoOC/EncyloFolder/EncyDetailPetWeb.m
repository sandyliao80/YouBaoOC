//
//  EncyDetailPetWeb.m
//  YouBaoOC
//
//  Created by developer on 14-8-27.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "EncyDetailPetWeb.h"
#import "EncyAllListFile.h"
#import "UIViewController+HideTabBar.h"
#import "EN_PreDefine.h"
#import <AFNetworking/AFNetworking.h>
#import "LCYGlobal.h"
#import "LCYCommon.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "RegisterAndLoginViewController.h"
@interface EncyDetailPetWeb ()
{
    NSInteger pet_id;
    BOOL _isCollect;
    BOOL _isPet;
    MBProgressHUD *progress;
    BOOL _isSearch;
}
@property (weak, nonatomic) IBOutlet UIWebView *currentWeb;

@end

@implementation EncyDetailPetWeb
- (id)initWithPetID:(NSInteger)petID andType:(BOOL)isPet
{
    if(self = [super initWithNibName:@"EncyDetailPetWeb" bundle:nil])
    {
        pet_id = petID;
        _isPet = isPet;
        _isCollect = NO;
        _isSearch  = NO;
    }
    return self;
}

- (void)setIsSelected:(BOOL)isSelect
{
    _isCollect = isSelect;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    progress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progress];
    NSString *urlStrings = [NSString stringWithFormat:@"%@%@%ld",ZXY_HOSTURL,ZXY_TYPEHTML,(long)pet_id];
    if(!_isPet)
    {
        urlStrings = [NSString stringWithFormat:@"%@%@%ld",ZXY_HOSTURL,ZXY_ENCYHTML,(long)pet_id];
        if(_isCollect)
        {
            [self setNaviRightItem:@"取消"];
        }
        else
        {
            [self setNaviRightItem:@"收藏"];
        }

        [self setNaviLeftItem];
    }
    else
    {
        [self setNaviLeftItem];
    }
    NSURL *url = [NSURL URLWithString:urlStrings];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.currentWeb loadRequest:request];
    if(self.navigationController)
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
   
}

- (void)setNaviRightItem:(NSString *)imageName
{
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 24)];
    [leftBtn setTitle:imageName forState:UIControlStateNormal];
//    [leftBtn setTitleColor:[UIColor grayColor]  forState:UIControlStateHighlighted];
//    [leftBtn setTitleColor:[UIColor colorWithRed:0.3882 green:0.6235 blue:0.7569 alpha:1] forState:UIControlStateNormal];
    leftBtn.layer.cornerRadius=4;
    leftBtn.layer.masksToBounds = YES;
    [leftBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [leftBtn addTarget:self action:@selector(setRightItemAction) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setBackgroundColor:[UIColor colorWithRed:0.3882 green:0.6235 blue:0.7569 alpha:1]];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    [self.navigationItem setRightBarButtonItem:leftBtnItem];
}

- (void)setRightItemAction
{
    if([[LCYCommon sharedInstance] isUserLogin])
    {
        [progress show:YES];
        NSString *userID = [[LCYGlobal sharedInstance] currentUserID];
        NSInteger status = 0;
        if(_isCollect)
        {
            status = 2;
        }
        else
        {
            status = 1;
        }
        NSString *stringURL = [ZXY_HOSTURL stringByAppendingString:ZXY_Select];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:stringURL parameters:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:pet_id],@"ency_id",[NSNumber numberWithInt:userID.intValue],@"user_name",[NSNumber numberWithInteger:status],@"status", nil] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",operation.responseString);
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:0 error:nil];
            if([response objectForKey:@"result"])
            {
                _isCollect = !_isCollect;
                if(_isCollect)
                {
                    [self setNaviRightItem:@"取消"];
                }
                else
                {
                    [self setNaviRightItem:@"收藏"];
                }
            }
            else
            {
                
            }
            [progress hide:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",operation.responseString);
            [progress hide:YES];
        }];
    }
    else
    {
        [progress show:NO];
        UIStoryboard *login = [UIStoryboard storyboardWithName:@"RegisterAndLogin" bundle:nil];
        RegisterAndLoginViewController *loginV = [login instantiateInitialViewController];
        [self.navigationController pushViewController:loginV animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)isSearchListClick:(BOOL)isSearch
{
    _isSearch = isSearch;
}

- (void)leftItemAction
{
    if(_isSearch)
    {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    if(_isPet)
    {
        if(self.navigationController)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:^{
            
            }];
        }
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
