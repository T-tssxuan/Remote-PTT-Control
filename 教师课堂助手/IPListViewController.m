//
//  IPListViewController.m
//  教师课堂助手
//
//  Created by 罗玄 on 15/3/30.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

#import "IPListViewController.h"

@interface IPListViewController()

@property(nonatomic, strong) NSDictionary * buildingList;    //教学楼列表,字段1:教楼编号，学段2:教学楼名称
@property(nonatomic, strong) NSArray * IPList;          //ip数据
@property(nonatomic, strong) NSArray * RoomNumberList;  //房间列表

//从服务器取回教学楼列表
- (void)retrieveBuildingList;
//从服务器取回所属教学楼ip列表
- (void)buildingIndex:(NSInteger)buildingIndex;
@end


@implementation IPListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self tableViewConfigure];      //配置显示表格
    [self retrieveBuildingList];    //取得教学楼列表
}

- (void)viewWillLayoutSubviews
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)tableViewConfigure
{
    NSLog(@"SPLIT");
    NSLog(@"left :%@", NSStringFromCGRect(self.leftTableView.frame));
    NSLog(@"right :%@", NSStringFromCGRect(self.rightTableView.frame));
    
    CGFloat senceWidth = self.view.frame.size.width;
    CGFloat senceHeight = self.view.frame.size.height;

    //设置第一个view
    self.containerPlaceholdView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:self.containerPlaceholdView];
    
    //左列表，显示教室列表
    self.leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, senceWidth / 3, senceHeight - 50) style:UITableViewStylePlain];
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    self.leftTableView.tag = 0;
    self.leftTableView.rowHeight = 30;
    //self.leftTableView.hidden = YES;
    self.leftTableView.bounces = NO;
    [self.leftTableView setBackgroundColor:[UIColor colorWithRed:17/255 green:78/255 blue:61/255 alpha:1]];
    [self.leftTableView setTintColor:[UIColor colorWithRed:17/255 green:78/255 blue:61/255 alpha:1] ];
    [self.view addSubview:self.leftTableView];
    
    //右列表显示教学楼的ip地址
    self.rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(senceWidth / 3, 64, senceWidth * 2 / 3, senceHeight - 50) style:UITableViewStylePlain];
    self.rightTableView.delegate = self;
    self.rightTableView.dataSource = self;
    self.rightTableView.tag = 1;
    self.rightTableView.rowHeight = 30;
    //self.rightTableView.hidden = YES;
    self.rightTableView.bounces = NO;
    [self.rightTableView setBackgroundColor:[UIColor colorWithRed:21/255 green:119/255 blue:89/255 alpha:1]];
    [self.view addSubview:self.rightTableView];
    
    
    NSLog(@"container :%@", NSStringFromCGRect(self.leftTableView.superview.frame));
    NSLog(@"left :%@", NSStringFromCGRect(self.leftTableView.frame));
    NSLog(@"right :%@", NSStringFromCGRect(self.rightTableView.frame));
    
    NSLog(@"bound left :%@", NSStringFromCGRect(self.leftTableView.bounds));
    NSLog(@"bound right :%@", NSStringFromCGRect(self.rightTableView.bounds));
    
    
    
    NSLog(@"%f %f", senceHeight, senceWidth);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    
    headerLabel.text = @"教室列表";
    [headerLabel setBackgroundColor:[UIColor grayColor]];
    return headerLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    static NSString * leftIndentifier = @"leftCell";
    static NSString * rightIndentifier = @"rightCell";
    
    if (tableView.tag == 0) {
        NSLog(@"table left");
        cell = [tableView dequeueReusableCellWithIdentifier:leftIndentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftIndentifier];
            [cell setBackgroundColor:[UIColor colorWithRed:17/255 green:78/255 blue:61/255 alpha:1]];
            cell.textLabel.textColor = [UIColor whiteColor];
        }
        cell.textLabel.text = [self.buildingList objectForKey:[NSString stringWithFormat:@"%ld", indexPath.row + 1]];
    }
    else{
        NSLog(@"table right");
        cell = [tableView dequeueReusableCellWithIdentifier:rightIndentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightIndentifier];
        }
        cell.textLabel.text = [self.RoomNumberList objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [self.IPList objectAtIndex:indexPath.row];
    }
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 0) {
        return [self.buildingList count];
    }
    else{
        return [self.RoomNumberList count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0) {
        [self buildingIndex:indexPath.row];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else{
        [self.delegate setIPAddress:[self.IPList objectAtIndex:indexPath.row]];
        [self.navigationController popToViewController:(UIViewController *)self.delegate animated:YES];
    }
}

//从服务器取得教学楼列表
- (void)retrieveBuildingList
{
    NSString *urlString = @"http://10.201.17.164/sjkt/build.php";
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:200];
    //建立异步请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            NSError * error;
            //取出请求到的数据
            
            self.buildingList = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSLog(@"%@", self.buildingList);
            
//            self.buildingList = [buildingData allValues];
            [self.leftTableView reloadData];
            [self buildingIndex:1];
        }
        else if(data == nil && connectionError != nil){
            NSLog(@"retrieveBuildingList 无数据");
        }
        else{
            NSLog(@"retrieveBuildingList 出错");
        }
    }];
}
//从服务器取回所属教学楼ip列表
- (void)buildingIndex:(NSInteger)buildingIndex
{
    //@"http://10.201.17.164/sjkt/data.php?bn=%ld
    //初始化url，请求目标为教学楼ip地址
    NSString *urlString = [NSString stringWithFormat:@"http://10.201.17.164/sjkt/data.php?bn=%ld", (long)(buildingIndex + 1)];
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"%@", urlString);
    //建立url请求
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:200];
    //建立异步请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            NSError * error;
            //取出请出求到的数据
            NSDictionary * ipData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            self.RoomNumberList = [ipData allKeys];
            self.IPList = [ipData allValues];
            //重新加载表中数据
            [self.rightTableView reloadData];
        }
        else if(data == nil && connectionError != nil)
        {
            self.RoomNumberList = nil;
            NSLog(@"buildingIndex 接受据数");
        }
        else{
            NSLog(@"buildingIndex %@", [connectionError localizedDescription]);
        }
        
    }];
    
}

@end
