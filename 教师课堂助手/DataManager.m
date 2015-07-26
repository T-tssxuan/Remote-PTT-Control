//
//  DataManager.m
//  教师课堂助手
//
//  Created by 罗玄 on 15/4/6.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

#import "DataManager.h"

@interface DataManager()

@property(nonatomic, strong) NSFileManager *fileManager;
@property(nonatomic, strong) NSMutableDictionary *data;
@property(nonatomic, strong) NSString *path;

@end

@implementation DataManager

+ (DataManager *)dataManageInstance{
    static DataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DataManager alloc] init];
    });
    return sharedInstance;
}

- (DataManager *)init{
    if (self = [super init]) {
        self.fileManager = [NSFileManager defaultManager];
        [self dataPrepare];
    }
    return self;
}

- (void)dealloc{
    [self dataSave];
}

//对文件进行预处理，判断在Documents目录下是否存在plist文件，如果不存在则从资源目录下复制一个。
- (void)createEditableDatabaseIfNeeded
{
    self.path = [self applicationDocumentsDirectoryFile];
    
    BOOL dbexits=[self.fileManager fileExistsAtPath:self.path];
    if (!dbexits) {
        BOOL temp = [self.fileManager createFileAtPath:self.path contents:nil attributes:nil];
        if (!temp) {
            NSLog(@"创建文件失败");
        }
        else{
            self.data = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"red",@"0",@"green",@"0", @"blue", @"2", @"width", @"0.0.0.0", @"ip", nil];
            [self.data writeToFile:self.path atomically:YES];
        }
    }
}

//获取放置在沙箱Documents目录下的文件的完整路径
- (NSString *)applicationDocumentsDirectoryFile
{
    NSString *documentDirectory=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path=[documentDirectory stringByAppendingPathComponent:@"data.plist"];
    
    return path;
}

//初始化数据
- (void)dataPrepare{
    [self createEditableDatabaseIfNeeded];
    //将属性列表文件内容读取到array变量中，也就是获取了属性列表文件中全部的数据集合
    self.data = [NSMutableDictionary dictionaryWithContentsOfFile:self.path];
}
//保存数据
- (void)dataSave{
    //将array重新写入属性列表文件中
    [self.data writeToFile:self.path atomically:YES];
}



- (void)setLocalValueWithKey:(NSString *) key value:(NSString *)value{
    //向array中添加一条新记录
    [self.data setValue:value forKey:key];
}

- (NSString *)getLocalVaueWithKey:(NSString *)key{
    return [self.data valueForKey:key];
}

@end















