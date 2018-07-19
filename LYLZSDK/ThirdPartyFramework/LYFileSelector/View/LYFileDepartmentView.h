//
//  CJDepartmentView.h
//  Antenna
//
//  Created by HHLY on 16/6/15.
//  Copyright © 2016年 深圳柒壹思诺科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LYFileDepartmentView;

@protocol LYFileDepartmentViewDelegate <NSObject>

- (void)departmentView:(LYFileDepartmentView *)departmentView didScrollToIndex:(NSInteger)index;

@end

///总部门视图(联系人上导航视图)
@interface LYFileDepartmentView : UIScrollView

@property (strong, nonatomic) NSArray *departmentArr;//!< 部门对象集合


@property (assign, nonatomic) id<LYFileDepartmentViewDelegate> lyt_delegate;

/** 总部门视图构造方法 */
- (instancetype)initWithParts:(NSArray *)partArr;
- (instancetype)initWithParts:(NSArray *)partArr withFrame:(CGRect)frame;

// 跳转到指定的index
- (void)setSelectedIndex:(NSInteger)selectedIndex;

// 重新刷新数据
- (void)reloadData;

@end
