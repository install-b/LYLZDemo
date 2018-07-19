
#import "LYCOMRefreshStateHeader.h"

@interface LYCOMRefreshStateHeader()
{
    /** 显示上一次刷新时间的label */
    __weak UILabel *_lastUpdatedTimeLabel;
    /** 显示刷新状态的label */
    __weak UILabel *_stateLabel;
}
/** 所有状态对应的文字 */
@property (strong, nonatomic) NSMutableDictionary *stateTitles;
@end

@implementation LYCOMRefreshStateHeader
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

- (UILabel *)lastUpdatedTimeLabel
{
    if (!_lastUpdatedTimeLabel) {
        [self addSubview:_lastUpdatedTimeLabel = [UILabel label]];
    }
    return _lastUpdatedTimeLabel;
}

#pragma mark - 公共方法
- (void)setTitle:(NSString *)title forState:(LYCOMRefreshState)state
{
    if (title == nil) return;
    self.stateTitles[@(state)] = title;
    self.stateLabel.text = self.stateTitles[@(self.state)];
}

#pragma mark key的处理
- (void)setLastUpdatedTimeKey:(NSString *)lastUpdatedTimeKey
{
    [super setLastUpdatedTimeKey:lastUpdatedTimeKey];
    
    NSDate *lastUpdatedTime = [[NSUserDefaults standardUserDefaults] objectForKey:lastUpdatedTimeKey];
    
    // 如果有block
    if (self.lastUpdatedTimeText) {
        self.lastUpdatedTimeLabel.text = self.lastUpdatedTimeText(lastUpdatedTime);
        return;
    }
    
    if (lastUpdatedTime) {
        // 1.获得年月日
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute;
        NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:lastUpdatedTime];
        NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
        
        // 2.格式化日期
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        if ([cmp1 day] == [cmp2 day]) { // 今天
            formatter.dateFormat = @"今天 HH:mm";
        } else if ([cmp1 year] == [cmp2 year]) { // 今年
            formatter.dateFormat = @"MM-dd HH:mm";
        } else {
            formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        }
        NSString *time = [formatter stringFromDate:lastUpdatedTime];
        
        // 3.显示日期
        self.lastUpdatedTimeLabel.text = [NSString stringWithFormat:@"最后更新：%@", time];
    } else {
        self.lastUpdatedTimeLabel.text = @"最后更新：无记录";
    }
}

#pragma mark - 覆盖父类的方法
- (void)prepare
{
    [super prepare];
    
    // 初始化文字
    [self setTitle:LYCOMRefreshHeaderIdleText forState:LYCOMRefreshStateIdle];
    [self setTitle:LYCOMRefreshHeaderPullingText forState:LYCOMRefreshStatePulling];
    [self setTitle:LYCOMRefreshHeaderRefreshingText forState:LYCOMRefreshStateRefreshing];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.stateLabel.hidden) return;
    
    if (self.lastUpdatedTimeLabel.hidden) {
        // 状态
        self.stateLabel.frame = self.bounds;
    } else {
        // 状态
        self.stateLabel.lycom_x = 0;
        self.stateLabel.lycom_y = 0;
        self.stateLabel.lycom_w = self.lycom_w;
        self.stateLabel.lycom_h = self.lycom_h * 0.5;
        
        // 更新时间
        self.lastUpdatedTimeLabel.lycom_x = 0;
        self.lastUpdatedTimeLabel.lycom_y = self.stateLabel.lycom_h;
        self.lastUpdatedTimeLabel.lycom_w = self.lycom_w;
        self.lastUpdatedTimeLabel.lycom_h = self.lycom_h - self.lastUpdatedTimeLabel.lycom_y;
    }
}

- (void)setState:(LYCOMRefreshState)state
{
    LYCOMRefreshCheckState
    
    // 设置状态文字
    self.stateLabel.text = self.stateTitles[@(state)];
    
    // 重新设置key（重新显示时间）
    self.lastUpdatedTimeKey = self.lastUpdatedTimeKey;
}
@end
