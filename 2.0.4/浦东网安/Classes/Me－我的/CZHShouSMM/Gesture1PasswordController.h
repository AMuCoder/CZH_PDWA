//
//  Gesture1PasswordController.h
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "Tentacle1View.h"
#import "Gesture1PasswordView.h"

@interface Gesture1PasswordController : UIViewController <VerificationDelegate,ResetDelegate,GesturePasswordDelegate>//

- (void)clear;

- (BOOL)exist;

@end
