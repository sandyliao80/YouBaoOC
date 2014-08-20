//
//  ModifyMoePetViewController.h
//  YouBaoOC
//
//  Created by eagle on 14/8/19.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GetPetDetail.h"
#import "GetUserInfo.h"

@interface ModifyMoePetViewController : UIViewController

@property (strong, nonatomic) GetPetDetailBase *petDetailBase;

@property (strong, nonatomic) GetUserInfoPetInfo *userPetInfo;

@end
