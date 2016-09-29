//
//  Gesture1PasswordView.h
//  Gesture1Password
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tentacle1View.h"
@protocol GesturePasswordDelegate <NSObject>

- (void)change;

@end


@interface Gesture1PasswordView : UIView<TouchBeginDelegate>

@property (nonatomic,strong) Tentacle1View * tentacle1View;

@property (nonatomic,strong) UILabel * state;

@property (nonatomic,assign) id<GesturePasswordDelegate> gesturePasswordDelegate;

@end
