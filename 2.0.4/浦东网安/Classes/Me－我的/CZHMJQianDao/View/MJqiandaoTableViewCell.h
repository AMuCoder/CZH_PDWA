//
//  MJqiandaoTableViewCell.h
//  浦东网安
//
//  Created by Chun on 16/5/22.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJqiandaoInfo;
@interface MJqiandaoTableViewCell : UITableViewCell

@property(nonatomic,strong)MJqiandaoInfo *mJqiandaoInfo;
@property (weak, nonatomic) IBOutlet UILabel *names;
@property (weak, nonatomic) IBOutlet UILabel *neirong;
@property (weak, nonatomic) IBOutlet UILabel *times;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
-(CGFloat)heights;
@end
