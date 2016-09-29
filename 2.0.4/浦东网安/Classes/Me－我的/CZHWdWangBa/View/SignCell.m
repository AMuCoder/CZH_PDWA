//
//  Detail4Cell.m
//  浦东网安
//
//  Created by Chun on 16/5/11.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import "SignCell.h"
#import "SignInfo.h"
@interface SignCell ()



@end
@implementation SignCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"SignCell";
    SignCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    return cell;
}
-(void)setSignInfo:(SignInfo *)signInfo
{
    _signInfo = signInfo;
    self.yztime.text = signInfo.lastSign;
    self.yznum.text = signInfo.signCount;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
