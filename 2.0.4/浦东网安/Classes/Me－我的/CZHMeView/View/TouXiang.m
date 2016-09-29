//
//  TouXiang.m
//  浦东网安
//
//  Created by jiji on 15/6/25.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//

#import "TouXiang.h"

@interface TouXiang()


@end

@implementation TouXiang

+(instancetype)touXiang
{
    
    return [[[NSBundle mainBundle]loadNibNamed:@"TouXiang" owner:nil options:nil]lastObject];
}
@end
