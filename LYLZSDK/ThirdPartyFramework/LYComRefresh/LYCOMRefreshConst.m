
#import <UIKit/UIKit.h>

const CGFloat LYCOMRefreshHeaderHeight = 54.0;
const CGFloat LYCOMRefreshFooterHeight = 44.0;
const CGFloat LYCOMRefreshFastAnimationDuration = 0.25;
const CGFloat LYCOMRefreshSlowAnimationDuration = 0.4;

NSString *const LYCOMRefreshKeyPathContentOffset = @"contentOffset";
NSString *const LYCOMRefreshKeyPathContentInset = @"contentInset";
NSString *const LYCOMRefreshKeyPathContentSize = @"contentSize";
NSString *const LYCOMRefreshKeyPathPanState = @"state";

NSString *const LYCOMRefreshHeaderLastUpdatedTimeKey = @"LYCOMRefreshHeaderLastUpdatedTimeKey";

NSString *const LYCOMRefreshHeaderIdleText = @"下拉可以刷新";
NSString *const LYCOMRefreshHeaderPullingText = @"松开立即刷新";
NSString *const LYCOMRefreshHeaderRefreshingText = @"正在刷新数据中...";

NSString *const LYCOMRefreshAutoFooterIdleText = @"点击或上拉加载更多";
NSString *const LYCOMRefreshAutoFooterRefreshingText = @"正在加载更多的数据...";
NSString *const LYCOMRefreshAutoFooterNoMoreDataText = @"已经全部加载完毕";

NSString *const LYCOMRefreshBackFooterIdleText = @"上拉可以加载更多";
NSString *const LYCOMRefreshBackFooterPullingText = @"松开立即加载更多";
NSString *const LYCOMRefreshBackFooterRefreshingText = @"正在加载更多的数据...";
NSString *const LYCOMRefreshBackFooterNoMoreDataText = @"已经全部加载完毕";
