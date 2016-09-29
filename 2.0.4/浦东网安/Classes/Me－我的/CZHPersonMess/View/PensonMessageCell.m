//
//  PensonMessageCell.m
//  浦东网安
//
//  Created by Chun on 16/5/19.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import "PensonMessageCell.h"
#import "PersonInfo.h"
@interface PensonMessageCell ()

@end
@implementation PensonMessageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"PensonMessageCell";
    PensonMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    return cell;
}
-(void)setPersonInfo:(PersonInfo *)personInfo
{
    _personInfo = personInfo;
    self.name.text = personInfo.userName;
    self.messages.text = personInfo.message;
    self.time.text = personInfo.createTime;
    self.messages.numberOfLines = 0;
}

-(CGFloat)heights{
    return CGRectGetMaxY(self.time.frame) + 10;
}

@end
