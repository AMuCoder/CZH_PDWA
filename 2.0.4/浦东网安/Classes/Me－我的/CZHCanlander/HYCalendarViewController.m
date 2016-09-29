//
//  ViewController.m
//  HYCalendar
//
//  Created by nathan on 14-9-27.
//  Copyright (c) 2014年 nathan. All rights reserved.
//

#import "HYCalendarViewController.h"
#import "HYCalendarView.h"

#import "UserInfo.h"
#import "UserInfoTool.h"
#import "KeychainItemWrapper.h"

#import "Qian.h"
#import "MJExtension.h"

@interface HYCalendarViewController ()
@end

@implementation HYCalendarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    KeychainItemWrapper * messtype = [[KeychainItemWrapper alloc]initWithIdentifier:@"messageTypes" accessGroup:nil];
    [messtype resetKeychainItem];
    self.view.backgroundColor = CZHRGBColor(49, 174, 215);
//    self.title = @"业主签到";
    //创建一个导航栏
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    //创建一个导航栏集合
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    //创建一个左边按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(rebackToRootViewAction)];
    leftButton.tintColor = [UIColor whiteColor];
    //设置导航栏的内容
    [navItem setTitle:@"业主签到"];
    //把导航栏集合添加到导航栏中，设置动画关闭
    [navBar pushNavigationItem:navItem animated:NO];
    //把左右两个按钮添加到导航栏集合中去
    [navItem setLeftBarButtonItem:leftButton];
    //将标题栏中的内容全部添加到主视图当中
    navBar.barTintColor = CZHRGBColor(49, 174, 215);
    [self.view addSubview:navBar];
}
- (void)viewWillAppear:(BOOL)animated{
    KeychainItemWrapper * messtype = [[KeychainItemWrapper alloc]initWithIdentifier:@"messageTypes" accessGroup:nil];
    [messtype resetKeychainItem];
    _btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 4*self.view.frame.size.height/5, self.view.frame.size.width-20, 40)];
    [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_btn addTarget:self action:@selector(qiandao) forControlEvents:UIControlEventTouchUpInside];
    _btn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_bg_1"]];
    _btn.layer.cornerRadius = 5.0;
    [self.view addSubview:_btn];
    
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    HYCalendarView *calendarView = [[HYCalendarView alloc] init];
    calendarView.frame = CGRectMake(0, 64, size.width, size.height/2);
    [self.view addSubview:calendarView];
    calendarView.date = [NSDate date];
    //NSLog(@"=============%@",[NSDate date]);
    
    KeychainItemWrapper * CZHkeychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"PDWA" accessGroup:nil];
    NSString *loginusername = [CZHkeychin objectForKey:(__bridge id)kSecAttrAccount];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userName"] = loginusername;
    [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"/getSignlog"] params:params success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *messageArr = dic[@"result"];
        //NSLog(@"messageArr:--------%@",messageArr);
        NSDictionary *signss = [NSDictionary dictionaryWithDictionary:messageArr[0]];
        NSString *signinDate= [NSString stringWithFormat:@"%@",[signss objectForKey:@"signInDate"]];
        //NSLog(@"signinDate:--------%@",signinDate);
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
        NSString *currentDateStr = [dateFormat stringFromDate:[NSDate date]];
        NSString *currentDateStr2 = [currentDateStr substringWithRange:NSMakeRange(1, 10)];
        if([signinDate rangeOfString:currentDateStr2].location != NSNotFound){
            _btn.enabled = NO;
        }else{
            _btn.enabled = YES;
        }
        [_btn setTitle:@"今日已经签到过了,明天再来!" forState:UIControlStateDisabled];
        [self.btn setBackgroundImage:[UIImage imageNamed:@"gray"] forState:UIControlStateDisabled];
        [_btn setTitle:@"签到" forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(qiandao) forControlEvents:UIControlEventTouchUpInside];
    }failed:^{
        [_btn setTitle:@"网络连接错误" forState:UIControlStateNormal];
        //[MBProgressHUD showError:@"请检查网络!"];
    }];
}
-(void)qiandao{
    KeychainItemWrapper * CZHkeychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"PDWA" accessGroup:nil];
    NSString *loginusername = [CZHkeychin objectForKey:(__bridge id)kSecAttrAccount];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userName"] = loginusername;
    //NSLog(@"%@",loginusername);
    [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"/user_SignIn"] params:params success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSString *message = dic[@"return"][@"message"];
        if([message isEqualToString:@"今日已经签到过了"]){
            _btn.enabled = NO;
        }else{
            _btn.enabled = YES;
        }
        [_btn setTitle:@"今日已经签到过了,明天再来!" forState:UIControlStateDisabled];
        [_btn setTitle:@"签到" forState:UIControlStateNormal];
        [MBProgressHUD showSuccess:message];
    }failed:^{
        [MBProgressHUD showError:@"登录错误，请检查网络!"];
    }];
}

- (NSArray *)separateStringWithStr:(NSString *)str{
    NSArray *array = [str componentsSeparatedByString:@","];
    return array;
}
- (NSMutableArray *)separateStringWithArray:(NSArray *)array{
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSString *str in array) {
        NSArray *strArray = [str componentsSeparatedByString:@" "];
        [dataArray addObject:strArray[0]];
        
    }
    
    return dataArray;
}

- (void)rebackToRootViewAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
