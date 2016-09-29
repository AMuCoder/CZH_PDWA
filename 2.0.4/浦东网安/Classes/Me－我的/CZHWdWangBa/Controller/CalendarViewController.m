//
//  ViewController.m
//  HYCalendar
//
//  Created by nathan on 14-9-27.
//  Copyright (c) 2014年 nathan. All rights reserved.
//

#import "CalendarViewController.h"
#import "CalendarView.h"

#import "UserInfo.h"
#import "UserInfoTool.h"
#import "KeychainItemWrapper.h"

#import "MJExtension.h"

@interface CalendarViewController ()

@end

@implementation CalendarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZHRGBColor(49, 174, 215);
    self.title = @"业主签到";
}
- (void)viewWillAppear:(BOOL)animated{
    CGSize size = [UIScreen mainScreen].bounds.size;
    CalendarView *calendarView = [[CalendarView alloc] init];
    calendarView.frame = CGRectMake(0, 0, size.width, size.height/2);
    [self.view addSubview:calendarView];
    calendarView.date = [NSDate date];
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
