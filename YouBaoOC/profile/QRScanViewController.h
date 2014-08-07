//
//  QRScanViewController.h
//  YouBaoOC
//
//  Created by Licy on 14-8-5.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QRScanViewController;

@protocol QRScanDelegate <NSObject>
@optional

/**
 *  成功扫描到二维码
 *
 *  @param QRScanVC 控制器的引用
 *  @param info     扫描到的信息
 */
- (void)QRScanViewController:(QRScanViewController *)QRScanVC didFinishScanned:(NSString *)info;

/**
 *  用户取消扫描
 *
 *  @param QRScanVC 控制器的引用
 */
- (void)QRScanViewControllerDidCancled:(QRScanViewController *)QRScanVC;

@end

@interface QRScanViewController : UIViewController

@property (weak, nonatomic) id<QRScanDelegate>delegate;

@end
