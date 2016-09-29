//
//  HttpRequestManager.m
//  爱限免
//
//  Created by huangdl on 14-11-21.
//  Copyright (c) 2014年 1000phone. All rights reserved.
//


#import "CacheManager.h"
@interface HttpRequest()<NSURLConnectionDataDelegate>
{
    NSMutableData *_data;
}
@end

@implementation HttpRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        _data = [[NSMutableData alloc]init];
    }
    return self;
}

-(void)startReqeust
{
    NSURLRequest *req = nil;
    if (_isPOST) {
        NSMutableURLRequest *req2 = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:_url]];
        req2.HTTPMethod = @"POST";
        
        NSString *str = @"";
        for (NSString *key in _params.allKeys) {
            str = [NSString stringWithFormat:@"%@&%@=%@",str,key,_params[key]];
        }
        
        str = [str substringFromIndex:1];
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        req2.HTTPBody = data;
        req = req2;
    }
    else
    {
        if (_isCached && !_isList && [[CacheManager sharedManager]isCacheExist:_url]) {
            _successCallback([[CacheManager sharedManager]getCache:_url]);
            return;
        }
        req = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
        
    }
    [NSURLConnection connectionWithRequest:req delegate:self];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_data setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (_isCached) {
        if (_isList) {
            [[CacheManager sharedManager]saveCache:_data withName:_cacheName withPage:_page];
        }
        else
        {
            [[CacheManager sharedManager]saveCache:_data withName:_cacheName];
        }
    }
    _resultData = _data;
    _successCallback(_data);
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    _failedCallback();
}



@end



@implementation HttpRequestManager
{
    NSMutableArray *_reqArray;
}
+(id)sharedManager
{
    static HttpRequestManager *_m = nil;
    if (!_m) {
        _m = [[HttpRequestManager alloc]init];
    }
    return _m;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _reqArray = [[NSMutableArray alloc]init];
    }
    return self;
}


//高内聚
-(void)GET:(NSString *)url success:(void (^)(NSData *))okCallback failed:(void (^)())failCallback
{
    [self GET:url success:okCallback failed:failCallback isCached:NO];
}

//-(void)GET:(NSString *)url success:(void(^)(NSData *))okCallback failed:(void(^)())failCallback isRefresh:(BOOL)refresh
//{
//    if (!refresh) {
//        for (HttpRequest *req in _reqArray) {
//            if ([req.url isEqualToString:url]) {
//                okCallback(req.resultData);
//                return;
//            }
//        }
//    }
//    
//    HttpRequest *req = [[HttpRequest alloc]init];
//    req.url = url;
//    req.successCallback = okCallback;
//    req.failedCallback = failCallback;
//    [req startReqeust];
//    [_reqArray addObject:req];
//    
//}

-(void)GET:(NSString *)url success:(void(^)(NSData *))okCallback failed:(void(^)())failCallback isCached:(BOOL)iscache
{
    [self GET:url success:okCallback failed:failCallback isCached:iscache isList:NO currentPage:0 cacheName:url];
}

-(void)GET:(NSString *)url 
   success:(void(^)(NSData *))okCallback 
    failed:(void(^)())failCallback 
  isCached:(BOOL)iscache 
    isList:(BOOL)islist 
currentPage:(NSInteger)page 
 cacheName:(NSString *)cachename
{
    HttpRequest *req = [[HttpRequest alloc]init];
    req.url = url;
    req.successCallback = okCallback;
    req.failedCallback = failCallback;
    req.isCached = iscache;
    req.isList = islist;
    req.page = page;
    req.cacheName = cachename;
    
    [req startReqeust];
    [_reqArray addObject:req];
}

-(void)POST:(NSString *)url params:(NSDictionary *)params success:(void(^)(NSData *))okCallback failed:(void(^)())failCallback
{
    HttpRequest *req = [[HttpRequest alloc]init];
    req.url = url;
    req.successCallback = okCallback;
    req.failedCallback = failCallback;
    
    req.isPOST = YES;
    req.params = params;
    
    [req startReqeust];
}



@end










