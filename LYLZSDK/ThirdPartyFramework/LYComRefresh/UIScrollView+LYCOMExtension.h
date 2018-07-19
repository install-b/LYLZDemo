#import <UIKit/UIKit.h>

@interface UIScrollView (LYCOMExtension)
@property (assign, nonatomic) CGFloat lycom_insetT;
@property (assign, nonatomic) CGFloat lycom_insetB;
@property (assign, nonatomic) CGFloat lycom_insetL;
@property (assign, nonatomic) CGFloat lycom_insetR;

@property (assign, nonatomic) CGFloat lycom_offsetX;
@property (assign, nonatomic) CGFloat lycom_offsetY;

@property (assign, nonatomic) CGFloat lycom_contentW;
@property (assign, nonatomic) CGFloat lycom_contentH;
@end
