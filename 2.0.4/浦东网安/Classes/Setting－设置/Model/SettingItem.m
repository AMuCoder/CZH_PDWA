//
//  settingItem.m
//  浦东网安
//
//  Created by jiji on 15/6/16.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//

#import "SettingItem.h"

@implementation SettingItem
+(instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title
{
    SettingItem *item = [[self alloc]init];
    item.icon = icon;
    item.title = title;
    return item;
}
@end
