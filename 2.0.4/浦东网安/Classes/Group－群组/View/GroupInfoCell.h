//
//  GroupInfoCell.h
//  浦东网安
//
//  Created by jiji on 15/7/2.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GroupInfo;
@interface GroupInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *haveRead;
@property (weak, nonatomic) IBOutlet UIButton *unRead;
@property(nonatomic,strong)GroupInfo *groupInfo;

@end
