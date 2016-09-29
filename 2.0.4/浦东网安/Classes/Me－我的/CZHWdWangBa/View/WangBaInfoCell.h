//
//  WangBaInfoCell.h
//  浦东网安
//
//  Created by Chun on 16/5/10.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WangBaInfo;
@interface WangBaInfoCell : UITableViewCell
@property(nonatomic,strong)WangBaInfo *wangBaInfo;
-(CGFloat)alllheight;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
