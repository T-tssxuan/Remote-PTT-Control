//
//  QRCodeScanViewController.m
//  教师课堂助手
//
//  Created by 罗玄 on 15/3/28.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

#import "QRCodeScanViewController.h"

@interface QRCodeScanViewController ()

@property(nonatomic, strong)AVCaptureSession *captureSession;
@property(nonatomic, strong)AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property(nonatomic, strong)AVAudioPlayer *audioPlayer;
@property(nonatomic, strong)NSString * scanValue;

- (void)loadBeepSound;

- (BOOL)startReading;
- (void)stopReading;
@end

@implementation QRCodeScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.captureSession = nil;
    self.scanValue =  nil;

    [self loadBeepSound];
    [self startReading];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.delegate setIPAddress:self.scanValue];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)startReading{
    NSError *error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    self.captureSession = [[AVCaptureSession alloc] init];
    [self.captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [self.captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    [self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.videoPreviewLayer setFrame:self.viewPreview.layer.bounds];
    [self.viewPreview.layer addSublayer:self.videoPreviewLayer];
    
    [_captureSession startRunning];
    
    return YES;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        [self.hint performSelectorOnMainThread:@selector(setText:) withObject: @"读取成功" waitUntilDone:NO];
        self.scanValue = [[NSString alloc] initWithString:[metadataObject stringValue]];

        if (self.audioPlayer) {
            [self.audioPlayer play];
        }
        [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
    }
}

- (void)stopReading
{
    [self.captureSession stopRunning];
    self.captureSession = nil;
    [self.videoPreviewLayer removeFromSuperlayer];
    [self.navigationController popToViewController:(UIViewController *)self.delegate animated:YES];
}

- (void)loadBeepSound{
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
    NSLog(@"%@", beepFilePath);
    
    NSData * beepData = [NSData dataWithContentsOfFile:beepFilePath];
    
    NSError *error;
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:beepData error:&error];
    
    if (error) {
        NSLog(@"Could not play beep file");
        NSLog(@"%@", [error localizedDescription]);
    }
    else{
        [self.audioPlayer prepareToPlay];
    }
}


@end










