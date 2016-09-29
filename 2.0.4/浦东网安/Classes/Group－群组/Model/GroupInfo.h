//
//  GroupInfo.h
//  浦东网安
//
//  Created by jiji on 15/6/30.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupInfo : NSObject<NSCoding>
//UpdateTime = 1434556800000,
//noRead = 1,
//ID = 7,
//GroupInfoContents = <null>,
//UpdateUserID = ,
//GroupID = 2,
//GroupInfoTitle = 111,
//UpdateUserName = ,
//ReadUserID = ,
//GroupInfo_Url = http://pengyue-test.oicp.net:53529/image/9e87f4be-5563-4c08-82f2-ef3c86bcf073.png,
//Popedom = ,
//Status = 1,
//yesRead = 0

@property(nonatomic,copy)NSString *GroupInfoTitle;
@property(nonatomic,copy)NSString *GroupInfo_Url;
@property(nonatomic,copy)NSString *yesRead;
@property(nonatomic,copy)NSString *noRead;
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *GroupInfoContents;
@property(nonatomic,copy)NSString *GroupID;
@end
