//
//  NewsTableViewCell.m
//  浦东网安
//
//  Created by jiji on 15/7/6.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//

#import "NewsTableViewCell.h"
#import "News.h"

@implementation NewsTableViewCell

- (void)awakeFromNib {
    
    
    NSTimeInterval time=[self.news.UpdateTme doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    self.timeLable.text = currentDateStr;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
