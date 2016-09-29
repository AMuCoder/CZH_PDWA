//
//  AppDelegate.m
//  浦东网安
//
//  Created by jiji on 15/6/16.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//
#import "AppDelegate.h"
#import "ATAppUpdater.h"
#import "HYCalendarViewController.h"
#import "UserInfo.h"
#import "UserInfoTool.h"
#import "KeychainItemWrapper.h"
#import <AudioToolbox/AudioToolbox.h>
#import "PersonController.h"
#import "GesturePasswordController.h"
#import "LoginViewController.h"
@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //系统升级
    [[ATAppUpdater sharedUpdater] showUpdateWithForce];
    if ([UIDevice currentDevice].systemVersion.doubleValue>=8.0) {
        UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:nil];
        [application registerUserNotificationSettings:notiSettings];
    }
    return YES;
}
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}
//注册失败
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"Register Remote Notifications error:{%@}",error);
}
//获取token值
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    NSString *pushToken = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    KeychainItemWrapper * CZHToken = [[KeychainItemWrapper alloc]initWithIdentifier:@"IOSTOKEN" accessGroup:nil];
    [CZHToken setObject:pushToken forKey:(__bridge id)kSecAttrAccount];
    NSLog(@"%@",pushToken);
}

//前台接收到的消息在这里处理ios7.0
-(void)application:(UIApplication *)application didReceiveRemoteNotification: (NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler{
    //测试用
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:userInfo[@"messageType"] message:[NSString stringWithFormat:@"userInfo:\n%@",userInfo] delegate:self cancelButtonTitle:@"Cancek" otherButtonTitles:@"OK", nil];
//    [alert show];
    UserInfo *userinfo = [UserInfoTool info];
    KeychainItemWrapper *messtype = [[KeychainItemWrapper alloc]initWithIdentifier:@"messageTypes" accessGroup:nil];
    NSString *string = userInfo[@"messageType"];
    
    if (application.applicationState == UIApplicationStateActive) {
        
        AudioServicesPlaySystemSound(1007);//系统的通知声音
        
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);//震动
        
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        
        localNotification.userInfo = userInfo;
        
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        
        localNotification.alertBody = userInfo[@"aps"][@"alert"];
        
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
     
        [application setApplicationIconBadgeNumber:1];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"网警提示" message:[NSString stringWithFormat:@"您有一条新的消息:\n%@",userInfo[@"aps"][@"alert"]] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert1 show];
        
    } else if (application.applicationState == UIApplicationStateInactive){
        //如果是在后台挂起，用户点击进入是UIApplicationStateInactive这个状态
        GesturePasswordController *vc = [[GesturePasswordController alloc] init];
        //do it this.
        if ([string isEqualToString:@"1"] && userinfo) {
            HYCalendarViewController * VC = [[HYCalendarViewController alloc]init];
            [self.window.rootViewController presentViewController:VC animated:YES completion:nil];
        }else if ([vc exist] && !userinfo) {
            [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
        }else if (![vc exist] && !userinfo){
            LoginViewController *vc = [[LoginViewController alloc] init];
            [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
        }else{
            PersonController *vc = [[PersonController alloc] init];
            [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
        }
    }
    NSLog(@"---%@",userInfo[@"messageType"]);
    [messtype setObject:string forKey:(__bridge id)kSecAttrAccount];
    
}

//本地推送通知/////////////////////////////////////////////////
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler{
    completionHandler();//处理完消息，最后一定要调用这个代码块
}
- (void)applicationWillResignActive:(UIApplication *)application{
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    [application setApplicationIconBadgeNumber:0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
