//
//  GroupInfoDetailViewController.m
//  浦东网安
//
//  Created by jyc on 15/7/8.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//
#define XXXXXXXXX 10
#define MARGIN 10
#define KUAN [UIScreen mainScreen].bounds.size.width

#import "GroupInfoDetailViewController.h"
#import "GroupInfo.h"
#import "UIView+Extension.h"
#import "UIImageView+WebCache.h"


#import "UserInfoTool.h"
#import "UserInfo.h"
#import "NSString+Extension.h"
#import "Gruop.h"
#import "HaveRead.h"
#import "MJExtension.h"


@interface GroupInfoDetailViewController ()
@property(nonatomic,strong)NSMutableArray *haveReadArr;

@property(nonatomic,strong)UserInfo *user;
@end

@implementation GroupInfoDetailViewController
-(NSMutableArray *)haveReadArr
{
    if (!_haveReadArr) {
        self.haveReadArr = [NSMutableArray array];
        
    }
    return _haveReadArr;
}

-(UserInfo *)user
{
    if (!_user) {
        self.user = [UserInfoTool info];
    }
    return _user;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"消息详情";
    [self setupHaveRead];
   
}

-(void)setupHaveRead
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"GroupID"] = self.group.GroupID;
    params[@"GroupInfoID"] = self.gropuInfo.ID;
    [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"/yesRead"] params:params success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *haveReads =[NSArray array];
        haveReads =  [HaveRead objectArrayWithKeyValuesArray:dic[@"result"]];
        for (HaveRead *h in haveReads) {
            NSString *ha = h.UserName;
            [self.haveReadArr addObject:ha];
        }
            [self configGroupDetail];
    
    } failed:^{
        [MBProgressHUD showError:@"网络错误!"];
    }];
    
    
}

-(void)configGroupDetail
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"GroupInfoID"] = self.gropuInfo.ID;
    [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"/GetDetailedGroupInfo"] params:params success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         
        UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [self.view addSubview:scroll];
        
                UILabel *titleLabel = [[UILabel alloc]init];
                titleLabel.text = self.gropuInfo.GroupInfoTitle;
                titleLabel.x = XXXXXXXXX;
                if (IOS8) {
                    titleLabel.y = 20;
                }else{
                titleLabel.y = 20 + 64;
                }
        
                titleLabel.width = KUAN - 2*XXXXXXXXX;
                titleLabel.height = 25;
                titleLabel.textAlignment = NSTextAlignmentCenter;
                titleLabel.font = [UIFont boldSystemFontOfSize:20];
                [scroll addSubview:titleLabel];
               
                NSString *content = dic[@"result"][@"GroupInfoContents"];
        
                UILabel *contentLabel = [[UILabel alloc]init];
        
        NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, attrStr.length)];
        
                contentLabel.attributedText = attrStr;
                contentLabel.numberOfLines = 0;
        
                CGFloat contentLabelX = XXXXXXXXX;
                CGFloat contentLabelY = CGRectGetMaxY(titleLabel.frame)+MARGIN;
                CGFloat maxW = KUAN - 2*contentLabelX;
                CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:17] maxW:maxW];
                contentLabel.frame = (CGRect){{contentLabelX,contentLabelY},contentSize};
                [scroll addSubview:contentLabel];
        
        UIButton *haveReadBtn = [[UIButton alloc]init];
        haveReadBtn.x = XXXXXXXXX;
        haveReadBtn.width = KUAN - 2*XXXXXXXXX;
        haveReadBtn.height = 40;
        haveReadBtn.backgroundColor = CZHRGBColor(122, 199, 119);
        
            if ([self.haveReadArr containsObject:self.user.UserName]) {
                haveReadBtn.enabled = NO;
            }else{
                haveReadBtn.enabled = YES;
            }
        
         [haveReadBtn setTitle:@"已阅" forState:UIControlStateDisabled];
         [haveReadBtn setBackgroundImage:[UIImage imageNamed:@"gray"] forState:UIControlStateDisabled];
        [haveReadBtn setTitle:@"签阅" forState:UIControlStateNormal];

        [haveReadBtn setTintColor:[UIColor whiteColor]];
        haveReadBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        //有配图
        if (self.gropuInfo.GroupInfo_Url) {
            UIImageView *newsImageView = [[UIImageView alloc]init];
            newsImageView.x = 0;
            newsImageView.y = CGRectGetMaxY(contentLabel.frame)+MARGIN;
            newsImageView.width = KUAN - 2*newsImageView.x;
            [newsImageView sd_setImageWithURL:[NSURL URLWithString:self.gropuInfo.GroupInfo_Url] placeholderImage:[UIImage imageNamed:@"ic_launcher"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    CGFloat scale = image.size.height/image.size.width;
                    newsImageView.height = newsImageView.width * scale;
                    newsImageView.contentMode = UIViewContentModeScaleToFill;
                    [scroll addSubview:newsImageView];
                    haveReadBtn.y = CGRectGetMaxY(newsImageView.frame)+MARGIN;
                    [scroll addSubview:haveReadBtn];
                    scroll.contentSize = CGSizeMake(0, CGRectGetMaxY(haveReadBtn.frame)+70);
                }else{
                    haveReadBtn.y = CGRectGetMaxY(contentLabel.frame)+MARGIN;
                    [scroll addSubview:haveReadBtn];
                    scroll.contentSize = CGSizeMake(0, CGRectGetMaxY(haveReadBtn.frame)+70);
                }
            }];
        }
        
      
        [haveReadBtn addTarget:self action:@selector(haveRead:) forControlEvents:UIControlEventTouchUpInside];

       

//       NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        NSNumber * fuck = [defaults objectForKey:[@(self.selectIndex) stringValue]];
//        if (![fuck boolValue]) {
//            
//            haveReadBtn.enabled = YES;
//            
//        }else{
//            
//            haveReadBtn.enabled = NO;
//        }
    } failed:^{
        [MBProgressHUD showError:@"网络错误!"];
    }];
    
    
}


-(void)haveRead:(UIButton *)haveReadBtn
{
    //UserInfo *user = [UserInfoTool info];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"GroupInfoID"] = self.gropuInfo.ID;
    params[@"ReadUserID"] = self.user.UserName;
    [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"HaveRead"] params:params success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        haveReadBtn.enabled = NO;
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        //[defaults setBool:haveReadBtn.enabled forKey:@"haveReadState"];
//        NSString *fuck = @"fuck";
//        [defaults setObject:fuck forKey:@"fuck"];
//        [defaults setObject:@(YES) forKey:[@(self.selectIndex) stringValue]];
//        [defaults synchronize];
        NSNumber *tag = [NSNumber numberWithInteger:self.selectIndex];
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[@"tag"] = tag;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"haveReadClick" object:nil userInfo:userInfo];
        
        [MBProgressHUD showSuccess:[NSString stringWithFormat:@"%@",dic[@"return"][@"message"]]];
    } failed:^{
        [MBProgressHUD showError:@"网络错误!"];
    }];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
