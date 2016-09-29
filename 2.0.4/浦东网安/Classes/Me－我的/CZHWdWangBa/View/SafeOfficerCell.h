//
//  SafeOfficerCell.h
//  浦东网安
//
//  Created by Chun on 16/5/16.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SafeOfficer;
@interface SafeOfficerCell : UITableViewCell
@property(nonatomic,strong)SafeOfficer *safeOfficer;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
