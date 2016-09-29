//
//  CheckInfo.h
//  浦东网安
//
//  Created by Chun on 16/5/13.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckInfo : NSObject
@property(nonatomic,copy)NSString *checkInfo;
@property(nonatomic,copy)NSString *checkTime;
@property(nonatomic,copy)NSString *checkMan;
@property(nonatomic,copy)NSString *existProblem;
@property(nonatomic,copy)NSString *pic1;
@property(nonatomic,copy)NSString *checkID;
+ (instancetype)statusWithDict:(NSDictionary *)dict;
@end
