//
//  UnReadViewController.h
//  浦东网安
//
//  Created by jyc on 15/7/3.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Gruop,GroupInfo;
@interface UnReadViewController : UITableViewController
@property(nonatomic,strong)Gruop *group;
@property(nonatomic,strong)GroupInfo *groupInfo;
@end
