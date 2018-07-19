
#import "UIView+LYCOMExtension.h"

@implementation UIView (LYCOMExtension)
- (void)setLycom_x:(CGFloat)lycom_x
{
    CGRect frame = self.frame;
    frame.origin.x = lycom_x;
    self.frame = frame;
}

- (CGFloat)lycom_x
{
    return self.frame.origin.x;
}

- (void)setLycom_y:(CGFloat)lycom_y
{
    CGRect frame = self.frame;
    frame.origin.y = lycom_y;
    self.frame = frame;
}

- (CGFloat)lycom_y
{
    return self.frame.origin.y;
}

- (void)setLycom_w:(CGFloat)lycom_w
{
    CGRect frame = self.frame;
    frame.size.width = lycom_w;
    self.frame = frame;
}

- (CGFloat)lycom_w
{
    return self.frame.size.width;
}

- (void)setLycom_h:(CGFloat)lycom_h
{
    CGRect frame = self.frame;
    frame.size.height = lycom_h;
    self.frame = frame;
}

- (CGFloat)lycom_h
{
    return self.frame.size.height;
}

- (void)setLycom_size:(CGSize)lycom_size
{
    CGRect frame = self.frame;
    frame.size = lycom_size;
    self.frame = frame;
}

- (CGSize)lycom_size
{
    return self.frame.size;
}

- (void)setLycom_origin:(CGPoint)lycom_origin
{
    CGRect frame = self.frame;
    frame.origin = lycom_origin;
    self.frame = frame;
}

- (CGPoint)lycom_origin
{
    return self.frame.origin;
}
@end
