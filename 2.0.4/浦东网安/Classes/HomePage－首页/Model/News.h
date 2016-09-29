//
//  News.h
//  浦东网安
//
//  Created by jyc on 15/6/21.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject
//"ID": 24,
//"Title": "koon",
//"Contents": "",
//"News_Url": "",
//"New_classname": "公益广告",
//"UpdateTme": "1435378820000",
//"UpdateUserID": "2",
//"UpdateUserName": "ceshi"
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *Title;
@property(nonatomic,copy)NSString *Contents;
@property(nonatomic,copy)NSString *News_Url;
@property(nonatomic,copy)NSString *New_classname;
@property(nonatomic,copy)NSString *UpdateTme;
@property(nonatomic,copy)NSString *UpdateUserID;
@property(nonatomic,copy)NSString *UpdateUserName;
@end
