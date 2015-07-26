//
//  PPTViewController.h
//  教师课堂助手
//
//  Created by 罗玄 on 15/4/4.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkService.h"

@interface PPTViewController : UIViewController
- (IBAction)lastPage:(id)sender;
- (IBAction)nextPage:(id)sender;
- (IBAction)escFullScreen:(id)sender;
- (IBAction)fullScreen:(id)sender;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIButton *preButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end
