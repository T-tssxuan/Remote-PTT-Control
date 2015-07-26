//
//  DrawView.h
//  教师课堂助手
//
//  Created by 罗玄 on 15/4/1.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawItem.h"

@protocol DrawDataTransmission

- (void) setStartPoint:(CGPoint) point;
- (NSString *) setMovePoint:(CGPoint) point;
- (void) setEndPoint:(CGPoint) point;
- (void) setClear;

@end

@interface DrawView : UIView
//画笔宽度
@property (assign, nonatomic) CGFloat lineWidth;
//画笔颜色
@property (nonatomic, strong) UIColor *lineColor;
//网络传输代理
@property (nonatomic, weak) id<DrawDataTransmission> delegate;

@end
