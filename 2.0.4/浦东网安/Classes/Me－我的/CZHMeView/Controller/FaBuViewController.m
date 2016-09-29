//
//  FaBuViewController.m
//  浦东网安
//
//  Created by jiji on 15/7/1.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//
#define GIFCONTINUETIME 4
#define IPHONE5S [UIScreen mainScreen].bounds.size.width == 320
#define maxTextLength 150

#import "FaBuViewController.h"

#import "UserInfo.h"
#import "UserInfoTool.h"

#import <ImageIO/ImageIO.h>
#import "UIView+Extension.h"

#import "ChooseGroupList.h"
#import "RegionViewController.h"
#import "KxMenu.h"
#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"

@interface FaBuViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextViewDelegate>
@property (nonatomic,strong) UIImage *image;

//接受群组列表是第几行
@property (nonatomic,strong) NSNumber *selectedGroup;
@property (nonatomic,strong) NSString *selectedRegion;
@property (nonatomic,weak) UIImage *celebrateImage;
@property (nonatomic,weak) UIView *contentView;

//是否第一次发布
@property (nonatomic,assign)BOOL firstFabu;
//字数
@property (weak, nonatomic) IBOutlet UILabel *textLengthLabel;
@property (weak, nonatomic) IBOutlet UIButton *faBuType;
- (IBAction)faBuTypeBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextView *faBuContent;
@property (weak, nonatomic) IBOutlet UITextField *faBuTitle;
- (IBAction)go2Back:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *choosePicBtn;
@property (nonatomic,strong)UIActionSheet *sheet;
- (IBAction)choosePic:(UIButton *)sender;

- (IBAction)faBu:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UINavigationBar *fabu;
@property(nonatomic,assign)BOOL groupChosen;
@end

@implementation FaBuViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //控制器显示后，取出BOOL值
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.firstFabu = [defaults boolForKey:@"firstFabu"];
    [_fabu setBarTintColor:CZHRGBColor(49, 174, 215)];
    self.groupChosen = NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fabuGroup:) name:@"selectedIndex" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fabuRegion:) name:@"selectedRegion" object:nil];
    self.faBuContent.layer.borderWidth = 1.3;
    self.faBuContent.layer.borderColor = [UIColor blackColor].CGColor;
    _faBuContent.layer.cornerRadius =5.0;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.faBuType.selected = NO;
    [self.view endEditing:YES];
    
    if (self.celebrateImage) {
                    [self dismissViewControllerAnimated:NO completion:^{
                    [self.contentView removeFromSuperview];
                    [MBProgressHUD showSuccess:@"发布成功!"];
                }];
    }
}

- (IBAction)go2Back:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)choosePic:(UIButton *)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册",nil];
    [sheet showInView:self.view];

}

