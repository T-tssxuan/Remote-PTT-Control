//
//  MainViewController.m
//  教师课堂助手
//
//  Created by 罗玄 on 15/3/27.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

#import "MainViewController.h"
#import "DataManager.h"

@interface MainViewController ()

@property(nonatomic, strong) DataManager * dataManager;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataManager = [DataManager dataManageInstance];
    self.PPTControlButton.layer.cornerRadius = 5;
    self.WhiteBoardButton.layer.cornerRadius = 5;
    self.NetWorkControlButton.layer.cornerRadius = 5;
    self.HelpButton.layer.cornerRadius = 5;
    
    //self.bgImageView.image = [[UIImage imageNamed:@"name.png"] stretchableImageWithLeftCapWidth: topCapHeight:top];
    UIImage * image = [UIImage imageNamed:@"bgImage"];
    self.bgImageView.layer.contents = (id)image.CGImage;
    //self.MainView.layer.backgroundColor = [UIColor clearColor].CGColor;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
