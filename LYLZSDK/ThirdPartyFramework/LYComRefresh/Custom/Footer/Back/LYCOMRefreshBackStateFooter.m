#import "LYCOMRefreshBackStateFooter.h"

@interface LYCOMRefreshBackStateFooter()
{
    /** 显示刷新状态的label */
    __weak UILabel *_stateLabel;
}
/** 所有状态对应的文字 */
@property (strong, nonatomic) NSMutableDictionary *stateTitles;
@end

@implementation LYCOMRefreshBackStateFooter
#pragma mark - 懒加载
- (NSMutableDictionary *)stateTitles
{
    if (!_stateTitles) {
        self.stateTitles = [NSMutableDictionary dictionary];
    }
    return _stateTitles;
}

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        [self addSubview:_stateLabel = [UILabel label]];
    }
    return _stateLabel;
}

#pragma mark - 公共方法
- (void)setTitle:(NSString *)title forState:(LYCOMRefreshState)state
{
    if (title == nil) return;
    self.stateTitles[@(state)] = title;
    self.stateLabel.text = self.stateTitles[@(self.state)];
}

- (NSString *)titleForState:(LYCOMRefreshState)state {
  return self.stateTitles[@(state)];
}

#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    
    // 初始化文字
    [self setTitle:LYCOMRefreshBackFooterIdleText forState:LYCOMRefreshStateIdle];
    [self setTitle:LYCOMRefreshBackFooterPullingText forState:LYCOMRefreshStatePulling];
    [self setTitle:LYCOMRefreshBackFooterRefreshingText forState:LYCOMRefreshStateRefreshing];
    [self setTitle:LYCOMRefreshBackFooterNoMoreDataText forState:LYCOMRefreshStateNoMoreData];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    // 状态标签
    self.stateLabel.frame = self.bounds;
}

- (void)setState:(LYCOMRefreshState)state
{
    LYCOMRefreshCheckState
    
    // 设置状态文字
    self.stateLabel.text = self.stateTitles[@(state)];
}
@end
