//
//  LZSystemNotiCell.h
//  LZSDKDemo
//
//  Created by Shangen Zhang on 2017/8/14.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LZSystemNotiModel : NSObject

/** 高度 */
@property(nonatomic,assign,readonly) CGFloat cellHeight;

- (instancetype)initWithContent:(NSString *)content time:(NSString *)time;

@end



@interface LZSystemNotiCell : UITableViewCell

/** 模型 */
@property (nonatomic,strong) LZSystemNotiModel * systemNoti;

@end
