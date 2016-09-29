//
//  Gesture1PasswordView.m
//  Gesture1Password
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

#import "Gesture1PasswordView.h"
#import "Gesture1PasswordButton.h"
#import "Tentacle1View.h"

@implementation Gesture1PasswordView {
    NSMutableArray * buttonArray;
    
    CGPoint lineStartPoint;
    CGPoint lineEndPoint;
    
}
@synthesize tentacle1View;
@synthesize state;
@synthesize gesturePasswordDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        buttonArray = [[NSMutableArray alloc]initWithCapacity:0];
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height/2-frame.size.height/3, frame.size.width, frame.size.width)];
        for (int i=0; i<9; i++) {
            NSInteger row = i/3;
            NSInteger col = i%3;
            // Button Frame
            
            NSInteger distance = frame.size.width/3;
            NSInteger size = distance/1.5;
            NSInteger margin = size/4;
            Gesture1PasswordButton * gesture1PasswordButton = [[Gesture1PasswordButton alloc]initWithFrame:CGRectMake(col*distance+margin, row*distance, size, size)];
            [gesture1PasswordButton setTag:i];
            [view addSubview:gesture1PasswordButton];
            [buttonArray addObject:gesture1PasswordButton];
        }
        frame.origin.y=0;
        [self addSubview:view];
        tentacle1View = [[Tentacle1View alloc]initWithFrame:view.frame];
        [tentacle1View setButtonArray:buttonArray];
        [tentacle1View setTouchBeginDelegate:self];
        [self addSubview:tentacle1View];
        
        state = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2-140, frame.size.height/2-frame.size.height/3-frame.size.height/8, 280, 30)];
        [state setTextAlignment:NSTextAlignmentCenter];
        [state setFont:[UIFont systemFontOfSize:18.f]];
        [self addSubview:state];
    }
    
    return self;
}
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat colors[] =
    {
        134 / 255.0, 157 / 255.0, 147 / 255.0, 1.00,
        3 / 255.0,  3 / 255.0, 37 / 255.0, 1.00,
    };
    CGGradientRef gradient = CGGradientCreateWithColorComponents
    (rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
    CGColorSpaceRelease(rgb);
    CGContextDrawLinearGradient(context, gradient,CGPointMake
                                (0.0,0.0) ,CGPointMake(0.0,self.frame.size.height),
                                kCGGradientDrawsBeforeStartLocation);
}

- (void)gestureTouchBegin {
    [self.state setText:@"请滑动密码"];
    self.state.textColor = [UIColor whiteColor];
}

-(void)change{
    [gesturePasswordDelegate change];
}


@end
