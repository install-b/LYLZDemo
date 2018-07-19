//
//  ViewController.h
//  fileManage
//
//  Created by Vieene on 2016/10/13.
//  Copyright © 2016年 深圳柒壹思诺科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LYFileObjModel.h"
@class LYFileManagerVC;


@protocol LYFileSelectVcDelegate <NSObject>
@required
- (void)fileViewControler:(LYFileManagerVC *)fileVC Selected:(NSArray <LYFileObjModel *> *)fileModels;

@end


@interface LYFileManagerVC : UIViewController

- (instancetype)init __attribute__((unavailable("initWithHomeFilePath: instead it")));

- (instancetype)initWithHomeFilePath:(NSString *)homeFilePath;

@property (nonatomic,weak) id<LYFileSelectVcDelegate> fileSelectVcDelegate;

@end


