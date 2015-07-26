//
//  WhiteboardViewController.h
//  教师课堂助手
//
//  Created by 罗玄 on 15/4/1.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawView.h"
#import "NetworkService.h"

@interface WhiteboardViewController : UIViewController<RetrieveNetData, DrawDataTransmission>
//设置按钮相关
- (IBAction)configure:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *configButton;
@property (weak, nonatomic) IBOutlet UIView *configPanel;
//调节红色
- (IBAction)redSliderChange:(id)sender;
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UILabel *redLabel;
//调节绿色
- (IBAction)greenSliderChange:(id)sender;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UILabel *greenLabel;
//调节蓝色
- (IBAction)blueSliderChange:(id)sender;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UILabel *blueLabel;
//调节画笔宽度
- (IBAction)widthSliderChange:(id)sender;
@property (weak, nonatomic) IBOutlet UISlider *widthSlider;
@property (weak, nonatomic) IBOutlet UILabel *widthLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sampleImageView;
@property (weak, nonatomic) IBOutlet UIView *bgImageView;

@end
