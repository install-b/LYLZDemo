//
//  TYHPrivacyPermissionsManager.h
//  TaiYangHua
//
//  Created by Vieene on 15/12/11.
//  Copyright © 2015年 hhly. All rights reserved.
//  权限检测类


#import <UIKit/UIKit.h>
@interface TYHPrivacyPermissionsManager : NSObject
//是否开启远程通知
+ (BOOL)fxwIsOpenAPNS;

//是否开启定位
+ (BOOL)fxwIsOpenLocation;

//是否开启相册访问
+ (BOOL)fxwIsOpenScanPhotos;

//是否开启相机
+ (BOOL)fxwIsOpenCamera;

//是否开启运动与健康[这个地方可能不需要单独判断]
+ (BOOL)fxwIsOpenHealthData;

//是否开启麦克风
+ (BOOL)fxwIsOpenMicrophone;

@end
