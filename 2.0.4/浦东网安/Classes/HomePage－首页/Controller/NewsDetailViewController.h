//
//  NewsDetailViewController.h
//  浦东网安
//
//  Created by jiji on 15/7/8.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//

#import <UIKit/UIKit.h>
@class News;
@interface NewsDetailViewController : UIViewController <UIScrollViewDelegate>
{
    UIImageView *_newsImageView;
    UIImage *_image;
    UITapGestureRecognizer *_tap;
    UIScrollView *scroll;
    UILabel *contentLabel;
}

@property(retain,nonatomic)UIScrollView *scroll;
@property(retain,nonatomic)UIImageView *_newsImageView;
@property(nonatomic,strong)News *news;
@end
