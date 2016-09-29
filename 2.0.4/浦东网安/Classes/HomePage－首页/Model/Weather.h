//
//  Weather.h
//  浦东网安
//
//  Created by jiji on 16/1/14.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weather : NSObject
@property(nonatomic,copy)NSString *dayPictureUrl;
@property(nonatomic,copy)NSString *nightPictureUrl;
@property(nonatomic,copy)NSString *weather;
@property(nonatomic,copy)NSString *wind;
@property(nonatomic,copy)NSString *temperature;
@end
