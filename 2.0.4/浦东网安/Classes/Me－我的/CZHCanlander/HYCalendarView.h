//
//  MyCalendarItem.h
//  HYCalendar
//
//  Created by nathan on 14-9-17.
//  Copyright (c) 2014年 nathan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYCalendarTool.h"

@interface HYCalendarView : UIView


@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) void(^calendarBlock)(NSInteger day, NSInteger month, NSInteger year);

//今天
@property (nonatomic,strong)  UIButton *dayButton;
@property (nonatomic,strong)  NSArray *sign;
@property (nonatomic,strong)  NSDictionary *signss;

@end