#pragma mark - UIActionSheetDelegate
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *subViwe in actionSheet.subviews) {
        if ([subViwe isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)subViwe;
            if ([button.titleLabel.text isEqualToString:@"取消"]) {
                [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
            
        }
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
    }else if (buttonIndex == 1) {
        [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

- (void)openImagePickerController:(UIImagePickerControllerSourceType)type
{
    if (![UIImagePickerController isSourceTypeAvailable:type]) return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = type;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
/**
 * 从UIImagePickerController选择完图片后就调用（拍照完毕或者选择相册图片完毕）
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // info中就包含了选择的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (image) {
        //获得图片大小（KB）
        NSData *data = UIImageJPEGRepresentation(image, 0.3f);
        NSUInteger length = [data length]/1000;
        if (length>1000) {
            UIAlertView *alart = [[UIAlertView alloc]initWithTitle:@"警告！" message:@"图片大小超过限制！请重新选择！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alart show];
            image = nil;
            
        }
        self.choosePicBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.choosePicBtn.imageView clipsToBounds];
        [self.choosePicBtn setImage:image?image:[UIImage imageNamed:@"pic"] forState:UIControlStateNormal];
        
        self.image = image;
    }

}
- (IBAction)faBu:(UIButton *)sender {
   
    if (!self.faBuType.tag ) {
        [MBProgressHUD showError:@"请选择发布类型!"];
    }
    else{
        switch (self.faBuType.tag) {
            case 1:
                [self wangJingFabu:sender];
                break;
            case 2:
                [self adFabu:sender];
                break;
                case 3:
                [self groupFabu:sender];
                break;
            default:
                break;
        }
    
    }
}

//通过self.firstFabu这个BOOL来判断是否显示GIF
-(void)successGif
{
    if (self.firstFabu == NO) {
        NSURL *url = nil;
        if (IPHONE5S) {
            url = [[NSBundle mainBundle] URLForResource:@"1136-640.gif" withExtension:nil];
        }
        url = [[NSBundle mainBundle] URLForResource:@"1334-750_zhen.gif" withExtension:nil];
        CGImageSourceRef csf = CGImageSourceCreateWithURL((__bridge CFTypeRef) url, NULL);
        size_t const count = CGImageSourceGetCount(csf);
        UIImage *frames[count];
        CGImageRef images[count];
        for (size_t i = 0; i < count; i++) {
            images[i] = CGImageSourceCreateImageAtIndex(csf, i, NULL);
            UIImage *image =[[UIImage alloc] initWithCGImage:images[i]];
            frames[i] = image;
            CFRelease(images[i]);
        }
        UIImage *const animation = [UIImage animatedImageWithImages:[NSArray arrayWithObjects:frames count:count] duration:GIFCONTINUETIME];
        UIView *contentView = [[UIView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:contentView];
        self.contentView = contentView;
        UIImageView *view1 =[[UIImageView alloc]init];
        view1.frame = self.view.bounds;
        view1.userInteractionEnabled = NO;
        [contentView addSubview:view1];
        [view1 setImage:animation];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(GIFCONTINUETIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIImageView *view2 = [[UIImageView alloc]initWithFrame:self.view.bounds];
            if (IPHONE5S) {
                view2.image = [UIImage imageNamed:@"1136-640"];
            }
            view2.image = [UIImage imageNamed:@"1334-750"];
            self.celebrateImage = view2.image;
            [view1 addSubview:view2];
                });
        CFRelease(csf);
        //显示GIF后，更改BOOL值并保存状态
        self.firstFabu = YES;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:self.firstFabu forKey:@"firstFabu"];
        [defaults synchronize];
    }
    //如果BOOL为YES，直接销毁控制器
    else{
        [self dismissViewControllerAnimated:NO completion:^{
            [MBProgressHUD showSuccess:@"发布成功!"];
        }];
    }
}

-(void)wangJingFabu:(UIButton *)btn
{
    NSData *data = UIImageJPEGRepresentation(self.image, 0.3f);
    NSString *baseStr = [data base64EncodedStringWithOptions:0];
    
    //2015-05-21 防止base64 中包含特殊字符
    NSString *bStr =(__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)baseStr,NULL,CFSTR("+"),kCFStringEncodingUTF8);
    
    btn.enabled = NO;
    UserInfo *user = [UserInfoTool info];
    if (self.faBuTitle.text.length&&self.faBuContent.text.length) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"TitleStr"] = self.faBuTitle.text;
        params[@"Contents"] = self.faBuContent.text;
        params[@"TyPeName"] = @"网警提示";
        params[@"userID"] = user.UserID;
        params[@"userName"] = user.UserName;
        params[@"photo"] = self.image?bStr:@"";
        [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"/ReleasedNewsInfo" ]params:params success:^(NSData *data) {
            
            //  NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
           
            [self.view endEditing:YES];
            
                 [self successGif];
            
            
        } failed:^{
            [MBProgressHUD showError:@"发布失败!请检查网络!"];
            btn.enabled = YES;
        }];
    }
   
    else{
        [MBProgressHUD showError:@"标题和内容不得为空!"];
         btn.enabled = YES;
    }
    
}

-(void)adFabu:(UIButton *)btn
{
    NSData *data = UIImageJPEGRepresentation(self.image, 0.3f);
    NSString *baseStr = [data base64EncodedStringWithOptions:0];
    
    //2015-05-21 防止base64 中包含特殊字符
    NSString *bStr =(__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)baseStr,NULL,CFSTR("+"),kCFStringEncodingUTF8);
    
    btn.enabled = NO;
    UserInfo *user = [UserInfoTool info];
    if (self.faBuTitle.text.length&&self.faBuContent.text.length) {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"TitleStr"] = self.faBuTitle.text;
    params[@"Contents"] = self.faBuContent.text;
    params[@"TyPeName"] = @"公益广告";
    params[@"userID"] = user.UserID;
    params[@"userName"] = user.UserName;
    params[@"photo"] = self.image?bStr:@"";
    [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"/ReleasedNewsInfo" ] params:params success:^(NSData *data) {
        
        //  NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
       
        [self.view endEditing:YES];
        [self successGif];
        
    } failed:^{
        [MBProgressHUD showError:@"发布失败!请检查网络!"];
         btn.enabled = YES;
    }];}
    else{
    [MBProgressHUD showError:@"标题和内容不得为空!"];
         btn.enabled = YES;
    }
}

-(void)groupFabu:(UIButton *)btn

{
    btn.enabled = NO;
    if (self.groupChosen == NO) {
        [MBProgressHUD showError:@"请选择群组!"];
        [self.sheet showInView:self.view];
        btn.enabled = YES;
    }
    else{
    NSData *data = UIImageJPEGRepresentation(self.image, 0.3f);
    NSString *baseStr = [data base64EncodedStringWithOptions:0];

    //2015-05-21 防止base64 中包含特殊字符
    NSString *bStr =(__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)baseStr,NULL,CFSTR("+"),kCFStringEncodingUTF8);
        
    UserInfo *user = [UserInfoTool info];
    if (self.faBuTitle.text.length && self.faBuContent.text.length) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"TitleStr"] = self.faBuTitle.text;
        params[@"Contents"] = self.faBuContent.text;
        params[@"userID"] = user.UserID;
        params[@"userName"] = user.UserName;
        params[@"photo"] = self.image?bStr:@"";
        params[@"GroupID"] = self.selectedGroup;
        params[@"Popedom"] = self.selectedRegion.length?self.selectedRegion:@"0";
        [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"/ReleasedGroupInfo" ] params:params success:^(NSData *data) {
            //  NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            [self.view endEditing:YES];
            [self successGif];
        
                } failed:^{
            [MBProgressHUD showError:@"发布失败!请检查网络!"];
                     btn.enabled = YES;
        }];}
    else{
        [MBProgressHUD showError:@"标题和内容不得为空!"];
         btn.enabled = YES;
    }
    
    }
    
  }

-(void)fabuGroup:(NSNotification *)not
{
    self.groupChosen = YES;
    self.selectedGroup = not.userInfo[@"selectedIndex"];
}

-(void)fabuRegion:(NSNotification *)not
{
    self.selectedRegion = not.userInfo[@"selectedRegion"];
    if ([self.selectedRegion isEqual:@"全部辖区"]) {
        self.selectedRegion = @"0";
    }
}

- (IBAction)faBuTypeBtnClick:(UIButton *)sender {
     self.faBuType.selected = YES;
    NSArray *menuItems =
    @[
      
           [KxMenuItem menuItem:@"网警提示"
                     image:nil
                    target:self
                    action:@selector(pushWangJing:)],
      
      [KxMenuItem menuItem:@"公益广告"
                     image:nil
                    target:self
                    action:@selector(pushAD:)],
      
      [KxMenuItem menuItem:@"群组信息"
                     image:nil
                    target:self
                    action:@selector(chooseGroup:)]];
      
    
    [KxMenu showMenuInView:self.view
                  fromRect:sender.frame
                 menuItems:menuItems];
}

-(void)pushWangJing:(UIButton *)sender
{
    [self.faBuType setTitle:@"网警提示" forState:UIControlStateNormal];
    self.faBuType.tag = 1;
     self.faBuType.selected = NO;
}

-(void)pushAD:(UIButton *)sender
{
    [self.faBuType setTitle:@"公益广告" forState:UIControlStateNormal];
    self.faBuType.tag = 2;
     self.faBuType.selected = NO;
}

//-(void)pushGroup:(UIButton *)sender
//{
//    [self.faBuType setTitle:@"群组信息" forState:UIControlStateNormal];
//    self.faBuType.tag = 3;
//    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"请选择群组和辖区" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"群组(必选)" otherButtonTitles:@"辖区(可选)", nil];
//    self.sheet = sheet;
//    [sheet showInView:self.view];
//     self.faBuType.selected = NO;
//}

#pragma mark - UIActionSheetDelegate

//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    switch (buttonIndex) {
//        case 0:
//            [self chooseGroup];
//            break;
//           case 1:
//            [self chooseRegion];
//            break;
//    }
//}
//
-(void)chooseGroup:(UIButton *)sender
{
    [self.faBuType setTitle:@"群组信息" forState:UIControlStateNormal];
    self.faBuType.selected = NO;
    self.faBuType.tag = 3;
    ChooseGroupList *choose = [[ChooseGroupList alloc]init];
    choose.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:choose animated:YES completion:nil];
    
}

-(void)chooseRegion
{
    RegionViewController *region = [[RegionViewController alloc]init];
    [self presentViewController:region animated:YES completion:nil];
}

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    NSUInteger length = [textView.text length];
    if (length < maxTextLength) {
        self.textLengthLabel.textColor = [UIColor lightGrayColor];
         self.textLengthLabel.text = [NSString stringWithFormat:@"%@/%@",@(length).description,@(maxTextLength - length).description];
    }else{
        self.textLengthLabel.text = [NSString stringWithFormat:@"%d/0",maxTextLength];
        self.textLengthLabel.textColor = [UIColor redColor];
        //排除中文输入法BUG
        if (textView.markedTextRange) {
            return;
        }else{
            [textView setText:[textView.text substringToIndex:maxTextLength]];
        }
    }
   
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
