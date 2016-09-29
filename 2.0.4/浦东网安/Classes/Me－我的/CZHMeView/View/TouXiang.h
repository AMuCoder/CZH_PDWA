//
//  TouXiang.h
//  浦东网安
//
//  Created by jiji on 15/6/25.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TouXiang : UIView
@property (weak, nonatomic) IBOutlet UIImageView *touXiangImageView;
@property (weak, nonatomic) IBOutlet UILabel *touXiang;
@property (weak, nonatomic) IBOutlet UIButton *yiShenHe;
@property (weak, nonatomic) IBOutlet UIButton *daiShenHe;
@property (weak, nonatomic) IBOutlet TouXiang *touXiangView;
+(instancetype)touXiang;
@end
