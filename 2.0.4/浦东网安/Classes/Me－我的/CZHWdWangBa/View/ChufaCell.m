//
//  ChufaCell.m
//  浦东网安
//
//  Created by Chun on 16/5/13.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import "ChufaCell.h"
#import "PunishInfo.h"
@interface ChufaCell ()



@end

@implementation ChufaCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ChufaCell";
    ChufaCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    return cell;
}
-(void)setPunishInfo:(PunishInfo *)punishInfo
{
    _punishInfo = punishInfo;
    _jiancharen.text = punishInfo.checkMan;
    _chufaneirong.text = punishInfo.punishInfo;
    //_fakuanshu.text = punishInfo.punishMoney;
    _chufashijian.text = punishInfo.punishDate;
    self.chufaneirong.numberOfLines = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(CGFloat)chufacellheight{
    return CGRectGetMaxY(self.chufashijian.frame) +10;
}
@end
