//
//  HttpRequestManager.h
//  爱限免
//
//  Created by huangdl on 14-11-21.
//  Copyright (c) 2014年 1000phone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequest : NSObject

@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) void(^successCallback)(NSData *);
@property (nonatomic,copy) void(^failedCallback)();
@property (nonatomic,assign) BOOL isCached;
@property (nonatomic,assign) BOOL isList;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,copy) NSString *cacheName;

@property (nonatomic,strong) NSData *resultData;

//POST
@property (nonatomic,assign) BOOL isPOST;
@property (nonatomic,strong) NSDictionary *params;

-(void)startReqeust;

@end

@interface HttpRequestManager : NSObject

+(id)sharedManager;


//基本的数据请求
-(void)GET:(NSString *)url success:(void(^)(NSData *))okCallback failed:(void(^)())failCallback;


//刷新
//-(void)GET:(NSString *)url success:(void(^)(NSData *))okCallback failed:(void(^)())failCallback isRefresh:(BOOL)refresh;


//带有缓存参数的请求(本地化缓存)
-(void)GET:(NSString *)url success:(void(^)(NSData *))okCallback failed:(void(^)())failCallback isCached:(BOOL)iscache;


//适用于列表页的缓存请求
-(void)GET:(NSString *)url success:(void(^)(NSData *))okCallback failed:(void(^)())failCallback isCached:(BOOL)iscache isList:(BOOL)islist currentPage:(NSInteger)page cacheName:(NSString *)cachename;

//POST请求
-(void)POST:(NSString *)url params:(NSDictionary *)params success:(void(^)(NSData *))okCallback failed:(void(^)())failCallback;


@end








