//
//  UIColor+HexColor.h
//  LYTDemo
//
//  Created by Shangen Zhang on 2017/5/12.
//  Copyright © 2017 深圳柒壹思诺科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark -定义颜色的宏
#define LYColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define LYColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]


#define BackGroundColor LYColor(236, 241, 244);
//黑色
#define APPBLACKCOLOR [UIColor colorWithWhite:0.298 alpha:1.000]//4C4C4C
//灰色 字体
#define APPGREYCOLOR [UIColor colorWithWhite:0.600 alpha:1.000]//999999
//线条颜色
#define APPLINECOLOR [UIColor colorWithWhite:0.898 alpha:1.000]//E5E5E5
//背景颜色 灰
#define APPBACKGROUNDCOLOR [UIColor colorWithRed:0.949 green:0.949 blue:0.922 alpha:1.000]//F2F2EB

#define APPDLIDERCOLOR [UIColor colorWithRed:1.000 green:0.690 blue:0.773 alpha:1.000]


//常见颜色
#define backColor [UIColor colorWithRed:0.757 green:0.875 blue:1.000 alpha:1.000];

//蓝色

#define colorC1D [UIColor colorWithRed:0.757 green:0.875 blue:1.000 alpha:1.000]
#define color8FD [UIColor colorWithRed:0.561 green:0.827 blue:1.000 alpha:1.000]
#define color72c [UIColor colorWithRed:0.447 green:0.784 blue:1.000 alpha:1.000]

#define color01a  [UIColor colorWithRed:0.004 green:0.651 blue:0.996 alpha:1.000]
#define color227shallblue [UIColor colorWithRed:0.133 green:0.478 blue:0.898 alpha:1.000]
#define color004deepblue [UIColor colorWithRed:0.000 green:0.310 blue:0.686 alpha:1.000]
//灰色
#define colorf0fGrey [UIColor colorWithWhite:0.941 alpha:1.000]
#define colore0eGrey [UIColor colorWithWhite:0.878 alpha:1.000]
#define colorc8cwhiteGrey [UIColor colorWithWhite:0.784 alpha:1.000]
#define color999Grey [UIColor colorWithWhite:0.600 alpha:1.000]
#define color969Grey [UIColor colorWithWhite:0.588 alpha:1.000]
#define color646grey [UIColor colorWithWhite:0.392 alpha:1.000]
#define color333Grey [UIColor colorWithWhite:0.200 alpha:1.000]



@interface UIColor (HexColor)

+ (UIColor *)colorWithHexString:(NSString *)hexStr;

+ (UIColor *)colorWithHexString:(NSString *)hexStr alpha:(CGFloat)alpha;

@end
