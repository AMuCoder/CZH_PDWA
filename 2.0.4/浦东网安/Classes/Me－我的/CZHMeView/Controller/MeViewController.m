//
//  MeViewController.m
//  浦东网安
//
//  Created by jyc on 15/6/21.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//

#import "MeViewController.h"
#import "TouXiang.h"
#import "UIView+Extension.h"

#import "LoginViewController.h"
#import "PoliceView.h"
#import "UserInfo.h"
#import "UserInfoTool.h"
#import "ResetPwdViewController.h"
#import "GesturePasswordController.h"
#import "FaBuViewController.h"
#import "KeychainItemWrapper.h"
#import "CzhTogetherViewController.h"

@interface MeViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)TouXiang *tou;
@property(nonatomic,strong)PoliceView *police;
@property(nonatomic,strong)UserInfo *info;
@property(nonatomic,assign)BOOL isAccount;
@end

@implementation MeViewController


-(void)viewWillAppear:(BOOL)animated
{
    UserInfo *info = [UserInfoTool info];
    self.info = info;
    
    if (info) {
        
        if ([info.AuthorityTag isEqual: @"_Browse;"]) {
            [self liuLan];
        }
        else if ([info.AuthorityTag isEqual:@"_Add;_Browse;_Sp;"]){
            [self shenHe];
        }
        else if ([info.AuthorityTag isEqual:@"_Add;_Browse;"]){
            [self faBuuuu];
        }else{
            [self liuLan];
        }
    }
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:_isAccount?@"切换账号":@"登录" style:UIBarButtonItemStyleBordered target:self action:@selector(login:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"切换账号" style:UIBarButtonItemStyleBordered target:self action:@selector(login:)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    //title图片
    if (!info) {
        self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"titleView_1"]];
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_bg_1"]]];
    }
    else{
        self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"titleView"]];
        [self.navigationController.navigationBar setBarTintColor:CZHRGBColor(49, 174, 215)];
    }
    KeychainItemWrapper * CZHkeychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"PDWA" accessGroup:nil];
    [CZHkeychin setObject:info.UserName forKey:(__bridge id)kSecAttrAccount];// 上面两行用来标识一个Item
    [super viewWillAppear:animated];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //   消除navigationBar底部的黑线
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        
        NSArray *list=self.navigationController.navigationBar.subviews;
        
        for (id obj in list) {
            
            if ([obj isKindOfClass:[UIImageView class]]) {
                
                UIImageView *imageView=(UIImageView *)obj;
                
                NSArray *list2=imageView.subviews;
                
                for (id obj2 in list2) {
                    
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        
                        UIImageView *imageView2=(UIImageView *)obj2;
                        
                        imageView2.hidden=YES;
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults boolForKey:@"isAccount"];
}

-(void)faBuuuu
{
    [self configPoliceView];
}

-(void)liuLan
{
    [self configDanWeiYongHuTouXiang];
}

-(void)shenHe
{
    
    [self configLeaderTouXiang];
}

-(void)configPoliceView
{
    _isAccount = YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:_isAccount forKey:@"isAccount"];
    [defaults synchronize];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"修改密码" style:UIBarButtonItemStyleBordered target:self action:@selector(resetPwd)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    PoliceView *tou = [PoliceView policeView];
    [tou.faBu addTarget:self action:@selector(faBuXiaoXi) forControlEvents:UIControlEventTouchUpInside];
    tou.width = self.view.width;
    [self.view addSubview:tou];
    self.police = tou;
    if (IOS8) {
        tou.y = 0;
    }else{
        tou.y = 64;
    }
    // tou.backgroundColor = CZHRGBColor(32, 140, 211);
    tou.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main.jpg"]];
    tou.nameTitle.text = self.info.UserName;
    self.police = tou;
    
    [self configTableView];
}



