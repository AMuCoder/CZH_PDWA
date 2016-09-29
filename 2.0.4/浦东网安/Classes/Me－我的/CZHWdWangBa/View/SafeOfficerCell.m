//
//  SafeOfficerCell.m
//  浦东网安
//
//  Created by Chun on 16/5/16.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import "SafeOfficerCell.h"
#import "SafeOfficer.h"
@interface SafeOfficerCell ()
@property (weak, nonatomic) IBOutlet UILabel *aqname;
@property (weak, nonatomic) IBOutlet UILabel *aqtime;

@end

@implementation SafeOfficerCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"SafeOfficerCell";
    SafeOfficerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    return cell;
}
-(void)setSafeOfficer:(SafeOfficer *)safeOfficer
{
    _safeOfficer = safeOfficer;
    _aqname.text = safeOfficer.safeOfficerName;
    _aqtime.text = safeOfficer.cardDate;
}

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
