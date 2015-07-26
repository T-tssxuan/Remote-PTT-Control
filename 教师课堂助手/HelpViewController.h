//
//  HelpViewController.h
//  教师课堂助手
//
//  Created by 罗玄 on 15/5/8.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UITextView *iosHelp;
@property (weak, nonatomic) IBOutlet UITextView *windowsHelp;
@property (weak, nonatomic) IBOutlet UITextView *attention;

@end
