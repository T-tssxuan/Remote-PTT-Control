//
//  DrawItem.h
//  教师课堂助手
//
//  Created by 罗玄 on 15/4/1.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface DrawItem : NSObject

+ (id)viewItemWithColor:(UIColor *)color Path:(UIBezierPath *)path Width:(CGFloat)width;
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) UIBezierPath * path;
@property (assign, nonatomic) CGFloat width;

@end
