//
//  DrawItem.m
//  教师课堂助手
//
//  Created by 罗玄 on 15/4/1.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

#import "DrawItem.h"

@implementation DrawItem

+ (id)viewItemWithColor:(UIColor *)color Path:(UIBezierPath *)path Width:(CGFloat)width
{
    DrawItem * tempItem = [[DrawItem alloc] init];
    
    tempItem.color = color;
    tempItem.path = path;
    tempItem.width = width;
    
    return tempItem;
}

@end
