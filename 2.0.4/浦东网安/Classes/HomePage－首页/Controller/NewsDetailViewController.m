//
//  NewsDetailViewController.m
//  浦东网安
//
//  Created by jiji on 15/7/8.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//
#define XXXXXXXXX 10
#define MARGIN 10
#define KUAN [UIScreen mainScreen].bounds.size.width

#import "NewsDetailViewController.h"
#import "NSString+Extension.h"
#import "News.h"
#import "UIView+Extension.h"
#import "UIImageView+WebCache.h"
#import "UILabel+Extension.h"

@implementation NewsDetailViewController
@synthesize scroll;
@synthesize _newsImageView;
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.view.tag == 0) {
        self.title =@"网警提示";
    }else if(self.view.tag ==1){
        self.title = @"公益广告";
    }
}



-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(contentLabel.frame), KUAN - 2*_newsImageView.x, 300)];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setTitle:@"" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
    scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    if(self.scroll==nil)
    {
        UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.scroll=scrollView;
    }
    self.scroll.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.scroll];
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = self.news.Title;
    titleLabel.x = XXXXXXXXX;
    titleLabel.y = 20;
    titleLabel.width = KUAN - 2*XXXXXXXXX;
    titleLabel.height = 50;
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [scroll addSubview:titleLabel];
    
    contentLabel = [[UILabel alloc]init];
    contentLabel.text = self.news.Contents;
    contentLabel.numberOfLines = 0;
    CGFloat contentLabelX = XXXXXXXXX;
    CGFloat contentLabelY = CGRectGetMaxY(titleLabel.frame);
    CGFloat maxW = KUAN - 2*contentLabelX;
    CGSize contentSize = [self.news.Contents sizeWithFont:[UIFont systemFontOfSize:17] maxW:maxW];
    contentLabel.frame = (CGRect){{contentLabelX,contentLabelY},contentSize};
    [scroll addSubview:contentLabel];
    
    if (self.news.News_Url) {
        _newsImageView = [[UIImageView alloc]init];
        _newsImageView.userInteractionEnabled = YES;
        _newsImageView.x = 0;
        _newsImageView.y = CGRectGetMaxY(contentLabel.frame)+MARGIN;
        _newsImageView.width = KUAN;
        _newsImageView.contentMode =  UIViewContentModeScaleAspectFill;
        UIImage *placeholderImage = [UIImage imageNamed:@"ic_launcher"];
        [_newsImageView sd_setImageWithURL:[NSURL URLWithString:self.news.News_Url] placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                CGFloat scale = image.size.height/image.size.width;
                _newsImageView.height = _newsImageView.width * scale;
                [_newsImageView addSubview:btn];
                [scroll addSubview:_newsImageView];
            }
        }];
    }
}

-(void)clickEvent:(id)sender{
    //NSLog(@"***********clickeventad");
    
    scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    if(self.scroll==nil)
    {
        UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.scroll=scrollView;
    }
    self.scroll.backgroundColor=[UIColor blackColor];
    self.scroll.delegate=self;
    scroll.contentSize = CGSizeMake(400,0);
    self.scroll.multipleTouchEnabled=YES; //是否支持多点触控
    self.scroll.minimumZoomScale=0.2;  //表示与原图片最小的比例
    self.scroll.maximumZoomScale=2.0; //表示与原图片最大的比例
    [self.view addSubview:self.scroll];
    _newsImageView = [[UIImageView alloc]init];
    _newsImageView.userInteractionEnabled = YES;
    _newsImageView.x = 0;
    _newsImageView.y = (scroll.frame.size.height)/2 - (scroll.frame.size.height)/4;
    _newsImageView.width = KUAN;
    _newsImageView.contentMode =  UIViewContentModeCenter;
    _newsImageView.clipsToBounds  = YES;
    _newsImageView.contentMode =  UIViewContentModeScaleAspectFill;
    [_newsImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    UIImage *placeholderImage = [UIImage imageNamed:@"ic_launcher"];
    [_newsImageView sd_setImageWithURL:[NSURL URLWithString:self.news.News_Url] placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            CGFloat scale = image.size.height/image.size.width;
            _newsImageView.height = _newsImageView.width * scale;
            //_newsImageView.contentMode = UIViewContentModeScaleToFill;
            [scroll addSubview:_newsImageView];
        }
    }];
    //返回按钮
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self._newsImageView.frame.size.width, self._newsImageView.frame.size.height)];
    [closeBtn setBackgroundColor:[UIColor clearColor]];
    [closeBtn setTitle:@"" forState:UIControlStateNormal];
    [closeBtn setAlpha:0.5];
    [closeBtn addTarget:self action:@selector(closeEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_newsImageView addSubview:closeBtn];
}

-(void)closeEvent:(id)sender{
    [self._newsImageView setHidden:YES];
    [self.scroll setHidden:YES];
}

#pragma mark 当正在缩放的时候调用
//实现图片在缩放过程中居中
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?(scrollView.bounds.size.width - scrollView.contentSize.width)/2 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0.0;
    self._newsImageView.center = CGPointMake(scrollView.contentSize.width/2 + offsetX,scrollView.contentSize.height/2 + offsetY);
}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self._newsImageView;
}
- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    return YES;
}
#pragma mark 当缩放完毕的时候调用
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(double)scale
{
}

-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    NSString * regEx = @"<([^>]*)>";
    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}


@end
//    else{
//        scroll.contentSize = CGSizeMake(0, CGRectGetMaxY(contentLabel.frame)+64);
//    }
//
//};


