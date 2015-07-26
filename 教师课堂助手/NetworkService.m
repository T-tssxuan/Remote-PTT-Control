//
//  NetworkService.m
//  NetworkTest
//
//  Created by 罗玄 on 15/4/1.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

#import "NetworkService.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>

@interface NetworkService()

- (id)init;
@property (nonatomic, strong) AsyncSocket * handle;
//心跳计时器
@property (nonatomic, retain) NSTimer * connectTimer;
//开启定时器
- (void)startTimer;
//停止计时器
- (void)stopTimer;
//发送心跳包
- (void)heartPackage;

@end

#define TAG_RECIEVE 0
#define TAG_SEND 1

@implementation NetworkService

- (id)init{
    if (self = [super init]) {
        self.handle = [[AsyncSocket alloc] initWithDelegate:self];
    }
    
    return self;
}

+ (NetworkService *)networkServiceInstance{
    static NetworkService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NetworkService alloc] init];
    });
    return sharedInstance;
}

- (void)connectWithHostIP:(NSString *)ip Port:(UInt16)port{
    NSError * error;
    [self.handle connectToHost:ip onPort:port error:&error];
    if (error) {
        NSLog(@"connect error: %@", [error localizedDescription]);
        return;
    }
}

- (void)sendData:(NSData *)data{
    [self.handle writeData:data withTimeout:-1 tag:TAG_SEND];
}

- (void)recieveData{
    [self.handle readDataWithTimeout:-1 tag:TAG_RECIEVE];
}

- (BOOL)retrieveNetworkState{
    return [self.handle isConnected];
}

- (void)disconnectToHost{
    [self.handle disconnect];
    //关闭心跳计时器
    [self stopTimer];
}
//成功连接后的代理
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    NSLog(@"connect success: %@:%d", host, port);
    NSLog(@"%d", self.retrieveNetworkState);
    //打开心跳计时器
    [self startTimer];
}
//成功发送数据后代理
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"send data success");
}
//成功收到数据后的代理
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    [self.delegate setRetrieveData:data];
    NSString *temp = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", temp);
    NSLog(@"recieve data success");
}

//查看是否正在连接
- (BOOL)isconnecting{
    CFReadStreamRef readStream = [self.handle getCFReadStream];
    CFWriteStreamRef writeStream = [self.handle getCFWriteStream];
    if (readStream == NULL || writeStream == NULL) {
        return NO;
    }
    else if (CFReadStreamGetStatus(readStream) ==  kCFStreamStatusOpening && CFWriteStreamGetStatus(writeStream) == kCFStreamStatusOpening) {
        return YES;
    }
    else{
        return NO;
    }
}

//开启计时器
- (void)startTimer{
    NSLog(@"socket连接成功");
    
    // 每隔30s像服务器发送心跳包
    self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(heartPackage) userInfo:nil repeats:YES];
    
    [self.connectTimer fire];
}

//停止计时器
- (void)stopTimer{
    [self.connectTimer invalidate];
    self.connectTimer = NULL;
}

//发送心跳包
- (void)heartPackage{
    CFWriteStreamRef temp = [self.handle getCFWriteStream];
    if (temp == nil) {
        return;
    }
    if (CFWriteStreamGetStatus(temp) == kCFStreamStatusOpen) {
        NSString * heartPackage = @"heartbeat-00000";
        NSData * data = [heartPackage dataUsingEncoding:NSUTF8StringEncoding];
        [self sendData:data];
        NSLog(@"%@", heartPackage);

    }
}
@
end
























