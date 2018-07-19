//
//  ViewController.m
//  LZSDKDemo
//
//  Created by Shangen Zhang on 2017/8/3.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "LZLoginViewController.h"
#import "LYNavigationController.h"

#import "LYLZConfigInfo.h"
#import "LZTabbarController.h"

#import "LZSessionListViewController.h"
#import "LZTabbarController.h"
#import "LYLZUserInfo.h"


@interface LZLoginViewController () 
/** 输入框 */
@property (nonatomic,weak) UITextField * userIdTextField;
@end

@implementation LZLoginViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息列表";
    
    [self setUpSubViews];
}

#pragma mark - click
- (void)clickLawyer {
    [self loginWithUser:self.userIdTextField.text chatIdentity:LYLZChatIdentityLawyer];
}

- (void)clickConsultant {
    [self loginWithUser:self.userIdTextField.text chatIdentity:LYLZChatIdentityConsultant];
}

#pragma mark - login

- (void)loginWithUser:(NSString *)userId chatIdentity:(LYLZChatIdentity)chatIdentity {
    
    // 模拟 登录
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        // 登录 SDK
        [self loginSDKWithUser:userId chatIdentity:chatIdentity showCMTandInterMessage:chatIdentity == LYLZChatIdentityLawyer];
    });
}

// 登录SDK
- (void)loginSDKWithUser:(NSString *)userId chatIdentity:(LYLZChatIdentity)chatIdentity showCMTandInterMessage:(BOOL)showCMTandInter {
    
    LZTabbarController *ROOTVC =  [[LZTabbarController alloc] initWithChatIdentity:chatIdentity userId:userId];
    
    // 登录
    [[LYLZChatManager shareManager] loginWithUserId:userId showCMTandInterMessage:showCMTandInter complete:^(LYTError *error) {
        if (error) {
            NSLog(@"登录SDK失败 %@",error);
            return ;
        }
        
        LYLZUserInfo *userInfo = [[LYLZUserInfo alloc] init];
        userInfo.userId = userId;
        userInfo.userName = [NSString stringWithFormat:@"uid(%@)",userId];
        userInfo.picture = @"http://ftp.71chat.com/C10086/2016-11-17/67909CD9-015E-4539-A7CD-BE26C841DB8A/7ec66d80e4fd4f3c85525bfb69655c2b.jpg";
        [[LYLZChatManager shareManager] updateContactWithContactInfo:userInfo complete:^(LYTError * _Nullable error) {
            if (error) {
                NSLog(@"个人信息上传成功。（%@",userInfo);
            } else {
                NSLog(@"个人信息上传失败。（%@",userInfo);
            }
        }];
        [UIApplication sharedApplication].keyWindow.rootViewController = ROOTVC;
    }];
}








#pragma mark - setUp subviews
- (void)setUpSubViews {
    self.view.backgroundColor = [UIColor colorWithRed:0.5 green:0.8 blue:0.1 alpha:1];
    
    UITextField *userIdTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 32)];
    userIdTextField.backgroundColor = [UIColor whiteColor];
    userIdTextField.placeholder = @"输入用户ID";
    [self.view addSubview:userIdTextField];
    self.userIdTextField = userIdTextField;
    
    
    UIButton *lawyerBtn = [self createButtonWithTitle:@"律师入口" action:@selector(clickLawyer)];
    [self.view addSubview:lawyerBtn];
    
    UIButton *consultantBtn = [self createButtonWithTitle:@"咨询者入口" action:@selector(clickConsultant)];
    [self.view addSubview:consultantBtn];
    
    CGPoint center = self.view.center;
    
    userIdTextField.center = CGPointMake(center.x, center.y - 100);
    lawyerBtn.center = center;
    consultantBtn.center = CGPointMake(center.x, center.y + 100);
}

- (UIButton *)createButtonWithTitle:(NSString *)title action:(SEL)selector {
    UIButton *btn = [[UIButton alloc] init];
    btn.backgroundColor = [UIColor colorWithRed:1 green:0.1 blue:0.1 alpha:1];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    return btn;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
