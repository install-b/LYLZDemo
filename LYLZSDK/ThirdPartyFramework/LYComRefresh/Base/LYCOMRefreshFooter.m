#import "LYCOMRefreshFooter.h"

@interface LYCOMRefreshFooter()

@end

@implementation LYCOMRefreshFooter
#pragma mark - 构造方法
+ (instancetype)footerWithRefreshingBlock:(LYCOMRefreshComponentRefreshingBlock)refreshingBlock
{
    LYCOMRefreshFooter *cmp = [[self alloc] init];
    cmp.refreshingBlock = refreshingBlock;
    return cmp;
}
+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    LYCOMRefreshFooter *cmp = [[self alloc] init];
    [cmp setRefreshingTarget:target refreshingAction:action];
    return cmp;
}

#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    
    // 设置自己的高度
    self.lycom_h = LYCOMRefreshFooterHeight;
    
    // 默认是自动隐藏
    self.automaticallyHidden = YES;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview) {
        // 监听scrollView数据的变化
        [self.scrollView setReloadDataBlock:^(NSInteger totalDataCount) {
            if (self.isAutomaticallyHidden) {
                self.hidden = (totalDataCount == 0);
            }
        }];
    }
}

#pragma mark - 公共方法
- (void)endRefreshingWithNoMoreData
{
    self.state = LYCOMRefreshStateNoMoreData;
}

- (void)noticeNoMoreData
{
    [self endRefreshingWithNoMoreData];
}

- (void)resetNoMoreData
{
    self.state = LYCOMRefreshStateIdle;
}
@end
