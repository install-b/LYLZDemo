//
//  FileViewCell.m
//  fileManage
//
//  Created by Vieene on 2016/10/13.
//  Copyright © 2016年 深圳柒壹思诺科技有限公司. All rights reserved.
//

#import "LYFileViewCell.h"
#import "HPWYsonry.h"
#import "LYFileObjModel.h"
#import "UIColor+HexColor.h"
#import "UIImage+Bundle.h"
#import "NSString+Time.h"


@interface LYFileViewCell ()
@property (nonatomic,strong) UIImageView *headImagV;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *detailLabel;
@property (nonatomic,strong) UIButton *sendBtn;
@end


@implementation LYFileViewCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _headImagV = [[UIImageView alloc] init];
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.lineBreakMode=NSLineBreakByTruncatingMiddle;

        _titleLabel.numberOfLines = 1;
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.numberOfLines = 1;
        _detailLabel.lineBreakMode=NSLineBreakByTruncatingMiddle;
        
        _sendBtn = [[UIButton alloc] init];
        [_sendBtn setImage:[UIImage imageFromFileSelectorBunldeWithNamed:@"file_unselected.png"] forState:UIControlStateNormal];
        [_sendBtn setImage:[UIImage imageFromFileSelectorBunldeWithNamed:@"file_selected.png"] forState:UIControlStateSelected];

        [_sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_sendBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        _titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _detailLabel.textColor = [UIColor colorWithHexString:@"999999"];
        [self.contentView addSubview:_headImagV];
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_detailLabel];
        [self.contentView addSubview:_sendBtn];
    }
    return self;
}
- (void)setModel:(LYFileObjModel *)model
{
    _model = model;
    
    if (model.imagePath) {
        self.headImagV.image = [UIImage imageWithContentsOfFile:model.imagePath];
    }else{
        self.headImagV.image = model.image;
    }
    
    self.titleLabel.text = model.name;
    self.detailLabel.text = [[model.creatTime lyt_timeString] stringByAppendingString:[NSString stringWithFormat:@"   %@",model.fileSize]];
    self.sendBtn.selected = model.select;
    
}
- (void)clickBtn:(UIButton *)btn
{

        btn.selected = !btn.selected;
        self.model.select = btn.selected;
        if (_Clickblock) {
            _Clickblock(_model,btn);
        }

}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat margin = 12;
    CGFloat w = 48;
    CGFloat h = 48;
    [_headImagV hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.left.equalTo(self.hpwys_left).offset(margin);
        make.centerY.equalTo(self.hpwys_centerY);
        make.size.hpwys_equalTo(CGSizeMake(w, h));
    }];
    [_titleLabel hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.left.equalTo(self.headImagV.hpwys_right).offset(10);
        make.centerY.equalTo(self.hpwys_centerY).offset(-10);
        make.right.equalTo(self.sendBtn.hpwys_left).offset(-margin);
    }];
    [_detailLabel hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.left.equalTo(self.headImagV.hpwys_right).offset(10);
        make.centerY.equalTo(self.hpwys_centerY).offset(10);
        make.right.equalTo(self.sendBtn.hpwys_left).offset(-margin);
    }];
    [_sendBtn hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.right.equalTo(self.hpwys_right).offset(-margin);
        make.centerY.equalTo(self.hpwys_centerY);
        make.size.hpwys_equalTo(CGSizeMake(50, 50));
    }];
}
@end
