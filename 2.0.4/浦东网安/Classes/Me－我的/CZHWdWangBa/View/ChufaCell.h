//
//  ChufaCell.h
//  浦东网安
//
//  Created by Chun on 16/5/13.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PunishInfo;
@interface ChufaCell : UITableViewCell
@property(nonatomic,strong)PunishInfo *punishInfo;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *jiancharen;
@property (weak, nonatomic) IBOutlet UILabel *chufaneirong;
@property (weak, nonatomic) IBOutlet UILabel *chufashijian;
@property (weak, nonatomic) IBOutlet UIButton *gengduobtn;
-(CGFloat)chufacellheight;
@end
