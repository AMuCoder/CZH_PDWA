//
//  InfoDetailCell
//  浦东网安
//
//  Created by Chun on 16/5/11.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface InfoDetailCell : NSObject<NSCoding>

@property(nonatomic,copy)NSString *netBarAddress;//浦东新区
@property(nonatomic,copy)NSString *netBarNumber; //33333333333
@property(nonatomic,copy)NSString *netBarName;//长信网吧
@property(nonatomic,copy)NSString *netBarPhone;//电话号码
@property(nonatomic,copy)NSString *sysOnLineStatus;//正常
@property(nonatomic,copy)NSString *netBarLogo;
@property(nonatomic,copy)NSString *netBarID;
@property(nonatomic,copy)NSString *netBarManager;
@property(nonatomic,copy)NSString *netBarComputerNum;
@property(nonatomic,copy)NSString *businessStatus;
@property(nonatomic,copy)NSString *netBarType;
@property(nonatomic,copy)NSString *netBarManagerPhone;
@property(nonatomic,copy)NSString *memo;
@property(nonatomic,copy)NSString *nerBarInternet;
@property(nonatomic,copy)NSString *forPoliceStation;
@property(nonatomic,copy)NSString *iscollect;
@property(nonatomic,copy)NSString *userName;

@end
