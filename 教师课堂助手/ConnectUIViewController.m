//
//  ConnectUIViewController.m
//  教师课堂助手
//
//  Created by 罗玄 on 15/3/29.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

#import "ConnectUIViewController.h"
#import "NetworkService.h"
#import "DataManager.h"

@interface ConnectUIViewController ()

@property(nonatomic, strong)NSString * ipAddress;
@property(nonatomic, strong)NetworkService * networkService;
@property(nonatomic, strong)NSTimer * timer;
//调ip标签
- (void)setIPLable;
//键盘收回
- (void)textFieldResignKeyboard:(id)sender;
//本地数据管理
@property (nonatomic, strong) DataManager * dataManager;
@end


@implementation ConnectUIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.ipAddress = nil;
    //[self setIPLable:self.ipAddress];
    self.networkService = [NetworkService networkServiceInstance];
//    self.ipAddress = @"192.168.191.1";
    [self setButtonStyle];
    
    //取得数据管理句柄
    self.dataManager = [DataManager dataManageInstance];
    
    self.ipAddress = [[NSString alloc] initWithString:[self.dataManager getLocalVaueWithKey:@"ip"]];

    
    //设置背景相关
    self.connectButton.layer.cornerRadius = 5;
    self.scanButton.layer.cornerRadius = 5;
    UIImage * image = [UIImage imageNamed:@"bgImage"];
    self.bgImageView.layer.contents = (id)image.CGImage;
    //self.connectView.layer.backgroundColor = [UIColor clearColor].CGColor;
    
    //设置输入文本框代理
    self.ip1.delegate = self;
    self.ip2.delegate = self;
    self.ip3.delegate = self;
    self.ip4.delegate = self;
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldResignKeyboard:)];
    [self.view addGestureRecognizer:tapGesture];
    //设置定时状态更新
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(setButtonStyle) userInfo:nil repeats:YES];
//    [self.timer fire];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewWillAppear:(BOOL)animated{
    [self setIPLable];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self textFieldResignKeyboard:self];
    [self.timer invalidate];
    [self.dataManager setLocalValueWithKey:@"ip" value:self.ipAddress];
    [self.dataManager dataSave];
    NSLog(@"%d", [self.networkService retrieveNetworkState]);
}

- (void)setIPAddress:(NSString *)ipAddress
{
    if (ipAddress == nil) {
        self.ipAddress = @"0.0.0.0";
        return;
    }
    
    self.ipAddress = nil;
    self.ipAddress = [[NSString alloc] initWithString:ipAddress];
    NSError *error = NULL;
    //使用正则表达式进行判断
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^((2[0-4][0-9]|25[0-5]|[01]?[0-9]?[0-9])\.){3}(2[0-4][0-9]|25[0-5]|[01]?[0-9]?[0-9])$" options:NSRegularExpressionCaseInsensitive error:&error];
    NSInteger num = [regex numberOfMatchesInString:self.ipAddress options:0 range:NSMakeRange(0, self.ipAddress.length)];
    if (num == 0) {
        self.ipAddress = @"0.0.0.0";
    }
    NSLog(@"num %ld", num);
}
//设置ip输入框显示，用于取回ip时
- (void)setIPLable
{
    if (self.ipAddress) {
        NSArray * ipList = [self.ipAddress componentsSeparatedByString:@"."];
        [self.ip1 setText:[ipList objectAtIndex:0]];
        [self.ip2 setText:[ipList objectAtIndex:1]];
        [self.ip3 setText:[ipList objectAtIndex:2]];
        [self.ip4 setText:[ipList objectAtIndex:3]];
        
    }
    else{
        [self.ip1 setText:@"000"];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"QRScanSegue"]) {
        QRCodeScanViewController * QRCodeVC = segue.destinationViewController;
        QRCodeVC.delegate = self;
    }
    else if([segue.identifier isEqualToString:@"IPListSegue"]){
        IPListViewController * IPListVC = segue.destinationViewController;
        IPListVC.delegate = self;
    }
}

- (IBAction)connectOrDisconnect:(id)sender {
    //让texfield失去焦点
    [self textFieldResignKeyboard:sender];
    self.ipAddress = [[NSString alloc] initWithFormat:@"%@.%@.%@.%@", self.ip1.text, self.ip2.text, self.ip3.text, self.ip4.text];
    if ([self.networkService retrieveNetworkState]) {
        NSString * data = @"stop-000,000,00";
        [self.networkService sendData:[data dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"%@", data);
        [self.networkService disconnectToHost];
    }
    else{
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^((2[0-4][0-9]|25[0-5]|[01]?[0-9]?[0-9])\.){3}(2[0-4][0-9]|25[0-5]|[01]?[0-9]?[0-9])$" options:NSRegularExpressionCaseInsensitive error:&error];
        NSInteger num = [regex numberOfMatchesInString:self.ipAddress options:0 range:NSMakeRange(0, self.ipAddress.length)];
        if (num != 0) {
            if ([self.networkService isconnecting]) {
                [self.networkService disconnectToHost];
            }
            [self.networkService connectWithHostIP:self.ipAddress Port:3001];
        }
        else{
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"ip地址错误" message:@"请检查ip地址格式" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            self.ipAddress = @"0.0.0.0";
            [self setIPLable];
        }
        NSLog(@"%@", self.ipAddress);
    }
    [self setButtonStyle];
}
//根据状态设置按钮状态
- (void)setButtonStyle{
    if (![self.networkService retrieveNetworkState]) {
        [self.connectButton setTitle:@"连接" forState:normal];
        [self.connectButton setBackgroundColor:[UIColor redColor]];
//        [self.timer fire];
    }
    else{
        [self.connectButton setTitle:@"断开" forState:normal];
        [self.connectButton setBackgroundColor:[UIColor greenColor]];
//        [self.timer fire];
    }
}
//textField开始
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}
//textField开始编辑，初始化
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.ip1) {
        self.ip1.text = @"";
        self.ip2.text = @"";
        self.ip3.text = @"";
        self.ip4.text = @"";
    }
    textField.text = @"";
}
//textFiel输入控制
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    //如果输入小于等于3个数，且输入的为数字，则继续输入
    if (range.location <= 3 && [scan scanInt:&val] &&string.length == 1 ) {
        //进行切换输入
        if (range.location == 2) {
            textField.text = [textField.text stringByAppendingString:string];
            if (textField == self.ip1) {
                [self.ip1 resignFirstResponder];
                [self.ip2 becomeFirstResponder];
            }
            else if(textField == self.ip2) {
                [self.ip2 resignFirstResponder];
                [self.ip3 becomeFirstResponder];
            }
            else if(textField == self.ip3) {
                [self.ip3 resignFirstResponder];
                [self.ip4 becomeFirstResponder];
            }
            else{
                self.ipAddress = [[NSString alloc] initWithFormat:@"%@.%@.%@.%@", self.ip1.text, self.ip2.text, self.ip3.text, self.ip4.text];
                [self.ip4 resignFirstResponder];
            }
            return NO;
        }
        return YES;
    }
    else{
        return NO;
    }
}
//键盘收回
- (void)textFieldResignKeyboard:(id)sender{
    [self.ip1 resignFirstResponder];
    [self.ip2 resignFirstResponder];
    [self.ip3 resignFirstResponder];
    [self.ip4 resignFirstResponder];
}

@end


















