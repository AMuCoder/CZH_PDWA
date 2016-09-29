//
//  Detail4Cell.h
//  浦东网安
//
//  Created by Chun on 16/5/11.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SignInfo;
@interface SignCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *yzname;
@property (weak, nonatomic) IBOutlet UILabel *yztime;
@property (weak, nonatomic) IBOutlet UILabel *yznum;
@property (weak, nonatomic) IBOutlet UILabel *lablesss;
@property(nonatomic,strong) SignInfo *signInfo;
@end
