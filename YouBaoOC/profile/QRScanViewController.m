//
//  QRScanViewController.m
//  YouBaoOC
//
//  Created by Licy on 14-8-5.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "QRScanViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface QRScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (strong,nonatomic)AVCaptureDevice *device;
@property (strong,nonatomic)AVCaptureDeviceInput *input;
@property (strong,nonatomic)AVCaptureMetadataOutput *output;
@property (strong,nonatomic)AVCaptureSession *session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer *preview;

@property (weak, nonatomic) IBOutlet UIView *lensView;
@end

@implementation QRScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.lensView.layer setBorderWidth:2.0f];
    [self.lensView.layer setBorderColor:[[UIColor yellowColor] CGColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setupCamera];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)setupCamera
{
    // Device
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    self.output = [[AVCaptureMetadataOutput alloc]init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.session canAddInput:self.input])
    {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output])
    {
        [self.session addOutput:self.output];
    }
    
    // 条码类型
    self.output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    // Preview
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [self.preview addSublayer:self.lensView.layer];
    [self.view.layer addSublayer:self.preview];
    
    // 设置监测区域
    CGFloat x = (self.view.frame.size.width - (self.lensView.center.x + self.lensView.bounds.size.width / 2.0f)) / self.view.frame.size.width;
    CGFloat y = (self.lensView.center.y - self.lensView.bounds.size.height / 2.0f) / self.view.frame.size.height;
    CGFloat w = self.lensView.bounds.size.width / self.view.frame.size.width;
    CGFloat h = self.lensView.bounds.size.height / self.view.frame.size.height;
    self.output.rectOfInterest = CGRectMake(y, x, h, w);
    
    // Start
    [self.session startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if ([self isBeingPresented]) {
        return;
    }
    NSString *stringValue;
    
    if ([metadataObjects count] >0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [_session stopRunning];
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"%@",stringValue);
    }];
}

@end
