//
//  DataManager.h
//  教师课堂助手
//
//  Created by 罗玄 on 15/4/6.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject
//得到一个datamanage实例
+ (DataManager *)dataManageInstance;
//设置值
- (void)setLocalValueWithKey:(NSString *) key value:(NSString *)value;
//取得值，如果值不存在，则向属性列表中添加一项，并返回”“字符串
- (NSString *)getLocalVaueWithKey:(NSString *)key;
//保存数据
- (void)dataSave;
@end
