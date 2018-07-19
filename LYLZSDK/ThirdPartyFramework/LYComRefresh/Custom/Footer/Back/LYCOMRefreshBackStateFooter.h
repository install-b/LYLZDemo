
#import "LYCOMRefreshBackFooter.h"

@interface LYCOMRefreshBackStateFooter : LYCOMRefreshBackFooter
/** 显示刷新状态的label */
@property (weak, nonatomic, readonly) UILabel *stateLabel;
/** 设置state状态下的文字 */
- (void)setTitle:(NSString *)title forState:(LYCOMRefreshState)state;

/** 获取state状态下的title */
- (NSString *)titleForState:(LYCOMRefreshState)state;
@end
