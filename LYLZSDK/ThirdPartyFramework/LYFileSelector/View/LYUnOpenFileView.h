//
//  UnOpenFileView.h
//  fileManage
//
//  Created by Vieene on 2016/10/14.
//  Copyright © 2016年 深圳柒壹思诺科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LYFileObjModel;
@interface LYUnOpenFileView : UIView
@property (nonatomic,copy) void (^Clickblock)(LYFileObjModel *model);

@property (nonatomic,strong) LYFileObjModel *model;
@end
