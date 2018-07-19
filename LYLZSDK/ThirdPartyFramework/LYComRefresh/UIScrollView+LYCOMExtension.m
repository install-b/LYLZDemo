
#import "UIScrollView+LYCOMExtension.h"
#import <objc/runtime.h>

@implementation UIScrollView (LYCOMExtension)

- (void)setLycom_insetT:(CGFloat)lycom_insetT
{
    UIEdgeInsets inset = self.contentInset;
    inset.top = lycom_insetT;
    self.contentInset = inset;
}

- (CGFloat)lycom_insetT
{
    return self.contentInset.top;
}

- (void)setLycom_insetB:(CGFloat)lycom_insetB
{
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = lycom_insetB;
    self.contentInset = inset;
}

- (CGFloat)lycom_insetB
{
    return self.contentInset.bottom;
}

- (void)setLycom_insetL:(CGFloat)lycom_insetL
{
    UIEdgeInsets inset = self.contentInset;
    inset.left = lycom_insetL;
    self.contentInset = inset;
}

- (CGFloat)lycom_insetL
{
    return self.contentInset.left;
}

- (void)setLycom_insetR:(CGFloat)lycom_insetR
{
    UIEdgeInsets inset = self.contentInset;
    inset.right = lycom_insetR;
    self.contentInset = inset;
}

- (CGFloat)lycom_insetR
{
    return self.contentInset.right;
}

- (void)setLycom_offsetX:(CGFloat)lycom_offsetX
{
    CGPoint offset = self.contentOffset;
    offset.x = lycom_offsetX;
    self.contentOffset = offset;
}

- (CGFloat)lycom_offsetX
{
    return self.contentOffset.x;
}

- (void)setLycom_offsetY:(CGFloat)lycom_offsetY
{
    CGPoint offset = self.contentOffset;
    offset.y = lycom_offsetY;
    self.contentOffset = offset;
}

- (CGFloat)lycom_offsetY
{
    return self.contentOffset.y;
}

- (void)setLycom_contentW:(CGFloat)lycom_contentW
{
    CGSize size = self.contentSize;
    size.width = lycom_contentW;
    self.contentSize = size;
}

- (CGFloat)lycom_contentW
{
    return self.contentSize.width;
}

- (void)setLycom_contentH:(CGFloat)lycom_contentH
{
    CGSize size = self.contentSize;
    size.height = lycom_contentH;
    self.contentSize = size;
}

- (CGFloat)lycom_contentH
{
    return self.contentSize.height;
}
@end
