
#import "LYCOMRefreshAutoFooter.h"

@interface LYCOMRefreshAutoFooter()
@end

@implementation LYCOMRefreshAutoFooter

#pragma mark - 初始化
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview) { // 新的父控件
        if (self.hidden == NO) {
            self.scrollView.lycom_insetB += self.lycom_h;
        }
        
        // 设置位置
        self.lycom_y = _scrollView.lycom_contentH;
    } else { // 被移除了
        if (self.hidden == NO) {
            self.scrollView.lycom_insetB -= self.lycom_h;
        }
    }
}

#pragma mark - 过期方法
- (void)setAppearencePercentTriggerAutoRefresh:(CGFloat)appearencePercentTriggerAutoRefresh
{
    self.triggerAutomaticallyRefreshPercent = appearencePercentTriggerAutoRefresh;
}

- (CGFloat)appearencePercentTriggerAutoRefresh
{
    return self.triggerAutomaticallyRefreshPercent;
}

#pragma mark - 实现父类的方法
- (void)prepare
{
    [super prepare];
    
    // 默认底部控件100%出现时才会自动刷新
    self.triggerAutomaticallyRefreshPercent = 1.0;
    
    // 设置为默认状态
    self.automaticallyRefresh = YES;
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
    // 设置位置
    self.lycom_y = self.scrollView.lycom_contentH;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    if (self.state != LYCOMRefreshStateIdle || !self.automaticallyRefresh || self.lycom_y == 0) return;
    
    if (_scrollView.lycom_insetT + _scrollView.lycom_contentH > _scrollView.lycom_h) { // 内容超过一个屏幕
        // 这里的_scrollView.mj_contentH替换掉self.mj_y更为合理
        if (_scrollView.lycom_offsetY >= _scrollView.lycom_contentH - _scrollView.lycom_h + self.lycom_h * self.triggerAutomaticallyRefreshPercent + _scrollView.lycom_insetB - self.lycom_h) {
            // 防止手松开时连续调用
            CGPoint old = [change[@"old"] CGPointValue];
            CGPoint new = [change[@"new"] CGPointValue];
            if (new.y <= old.y) return;
            
            // 当底部刷新控件完全出现时，才刷新
            [self beginRefreshing];
        }
    }
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
    if (self.state != LYCOMRefreshStateIdle) return;
    
    if (_scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {// 手松开
        if (_scrollView.lycom_insetT + _scrollView.lycom_contentH <= _scrollView.lycom_h) {  // 不够一个屏幕
            if (_scrollView.lycom_offsetY >= - _scrollView.lycom_insetT) { // 向上拽
                [self beginRefreshing];
            }
        } else { // 超出一个屏幕
            if (_scrollView.lycom_offsetY >= _scrollView.lycom_contentH + _scrollView.lycom_insetB - _scrollView.lycom_h) {
                [self beginRefreshing];
            }
        }
    }
}

- (void)setState:(LYCOMRefreshState)state
{
    LYCOMRefreshCheckState
    
    if (state == LYCOMRefreshStateRefreshing) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self executeRefreshingCallback];
        });
    }
}

- (void)setHidden:(BOOL)hidden
{
    BOOL lastHidden = self.isHidden;
    
    [super setHidden:hidden];
    
    if (!lastHidden && hidden) {
        self.state = LYCOMRefreshStateIdle;
        
        self.scrollView.lycom_insetB -= self.lycom_h;
    } else if (lastHidden && !hidden) {
        self.scrollView.lycom_insetB += self.lycom_h;
        
        // 设置位置
        self.lycom_y = _scrollView.lycom_contentH;
    }
}
@end
