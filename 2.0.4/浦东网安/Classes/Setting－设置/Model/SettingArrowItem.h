//
//  SettingArrowItem.h
//  浦东网安
//
//  Created by jiji on 15/6/16.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//

#import "SettingItem.h"

@interface SettingArrowItem : SettingItem
@property(nonatomic,assign)Class destVcClass;
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass;
@end
