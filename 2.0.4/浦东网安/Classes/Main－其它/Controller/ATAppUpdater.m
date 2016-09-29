//
//  ATAppUpdater.m
//  浦东网安
//
//  Created by Chun on 16/2/2.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import "ATAppUpdater.h"

@implementation ATAppUpdater


#pragma mark - Init


+ (id)sharedUpdater
{
    static ATAppUpdater *sharedUpdater;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUpdater = [[ATAppUpdater alloc] init];
    });
    return sharedUpdater;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.alertTitle = @"新版本升级";
        self.alertMessage = @"AppStore有新版本Version %@";
        self.alertUpdateButtonTitle = @"升级";
        self.alertCancelButtonTitle = @"取消";
    }
    return self;
}


#pragma mark - Instance Methods


- (void)showUpdateWithForce
{
    BOOL hasConnection = [self hasConnection];
    if (!hasConnection) return;
    
    [self checkNewAppVersion:^(BOOL newVersion, NSString *version) {
        if (newVersion) {
            [[self alertUpdateForVersion:version withForce:YES] show];
        }
    }];
}

- (void)showUpdateWithConfirmation
{
    BOOL hasConnection = [self hasConnection];
    if (!hasConnection) return;
    
    [self checkNewAppVersion:^(BOOL newVersion, NSString *version) {
        if (newVersion) {
            [[self alertUpdateForVersion:version withForce:NO] show];
        }
    }];
}

- (void)forceOpenNewAppVersion:(BOOL)force
{
    BOOL hasConnection = [self hasConnection];
    if (!hasConnection) return;
    
    [self checkNewAppVersion:^(BOOL newVersion, NSString *version) {
        if (newVersion) {
            [[self alertUpdateForVersion:version withForce:force] show];
        }
    }];
}


#pragma mark - Private Methods


- (BOOL)hasConnection
{
    const char *host = "itunes.apple.com";
    BOOL reachable;
    BOOL success;
    
    // Link SystemConfiguration.framework! <SystemConfiguration/SystemConfiguration.h>
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host);
    SCNetworkReachabilityFlags flags;
    success = SCNetworkReachabilityGetFlags(reachability, &flags);
    reachable = success && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
    CFRelease(reachability);
    return reachable;
}

NSString *appStoreURL = nil;

- (void)checkNewAppVersion:(void(^)(BOOL newVersion, NSString *version))completion
{
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleIdentifier = bundleInfo[@"CFBundleIdentifier"];
    NSString *currentVersion = bundleInfo[@"CFBundleShortVersionString"];
    NSURL *lookupURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@", bundleIdentifier]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void) {
        
        NSData *lookupResults = [NSData dataWithContentsOfURL:lookupURL];
        if (!lookupResults) {
            completion(NO, nil);
            return;
        }
        
        NSDictionary *jsonResults = [NSJSONSerialization JSONObjectWithData:lookupResults options:0 error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            NSUInteger resultCount = [jsonResults[@"resultCount"] integerValue];
            if (resultCount){
                NSDictionary *appDetails = [jsonResults[@"results"] firstObject];
                NSString *appItunesUrl = [appDetails[@"trackViewUrl"] stringByReplacingOccurrencesOfString:@"&uo=4" withString:@""];
                NSString *latestVersion = appDetails[@"version"];
                if ([latestVersion compare:currentVersion options:NSNumericSearch] == NSOrderedDescending) {
                    appStoreURL = appItunesUrl;
                    completion(YES, latestVersion);
                } else {
                    completion(NO, nil);
                }
            } else {
                completion(NO, nil);
            }
        });
    });
}

- (UIAlertView *)alertUpdateForVersion:(NSString *)version withForce:(BOOL)force
{
    NSString *msg = [NSString stringWithFormat:self.alertMessage, version];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.alertTitle message:msg delegate:self cancelButtonTitle:force ? nil:self.alertUpdateButtonTitle otherButtonTitles:force ? self.alertUpdateButtonTitle:self.alertCancelButtonTitle, nil];
    return alert;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSURL *appUrl = [NSURL URLWithString:appStoreURL];
        if ([[UIApplication sharedApplication] canOpenURL:appUrl]) {
            [[UIApplication sharedApplication] openURL:appUrl];
        } else {
            UIAlertView *cantOpenUrlAlert = [[UIAlertView alloc] initWithTitle:@"Not Available" message:@"Could not open the AppStore, please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [cantOpenUrlAlert show];
        }
    }
}

@end