-(void)configLeaderTouXiang
{
    _isAccount = YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:_isAccount forKey:@"isAccount"];
    [defaults synchronize];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"修改密码" style:UIBarButtonItemStyleBordered target:self action:@selector(resetPwd)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    TouXiang *tou = [TouXiang touXiang];
    if (IOS8) {
        tou.y = 0;
    }else{
        tou.y = 64;
    }
    
    
    tou.width = self.view.width;
    tou.touXiang.text = self.info.UserName;
    [self.view addSubview:tou];
    self.tou = tou;
    tou.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main.jpg"]];
    [self configTableView];
}

-(void)configDanWeiYongHuTouXiang
{
    _isAccount = YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:_isAccount forKey:@"isAccount"];
    [defaults synchronize];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"修改密码" style:UIBarButtonItemStyleBordered target:self action:@selector(resetPwd)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    TouXiang *tou = [TouXiang touXiang];
    if (IOS8) {
        tou.y = 0;
    }else{
        tou.y = 64;
    }
    
    tou.height = tou.touXiangView.height;
    tou.width = self.view.width;
    tou.touXiang.text = self.info.UserName;
    [self.view addSubview:tou];
    self.tou = tou;
    tou.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main.jpg"]];
    
    [self configTableView];
}


-(void)configTableView
{
    if (self.tou) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tou.frame), self.view.width, self.view.height) style:UITableViewStyleGrouped];
        
    }else {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.police.frame), self.view.width, self.view.height) style:UITableViewStyleGrouped];
        
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}


-(void)faBuXiaoXi
{
    FaBuViewController *fabu = [[FaBuViewController alloc]init];
    [self presentViewController:fabu animated:YES completion:nil];
    
}

-(void)login:(UIBarButtonItem *)btn
{
    LoginViewController *login = [[LoginViewController alloc]init];
    
    [self presentViewController:login animated:YES completion:nil];
}

-(void)resetPwd
{
    ResetPwdViewController *reset = [[ResetPwdViewController alloc]init];
    
    [self presentViewController:reset animated:YES completion:nil];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 20;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else{
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID= @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                
                cell.textLabel.text = @"用户名";
                label.text = self.info.UserName;
                cell.accessoryView = label;
                
                break;
            case 1:
                cell.textLabel.text = @"单位";
                label.text = self.info.UnitName;
                cell.accessoryView = label;
                break;
            default:
                break;
        }
    }else if (indexPath.section == 1){
        UIButton *btn = [[UIButton alloc]init];
        
        GesturePasswordController *vc = [[GesturePasswordController alloc] init];
        if ([vc exist] == 0) {
            [btn setTitle:@"设置图形密码" forState:UIControlStateNormal];
        }else{
            [btn setTitle:@"更改图形密码" forState:UIControlStateNormal];
        }
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        btn.width = self.view.width;
        btn.height = cell.height;
        [btn addTarget:self action:@selector(go2password) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
    }else if(indexPath.section == 2){
        UIButton *btn = [[UIButton alloc]init];
        [btn setTitle:@"用户工具" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        btn.width = self.view.width;
        btn.height = cell.height;
        [btn addTarget:self action:@selector(go2togerther) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
    }else{
        UIButton *btn = [[UIButton alloc]init];
        [btn setTitle:@"注  销" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        btn.width = self.view.width;
        btn.height = cell.height;
        [btn addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
    }
    
    return cell;
}
-(void)go2password{
    GesturePasswordController *vc = [[GesturePasswordController alloc] init];
    [vc clear];
    [self presentViewController:vc animated:YES completion:nil];
    
}
-(void)go2togerther{
    CzhTogetherViewController *vc = [[CzhTogetherViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)logOut
{
    _isAccount = NO;
    [UserInfoTool saveInfo:nil];
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    self.navigationItem.rightBarButtonItem = nil;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"logoutNot" object:nil];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        LoginViewController *login = [[LoginViewController alloc]init];
        [self presentViewController:login animated:YES completion:nil];
        
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
