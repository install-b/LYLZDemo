#import "LYCOMRefreshBackStateFooter.h"

@interface LYCOMRefreshBackGifFooter : LYCOMRefreshBackStateFooter
/** 设置state状态下的动画图片images 动画持续时间duration*/
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(LYCOMRefreshState)state;
- (void)setImages:(NSArray *)images forState:(LYCOMRefreshState)state;
@end
