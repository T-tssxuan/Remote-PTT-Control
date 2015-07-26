//
//  ConnectUIViewController.h
//  教师课堂助手
//
//  Created by 罗玄 on 15/3/29.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetIPDelegate.h"
#import "QRCodeScanViewController.h"
#import "IPListViewController.h"


@interface ConnectUIViewController : UIViewController<SetIPDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *ip1;
@property (weak, nonatomic) IBOutlet UITextField *ip2;
@property (weak, nonatomic) IBOutlet UITextField *ip3;
@property (weak, nonatomic) IBOutlet UITextField *ip4;
- (IBAction)connectOrDisconnect:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;


@end