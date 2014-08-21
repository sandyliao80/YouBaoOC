//
//  ModifyTextViewController.h
//  YouBaoOC
//
//  Created by eagle on 14/8/20.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModifyTextDelegate <NSObject>

@required
/**
 *  修改完成的回调函数
 *
 *  @param textTitle 修改的字段名
 *  @param info      修改后的内容
 */
- (void)didModifyText:(NSString *)textTitle textInfo:(NSString *)info;
@optional

/**
 *  修改取消的回调函数
 *
 *  @param textTitle 修改的字段名
 */
- (void)cancleModifyText:(NSString *)textTitle;

@end

@interface ModifyTextViewController : UIViewController

@property (weak, nonatomic) id<ModifyTextDelegate>delegate;

@property (strong, nonatomic) NSString *modifyTitle;
@property (strong, nonatomic) NSString *defaultText;

@end
