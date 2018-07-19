//
//  FlieLookUpVC.h
//  fileManage
//
//  Created by Vieene on 2016/10/14.
//  Copyright © 2016年 深圳柒壹思诺科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYFileObjModel.h"


@class LYFlieLookUpVC;
@protocol LYFlieLookUpVCDelegate <NSObject>
@optional

- (void)fileLookUpVC:(LYFlieLookUpVC *)flieLookUpVC didDownLoadFileForFileModel:(LYFileObjModel *)fileModel;

- (void)fileLookUpVC:(LYFlieLookUpVC *)flieLookUpVC didDownLoadFileError:(NSError *)error;

@end

@interface LYFlieLookUpVC : UIViewController

- (instancetype)init __attribute__((unavailable("initWithFileModel: instead it")));

- (instancetype)initWithFileModel:(LYFileObjModel *)fileModel;

/** delegate */
@property (nonatomic,weak) id<LYFlieLookUpVCDelegate> delegate;
@end
