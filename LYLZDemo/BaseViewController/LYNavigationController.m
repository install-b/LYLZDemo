//
//  LYNavigationController.m
//  LYLink
//
//  Created by SYLing on 2016/11/29.
//  Copyright © 2016年 HHLY. All rights reserved.
//

#import "LYNavigationController.h"
#import "UIImage+Utility.h"

#import "HistoryChatListViewController.h"


@interface LYNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation LYNavigationController

#pragma mark -当他的类或子类第一次使用时，调用此方法
+ (void)initialize
{
    //获取当前导航条
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    
    // 设置导航条图片
    [bar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.7 green:0.751 blue:0.204 alpha:1.00]] forBarMetrics:UIBarMetricsDefault];
    [bar setShadowImage:[[UIImage alloc] init]];
    
    
    // 设置导航条字体
    NSMutableDictionary *attri = [NSMutableDictionary dictionary];
    attri[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attri[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18];
    [bar setTitleTextAttributes:attri];
    
    //导航条主题颜色
    bar.tintColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 清空手势代理, 然后就会重新出现手势移除控制器的功能
    self.interactivePopGestureRecognizer.delegate = self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // viewController:栈顶控制器导航栏的内容由栈顶控制器设置
    
    // 设置导航条左边按钮，非跟控制器才需要
    if (self.childViewControllers.count != 0) {
        // 隐藏导航栏
        viewController.hidesBottomBarWhenPushed = YES;
        
        //左边导航栏的图标
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        
        viewController.navigationItem.leftBarButtonItem = leftItem;
        
        if (self.childViewControllers.count == 1) {
            
            //右边导航栏的图标
            UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_go"] style:UIBarButtonItemStylePlain target:self action:@selector(goNext)];
            
            viewController.navigationItem.rightBarButtonItem = rightItem;
            
        }
        
    }
    [super pushViewController:viewController animated:animated];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}



//跳转历史消息界面
- (void)goNext {
    
    //第三方:c2090fd1d9dd6329620de9feb22c2693
    //包含自己:7c30758f3cd9399d1e444bf3d41fc7fe
    
   
    
    

    HistoryChatListViewController *chatListVC = [[HistoryChatListViewController alloc] init];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
    view.backgroundColor = [UIColor blueColor];
    chatListVC.headView = view;
    chatListVC.lawyerId = @"3692";
    chatListVC.userId = @"3712";
    chatListVC.bottomMargin = 64;
    chatListVC.listViewY = 0;
    chatListVC.headMargin = 15;
    chatListVC.fromIndex = 1;
    chatListVC.chartCount = 1000;
    chatListVC.isLeft = YES;
    [self pushViewController:chatListVC animated:YES];
}

#pragma mark - <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    return self.childViewControllers.count > 1;
}
@end
