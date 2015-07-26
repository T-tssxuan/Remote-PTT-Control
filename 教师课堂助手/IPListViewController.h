//
//  IPListViewController.h
//  教师课堂助手
//
//  Created by 罗玄 on 15/3/30.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetIPDelegate.h"

@interface IPListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UINavigationItem *ipListNavBar;


//@property(nonatomic, strong) UIView * containerView;
@property(nonatomic, strong) UIView * containerPlaceholdView;
@property(nonatomic, strong) UITableView * leftTableView;
@property(nonatomic, strong) UITableView * rightTableView;

@property(nonatomic, weak) id<SetIPDelegate> delegate;



@end
