//
//  WhiteboardViewController.m
//  教师课堂助手
//
//  Created by 罗玄 on 15/4/1.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

#import "WhiteboardViewController.h"
#import "DataManager.h"

@interface WhiteboardViewController()
//画图view
@property (nonatomic, strong) DrawView * drawview;

@property (nonatomic, strong) NetworkService * networkService;
//数据名柄
@property (nonatomic, strong) NSData * data;
//数据内容
@property (nonatomic, strong) NSString * content;
//本地数据管理
@property (nonatomic, strong) DataManager * dataManager;

@property (nonatomic, assign) CGFloat red;
@property (nonatomic, assign) CGFloat green;
@property (nonatomic, assign) CGFloat blue;
@property (nonatomic, assign) CGFloat width;

//向网络端设置窗口大小
- (void) sendViewInfo;
@end


@implementation WhiteboardViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.drawview = [[DrawView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.drawview.delegate = self;
    self.networkService = [NetworkService networkServiceInstance];
    
    //设置面板背景颜色
    UIImage * image = [UIImage imageNamed:@"bgImage"];
    self.bgImageView.layer.contents = (id)image.CGImage;
    
    //发送窗口大小
    [self sendViewInfo];
    //发送打开白板命令
    [self.networkService sendData:[@"1-000,000,000,0" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //取得数据管理句柄
    self.dataManager = [DataManager dataManageInstance];
    
    NSString * redStr = [[NSString alloc] initWithString:[self.dataManager getLocalVaueWithKey:@"red"]];
    NSString * greenStr = [[NSString alloc] initWithString:[self.dataManager getLocalVaueWithKey:@"green"]];
    NSString * blueStr = [[NSString alloc] initWithString:[self.dataManager getLocalVaueWithKey:@"blue"]];
    NSString * widthStr = [[NSString alloc] initWithString:[self.dataManager getLocalVaueWithKey:@"width"]];
    
    if (![redStr isEqualToString:@""]) {
        [self.redSlider setValue:[redStr floatValue]];
        [self.greenSlider setValue:[greenStr floatValue]];
        [self.blueSlider setValue:[blueStr floatValue]];
        [self.widthSlider setValue:[widthStr floatValue]];
    }
    
    //初始化面板
    [self redSliderChange:self.redSlider];
    [self greenSliderChange:self.greenSlider];
    [self blueSliderChange:self.blueSlider];
    [self widthSliderChange:self.widthSlider];

    [self configure:self.configButton];
    
    [self.view addSubview:self.drawview];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //发送清空命令
    [self setClear];
    //发送关闭窗口命令
    [self.networkService sendData:[@"0-000,000,000,0" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self.dataManager setLocalValueWithKey:@"red" value:[[NSString alloc] initWithFormat:@"%4.2f", self.red]];
    [self.dataManager setLocalValueWithKey:@"green" value:[[NSString alloc] initWithFormat:@"%4.2f", self.green]];
    [self.dataManager setLocalValueWithKey:@"blue" value:[[NSString alloc] initWithFormat:@"%4.2f", self.blue]];
    [self.dataManager setLocalValueWithKey:@"width" value:[[NSString alloc] initWithFormat:@"%4.4f", self.width]];
    
    //保存数据
    [self.dataManager dataSave];
}

- (void)sendViewInfo{
    self.content = [[NSString alloc] initWithFormat:@"view-%04.0f-%04.0f-", self.view.frame.size.width, self.view.frame.size.height];
    [self.networkService sendData:[self.content dataUsingEncoding:NSUTF8StringEncoding]];
}

//实时从服务器取回数据
- (void)setRetrieveData:(NSData *)data{
    NSString * temp = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"The retrieve data is : %@", temp);
}

//设置网络端起始点
- (void)setStartPoint:(CGPoint)point{
    self.content = [[NSString alloc] initWithFormat:@"s-%06.2f-%06.2f", point.x, point.y];
    self.data = [self.content dataUsingEncoding:NSUTF8StringEncoding];
    [self.networkService sendData:self.data];
    NSLog(@"%@", self.content);
}
//设置网络端移动点
- (NSString *)setMovePoint:(CGPoint)point{
    self.content = [[NSString alloc] initWithFormat:@"m-%06.02f-%06.02f", point.x, point.y];
    self.data = [self.content dataUsingEncoding:NSUTF8StringEncoding];
    [self.networkService sendData:self.data];
    NSLog(@"%@", self.content);
    return self.content;
}
//设置网络端终点
- (void)setEndPoint:(CGPoint)point{
    self.content = [[NSString alloc] initWithFormat:@"e-%06.2f-%06.2f", point.x, point.y];
    self.data = [self.content dataUsingEncoding:NSUTF8StringEncoding];
    [self.networkService sendData:self.data];
    NSLog(@"%@", self.content);
}
//清除画面命令
- (void)setClear{
    self.content = @"c-000,000,000,0";
    self.data = [self.content dataUsingEncoding:NSUTF8StringEncoding];
    [self.networkService sendData:self.data];
    NSLog(@"%@", self.content);
}
//开启与关闭控制面板
- (IBAction)configure:(id)sender {
    if (self.configPanel.hidden) {
        self.configPanel.hidden = NO;
        [self setSampleView];
    }
    else{
        self.configPanel.hidden = YES;
        UIColor * color = [UIColor colorWithRed:self.red green:self.green blue:self.blue alpha:1];
        self.drawview.lineColor = color;
        self.drawview.lineWidth = self.width;
        
        //发送画笔颜色
        self.content = [[NSString alloc] initWithFormat:@"set-%3.1f-%3.1f-%3.1f", self.red, self.green, self.blue];
        self.data = [self.content dataUsingEncoding:NSUTF8StringEncoding];
        [self.networkService sendData:self.data];
        NSLog(@"%@", self.content);
        
        //发送画笔宽度
        self.content = [[NSString alloc] initWithFormat:@"width-%04.1f-0000", self.width];
        self.data = [self.content dataUsingEncoding:NSUTF8StringEncoding];
        [self.networkService sendData:self.data];
        NSLog(@"%@", self.content);
    }
}
//设置红色
- (IBAction)redSliderChange:(id)sender {
    UISlider * slider = (UISlider *)sender;
    self.red = slider.value;
    [self.redLabel setText:[[NSString alloc] initWithFormat:@"%4.2f", self.red]];
    [self setSampleView];
}
//设置绿色
- (IBAction)greenSliderChange:(id)sender {
    UISlider * slider = (UISlider *)sender;
    self.green = slider.value;
    [self.greenLabel setText:[[NSString alloc] initWithFormat:@"%4.2f", self.green]];
    [self setSampleView];
}
//设置蓝色
- (IBAction)blueSliderChange:(id)sender {
    UISlider * slider = (UISlider *)sender;
    self.blue = slider.value;
    [self.blueLabel setText:[[NSString alloc] initWithFormat:@"%4.2f", self.blue]];
    [self setSampleView];
}
//设置宽度
- (IBAction)widthSliderChange:(id)sender {
    UISlider * slider = (UISlider *)sender;
    self.width = slider.value;
    [self.widthLabel setText:[[NSString alloc] initWithFormat:@"%4.1f", self.width]];
    [self setSampleView];
}
//设置样式
- (void)setSampleView{
    UIGraphicsBeginImageContext(self.sampleImageView.frame.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.sampleImageView.image drawInRect:self.sampleImageView.frame];
    
    UIColor * color = [UIColor colorWithRed:self.red green:self.green blue:self.blue alpha:1];
    
    CGContextSetLineWidth(context, self.width);
    CGContextSetStrokeColorWithColor(context, [color CGColor]);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    CGContextMoveToPoint(context, 10, 20);
    CGContextAddLineToPoint(context, 200, 20);
    
    //    CGContextStrokePath(context);
    CGContextDrawPath(context, kCGPathEOFillStroke);
    self.sampleImageView.image = UIGraphicsGetImageFromCurrentImageContext();

}

@end
