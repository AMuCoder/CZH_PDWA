//
//  Detail2Cell.m
//  浦东网安
//
//  Created by Chun on 16/5/11.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import "Detail2Cell.h"
#import "CheckInfo.h"

#import "UIImageView+WebCache.h"

@interface Detail2Cell ()


@end
@implementation Detail2Cell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"Detail2Cell";
    Detail2Cell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    return cell;
}
-(void)setCheckInfo:(CheckInfo *)checkInfo
{
    _checkInfo = checkInfo;
    self.mjname.text = checkInfo.checkMan;
    self.timelable.text = checkInfo.checkTime;
    self.hege.text = checkInfo.existProblem;
    self.detaillable.text = checkInfo.checkInfo;
    _hege.numberOfLines = 0;
    _detaillable.numberOfLines = 0;
    self.imegeesView.contentMode = UIViewContentModeScaleAspectFit;
    NSString *strings = @"";
    if ([checkInfo.pic1 isEqualToString:strings]){
        self.imegeesView.hidden = YES;
    } else {
        self.imegeesView.hidden = NO;
        [_imegeesView sd_setImageWithURL:[NSURL URLWithString:checkInfo.pic1]];
    }
}

-(CGFloat)checkcellheight{
    if (self.imegeesView.hidden) {//没有配图
        return CGRectGetMaxY(self.timelable.frame) + 5;
    } else {                       //有配图
        return CGRectGetMaxY(self.imegeesView.frame) + 10;
    }
}

@end
