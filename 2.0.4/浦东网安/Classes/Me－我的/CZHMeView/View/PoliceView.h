//
//  PoliceView.h
//  浦东网安
//
//  Created by jyc on 15/6/28.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PoliceView : UIView

@property (weak, nonatomic) IBOutlet UILabel *nameTitle;
@property (weak, nonatomic) IBOutlet UIButton *faBu;

@property (weak, nonatomic) IBOutlet UIImageView *touxiangImage;

+(instancetype)policeView;
@end
