//
//  PoliceView.m
//  浦东网安
//
//  Created by jyc on 15/6/28.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//

#import "PoliceView.h"

@implementation PoliceView

+(instancetype)policeView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"PoliceView" owner:nil options:nil]firstObject];
}


@end
