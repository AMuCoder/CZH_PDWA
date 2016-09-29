//
//  MainNavController.m
//  浦东网安
//
//  Created by jyc on 15/6/21.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//

#import "MainNavController.h"


#import "UIView+Extension.h"
//判断是否为用户
#import "UserInfo.h"
#import "UserInfoTool.h"
@interface MainNavController ()

@end

@implementation MainNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationBar *bar = [UINavigationBar appearance];
    if (IOS8) {
        bar.translucent = NO;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    dict[NSFontAttributeName] = [UIFont boldSystemFontOfSize:19];
    [bar setTitleTextAttributes:dict];
}

-(void)back
{
    [self popViewControllerAnimated:YES];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.hidesBottomBarWhenPushed = YES;
    if (self.viewControllers.count > 0) {
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"back" highImage:nil];
    }
    
    return [super pushViewController:viewController animated:animated];
    
}

@end
