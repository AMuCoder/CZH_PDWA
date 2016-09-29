//
//  SettingArrowItem.m
//  浦东网安
//
//  Created by jiji on 15/6/16.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//

#import "SettingArrowItem.h"

@implementation SettingArrowItem
+(instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass
{
    SettingArrowItem *item = [super itemWithIcon:icon title:title];
    item.destVcClass = destVcClass;
    return item;
}
@end
