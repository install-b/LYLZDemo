
#import <UIKit/UIKit.h>
#import <objc/message.h>

// 日志输出
#ifdef DEBUG
#define LYCOMRefreshLog(...) NSLog(__VA_ARGS__)
#else
#define LYCOMRefreshLog(...)
#endif

// 过期提醒
#define LYCOMRefreshDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

// 运行时objc_msgSend
#define LYCOMRefreshMsgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define LYCOMRefreshMsgTarget(target) (__bridge void *)(target)

// RGB颜色
#define LYCOMRefreshColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 文字颜色
#define LYCOMRefreshLabelTextColor LYCOMRefreshColor(90, 90, 90)

// 字体大小
#define LYCOMRefreshLabelFont [UIFont boldSystemFontOfSize:14]

// 图片路径
#define LYCOMRefreshSrcName(file) [@"PicturesOfComment.bundle" stringByAppendingPathComponent:file]
#define LYCOMRefreshFrameworkSrcName(file) [@"Frameworks/LYCOMRefresh.framework/LYCOMRefresh.bundle" stringByAppendingPathComponent:file]

// 常量
UIKIT_EXTERN const CGFloat LYCOMRefreshHeaderHeight;
UIKIT_EXTERN const CGFloat LYCOMRefreshFooterHeight;
UIKIT_EXTERN const CGFloat LYCOMRefreshFastAnimationDuration;
UIKIT_EXTERN const CGFloat LYCOMRefreshSlowAnimationDuration;

UIKIT_EXTERN NSString *const LYCOMRefreshKeyPathContentOffset;
UIKIT_EXTERN NSString *const LYCOMRefreshKeyPathContentSize;
UIKIT_EXTERN NSString *const LYCOMRefreshKeyPathContentInset;
UIKIT_EXTERN NSString *const LYCOMRefreshKeyPathPanState;

UIKIT_EXTERN NSString *const LYCOMRefreshHeaderLastUpdatedTimeKey;

UIKIT_EXTERN NSString *const LYCOMRefreshHeaderIdleText;
UIKIT_EXTERN NSString *const LYCOMRefreshHeaderPullingText;
UIKIT_EXTERN NSString *const LYCOMRefreshHeaderRefreshingText;

UIKIT_EXTERN NSString *const LYCOMRefreshAutoFooterIdleText;
UIKIT_EXTERN NSString *const LYCOMRefreshAutoFooterRefreshingText;
UIKIT_EXTERN NSString *const LYCOMRefreshAutoFooterNoMoreDataText;

UIKIT_EXTERN NSString *const LYCOMRefreshBackFooterIdleText;
UIKIT_EXTERN NSString *const LYCOMRefreshBackFooterPullingText;
UIKIT_EXTERN NSString *const LYCOMRefreshBackFooterRefreshingText;
UIKIT_EXTERN NSString *const LYCOMRefreshBackFooterNoMoreDataText;

// 状态检查
#define LYCOMRefreshCheckState \
LYCOMRefreshState oldState = self.state; \
if (state == oldState) return; \
[super setState:state];
