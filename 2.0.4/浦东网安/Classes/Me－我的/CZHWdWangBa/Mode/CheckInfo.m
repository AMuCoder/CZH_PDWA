//
//  CheckInfo.m
//  浦东网安
//
//  Created by Chun on 16/5/13.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import "CheckInfo.h"

#import "MJExtension.h"
@implementation CheckInfo


+ (instancetype)statusWithDict:(NSDictionary *)dict
{
    CheckInfo *checkInfo = [[self alloc] init];
    [checkInfo setValuesForKeysWithDictionary:dict];
    return checkInfo;
}
@end
