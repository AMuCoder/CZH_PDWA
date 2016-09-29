//
//  MyCalendarItem.m
//  HYCalendar
//
//  Created by nathan on 14-9-17.
//  Copyright (c) 2014年 nathan. All rights reserved.
//

#import "CalendarView.h"
#import "Qian.h"

#import "UserInfo.h"
#import "UserInfoTool.h"
#import "KeychainItemWrapper.h"

#import "Qian.h"
#import "MJExtension.h"
@implementation CalendarView
{
    UIButton  *_selectButton;
    NSMutableArray *_daysArray;
}
-(NSDictionary *)signss
{
    if (!_signss) {
        self.signss = [NSDictionary dictionary];
    }
    return _signss;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    //    self.backgroundColor = [UIColor grayColor];
    if (self) {
        _daysArray = [NSMutableArray arrayWithCapacity:42];
        for (int i = 0; i < 42; i++) {
            UIButton *button = [[UIButton alloc] init];
            [self addSubview:button];
            [_daysArray addObject:button];
        }
    }
    return self;
}
#pragma mark - create View
- (void)setDate:(NSDate *)date{
    KeychainItemWrapper * CZHnetBarManager = [[KeychainItemWrapper alloc]initWithIdentifier:@"CZHnetBarManager" accessGroup:nil];
    NSString *username = [CZHnetBarManager objectForKey:(__bridge id)kSecAttrAccount];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userName"] = username;
    [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"/getSignlog"] params:params success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *messageArr = dic[@"result"];
        /*
         userName = py,
         signInDate = 2016-05-02 23:24:23,2016-05-04 12:21:11
         */
        _signss = [NSDictionary dictionaryWithDictionary:messageArr[0]];
        NSString *signinDate= [NSString stringWithFormat:@"%@",[_signss objectForKey:@"signInDate"]];
        //NSLog(@"signss-----%lu",(unsigned long)_signss.count);
        /*
         signinDate:--------2016-05-02 23:24:23,2016-05-04 12:21:11
         */
        _sign = [self separateStringWithStr:signinDate];
        //        NSMutableArray * signArray = [self separateStringWithArray:sign];
        for (int i = 0; i < [_sign count]; i++) {
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
            NSDate *date1 =[dateFormat dateFromString:_sign[i]];
            _date = date1;
            [self createCalendarViewWith:date1];
        }
    }failed:^{
        _date = date;
        [self createCalendarViewWith:date];
    }];
}

- (void)createCalendarViewWith:(NSDate *)date{
    
    CGFloat itemW     = self.frame.size.width / 7;
    CGFloat itemH     = self.frame.size.height / 7;
    
    // 1.year month
    UILabel *headlabel = [[UILabel alloc] init];
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    NSString *currentDateStr = [dateFormat stringFromDate:[NSDate date]];
    NSString *currentDateStr2 = [currentDateStr substringWithRange:NSMakeRange(0, 10)];
    headlabel.text     = currentDateStr2;
    headlabel.frame           = CGRectMake(0, 0, self.frame.size.width-10, itemH);
    headlabel.textAlignment   = NSTextAlignmentCenter;
    [self addSubview:headlabel];
    
    // 2.weekday
    NSArray *array = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    UIView *weekBg = [[UIView alloc] init];
    weekBg.backgroundColor = [UIColor clearColor];
    weekBg.frame = CGRectMake(0, CGRectGetMaxY(headlabel.frame), self.frame.size.width, itemH);
    [self addSubview:weekBg];
    
    for (int i = 0; i < 7; i++) {
        UILabel *week = [[UILabel alloc] init];
        week.text     = array[i];
        week.font     = [UIFont systemFontOfSize:20];
        week.frame    = CGRectMake(itemW * i, 0, itemW, 32);
        week.textAlignment   = NSTextAlignmentCenter;
        week.backgroundColor = [UIColor clearColor];
        week.textColor       = [UIColor whiteColor];
        [weekBg addSubview:week];
    }
    //  3.days (1-31)
    for (int i = 0; i < 42; i++) {
        
        int x = (i % 7) * itemW ;
        int y = (i / 7) * itemH + CGRectGetMaxY(weekBg.frame);
        
        UIButton *dayButton = _daysArray[i];
        dayButton.frame = CGRectMake(x, y, itemW, itemH);
        dayButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
        dayButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        dayButton.layer.cornerRadius = 5.0f;
        [dayButton addTarget:self action:@selector(logDate:) forControlEvents:UIControlEventTouchUpInside];
        
        NSInteger daysInLastMonth = [CalendarTool totaldaysInMonth:[CalendarTool lastMonth:date]];
        NSInteger daysInThisMonth = [CalendarTool totaldaysInMonth:date];
        NSInteger firstWeekday    = [CalendarTool firstWeekdayInThisMonth:date];
        NSInteger day = 0;
        
        
        if (i < firstWeekday) {
            day = daysInLastMonth - firstWeekday + i + 1;
            [self setStyle_BeyondThisMonth:dayButton];
            
        }else if (i > firstWeekday + daysInThisMonth - 1){
            day = i + 1 - firstWeekday - daysInThisMonth;
            [self setStyle_BeyondThisMonth:dayButton];
            
        }else{
            day = i - firstWeekday + 1;
            [self setStyle_AfterToday:dayButton];
        }
        
        [dayButton setTitle:[NSString stringWithFormat:@"%li", (long)day] forState:UIControlStateNormal];
        
        if ([CalendarTool month:date] == [CalendarTool month:[NSDate date]]) {
            NSInteger todayIndex =[CalendarTool day:date] + firstWeekday-1;
            if(i ==  todayIndex){
                //本月今天
                [self setStyle_Today1:dayButton];
                _dayButton = dayButton;
            }
        }
    }
}
#pragma mark - output date
-(void)logDate:(UIButton *)dayBtn
{
    _selectButton.selected = NO;
    dayBtn.selected = YES;
    _selectButton = dayBtn;
}

/*
 
 */
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
#pragma mark - date button style
//1.设置不是本月的日期字体颜色   ---白色  看不到
- (void)setStyle_BeyondThisMonth:(UIButton *)btn
{
    btn.enabled = NO;
    [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
}
//这个月今天之后的日期style
- (void)setStyle_AfterToday:(UIButton *)btn
{
    btn.enabled = YES;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
//今日之前已签到
- (void)setStyle_BeforeToday1:(UIButton *)btn
{
    btn.enabled = NO;
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor grayColor]];
}
//今日之前未签到
- (void)setStyle_BeforeToday2:(UIButton *)btn
{
    btn.enabled = NO;
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}
//今日签到
- (void)setStyle_Today1:(UIButton *)btn
{
    btn.enabled = YES;
    [btn setBackgroundColor:[UIColor grayColor]];
}
//今日未签到
- (void)setStyle_Today2:(UIButton *)btn
{
    btn.enabled = YES;
}

@end
//
//    NSInteger day = [[dayBtn titleForState:UIControlStateNormal] integerValue];
//
//    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.date];
//
//    if (self.calendarBlock) {
//        self.calendarBlock(day, [comp month], [comp year]);
//    }