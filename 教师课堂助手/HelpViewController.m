//
//  HelpViewController.m
//  教师课堂助手
//
//  Created by 罗玄 on 15/5/8.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage * image = [UIImage imageNamed:@"bgImage"];
    self.bgImageView.layer.contents = (id)image.CGImage;
    
    self.iosHelp.text = @"1、打开应用后，进行网络连接，自行输入或者扫描windows端提供的二维码取得windows ip地址。\n2、连接windows端，等待连接成功。\n3、回到主界面选择相应的功能。\n";
    self.windowsHelp.text = @"1、启动软件，如果在局域网中，软件会自动获取本机局域网ip地址，并显示相关信息。\n2､等待手机端接入，接入成功后就能进行相应操作。\n3、使用ppt控制功能时应该保正ppt打开，并处于控制焦点。";
    self.attention.text = @"1、使用此软件，应该保证ios端和windows端都连入同一个局域网。\n2、系统需要在连接成功后才能正常使用。";
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
