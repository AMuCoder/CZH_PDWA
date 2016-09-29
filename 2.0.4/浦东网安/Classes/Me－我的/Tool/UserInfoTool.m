//
//  HWAccountTool.m
//  黑马微博2期
//
//  Created by apple on 14-10-12.
//  Copyright (c) 2014年 heima. All rights reserved.
//

// 账号的存储路径
#define HWAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userInfo.archive"]

#define JYCGroupPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"groupInfo.archive"]

#import "UserInfoTool.h"

@implementation UserInfoTool

/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+ (void)saveInfo:(UserInfo *)info
{
    // 自定义对象的存储必须用NSKeyedArchiver，不再有什么writeToFile方法
    [NSKeyedArchiver archiveRootObject:info toFile:HWAccountPath];
}


/**
 *  返回账号信息
 *
 *  @return 账号模型（如果账号过期，返回nil）
 */
+ (UserInfo *)info
{
    // 加载模型
    UserInfo *user = [NSKeyedUnarchiver unarchiveObjectWithFile:HWAccountPath];
    
    return user;
}

//+(void)saveGroupInfo:(GroupInfo *)groupInfo
//{
// [NSKeyedArchiver archiveRootObject:groupInfo toFile:JYCGroupPath];
//}
//
//+(GroupInfo *)groupInfo
//{
//    // 加载模型
//    GroupInfo *user = [NSKeyedUnarchiver unarchiveObjectWithFile:JYCGroupPath];
//    
//    
//    
//    return user;
//}
@end
