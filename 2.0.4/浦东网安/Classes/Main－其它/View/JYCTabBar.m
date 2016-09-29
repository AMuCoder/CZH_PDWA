//
//  JYCTabBar.m
//  浦东网安
//
//  Created by jyc on 15/6/21.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//

#import "JYCTabBar.h"
#import "JycButton.h"

@interface JYCTabBar()

@end
@implementation JYCTabBar

-(void)addTabBarButtonWithImage:(NSString *)image selImage:(NSString *)selImage
{
    JycButton *btn = [[JycButton alloc]init];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selImage] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:btn];
     
}

- (void)btnClick:(UIButton *)button
{
    // 取消之前选择按钮
    _selectedBtn.selected = NO;
    // 选中当前按钮
    button.selected = YES;
    // 记录当前选中按钮
    _selectedBtn = button;
   
    // 切换控制器
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectIndex:)]) {
        [self.delegate tabBar:self didSelectIndex:button.tag];
    }
    
}

//#warning 设置按钮的位置
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat btnW = self.bounds.size.width / self.subviews.count;
    CGFloat btnH = self.bounds.size.height;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
   
    // 设置按钮的尺寸
    for (int i = 0; i < self.subviews.count; i++) {
        UIButton *btn = self.subviews[i];
        
        // 绑定角标
        btn.tag = i;
        
        btnX = i * btnW;
        
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
      //   默认选中第一个按钮
        if (i == 0) {
            [self btnClick:btn];
        }
            }
    
}


@end
