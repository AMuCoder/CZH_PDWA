//
//  WangBaInfoCell.m
//  浦东网安
//
//  Created by Chun on 16/5/10.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import "WangBaInfoCell.h"
#import "WangBaInfo.h"
#import "UIImageView+WebCache.h"

@interface WangBaInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *WangBaname;//网吧名
@property (weak, nonatomic) IBOutlet UILabel *FuZeRen;//负责人
@property (weak, nonatomic) IBOutlet UIImageView *WangBaimage;//网吧头像图片
@property (weak, nonatomic) IBOutlet UILabel *diZhi;//网吧地址
@end

@implementation WangBaInfoCell

-(void)setWangBaInfo:(WangBaInfo *)wangBaInfo
{
    _wangBaInfo = wangBaInfo;
    _WangBaname.text = wangBaInfo.netBarName;
    _FuZeRen.text = wangBaInfo.NetBarManager;
    _diZhi.text = wangBaInfo.netBarAddress;
    _WangBaimage.image = [UIImage imageNamed:@"star45"];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"wangBaInfoCell";
    WangBaInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    return cell;
}
-(CGFloat)alllheight{
    return CGRectGetMaxY(self.diZhi.frame) + 10;
}

@end
