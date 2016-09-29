//
//  GesturePasswordController.m
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

#import <Security/Security.h>
#import <CoreFoundation/CoreFoundation.h>

#import "GesturePasswordController.h"
#import "UserInfo.h"
#import "UserInfoTool.h"
#import "KeychainItemWrapper/KeychainItemWrapper.h"
#import "LoginViewController.h"



#import "User.h"
#import "MJExtension.h"
#import "JYCTabBar.h"
#import "NSString+Hash.h"
#import "MeViewController.h"
#include <dlfcn.h>
@interface GesturePasswordController ()

@property (nonatomic,strong) GesturePasswordView * gesturePasswordView;
@property (nonatomic,strong) UIButton *go2login;
@property (nonatomic,strong) UIButton *userpassword;
@property (nonatomic,strong) UILabel * state;
@end

@implementation GesturePasswordController {
    NSString * previousString;
    NSString * password;
    NSString * name;
    int count;//加入计数器
}
@synthesize state;
@synthesize go2login;
@synthesize userpassword;
@synthesize back;
@synthesize gesturePasswordView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UserInfo *info = [UserInfoTool info];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"android_title_bg"]];
    previousString = [NSString string];
    [self check];
    //文字显示
    state = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
    [state setTextColor:[UIColor whiteColor]];
