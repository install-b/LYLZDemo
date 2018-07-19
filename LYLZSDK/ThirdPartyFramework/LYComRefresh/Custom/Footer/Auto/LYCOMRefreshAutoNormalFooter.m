
#import "LYCOMRefreshAutoNormalFooter.h"

@interface LYCOMRefreshAutoNormalFooter()
@property (weak, nonatomic) UIActivityIndicatorView *loadingView;
@end

@implementation LYCOMRefreshAutoNormalFooter
#pragma mark - 懒加载子控件
- (UIActivityIndicatorView *)loadingView
{
    if (!_loadingView) {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.activityIndicatorViewStyle];
        loadingView.hidesWhenStopped = YES;
        [self addSubview:_loadingView = loadingView];
    }
    return _loadingView;
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    _activityIndicatorViewStyle = activityIndicatorViewStyle;
    
    self.loadingView = nil;
    [self setNeedsLayout];
}
#pragma makr - 重写父类的方法
- (void)prepare
{
    [super prepare];
    
    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    // 圈圈
    CGFloat arrowCenterX = self.lycom_w * 0.5;
    if (!self.isRefreshingTitleHidden) {
        arrowCenterX -= 100;
    }
    CGFloat arrowCenterY = self.lycom_h * 0.5;
    self.loadingView.center = CGPointMake(arrowCenterX, arrowCenterY);
}

- (void)setState:(LYCOMRefreshState)state
{
    LYCOMRefreshCheckState
    
    // 根据状态做事情
    if (state == LYCOMRefreshStateNoMoreData || state == LYCOMRefreshStateIdle) {
        [self.loadingView stopAnimating];
    } else if (state == LYCOMRefreshStateRefreshing) {
        [self.loadingView startAnimating];
    }
}

@end
