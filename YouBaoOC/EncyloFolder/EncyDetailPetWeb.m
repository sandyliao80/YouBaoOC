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
@interface EncyDetailPetWeb ()
{
    NSInteger pet_id;
    
    BOOL _isPet;
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
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *urlStrings = [NSString stringWithFormat:@"%@%@%ld",ZXY_HOSTURL,ZXY_TYPEHTML,(long)pet_id];
    if(!_isPet)
    {
        urlStrings = [NSString stringWithFormat:@"%@%@%ld",ZXY_HOSTURL,ZXY_ENCYHTML,(long)pet_id];
        [self setNaviLeftItem];
    }
    NSURL *url = [NSURL URLWithString:urlStrings];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.currentWeb loadRequest:request];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leftItemAction
{
    if(_isPet)
    {
        [self dismissViewControllerAnimated:YES completion:^{
        
        }];
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
