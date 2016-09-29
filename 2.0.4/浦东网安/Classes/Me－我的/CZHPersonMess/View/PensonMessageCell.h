//
//  PensonMessageCell.h
//  浦东网安
//
//  Created by Chun on 16/5/19.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PersonInfo;
@interface PensonMessageCell : UITableViewCell
@property(nonatomic,strong)PersonInfo *personInfo;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *messages;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *txxt;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
-(CGFloat)heights;

@end
