//
//  Gesture1PasswordController.m
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

#import <Security/Security.h>
#import <CoreFoundation/CoreFoundation.h>
#import "Gesture1PasswordController.h"
#import "KeychainItemWrapper.h"
#import "UserInfo.h"
#import "UserInfoTool.h"

#import "User.h"
#import "MJExtension.h"
#import "JYCTabBar.h"
#import "NSString+Hash.h"


@interface Gesture1PasswordController ()<UIGestureRecognizerDelegate>

@property (nonatomic,strong) Gesture1PasswordView * gesture1PasswordView;

@end

@implementation Gesture1PasswordController {
    NSString * previousString;
    NSString * password;
}

@synthesize gesture1PasswordView;

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
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"titleView"]];
    UserInfo *info = [UserInfoTool info];
    previousString = [NSString string];
    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
    password = [keychin objectForKey:(__bridge id)kSecValueData];
    if ([password isEqualToString:@""] && info) {
        [self reset];
    }else if(![password isEqualToString:@""] && info){
        [self change];
    }
}

#pragma mark - 验证手势密码
- (void)verify{
    gesture1PasswordView = [[Gesture1PasswordView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [gesture1PasswordView.tentacle1View setRerificationDelegate:self];
    [gesture1PasswordView.tentacle1View setStyle:1];
    [gesture1PasswordView setGesturePasswordDelegate:self];
    [self.view addSubview:gesture1PasswordView];
}
- (BOOL)verification:(NSString *)result{
    if ([result isEqualToString:password]) {
        [gesture1PasswordView.state setTextColor:[UIColor whiteColor]];
        [gesture1PasswordView.state setText:@"输入正确"];
        return YES;
    }
    [gesture1PasswordView.state setTextColor:[UIColor redColor]];
    [gesture1PasswordView.state setText:@"手势密码错误"];
    return NO;
}


#pragma mark - 重置手势密码
- (void)reset{
    gesture1PasswordView = [[Gesture1PasswordView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [gesture1PasswordView.tentacle1View setResetDelegate:self];
    [gesture1PasswordView.tentacle1View setStyle:2];
    [self.view addSubview:gesture1PasswordView];
}
- (BOOL)resetPassword:(NSString *)result{
    if ([previousString isEqualToString:@""]){
        previousString=result;
        [gesture1PasswordView.tentacle1View enterArgin];
        [gesture1PasswordView.state setTextColor:[UIColor whiteColor]];
        [gesture1PasswordView.state setText:@"请验证输入密码"];
        return YES;
    }else{//1.前面不满足跳转到这个里面
        
        if (previousString.length < 4) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改失败" message:@"请至少连接4个圆圈" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            return NO;
            
        }else{//2.前面不满足跳转到这里
        
            if ([result isEqualToString:previousString]) {
            
                KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
            
                [keychin setObject:@"CZH_Password" forKey:(__bridge id)kSecAttrAccount];
            
                [keychin setObject:result forKey:(__bridge id)kSecValueData];
            
                [gesture1PasswordView.state setTextColor:[UIColor whiteColor]];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"密码修改成功" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
                
                //从keychain里取出帐号密码
                KeychainItemWrapper * CZHkeychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"PDWA" accessGroup:nil];
                NSString *loginusername = [CZHkeychin objectForKey:(__bridge id)kSecAttrAccount];
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                params[@"userName"] =loginusername;
                params[@"handPassword"] = result;
                [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"/user_HandPassword"] params:params success:^(NSData *data) {
                }failed:^{
                }];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            
                return YES;
        
            }else{
            
                previousString =@"";
            
                [gesture1PasswordView.state setTextColor:[UIColor redColor]];
            
                [gesture1PasswordView.state setText:@"两次密码不一致，请重新输入"];
            
                return NO;
        
            }
    
        }

    }
}
#pragma mark - 改变手势密码
- (void)change{
    [self reset];
}
#pragma mark - 判断是否已存在手势密码
- (BOOL)exist{
    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
    password = [keychin objectForKey:(__bridge id)kSecValueData];
    if ([password isEqualToString:@""])return NO;
    return YES;
}

#pragma mark - 清空记录
- (void)clear{
    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
    [keychin resetKeychainItem];
}



@end
