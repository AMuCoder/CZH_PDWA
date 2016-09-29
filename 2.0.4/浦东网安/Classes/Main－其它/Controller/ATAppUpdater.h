//
//  ATAppUpdater.h
//  浦东网安
//
//  Created by Chun on 16/2/2.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>

@interface ATAppUpdater : NSObject <UIAlertViewDelegate>

/** Shared instance. [ATAppUpdater sharedUpdater] */
+ (id)sharedUpdater;

/** Checks for newer version and show alert without a cancel button. */
- (void)showUpdateWithForce;

/** Checks for newer version and show alert with a cancel button. */
- (void)showUpdateWithConfirmation;

/** Checks for newer version and show alert with or without a cancel button. */
- (void)forceOpenNewAppVersion:(BOOL)force
__attribute((deprecated("Use 'showUpdateWithForce' or 'showUpdateWithConfirmation' instead.")));

/** Set the UIAlertView title. NSLocalizedString() supported. */
@property (nonatomic, weak) NSString *alertTitle;

/** Set the UIAlertView alert message. NSLocalizedString() supported. */
@property (nonatomic, weak) NSString *alertMessage;

/** Set the UIAlertView update button's title. NSLocalizedString() supported. */
@property (nonatomic, weak) NSString *alertUpdateButtonTitle;

/** Set the UIAlertView cancel button's title. NSLocalizedString() supported. */
@property (nonatomic, weak) NSString *alertCancelButtonTitle;

@end