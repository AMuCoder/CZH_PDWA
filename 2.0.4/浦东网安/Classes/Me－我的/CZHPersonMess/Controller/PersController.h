//
//  PersController.h
//  浦东网安
//
//  Created by Chun on 16/5/19.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PersonInfo,perssss;
@interface PersController : UIViewController
@property(nonatomic,strong)PersonInfo *personInfo;
@property(nonatomic,strong)perssss *pers;

@property (weak, nonatomic) IBOutlet UILabel *lables;
@property (weak, nonatomic) IBOutlet UIButton *buttons;

@property(nonatomic,assign)NSInteger selectIndex;
@end
