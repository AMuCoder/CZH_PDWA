//
//  MJqiandaoTableViewCell.m
//  浦东网安
//
//  Created by Chun on 16/5/22.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import "MJqiandaoTableViewCell.h"
#import "MJqiandaoInfo.h"
@interface MJqiandaoTableViewCell ()
@end
@implementation MJqiandaoTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"MJqiandaoTableViewCell";
    MJqiandaoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    return cell;
}
-(void)setMJqiandaoInfo:(MJqiandaoInfo *)mJqiandaoInfo
{
    _mJqiandaoInfo = mJqiandaoInfo;
    self.names.text = mJqiandaoInfo.username;
    self.neirong.text = mJqiandaoInfo.netbarmc;
    self.times.text = mJqiandaoInfo.qiandaoshij;
}

-(CGFloat)heights{
    return CGRectGetMaxY(self.times.frame) + 10;
}


@end
