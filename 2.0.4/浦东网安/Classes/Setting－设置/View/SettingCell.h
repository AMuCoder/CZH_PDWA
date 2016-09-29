//
//  SettingCell.h
//  浦东网安
//
//  Created by jiji on 15/6/16.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingItem;

@interface SettingCell : UITableViewCell
@property(nonatomic,strong)SettingItem *item;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
