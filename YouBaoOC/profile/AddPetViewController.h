//
//  AddPetViewController.h
//  YouBaoOC
//
//  Created by Licy on 14-8-4.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  宠物性别
 */
typedef NS_ENUM(NSUInteger, PetSex) {
    /**
     *  雄性
     */
    PetSexMale,
    /**
     *  雌性
     */
    PetSexFemale
};

/**
 *  宠物额外状态
 */
typedef NS_OPTIONS(NSUInteger, PetMiscOption) {
    PetMiscOptionBreeding = 1 << 0,     /**< 求配种 */
    PetMiscOptionAdopt = 1 << 1,        /**< 求领养 */
    PetMiscOptionFostered = 1 << 2,     /**< 被寄养 */
};

@interface AddPetViewController : UIViewController

@end
