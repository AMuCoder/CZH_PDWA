//
//  NewsTableViewCell.h
//  浦东网安
//
//  Created by jiji on 15/7/6.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//

#import <UIKit/UIKit.h>
@class News;
@interface NewsTableViewCell : UITableViewCell
@property(nonatomic,strong)News *news;
@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UILabel *newsTitle;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@end
