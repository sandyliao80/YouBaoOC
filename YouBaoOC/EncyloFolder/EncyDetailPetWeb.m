//
//  EncyDetailPetWeb.m
//  YouBaoOC
//
//  Created by developer on 14-8-27.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "EncyDetailPetWeb.h"
#import <WebViewJavascriptBridge/WebViewJavascriptBridge.h>
#import "EncyAllListFile.h"
@interface EncyDetailPetWeb ()<UIWebViewDelegate>
{
    NSInteger pet_id;
    WebViewJavascriptBridge *bridge;
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
    NSString *urlStrings = [NSString stringWithFormat:@"%@%@%d",ZXY_HOSTURL,ZXY_TYPEHTML,pet_id];
    if(!_isPet)
    {
        urlStrings = [NSString stringWithFormat:@"%@%@%d",ZXY_HOSTURL,ZXY_ENCYHTML,pet_id];
    }
    NSURL *url = [NSURL URLWithString:urlStrings];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.currentWeb loadRequest:request];
    if(_isPet)
    {
        bridge = [WebViewJavascriptBridge bridgeForWebView:self.currentWeb webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
            NSLog(@"init Ok");
            
        }];
        
        [bridge registerHandler:@"jiankang" handler:^(id data, WVJBResponseCallback responseCallback) {
            NSLog(@"jiankang");
            EncyAllListFile *allFile = [[EncyAllListFile alloc] initPetID:[NSString stringWithFormat:@"%d",pet_id] andTypeID:@"1"];
            [self.navigationController pushViewController:allFile animated:YES];
        }];
        
        [bridge registerHandler:@"yanghu" handler:^(id data, WVJBResponseCallback responseCallback) {
            NSLog(@"yanghu");
            EncyAllListFile *allFile = [[EncyAllListFile alloc] initPetID:[NSString stringWithFormat:@"%d",pet_id] andTypeID:@"2"];
            [self.navigationController pushViewController:allFile animated:YES];
        }];
        
        [bridge registerHandler:@"xundao" handler:^(id data, WVJBResponseCallback responseCallback) {
            NSLog(@"xundao");
            EncyAllListFile *allFile = [[EncyAllListFile alloc] initPetID:[NSString stringWithFormat:@"%d",pet_id] andTypeID:@"3"];
            [self.navigationController pushViewController:allFile animated:YES];
        }];
    }
    // Do any additional setup after loading the view from its nib.
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

@end
