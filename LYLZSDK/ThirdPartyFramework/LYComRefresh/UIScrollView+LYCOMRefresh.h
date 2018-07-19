
#import <UIKit/UIKit.h>

@class LYCOMRefreshHeader, LYCOMRefreshFooter;

@interface UIScrollView (LYCOMRefresh)
/** 下拉刷新控件 */
@property (strong, nonatomic) LYCOMRefreshHeader *header;
/** 上拉刷新控件 */
@property (strong, nonatomic) LYCOMRefreshFooter *footer;

#pragma mark - other
- (NSInteger)totalDataCount;
@property (copy, nonatomic) void (^reloadDataBlock)(NSInteger totalDataCount);
@end
