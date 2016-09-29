//
//  GroupInfoCell.m
//  浦东网安
//
//  Created by jiji on 15/7/2.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//

#import "GroupInfoCell.h"
#import "GroupInfo.h"
#import "UIImageView+WebCache.h"
#import "HaveReadViewController.h"

@interface GroupInfoCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UIImageView *image;

@end

@implementation GroupInfoCell

- (void)awakeFromNib {
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setGroupInfo:(GroupInfo *)groupInfo
{
    _groupInfo = groupInfo;
    _titleLable.text = groupInfo.GroupInfoTitle;
    [_haveRead setTitle:[NSString stringWithFormat:@" 已阅: %@",groupInfo.yesRead] forState:UIControlStateNormal];
    [_unRead setTitle:[NSString stringWithFormat:@" 未阅: %@",groupInfo.noRead] forState:UIControlStateNormal];
    [_image sd_setImageWithURL:[NSURL URLWithString:groupInfo.GroupInfo_Url] placeholderImage:[UIImage imageNamed:@"ic_launcher"]];
    _image.layer.masksToBounds = YES;
    _image.layer.cornerRadius = 5.0;
}


@end
