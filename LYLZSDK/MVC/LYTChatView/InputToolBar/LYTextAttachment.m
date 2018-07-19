//
//  LYTextAttachment.m
//  LYLink
//
//  Created by SYLing on 2016/12/7.
//  Copyright © 2016年 HHLY. All rights reserved.
//

#import "LYTextAttachment.h"
#import "UIImage+BundleImage.h"

@implementation LYTextAttachment

- (void)setEmotion:(LYEmotion *)emotion {
    _emotion = emotion;
    self.image = [UIImage lyt_emotionImageNamed:emotion.png];
}

@end
