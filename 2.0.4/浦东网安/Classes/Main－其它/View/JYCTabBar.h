//
//  JYCTabBar.h
//  浦东网安
//
//  Created by jyc on 15/6/21.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JYCTabBar;
@protocol JYCTabBarDelegate <NSObject>

@optional
-(void)tabBar:(JYCTabBar *)tabBar didSelectIndex:(NSInteger)index;

@end
@interface JYCTabBar : UIView
@property(nonatomic,weak)UIButton *selectedBtn;
@property(nonatomic,weak)id<JYCTabBarDelegate>delegate;
-(void)addTabBarButtonWithImage:(NSString *)image selImage:(NSString *)selImage;

@end
