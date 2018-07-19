//
//  FSVoiceBubble.m
//  Pods
//
//  Created by Wenchao Ding on 3/25/15.
//
//

#import "TYHVoiceBubble.h"
#import "UIColor+LYColor.h"
#import "UIView+Frame.h"
#import "UIImage+BundleImage.h"
#import "UIImage+Utility.h"
//#define UIImageNamed(imageName) [[UIImage imageNamed:[NSString stringWithFormat:@"FSVoiceBubble.bundle/%@", imageName]] imageWithRenderingMode:UIImageRenderingModeAutomatic]

@interface TYHVoiceBubble ()
//动画图片
@property (strong, nonatomic) NSArray       *animationImages;
//显示时间
@property (weak  , nonatomic) UIButton      *contentButton;

- (void)initialize;
@end

@implementation TYHVoiceBubble

@dynamic bubbleImage, textColor;

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;
    self.userInteractionEnabled = NO;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.backgroundColor                = [UIColor clearColor];
    button.titleLabel.font                = [UIFont systemFontOfSize:12];
    button.adjustsImageWhenHighlighted    = YES;
    button.imageView.animationDuration    = 2.0;
    button.imageView.animationRepeatCount = 30;
    button.imageView.clipsToBounds        = NO;
    button.imageView.contentMode          = UIViewContentModeCenter;
    button.contentHorizontalAlignment     = UIControlContentHorizontalAlignmentRight;
    [self addSubview:button];
    self.contentButton = button;
    self.contentButton.userInteractionEnabled = NO;
    
    self.textColor = [UIColor getColor:@"333333"];
    
    _animatingWaveColor = [UIColor whiteColor];
    _exclusive = YES;
    _durationInsideBubble = NO;
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _contentButton.frame = self.bounds;

    NSString *title = [_contentButton titleForState:UIControlStateNormal];
    if (title && title.length) {
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:[_contentButton titleForState:UIControlStateNormal] attributes:attributes];
        _contentButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _contentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//右边
        UIImage *image2 = [[[UIImage lyt_chatImageNamed:@"fs_icon_wave_2"] imageWithRenderingMode:UIImageRenderingModeAutomatic] imageWithOverlayColor:[UIColor getColor:@"333333"]];
        CGFloat Magin = 25;
        
        if ([self.seconds length] >= 2) {
            Magin = 32;
        }
        
        CGFloat leftMagin = self.width  - image2.size.width - Magin;
        UIEdgeInsets inset = UIEdgeInsetsMake(0,
                                              0,
                                              0,
                                              leftMagin);
        _contentButton.imageEdgeInsets = inset;
        NSInteger textPadding = _invert ? 2 : 4;

        if (_durationInsideBubble) {
            _contentButton.titleEdgeInsets = UIEdgeInsetsMake(1, -8-_textInset, 0, 8+_textInset);
        } else {
            _contentButton.titleEdgeInsets = UIEdgeInsetsMake(self.bounds.size.height - attributedString.size.height,
                                                    attributedString.size.width + textPadding,
                                                    0,
                                                    -attributedString.size.width - textPadding);
        }
        self.layer.transform = _invert ? CATransform3DMakeRotation(M_PI, 0, 1.0, 0) : CATransform3DIdentity;
        
        _contentButton.titleLabel.layer.transform = _invert ? CATransform3DMakeRotation(M_PI, 0.0, 1.0, 0.0) : CATransform3DIdentity;
        if (_invert) {//1 为右边
            UIImage *image2 = [[[UIImage lyt_chatImageNamed:@"fs_icon_wave_2"] imageWithRenderingMode:UIImageRenderingModeAutomatic] imageWithOverlayColor:[UIColor whiteColor]];
                [self.contentButton setImage:image2 forState:UIControlStateNormal];
            [self.contentButton setImage:image2 forState:UIControlStateHighlighted];

        }else{
            UIImage *image2 = [[[UIImage lyt_chatImageNamed:@"fs_icon_wave_2"] imageWithRenderingMode:UIImageRenderingModeAutomatic] imageWithOverlayColor:[UIColor getColor:@"333333"]];
            [self.contentButton setImage:image2 forState:UIControlStateNormal];
            [self.contentButton setImage:image2 forState:UIControlStateHighlighted];
        }
    }
}

# pragma mark - Setter & Getter

- (void)setWaveColor:(UIColor *)waveColor {
    if (![_waveColor isEqual:waveColor]) {
        _waveColor = waveColor;
        UIImage *image = [[[UIImage lyt_chatImageNamed:@"fs_icon_wave_2"] imageWithRenderingMode:UIImageRenderingModeAutomatic] imageWithOverlayColor:[UIColor getColor:@"333333"]];
        [_contentButton setImage:image forState:UIControlStateNormal];
    }
}

- (void)setInvert:(BOOL)invert {
    if (_invert != invert) {
        _invert = invert;
        [self setNeedsLayout];
    }
}

- (void)setBubbleImage:(UIImage *)bubbleImage
{
//    [_contentButton setBackgroundImage:bubbleImage forState:UIControlStateNormal];
}

- (void)setTextColor:(UIColor *)textColor
{
    [_contentButton setTitleColor:textColor forState:UIControlStateNormal];
}

- (UIColor *)textColor
{
    return [_contentButton titleColorForState:UIControlStateNormal];
}

- (UIImage *)bubbleImage
{
    return [_contentButton backgroundImageForState:UIControlStateNormal];
}

- (void)setWaveInset:(CGFloat)waveInset {
    if (_waveInset != waveInset) {
        _waveInset = waveInset;
        [self setNeedsLayout];
    }
}

- (void)setSeconds:(NSString *)seconds {
    _seconds = seconds;
    if ([_seconds intValue] > 60) {
        _seconds = @"60";
    }
    [_contentButton setTitle:[NSString stringWithFormat:@"%@\"",_seconds] forState:UIControlStateNormal];
    NSString *timeStr ;
    if ([seconds isEqualToString:@"0"]) {
        timeStr = @" ";
    } else {
        timeStr = [NSString stringWithFormat:@"%@\"",_seconds];
    }
    [_contentButton setTitle:timeStr forState:UIControlStateNormal];
    [self setNeedsLayout];
}

- (void)setTextInset:(CGFloat)textInset {
    if (_textInset != textInset) {
        _textInset = textInset;
        [self setNeedsLayout];
    }
}

#pragma mark - Public
- (void)startAnimating {
    if (!_contentButton.imageView.isAnimating) {
        UIColor *color = nil;
        if (_invert) {
            color = [UIColor whiteColor];
        }else{
            color = [UIColor getColor:@"333333"];
        }
        
        UIImage *image0 = [[[UIImage lyt_chatImageNamed:@"fs_icon_wave_0"] imageWithRenderingMode:UIImageRenderingModeAutomatic] imageWithOverlayColor:color];
        UIImage *image1 = [[[UIImage lyt_chatImageNamed:@"fs_icon_wave_1"] imageWithRenderingMode:UIImageRenderingModeAutomatic] imageWithOverlayColor:color];
        UIImage *image2 = [[[UIImage lyt_chatImageNamed:@"fs_icon_wave_2"] imageWithRenderingMode:UIImageRenderingModeAutomatic] imageWithOverlayColor:color];
        
        _contentButton.imageView.animationImages = @[image0, image1, image2];
        [_contentButton.imageView startAnimating];
    }
}

- (void)stopAnimating
{
    if (_contentButton.imageView.isAnimating) {
        [_contentButton.imageView stopAnimating];
    }
}



@end
