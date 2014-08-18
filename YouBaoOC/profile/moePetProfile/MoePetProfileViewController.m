//
//  MoePetProfileViewController.m
//  YouBaoOC
//
//  Created by eagle on 14/8/13.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "MoePetProfileViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LCYCommon.h"

@interface MoePetProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarLightBG;

@property (weak, nonatomic) IBOutlet UIImageView *avatarContent;

@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;


@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *miscLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imageOne;

@property (weak, nonatomic) IBOutlet UIImageView *imageTwo;

@property (weak, nonatomic) IBOutlet UIImageView *imageThree;

@end

@implementation MoePetProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat avatarBGRadius = MIN(self.avatarLightBG.bounds.size.height, self.avatarLightBG.bounds.size.width) / 2.0f;
    [self.avatarLightBG.layer setCornerRadius:avatarBGRadius];
    [self.avatarLightBG.layer setMasksToBounds:YES];
    [self.avatarLightBG setBackgroundColor:THEME_LIGHT_COLOR];
    
    CGFloat avatarContentRadius = MIN(self.avatarContent.bounds.size.width, self.avatarContent.bounds.size.height) / 2.0f;
    [self.avatarContent.layer setCornerRadius:avatarContentRadius];
    [self.avatarContent.layer setMasksToBounds:YES];
    
    if (!self.petInfo) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"宠物信息获取失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    } else {
        NSURL *avatarURL = [NSURL URLWithString:[hostImageURL stringByAppendingString:self.petInfo.headImage]];
        [self.avatarContent sd_setImageWithURL:avatarURL];
        
        // 宠物性别
        self.sexImageView.image = [self.petInfo.petSex isEqualToString:@"0"]?[UIImage imageNamed:@"icoFemale"]:[UIImage imageNamed:@"icoMaleDark"];
        
        // 三个状态图标
        BOOL breeding = [self.petInfo.fHybridization isEqualToString:@"1"]?YES:NO;
        BOOL adopt = [self.petInfo.fAdopt isEqualToString:@"1"]?YES:NO;
        BOOL entrust = [self.petInfo.isEntrust isEqualToString:@"1"]?YES:NO;
        [self petTypeBreeding:breeding adopting:adopt entrust:entrust];
        
        // 昵称
        self.nickNameLabel.text = self.petInfo.petName;
        
        // 种类、年龄
        [self.miscLabel.layer setCornerRadius:5.0f];
        [self.miscLabel.layer setMasksToBounds:YES];
        [self.miscLabel setBackgroundColor:THEME_LIGHT_COLOR];
        
        NSMutableString *misc = [NSMutableString string];
        if ([self.petInfo.age integerValue] == 0) {
            [misc appendString:@"小于1岁"];
        } else if ([self.petInfo.age integerValue] == 11) {
            [misc appendString:@"大于10岁"];
        } else {
            [misc appendString:self.petInfo.age];
            [misc appendString:@"岁"];
        }
        [misc appendString:@" "];
        [misc appendString:self.petInfo.name];
        [misc appendString:@" "];
        [misc insertString:@" " atIndex:0];
        self.miscLabel.text = misc;
    }
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
- (void)petTypeBreeding:(BOOL)breeding adopting:(BOOL)adopting entrust:(BOOL)entrust{
    NSInteger index = 0;
    self.imageOne.image = nil;
    self.imageTwo.image = nil;
    self.imageThree.image = nil;
    if (breeding) {
        self.imageOne.image = [UIImage imageNamed:@"profileBreedingColor"];
        index++;
    }
    if (adopting) {
        if (index == 0) {
            self.imageOne.image = [UIImage imageNamed:@"profileAdoptColor"];
        } else {
            self.imageTwo.image = [UIImage imageNamed:@"profileAdoptColor"];
        }
        index++;
    }
    if (entrust) {
        if (index == 0) {
            self.imageOne.image = [UIImage imageNamed:@"profileEntrustColor"];
        } else if (index == 1) {
            self.imageTwo.image = [UIImage imageNamed:@"profileEntrustColor"];
        } else {
            self.imageThree.image = [UIImage imageNamed:@"profileEntrustColor"];
        }
        index++;
    }
}

@end
