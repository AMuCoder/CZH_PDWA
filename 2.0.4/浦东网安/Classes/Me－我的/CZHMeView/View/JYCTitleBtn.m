//
//  JYCTitleBtn.m
//  浦东网安
//
//  Created by jiji on 15/7/10.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//

#import "JYCTitleBtn.h"

@implementation JYCTitleBtn
- (void)awakeFromNib
{
    
    [self setImage:[UIImage imageNamed:@"icon_down"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"icon_up"] forState:UIControlStateSelected];
    self.imageView.contentMode = UIViewContentModeCenter;
}

// 不能使用self.titleLabel 因为self.titleLabel内部会调用titleRectForContentRect
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleY = 0;
    NSDictionary *dict = @{
                           NSFontAttributeName : [UIFont boldSystemFontOfSize:18]
                           };
    CGFloat titleW = 0;
    
    // 判断运行时,及当前模拟器运行在哪个系统上
        

    titleW = [self.currentTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine attributes:dict context:nil].size.width;

    
    
    CGFloat titleH = contentRect.size.height;
    
    return CGRectMake(titleX, titleY, titleW, titleH);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = 20;
    CGFloat imageH = contentRect.size.height;
    CGFloat imageX = contentRect.size.width - imageW;
    CGFloat imageY = 0;
    
    return CGRectMake(imageX, imageY, imageW, imageH);
}

@end
