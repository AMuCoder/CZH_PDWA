//
//  UserInfo.h
//  浦东网安
//
//  Created by jiji on 15/6/29.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;

@interface UserInfo : NSObject <NSCoding>

@property(nonatomic,copy)NSString *Answer;
@property(nonatomic,copy)NSString *Email;
@property(nonatomic,copy)NSString *PerName;
@property(nonatomic,copy)NSString *LastLoginTime;
@property(nonatomic,copy)NSString *IsOnline;
@property(nonatomic,copy)NSString *UserName;
@property(nonatomic,copy)NSString *Password;
@property(nonatomic,copy)NSString *UnitName;
@property(nonatomic,copy)NSString *RoleID;
@property(nonatomic,copy)NSString *GroupID;
@property(nonatomic,copy)NSString *Question;
@property(nonatomic,copy)NSString *Popedom;
@property(nonatomic,copy)NSString *UG_ID;
@property(nonatomic,copy)NSString *CreateTime;
@property(nonatomic,copy)NSString *Status;
@property(nonatomic,copy)NSString *IsLimit;
@property(nonatomic,copy)NSString *AuthorityTag;
@property(nonatomic,copy)NSString *UserID;
@property(nonatomic,copy)NSString *EquipmentInfo;
+(instancetype)userInfoWithDict:(NSDictionary *)dict;

@end
