//
//  NewsViewController.m
//  浦东网安
//
//  Created by jiji on 15/7/6.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//

#import "NewsViewController.h"
#import "RemindViewController.h"
#import "AdViewController.h"
#import "UIView+Extension.h"




@interface NewsViewController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentCtrl;

- (IBAction)segClick:(UISegmentedControl *)sender;
@property(nonatomic,retain)AdViewController *ad;
@property(nonatomic,retain)RemindViewController *remind;
@end

@implementation NewsViewController

-(RemindViewController *)remind
{
    if (!_remind) {
        self.remind = [[RemindViewController alloc]init];
       
        if (IOS8) {
            self.remind.view.y = 0;
        }
        else{
            self.remind.view.y = 64;
        }
           [self addChildViewController:self.remind];
        
      }
    return _remind;
}

-(AdViewController *)ad
{
    if (!_ad) {
        self.ad = [[AdViewController alloc]init];
        if (IOS8) {
            self.ad.view.y = 0;
        }else{
            self.ad.view.y = 64;
        }
        self.ad.view.height = [UIScreen mainScreen].bounds.size.height - 70;
        [self addChildViewController:self.ad];
        [self.view addSubview:self.ad.view];
    }
    return _ad;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    self.segmentCtrl.height = 32;
    [self.segmentCtrl setTitleTextAttributes:dic forState:UIControlStateNormal];
    if (IOS8) {
        self.remind.view.height = [UIScreen mainScreen].bounds.size.height + 35;
    }else{
        self.remind.view.height = [UIScreen mainScreen].bounds.size.height - 70;
    }
   [self.view addSubview:self.remind.view];
}

- (IBAction)segClick:(UISegmentedControl *)sender {
    
    NSInteger index = sender.selectedSegmentIndex;
    switch (index) {
        case 0:
            [self backTo];
            break;
        case 1:
            
            [self toSecond];
            break;
        default:
            break;
    }
}

-(void)backTo
{
    self.ad.view.hidden = YES;
    self.remind.view.hidden = NO;
}

-(void)toSecond
{
    self.remind.view.hidden = YES;
    self.ad.view.hidden = NO;
}

@end
