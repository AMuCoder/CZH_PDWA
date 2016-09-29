//
//  Detail3Cell.m
//  浦东网安
//
//  Created by Chun on 16/5/11.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import "Detail3Cell.h"
#import "ChangeInfo.h"
@interface Detail3Cell ()



@end
@implementation Detail3Cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"Detail3Cell";
    Detail3Cell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    return cell;
}
-(void)setChangeInfo:(ChangeInfo *)changeInfo
{
    _changeInfo = changeInfo;
    self.mjnamelable.text = changeInfo.checkMan;
    self.timelable.text = changeInfo.changeTime;
    self.taillable.text = changeInfo.changeInfo;
    self.taillable.numberOfLines = 0;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(CGFloat)changecellheight{
    return CGRectGetMaxY(self.timelable.frame) + 10;
}
@end
