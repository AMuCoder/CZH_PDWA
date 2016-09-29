//
//  CacheManager.h
//  爱限免
//
//  Created by huangdl on 14-11-21.
//  Copyright (c) 2014年 1000phone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheManager : NSObject

+(id)sharedManager;

-(BOOL)isCacheExist:(NSString *)name;

-(NSData *)getCache:(NSString *)name;

-(void)saveCache:(NSData *)data withName:(NSString *)name;

-(void)saveCache:(NSData *)data withName:(NSString *)name withPage:(NSInteger)page;

@end







