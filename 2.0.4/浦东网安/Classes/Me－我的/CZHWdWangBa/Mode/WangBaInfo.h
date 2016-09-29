//
//  WangBaInfo.h
//  浦东网安
//
//  Created by Chun on 16/5/10.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WangBaInfo : NSObject<NSCoding>
/*
//
//
 {"result":[{"netBarNumber":"12312312","netBarAddress":"朝阳区","ID":"1","netBarID":"2222","netBarName":"时空网吧","NetBarManager":"向航涵"}],"return":{"message":"查询成功","code":"1"}}
//
 UILabel *WangBaname;//网吧名
 UILabel *FuZeRen;//负责人
 UIImageView *WangBaimage;//网吧头像图片
 UILabel *diZhi;//网吧地址
//
*/
@property(nonatomic,copy)NSString *netBarNumber; //网吧号
@property(nonatomic,copy)NSString *netBarAddress;//UILabel *diZhi;//网吧地址
@property(nonatomic,copy)NSString *netBarID;     //网吧id
@property(nonatomic,copy)NSString *ID; 
@property(nonatomic,copy)NSString *netBarName;   //UILabel *WangBaname;//网吧名
@property(nonatomic,copy)NSString *NetBarManager;//UILabel *FuZeRen;//负责人
@end
