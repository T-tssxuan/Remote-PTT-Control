//
//  NetworkService.h
//  NetworkTest
//
//  Created by 罗玄 on 15/4/1.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"

@protocol RetrieveNetData

- (void)setRetrieveData:(NSData *)data;

@end

@interface NetworkService : NSObject<AsyncSocketDelegate>

@property(nonatomic, weak) id<RetrieveNetData> delegate;

// 获取NetworkServic的单例
+ (NetworkService *)networkServiceInstance;
//通过tcp连接服务器
- (void)connectWithHostIP:(NSString *)ip Port:(UInt16)port;
//发送数据
- (void)sendData:(NSData *)data;
//接收数据命令
- (void)recieveData;
//查看连接状态
- (BOOL)retrieveNetworkState;
//查看是否正在连接
- (BOOL)isconnecting;
//断开连接
- (void)disconnectToHost;

@end
