//
//  QRCodeScanViewController.h
//  教师课堂助手
//
//  Created by 罗玄 on 15/3/28.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SetIPDelegate.h"

@interface QRCodeScanViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>
@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@property (weak, nonatomic) IBOutlet UILabel *hint;

@property (weak, nonatomic) id<SetIPDelegate> delegate;

@end
