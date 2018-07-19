//
//  CJSendRedpackageVc.m
//  Antenna
//
//  Created by LY-ZJ-201604422 on 2017/8/4.
//  Copyright © 2017年 HHLY. All rights reserved.
//

#import "LYLZSendRedpackageVc.h"
#import "UIImage+Utility.h"
#import "UIColor+LYColor.h"
#import "UIColor+HexColor.h"
#import "LYTCommonHeader.h"
#import "LYLZChatManager+Private.h"
#import "HPWYSProgressHUD.h"


#define tagVernier 10

@interface LYLZSendRedpackageVc ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *redPacketView;

@property (nonatomic, strong) NSArray *array;

@property (nonatomic, strong) UITextField *numberText;

@property (nonatomic, strong) UIButton *sendBtn;

@property (nonatomic, weak) UIButton *btnArray;

@property (nonatomic, copy) NSString * numberTextString;

@property (nonatomic, strong) NSPredicate * numberPred;
@end

@implementation LYLZSendRedpackageVc

#pragma  mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发红包";
    self.view.backgroundColor = [UIColor colorWithHexString:@"ebebeb"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
}

#pragma mark - 添加子控件
- (void)addSubView {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(12, 12, LYScreenW - 24, 246)];
    bgView.layer.cornerRadius = 3;
    bgView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self.view addSubview:bgView];
    
    _redPacketView = [[UIView alloc] init];
    CGRect viewFrame = CGRectMake(0 , 0 , LYScreenW - 24, 58);
    _redPacketView.frame = viewFrame;
    [bgView addSubview:_redPacketView];
    // 红包金额的数组
    NSArray *labels = [[LYLZChatManager shareManager] normalAmountOfPacketToLawyer:self.lawler];
    _array = labels;
    
    CGFloat btnW = (_redPacketView.width  - 12 * 5) / 4.0;
    CGFloat btnH = 34;
    CGFloat margin = 12;
    for (int a = 0; a < labels.count; a++) {
        UIButton *btn  = [[UIButton alloc] init];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        btn.tag = a + tagVernier;
        NSDictionary *typeDic = labels[a];
        NSString *title;
        if ([typeDic isKindOfClass:[NSDictionary class]]) {
            if([[typeDic allKeys] containsObject:@"typeName"]){
                title = typeDic[@"typeName"];
            }
        } else {
            title = labels[a];
        }
        
        [btn setTitle:[NSString stringWithFormat:@"%@元",title] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(clickbtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor colorWithHexString:@"fe3000"] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor colorWithHexString:@"fe3000"] forState:UIControlStateSelected];
        [_redPacketView addSubview:btn];
        
        btn.frame = CGRectMake(margin * (a + 1) + a * btnW, 13, btnW, btnH);
        btn.layer.cornerRadius = 6;
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor getColor:@"cccccc" alpha:1].CGColor;
    }
    
    UIView *grayLine = [[UIView alloc] initWithFrame:CGRectMake(12, 12 + btnH + 12, 327, 1)];
    grayLine.backgroundColor =  [UIColor getColor:@"e0e0e0" alpha:1];
    [bgView addSubview:grayLine];
    
    UIView *textView = [[UIView alloc] initWithFrame:CGRectMake(12, 12 + btnH + 12, bgView.width - 24, 105)];
    [bgView addSubview:textView];
    
    
    UILabel *redPacketLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 100, 24)];
    redPacketLab.text = @"红包金额";
    redPacketLab.font = [UIFont systemFontOfSize:13];
    redPacketLab.tintColor = [UIColor colorWithHexString:@"333333"];
    [textView addSubview:redPacketLab];
    
    UILabel *unitSymbolLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 55, 60, 40)];
    unitSymbolLab.text = @"¥";
    unitSymbolLab.font = [UIFont systemFontOfSize:40];
    unitSymbolLab.tintColor = [UIColor colorWithHexString:@"333333"];
    [textView addSubview:unitSymbolLab];
    
    _numberText = [[UITextField alloc] initWithFrame:CGRectMake(60, 55, 200, 40)];
    _numberText.font = [UIFont systemFontOfSize:40];
    _numberText.delegate = self;
    _numberText.keyboardType = UIKeyboardTypeDecimalPad;
    [_numberText addTarget:self
                    action:@selector(numbertextFieldDidChange:)
          forControlEvents:UIControlEventEditingChanged];
    [textView addSubview:_numberText];
    _numberText.tintColor = [UIColor colorWithHexString:@"333333"];
    [textView addSubview:_numberText];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 105, textView.width, 1)];
    line.backgroundColor = [UIColor getColor:@"e0e0e0" alpha:1];
    [textView addSubview:line];
    
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(12, 12 + btnH + 12 + 125, bgView.width - 24, 44)];
    sendBtn.layer.cornerRadius = 3;
    sendBtn.backgroundColor = [UIColor colorWithHexString:@"fe3000"];
    [sendBtn setTitle:@"塞钱" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [sendBtn setTitleColor:[UIColor colorWithHexString:@"fefefe"] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendDone:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:sendBtn];
    
    _sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(12, 12 + btnH + 12 + 125, bgView.width - 24, 44)];
    _sendBtn.layer.cornerRadius = 3;
    [_sendBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ec2d00"]] forState:UIControlStateNormal];
    [_sendBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ffb6a5"]] forState:UIControlStateDisabled];
    [_sendBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"fe3000"]] forState:UIControlStateHighlighted];
    [_sendBtn setTitle:@"塞钱" forState:UIControlStateNormal];
    _sendBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [_sendBtn setTitleColor:[UIColor colorWithHexString:@"fefefe"] forState:UIControlStateNormal];
    [_sendBtn addTarget:self action:@selector(sendDone:) forControlEvents:UIControlEventTouchUpInside];
    BOOL isNoMoney = _numberText.text.length == 0;
    _sendBtn.enabled = !isNoMoney;
    [bgView addSubview:_sendBtn];
}

