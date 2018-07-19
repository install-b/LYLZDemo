//
//  LYAssetGridToolBar.m
//  TaiYangHua
//
//  Created by Lc on 16/2/17.
//  Copyright © 2016年 深圳柒壹思诺科技有限公司. All rights reserved.
//

#import "LYAssetGridToolBar.h"
#import "LYAsset.h"
#import "UIColor+HexColor.h"
#import "HPWYsonry.h"
#import "UIImage+Utility.h"
#import "UIImage+Bundle.h"

#define color227shallblue [UIColor colorWithRed:0.133 green:0.478 blue:0.898 alpha:1.000]

@interface LYAssetGridToolBar ()

@property (weak, nonatomic) UIButton *previewButton;
@property (weak, nonatomic) UIButton *originalButton;
@property (weak, nonatomic) UIButton *senderButton;
@property (weak, nonatomic) UILabel *originalLabel;
@property (assign, nonatomic) NSInteger bytes;

@end

@implementation LYAssetGridToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self previewButton];
        [self originalButton];
        [self originalLabel];
        [self senderButton];
    }
    return self;
}

#pragma mark - lazy
- (UIButton *)previewButton
{
    if (!_previewButton) {
        UIButton *previewButton = [[UIButton alloc] init];
        [previewButton setTitle:@"预览" forState:UIControlStateNormal];
        [previewButton setTitleColor:color227shallblue forState:UIControlStateNormal];
        [previewButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [previewButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [previewButton setEnabled:NO];
        [previewButton addTarget:self action:@selector(clickPreviewButton:) forControlEvents:UIControlEventTouchUpInside];
        _previewButton = previewButton;
        [self addSubview:_previewButton];
    }
    
    return _previewButton;
}

- (UIButton *)originalButton
{
    if (!_originalButton) {
        UIButton *originalButton = [[UIButton alloc] init];
        [originalButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [originalButton setTitle:@"原图" forState:UIControlStateNormal];
        [originalButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [originalButton setTitleColor:color227shallblue forState:UIControlStateSelected];
        [originalButton setImage:[UIImage lyt_selectorImageNamed:@"file_unselected"] forState:UIControlStateNormal];
        [originalButton setImage:[UIImage lyt_selectorImageNamed:@"file_selected"] forState:UIControlStateSelected];
        [originalButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [originalButton setUserInteractionEnabled:NO];
        [originalButton addTarget:self action:@selector(clickOriginalButton:) forControlEvents:UIControlEventTouchUpInside];
        _originalButton = originalButton;
        [self addSubview:_originalButton];
    }
    
    return _originalButton;
}

- (UILabel *)originalLabel
{
    if (!_originalLabel) {
        UILabel *originalLabel = [[UILabel alloc] init];
        [originalLabel setFont:[UIFont systemFontOfSize:16]];
        [originalLabel setHidden:YES];
        [originalLabel setTextColor:color227shallblue];
        _originalLabel = originalLabel;
        [self addSubview:_originalLabel];
    }
    
    return _originalLabel;
}

- (UIButton *)senderButton
{
    if (!_senderButton) {
        UIButton *senderButton = [[UIButton alloc] init];
        [senderButton setBackgroundImage:[UIImage imageWithColor:color227shallblue] forState:UIControlStateNormal];
        [senderButton setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
        [senderButton setTitle:@"发送" forState:UIControlStateDisabled];
        [senderButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [senderButton.layer setCornerRadius:5];
        [senderButton.layer setMasksToBounds:YES];
        [senderButton setEnabled:NO];
        [senderButton addTarget:self action:@selector(clickSenderButton:) forControlEvents:UIControlEventTouchUpInside];
        _senderButton = senderButton;
        [self addSubview:_senderButton];
    }
    
    return _senderButton;
}

#pragma mark - allButton Action
- (void)clickPreviewButton:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(didClickPreviewInAssetGridToolBar:)]) {
        [self.delegate didClickPreviewInAssetGridToolBar:self];
    }
}

- (void)clickOriginalButton:(UIButton *)button
{
    button.selected = !button.isSelected;
    self.originalLabel.hidden = !button.isSelected;
    [self calculateAllselectedItemsBytes];
}

- (void)clickSenderButton:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(didClickSenderButtonInAssetGridToolBar:)]) {
        [self.delegate didClickSenderButtonInAssetGridToolBar:self];
    }
}

- (void)setSelectedItems:(NSMutableArray *)selectedItems
{
     _selectedItems = selectedItems;
    
    // 按钮能否点击
    self.previewButton.enabled = selectedItems.count > 0 ? YES : NO;
    self.originalButton.userInteractionEnabled = selectedItems.count > 0 ? YES : NO;
    self.senderButton.enabled = selectedItems.count > 0 ? YES : NO;
    
    // 按钮是否显示
    if (selectedItems.count == 0) self.originalButton.selected = NO;
    if (selectedItems.count > 0) [self.senderButton setTitle:[NSString stringWithFormat:@"%@(%ld)", @"发送", (unsigned long)selectedItems.count] forState:UIControlStateNormal];
    if (selectedItems.count == 0) self.originalLabel.hidden = YES;
    
    // 显示大小
    [self calculateAllselectedItemsBytes];
}

// 计算所有选中image的大小
- (void)calculateAllselectedItemsBytes
{
    if (self.originalButton.isSelected) {
        __block NSInteger dataLength = 0;
        __block NSInteger lastSelectedItem = 0;
        
        for (LYAsset *internalAsset in self.selectedItems) {
            lastSelectedItem++;
            dataLength += internalAsset.dataLength;
            
            if (lastSelectedItem == self.selectedItems.count) {
                NSString *bytes = nil;
                if (dataLength >= 0.1 * (1024 * 1024)) {
                    bytes = [NSString stringWithFormat:@"%0.1fM",dataLength/1024/1024.0];
                } else if (dataLength >= 1024) {
                    bytes = [NSString stringWithFormat:@"%0.0fK",dataLength/1024.0];
                } else {
                    bytes = [NSString stringWithFormat:@"%zdB",dataLength];
                }
                
                self.originalLabel.text = [NSString stringWithFormat:@"(%@)", bytes];
                
            }
        }
    }
}

#pragma mark - layoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_previewButton hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.centerY.equalTo(self);
    }];
    
    [_originalButton hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.left.equalTo(self).offset(80);
        make.width.equalTo(@(70));
        make.centerY.equalTo(self);
    }];
    
    [_originalLabel hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.originalButton.hpwys_right);
    }];
    
    [_senderButton hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.right.equalTo(self).offset(-12);
        make.centerY.equalTo(self);
        make.height.equalTo(@(29));
        make.width.equalTo(@(68));
    }];
}

@end
