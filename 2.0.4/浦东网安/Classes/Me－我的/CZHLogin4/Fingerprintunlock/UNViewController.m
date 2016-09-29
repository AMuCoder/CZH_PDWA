//
//  UNViewController.m
//  指纹和数字
//
//  Created by Chun on 16/4/18.
//  Copyright © 2016年 Chun. All rights reserved.
//

#import "UNViewController.h"
#import "LocalAuthentication/LAContext.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "HomeViewController.h"
@interface UNViewController ()
@end

@implementation UNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建安全验证对象
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *myLocalizedReasonString = @"请输入指纹";
    NSString *mymath = @"请输入密码";
    __block  NSString *msg;
    
    //判断是否有指纹识别功能
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                      localizedReason:myLocalizedReasonString
                                reply:^(BOOL success, NSError *error) {
                                if (success) {
                                        // User authenticated successfully, take appropriate action
                                        //验证成功，主线程处理UI
                                    msg =[NSString stringWithFormat:NSLocalizedString(@"SUCCESS", nil)];
                                } else {
                                        // User did not authenticate successfully, look at error and take appropriate action
                                    msg = [NSString stringWithFormat:NSLocalizedString(@"ERROR", nil), error.localizedDescription];
                                    switch (error.code) {
                                        case LAErrorSystemCancel:
                                        {
                                            NSLog(@"Authentication was cancelled by the system");
                                                //切换到其他APP，系统取消验证Touch ID
                                            break;
                                        }
                                        case LAErrorUserCancel:
                                        {
                                            NSLog(@"Authentication was cancelled by the user");
                                                //用户取消验证Touch ID
                                            break;
                                        }
                                        case LAErrorUserFallback:
                                        {
                                            NSLog(@"User selected to enter custom password");
                                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                    //用户选择其他验证方式，切换主线程处理
                                            }];
                                            break;
                                        }
                                        default:
                                        {
                                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                    //其他情况，切换主线程处理
                                            }];
                                            break;
                                        }
                                    }
                                }
                            }];
} else {
            [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthentication
                      localizedReason:mymath
                                reply:^(BOOL success, NSError *error) {
                                    if (success) {
                                        msg =[NSString stringWithFormat:NSLocalizedString(@"SUCCESS", nil)];
                                    } else {
                                        msg = [NSString stringWithFormat:NSLocalizedString(@"ERROR", nil), error.localizedDescription];
                                    }
                                }];
    }
}
    @end