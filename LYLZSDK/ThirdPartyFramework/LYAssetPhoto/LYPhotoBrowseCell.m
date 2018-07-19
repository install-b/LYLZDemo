//
//  CJPhotoBrowseCell.m
//  weChat
//
//  Created by Lc on 16/3/29.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LYPhotoBrowseCell.h"
#import "LYPhotoBrowseView.h"

#import "LYTProgressView.h"
#import "UIImage+HPWYSGIF.h"
#import "UIImageView+HPWYSWebCache.h"
#import "UIView+Frame.h"
/** self的弱引用 */
#define LYTWeakSelf __weak typeof(self) weakSelf = self;
#define progressViewWH  100
@interface LYPhotoBrowseCell () <UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *imgScrollView;
@property (strong, nonatomic) LYTProgressView *progressView;
@property (nonatomic, assign) BOOL doubleTap;
@end

@implementation LYPhotoBrowseCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.imgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 0, CGRectGetWidth(self.bounds) -10, CGRectGetHeight(self.bounds))];
        self.imgScrollView.delegate = self;
        self.imgScrollView.maximumZoomScale = 3.0;
        self.imgScrollView.minimumZoomScale = 1;
        self.imgScrollView.showsVerticalScrollIndicator = NO;
        self.imgScrollView.showsHorizontalScrollIndicator = NO;
        self.imgScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        self.imgScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.imgScrollView];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
 
        self.imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.imgScrollView addSubview:self.imageView];
        
//            [UIView animateWithDuration:0.3 animations:^{
//                self.imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-self.imageView.image.size.height*[UIScreen mainScreen].bounds.size.width/self.imageView.image.size.width)/2, [UIScreen mainScreen].bounds.size.width, self.imageView.image.size.height*[UIScreen mainScreen].bounds.size.width/self.imageView.image.size.width);
//        
//            } completion:^(BOOL finished) {
//                   self.imageView.frame = CGRectMake(0, 0, self.width, self.height);
//            }];
//        
        self.progressView = [[LYTProgressView alloc] initWithFrame:CGRectMake((self.width - progressViewWH) * 0.5 , (self.height  -progressViewWH )*0.5, progressViewWH, progressViewWH)];
//        self.progressView.roundedCorners = 5;
//        self.progressView.progressLabel.textColor = [UIColor whiteColor];
        self.progressView.hidden = YES;
        [self addSubview:self.progressView];

        // 监听点击
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
        singleTap.delaysTouchesBegan = YES;
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        
    }
    
    return self;
}

- (void)setMessage:(id <LYPhotoBrowsePotoProtocol>)body
{
    _message = body;
    
//    id <LYPhotoBrowsePotoProtocol> body =
//    LYTImageMessageBody *body = (LYTImageMessageBody *)message.messageBody;
    NSData *localImageData;// = [NSData dataWithContentsOfFile:body.localPath];
    LYTWeakSelf;
    if ([body.picUrl hasPrefix:@"http:"] && localImageData.length == 0) {

        
        [self.imageView hpwys_setImageWithURL:[NSURL URLWithString:body.picUrl]  placeholderImage:nil options:HPWYSWebImageLowPriority | HPWYSWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
            weakSelf.progressView.hidden = NO;
            weakSelf.progressView.progress = 1.0 * receivedSize / expectedSize;
//            weakSelf.progressView.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", weakSelf.progressView.progress * 100];
        } completed:^(UIImage *image, NSError *error, HPWYSImageCacheType cacheType, NSURL *imageURL) {
            weakSelf.progressView.hidden = YES;
            [self adjustFrame];
        }];
    }
    else{

        UIImage *image = [UIImage hpwys_animatedGIFWithData:localImageData];
        [self.imageView setImage:image];
    }
    
    [self adjustFrame];
}

- (void)adjustFrame
{
    if (_imageView.image == nil) return;
    
    CGSize boundsSize = self.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    
    CGSize imageSize = _imageView.image.size;
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
    
    // 设置伸缩比例
    CGFloat minScale = boundsWidth / imageWidth;
    if (minScale > 1) minScale = 1.0;
    
    CGFloat maxScale = 3.0;
    
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        maxScale = maxScale / [[UIScreen mainScreen] scale];
    }
    self.imgScrollView.maximumZoomScale = maxScale;
    self.imgScrollView.minimumZoomScale = minScale;
    self.imgScrollView.zoomScale = minScale;
    
    CGRect imageFrame = CGRectMake(0, 0, boundsWidth, imageHeight * boundsWidth / imageWidth);
    // 内容尺寸
    self.imgScrollView.contentSize = CGSizeMake(0, imageFrame.size.height);
    
    // y值
    if (imageFrame.size.height < boundsHeight) {
        imageFrame.origin.y = floorf((boundsHeight - imageFrame.size.height) / 2.0);
    } else {
        imageFrame.origin.y = 0;
    }
    
    _imageView.frame = imageFrame;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGRect imageViewFrame = _imageView.frame;
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    if (imageViewFrame.size.height > screenBounds.size.height) {
        imageViewFrame.origin.y = 0.0f;
    } else {
        imageViewFrame.origin.y = (screenBounds.size.height - imageViewFrame.size.height) / 2.0;
    }
    _imageView.frame = imageViewFrame;
}

- (void)handleSingleTap
{
    _doubleTap = NO;
    [self performSelector:@selector(hide) withObject:nil afterDelay:0.2];
    
}

- (void)hide
{
    if (_doubleTap) return;
    if ([self.delegate respondsToSelector:@selector(photoBrowseCellEndZooming:)]) {
        [self.delegate photoBrowseCellEndZooming:self];
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    _doubleTap = YES;
    
    CGPoint touchPoint = [tap locationInView:self];
    if (self.imgScrollView.zoomScale == self.imgScrollView.maximumZoomScale) {
        [self.imgScrollView setZoomScale:self.imgScrollView.minimumZoomScale animated:YES];
    } else {
        [self.imgScrollView zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
    }
}

@end
