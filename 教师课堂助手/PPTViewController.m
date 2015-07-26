//
//  PPTViewController.m
//  教师课堂助手
//
//  Created by 罗玄 on 15/4/4.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

#import "PPTViewController.h"

@interface PPTViewController()
@property (nonatomic, strong) NetworkService * networkService;

@end

@implementation PPTViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.networkService = [NetworkService networkServiceInstance];
    UIImage * image = [UIImage imageNamed:@"bgImage"];
    self.bgImageView.layer.contents = (id)image.CGImage;
    self.preButton.layer.cornerRadius = 5;
    self.nextButton.layer.cornerRadius = 5;
}

- (IBAction)lastPage:(id)sender {
    NSString * content = @"lastpage-000,00";
    NSData * data = [content dataUsingEncoding:NSUTF8StringEncoding];
    [self.networkService sendData:data];
    NSLog(@"%@", content);
}

- (IBAction)nextPage:(id)sender {
    NSString * content = @"nextpage-000,00";
    NSData * data = [content dataUsingEncoding:NSUTF8StringEncoding];
    [self.networkService sendData:data];
    NSLog(@"%@", content);

}

- (IBAction)escFullScreen:(id)sender {
    NSString * content = @"escfullscreen-0";
    NSData * data = [content dataUsingEncoding:NSUTF8StringEncoding];
    [self.networkService sendData:data];
    NSLog(@"%@", content);
}

- (IBAction)fullScreen:(id)sender {
    NSString * content = @"fullscreen-0000";
    NSData * data = [content dataUsingEncoding:NSUTF8StringEncoding];
    [self.networkService sendData:data];
    NSLog(@"%@", content);

}

@end
