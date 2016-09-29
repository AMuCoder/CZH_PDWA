//
//  User.h
//  浦东网安
//
//  Created by jiji on 15/6/29.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
//Answer = <null>,
//Email = <null>,
//PerName = 测试昵称1,
//LastLoginTime = -62135596800000,
//IsOnline = 0,
//UserName = ceshi,
//Password = <null>,
//UnitName = 测试单位1,
//RoleID = <null>,
//GroupID = 1,
//Question = <null>,
//Popedom = 测试辖区1,
//UG_ID = 0,
//CreateTime = -62135596800000,
//Status = 0,
//IsLimit = 0,
//AuthorityTag = _Add,
//UserID = 2

@property(nonatomic,copy)NSString *message;
@property(nonatomic,copy)NSString *code;
@end
