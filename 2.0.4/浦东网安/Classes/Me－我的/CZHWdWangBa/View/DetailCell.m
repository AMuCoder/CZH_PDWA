//
//  WangBaDetailCCell.m
//  浦东网安
//
//  Created by Chun on 16/5/10.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import "DetailCell.h"
#import "InfoDetailCell.h"
@interface DetailCell ()


@end
@implementation DetailCell

-(void)setInfoDetailCell:(InfoDetailCell *)infoDetailCell
{
    self.infoDetailCell = infoDetailCell;
    self.yyzk.text = infoDetailCell.sysOnLineStatus;
    self.wbimage.image = [UIImage imageNamed:@"pic_yh"];
    self.wbimage.layer.masksToBounds = YES;
    self.wbimage.layer.cornerRadius = 5.0;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"DetailCell";
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    return cell;
}
-(CGFloat)yzheight{
    return CGRectGetMaxY(self.fuwu.frame) + 10;
}


@end
