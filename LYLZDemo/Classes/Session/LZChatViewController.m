//
//  LZChatViewController.m
//  LZSDKDemo
//
//  Created by Shangen Zhang on 2017/8/6.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "LZChatViewController.h"
@interface LZChatViewController ()
/** <#des#> */
@property (nonatomic,weak) UIView * shopInfoView;

@end

@implementation LZChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加 子控件 例如 商品信息视图
    [self shopInfoView ];
    
    CGFloat shopViewHight = self.shopInfoView.frame.size.height;
    
    self.chatInsets = UIEdgeInsetsMake(shopViewHight,0, 0, 0);
    self.showTimeDownView = YES;

}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layoutShopViewWithNoti:) name:LYTMessageTipViewFrameWillChangeNoti object:nil];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - noti
- (void)layoutShopViewWithNoti:(NSNotification *)noti {
    CGFloat tipViewHeight = [noti.userInfo[@"height"] floatValue];
    NSTimeInterval animaTime = [noti.userInfo[@"duration"] floatValue];
    // 设置商品栏向下移动
    NSLog(@"消息提示高度变化到:%f 时间为%f",tipViewHeight,animaTime);
    CGRect frame = self.shopInfoView.frame;
    frame.origin.y = tipViewHeight;
    [UIView animateWithDuration:animaTime animations:^{
        self.shopInfoView.frame = frame;
    }];
    
}



#pragma mark - 重写 方法
- (CGFloat)heightForTimeDownView {
    return 30.0f;
}

- (UIView *)contentViewForTimeDownView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor grayColor];
    UILabel *lable = [[UILabel alloc] init];
    lable.text = @"您剩余的服务时间为6小时30分钟";
    [view addSubview:lable];
    [lable sizeToFit];
    lable.frame = CGRectMake(10, (30 - lable.frame.size.height) * 0.5, lable.frame.size.width, lable.frame.size.height);
    return view;
}

- (void)didClickJumpWithInfo:(id)jumpInfo {
    NSLog(@"订单跳转信息: %@",jumpInfo);
}

- (UIView *)shopInfoView {
    
    if (!_shopInfoView) {
        UIView *shopView = [[UIView alloc] init];
        shopView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        _shopInfoView = shopView;
        shopView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 80.0f);
        [self.view addSubview:shopView];
     
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shop"]];
        imageView.frame = CGRectMake(20, 10, 80, 60);
        [shopView addSubview:imageView];
        
        // add other subviews 。。。。
        
    }
    return _shopInfoView;
}

@end
