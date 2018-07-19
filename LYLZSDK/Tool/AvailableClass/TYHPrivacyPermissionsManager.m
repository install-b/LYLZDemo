//
//  TYHPrivacyPermissionsManager.m
//  TaiYangHua
//
//  Created by Vieene on 15/12/11.
//  Copyright © 2015年 hhly. All rights reserved.
//

#import "TYHPrivacyPermissionsManager.h"

#import <AssetsLibrary/AssetsLibrary.h>//判断用户是否有权限访问相册
//iOS7之前都可以访问相机，iOS7之后访问相机有权限设置
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AVFoundation/AVFAudio.h>
#import <CoreLocation/CLAvailability.h>
#import <CoreLocation/CLLocation.h>
#import <CoreLocation/CLRegion.h>
#import <CoreLocation/CLLocationManager.h>

@implementation TYHPrivacyPermissionsManager : NSObject

#pragma mark - 是否开启权限
//是否开启远程通知
+ (BOOL)fxwIsOpenAPNS
{
    //如果没有开发接收通知的功能 提醒用户打开
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types == UIUserNotificationTypeNone)
    {
        return NO;
    }
    return YES;
    
}

//是否开启定位
+ (BOOL)fxwIsOpenLocation
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status)
    {
        return NO;
    }
    return YES;
    
}

//是否开启相册访问
+ (BOOL)fxwIsOpenScanPhotos
{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == kCLAuthorizationStatusRestricted || author == kCLAuthorizationStatusDenied)
    {
        return NO;
    }
    /*
     typedef enum {
     kCLAuthorizationStatusNotDetermined = 0, // 用户尚未做出选择这个应用程序的问候
     kCLAuthorizationStatusRestricted,        // 此应用程序没有被授权访问的照片数据。可能是家长控制权限
     kCLAuthorizationStatusDenied,            // 用户已经明确否认了这一照片数据的应用程序访问
     kCLAuthorizationStatusAuthorized         // 用户已经授权应用访问照片数据
     } CLAuthorizationStatus;
     
     */
    return YES;
    
}

//是否开启相机
+ (BOOL)fxwIsOpenCamera
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        return NO;
    }
    return YES;
    
}

//是否开启运动与健康[这个地方可能不需要单独判断]
+ (BOOL)fxwIsOpenHealthData {
    //其实是需要判断两部：第一步是判断是否设备具有计步器的功能【监测芯片是否可用】
    //第二步是判断用户是否开启 运动与健康 的数据访问权限
    return YES;
    
}

//是否开启麦克风
+ (BOOL)fxwIsOpenMicrophone {
    __block BOOL bCanRecord = YES;
    dispatch_semaphore_t lock = dispatch_semaphore_create(1);
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            bCanRecord = granted;
            dispatch_semaphore_signal(lock);
        }];
    }
    else{
        dispatch_semaphore_signal(lock);
    }
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    return bCanRecord;
}
@end
