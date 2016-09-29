//
//  MainTabBarController.m
//  浦东网安
//
//  Created by jyc on 15/6/21.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//

#import "MainTabBarController.h"
#import "JYCTabBar.h"
#import "LoginViewController.h"
#import "UserInfoTool.h"
#import "UserInfo.h"

#import "GesturePasswordController.h"
#import "CzhTogetherViewController.h"
#import "MainNavController.h"
@interface MainTabBarController ()<JYCTabBarDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)JYCTabBar *JYCBar;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,weak)UIButton *btn;
@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    _JYCBar = [[JYCTabBar alloc]init];
    _JYCBar.frame = self.tabBar.bounds;
    _JYCBar.delegate = self;
    _JYCBar.backgroundColor = CZHRGBColor(250, 249, 249);
    [self.tabBar addSubview:_JYCBar];
    
    
    NSString *imageName = nil;
    
    NSString *selImageName = nil;
    
    for (int i = 0; i < self.childViewControllers.count; i++) {
        
        imageName = [NSString stringWithFormat:@"tab%d",i ];
        selImageName = [NSString stringWithFormat:@"tab%d_sel",i ];
        // 添加底部按钮
        [_JYCBar addTabBarButtonWithImage:imageName selImage:selImageName];
        
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logout) name:@"logoutNot" object:nil];
}

-(void)logout
{
    self.selectedIndex = 0;
    [self.JYCBar.subviews enumerateObjectsUsingBlock:^(UIButton * btn, NSUInteger idx, BOOL *stop) {
        if (idx == 0) {
            self.JYCBar.selectedBtn.selected = NO;
            btn.selected = YES;
            self.JYCBar.selectedBtn = btn;
        }
    }];
}

// 代理方法：跳转控制器
-(void)tabBar:(JYCTabBar *)tabBar didSelectIndex:(NSInteger)index
{
    _index = index;
    self.selectedIndex = index;
    UserInfo *user = [UserInfoTool info];
    if (!user) {
        if (index == 1||index ==2) {
            GesturePasswordController *vc = [[GesturePasswordController alloc] init];
            if ([vc exist] == YES) {
                [self presentViewController:vc animated:YES completion:nil];
            }else{
                LoginViewController *vc = [[LoginViewController alloc]init];
                [self presentViewController:vc animated:YES completion:nil];
            }
            self.selectedIndex = 0;
        }
        
    }
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