//    state.backgroundColor = [UIColor grayColor];
    [state setTextAlignment:NSTextAlignmentCenter];
    [state setFont:[UIFont systemFontOfSize:22.f]];
    [state setText:@"图形密码"];
    [self.view addSubview:state];
    //登录按钮
    go2login = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2+1, self.view.frame.size.height-50, self.view.frame.size.width/2-0.5, 50)];
    go2login.backgroundColor = [UIColor grayColor];
    [go2login.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [go2login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [go2login setTitle:@"账号密码登录" forState:UIControlStateNormal];
    [go2login addTarget:self action:@selector(go2loginview) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:go2login];
    //头部返回
    back = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, 60, 44)];
    back.backgroundColor = [UIColor clearColor];
    [back.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [back setTitle:@"返   回" forState:UIControlStateNormal];
    [back addTarget:self action:@selector(go2back2) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:back];
    //
    userpassword = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width/2-0.5, 50)];
    userpassword.backgroundColor = [UIColor grayColor];
    [userpassword.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [userpassword setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [userpassword setTitle:@"返   回" forState:UIControlStateNormal];
    [userpassword addTarget:self action:@selector(go2back1) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:userpassword];
    
    if(info && [self exist]){//[self exist] == NO
        [go2login setHidden:YES];
        [userpassword setHidden:YES];
        state.hidden = YES;
        [back setHidden:YES];
    }else if(![self exist]){
        [go2login setHidden:YES];
        [userpassword setHidden:YES];
        state.hidden = YES;
        [back setHidden:NO];
    }else if(!info){
        [back setHidden:YES];
    }
}
- (void)go2back{
    UserInfo *info = [UserInfoTool info];
    if ([self exist] && !info) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }else if([self exist] ==NO && info){
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }else if([self exist] ==YES && info){
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
- (void)go2back1{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)go2back2{
    UserInfo *info = [UserInfoTool info];
    if (![self exist] && !info) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }else if(![self exist] && info){
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }else if([self exist] && !info){
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }else if([self exist] && info){
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)go2loginview{
    
    [go2login setHidden:NO];
    [userpassword setHidden:NO];
    LoginViewController *vc = [[LoginViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    
}


#pragma mark - 检查密码是否为空
-(void)check{
    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
    password = [keychin objectForKey:(__bridge id)kSecValueData];
    if ([password isEqualToString:@""]) {
        [self reset];
    }
    else {
        [self verify];
    }
}

#pragma mark - 验证手势密码
- (void)verify{
    count = 0;
    gesturePasswordView = [[GesturePasswordView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [gesturePasswordView.tentacleView setRerificationDelegate:self];
    [gesturePasswordView.tentacleView setStyle:1];
    [gesturePasswordView setGesturePasswordDelegate:self];
    [self.view addSubview:gesturePasswordView];
}

#pragma mark - 重置手势密码
- (void)reset{
    gesturePasswordView = [[GesturePasswordView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [gesturePasswordView.tentacleView setResetDelegate:self];
    [gesturePasswordView.tentacleView setStyle:2];
    [gesturePasswordView.forgetButton setHidden:YES];
    [gesturePasswordView.changeButton setHidden:YES];
    [self.view addSubview:gesturePasswordView];
}

#pragma mark - 判断是否已存在手势密码
- (BOOL)exist{
    /** 初始化一个保存用户帐号的KeychainItemWrapper */
    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
    password = [keychin objectForKey:(__bridge id)kSecValueData];
    if ([password isEqualToString:@""])
    {
        return NO;
    }else{
        return YES;
    }
}
- (BOOL)have{
    /** 初始化一个保存用户帐号的KeychainItemWrapper */
    KeychainItemWrapper * CZHkeychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"PDWA" accessGroup:nil];
    name = [CZHkeychin objectForKey:(__bridge id)kSecAttrAccount];
    if ([name isEqualToString:@""])
    {
        return NO;
    }else{
        return YES;
    }
}
#pragma mark - 清空记录
- (void)clear{
    /** 初始化一个保存用户帐号的KeychainItemWrapper */
    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
    [keychin resetKeychainItem];
}

#pragma mark - 改变手势密码
- (void)change{
    [self verify];
    [self reset];
}

#pragma mark - 忘记手势密码
- (void)forget{
    [self clear];
    [self reset];
}

- (BOOL)verification:(NSString *)result{
    /** 初始化一个保存用户帐号的KeychainItemWrapper */
    KeychainItemWrapper * CZHkeychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"PDWA" accessGroup:nil];
    
    
    if ([result isEqualToString:password]) {
        //对的时候计数器清空
        [self countclear];
        [gesturePasswordView.state setTextColor:[UIColor whiteColor]];
        [gesturePasswordView.state setText:@"输入正确"];
        
        
        //从keychain里取出帐号密码
        KeychainItemWrapper * CZHToken = [[KeychainItemWrapper alloc]initWithIdentifier:@"IOSTOKEN" accessGroup:nil];
        NSString *tokenValue = [CZHToken objectForKey:(__bridge id)kSecAttrAccount];
        NSString *loginusername = [CZHkeychin objectForKey:(__bridge id)kSecAttrAccount];
        NSString *loginpassword = [CZHkeychin objectForKey:(__bridge id)kSecValueData];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"loginName"] =loginusername;
        params[@"loginPwd"] = loginpassword;
        params[@"iostoken"] = tokenValue;
        [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"/user_Login"] params:params success:^(NSData *data) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            User *user = [User objectWithKeyValues:dic[@"return"]];
            NSArray *usrArr = [UserInfo objectArrayWithKeyValuesArray:dic[@"result"]];
            
            if (usrArr) {
                for (UserInfo *info in usrArr) {
                    [UserInfoTool saveInfo:info];
                }
                [self.view endEditing:YES];
            }else{
                [MBProgressHUD showError:user.message];
            }
        }failed:^{
            [MBProgressHUD showError:@"登录错误，请检查网络!"];
        }];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        return YES;
    }else{
        [self countadd];//计数器加1
        if (count<5) {
            [gesturePasswordView.state setTextColor:[UIColor redColor]];
            [gesturePasswordView.state setText:@"错误请重新输入"];
        }else{
            [gesturePasswordView.state setText:@"密码错误5次"];
            [self clear];
            [UserInfoTool saveInfo:nil];
            [CZHkeychin resetKeychainItem];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        return NO;
    }
}
- (void)countadd{
    count = count + 1;
}
- (void)countclear{
    count = 0;
}
- (BOOL)resetPassword:(NSString *)result{
    if ([previousString isEqualToString:@""]) {
        previousString=result;
        [gesturePasswordView.tentacleView enterArgin];
        [gesturePasswordView.state setTextColor:[UIColor whiteColor]];
        [gesturePasswordView.state setText:@"请验证输入密码"];
        return YES;
    }
    else {
        if ([result isEqualToString:previousString]) {
            
            KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
            [keychin setObject:@"CZH_Password" forKey:(__bridge id)kSecAttrAccount];
            [keychin setObject:result forKey:(__bridge id)kSecValueData];
            [gesturePasswordView.state setTextColor:[UIColor whiteColor]];
            [gesturePasswordView.state setText:@"已保存手势密码"];
            if ([self exist] == YES) {
                [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            }
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            
            return YES;
        }
        else{
            previousString =@"";
            [gesturePasswordView.state setTextColor:[UIColor redColor]];
            [gesturePasswordView.state setText:@"两次密码不一致，请重新输入"];
            return NO;
        }
    }
}

@end