#pragma mark - 金额按钮点击事件
- (void)clickbtn:(UIButton *)btn {
    NSArray *views = [_redPacketView subviews];
    for (UIButton *btn in views) {
        btn.layer.borderColor = [UIColor getColor:@"cccccc" alpha:1].CGColor;
        btn.selected = NO;
    }
    
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        btn.layer.borderColor = [UIColor colorWithHexString:@"fe3000"].CGColor;
        self.btnArray = btn;
        _numberText.text = [NSString stringWithFormat:@"%@",self.array[btn.tag - tagVernier]];
        
        _sendBtn.enabled = _numberText.text.length;
    } else {
        btn.layer.borderColor = [UIColor getColor:@"cccccc" alpha:1].CGColor;
    }
}

//textfield-noti
- (void)numbertextFieldDidChange:(UITextField*)textField {
   
    if (textField.text.length && ![self.numberPred evaluateWithObject:textField.text]) {
        [HPWYSProgressHUD showErrorWithStatus:@"请输入正确的金额"];
        textField.text = _numberTextString;
        
    } else if ([textField.text componentsSeparatedByString:@"."].count > 2 && [textField.text hasSuffix:@"."]) {
       
        [HPWYSProgressHUD showErrorWithStatus:@"请输入正确的金额"];
        textField.text = _numberTextString;
        
    } else {
        
        _numberTextString = textField.text;
        CGFloat number = [_numberTextString floatValue];
        __block BOOL isContain = NO;
        [self.array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ( [obj floatValue] == number) {
                UIButton *btn = [self.redPacketView viewWithTag:idx + tagVernier];
                btn.selected = YES;
                btn.layer.borderColor = [UIColor colorWithHexString:@"fe3000"].CGColor;
                self.btnArray.selected = NO;
                self.btnArray.layer.borderColor = [UIColor getColor:@"cccccc" alpha:1].CGColor;
                self.btnArray = btn;
                isContain = YES;
                *stop = YES;
            }
        }];
        
        if (!isContain) {
            self.btnArray.selected = NO;
            self.btnArray.layer.borderColor = [UIColor getColor:@"cccccc" alpha:1].CGColor;
            self.btnArray = nil;
        }
    }
   
    _sendBtn.enabled = textField.text.length;
}

//UITapGestureRecognizer - textfield resignFirstResponder
- (void)handleSingleTap:(UITapGestureRecognizer *)sender {
    [_numberText resignFirstResponder];
}

- (void)sendDone:(UIButton *)btn {
    
    [[LYLZChatManager shareManager] sendRedPacket:[NSString stringWithFormat:@"%@",self.numberText.text] toLawyer:self.lawler];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSPredicate *)numberPred {
    if (!_numberPred) {
        _numberPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[0-9.]*$"];
    }
    return _numberPred;
}


@end
