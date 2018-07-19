//
//  FileViewCell.h
//  fileManage
//
//  Created by Vieene on 2016/10/13.
//  Copyright © 2016年 深圳柒壹思诺科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LYFileObjModel;
@interface LYFileViewCell : UITableViewCell
@property (nonatomic,strong)LYFileObjModel *model;
@property (nonatomic,copy) void (^Clickblock)(LYFileObjModel *model,UIButton *btn);
@end
