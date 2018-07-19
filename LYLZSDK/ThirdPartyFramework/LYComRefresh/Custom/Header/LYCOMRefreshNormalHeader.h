#import "LYCOMRefreshStateHeader.h"

@interface LYCOMRefreshNormalHeader : LYCOMRefreshStateHeader
@property (weak, nonatomic, readonly) UIImageView *arrowView;
/** 菊花的样式 */
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;
@end
