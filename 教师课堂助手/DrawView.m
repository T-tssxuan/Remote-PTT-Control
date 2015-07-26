//
//  DrawView.m
//  教师课堂助手
//
//  Created by 罗玄 on 15/4/1.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

#import "DrawView.h"

static const CGFloat kPointMinDistance = 3.0f;
static const CGFloat kPointMinDistanceSquared = kPointMinDistance * kPointMinDistance;

@interface DrawView()

@property (assign, nonatomic) CGMutablePathRef path;
@property (strong, nonatomic) NSMutableArray *pathArray;
@property (assign, nonatomic) BOOL isExistPath;

@property (assign, nonatomic) CGPoint currentPoint;
@property (assign, nonatomic) CGPoint previousPoint;
@property (assign, nonatomic) CGPoint previousPreviousPoint;

@end


@implementation DrawView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (DrawItem * item in self.pathArray) {
        CGContextAddPath(context, item.path.CGPath);
        [item.color set];
        CGContextSetLineWidth(context, item.width);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextDrawPath(context, kCGPathStroke);
        NSLog(@"test drawitem");
    }
    if (self.isExistPath) {
        CGContextAddPath(context, self.path);
        [self.lineColor set];
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextDrawPath(context, kCGPathStroke);
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [touches anyObject];
    self.path = CGPathCreateMutable();
    self.isExistPath = YES;
//    CGPathMoveToPoint(self.path, NULL, location.x, location.y);
    self.previousPoint = [touch locationInView:self];
    self.previousPreviousPoint = [touch locationInView:self];
    self.currentPoint = [touch locationInView:self];
    
    //向网络发送起始点
    [self.delegate setStartPoint:self.currentPoint];
    
    [self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    //计算，主要用于圆润画线
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    //向网络移动结束点
    NSString * temp = [self.delegate setMovePoint:point];
    NSLog(@"%@", temp);
    
    CGFloat dx = point.x - self.currentPoint.x;
    CGFloat dy = point.y - self.currentPoint.y;
    //如果移动范围小于最小范围则忽本次移动
    if ((dx * dx + dy * dy) < kPointMinDistanceSquared) {
        return;
    }
    
    self.previousPreviousPoint = self.previousPoint;
    self.previousPoint = [touch previousLocationInView:self];
    self.currentPoint = [touch locationInView:self];
    
    CGPoint mid1 = [self midPointWithFirstPoint:self.previousPoint secondPoint:self.previousPreviousPoint];
    CGPoint mid2 = [self midPointWithFirstPoint:self.currentPoint secondPoint:self.previousPoint];
    CGMutablePathRef subpath = CGPathCreateMutable();
    CGPathMoveToPoint(subpath, NULL, mid1.x, mid1.y);
    CGPathAddQuadCurveToPoint(subpath, NULL, self.previousPoint.x, self.previousPoint.y, mid2.x, mid2.y);
    
    [self printWithName:@"preprePoint" P1:self.previousPreviousPoint];
    [self printWithName:@"prePoint" P1:self.previousPoint];
    [self printWithName:@"current" P1:self.currentPoint];
    [self printWithName:@"md1" P1:mid1];
    [self printWithName:@"md2" P1:mid2];
    
    CGRect bounds = CGPathGetBoundingBox(subpath);
    CGRect drawBox = CGRectInset(bounds, -2.0 * self.lineWidth, -2.0 * self.lineWidth);
    
    CGPathAddPath(self.path, NULL, subpath);
    CGPathRelease(subpath);
    
//    UITouch *touch = [touches anyObject];
//    CGPoint location = [touch locationInView:self];
//    CGPathAddLineToPoint(self.path, NULL, location.x, location.y);
    [self setNeedsDisplayInRect:drawBox];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.pathArray == nil) {
        self.pathArray = [NSMutableArray array];
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:_path];
    DrawItem * item = [DrawItem viewItemWithColor:self.lineColor Path:path Width:self.lineWidth];
    [self.pathArray addObject:item];
    CGPathRelease(self.path);
    
    UITouch * touch = [touches anyObject];
    //向网络发送结束点
    [self.delegate setEndPoint:[touch locationInView:self]];
   
    self.isExistPath = NO;
}

- (CGPoint) midPointWithFirstPoint:(CGPoint)p1 secondPoint:(CGPoint)p2{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

- (void) printWithName:(NSString *)name P1:(CGPoint)p1{
    NSLog(@"%@: p1 x:%f y:%f", name, p1.x, p1.y);
}

@end



















