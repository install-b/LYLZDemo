//
//  LZSystemMessageTableViewCell.m
//  LZSDKDemo
//
//  Created by Shangen Zhang on 2017/8/8.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "LZSystemMessageTableViewCell.h"
#import "LZChatMessageOrderCell.h"
#import "LZChatMessageRecPacketCell.h"
#import "LYLZOrderMessageBody.h"
#import "LYLZRedPacketMessageBody.h"


@implementation LZSystemMessageTableViewCell
+ (instancetype)cellInTable:(UITableView*)tableView forMessageMode:(LYLZmessageBody *)model {
    
    if (model.messageType == LYLZmessageBodyTypeOrder) {
        LZChatMessageOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LZOrderContenView_cell_id"];
        
        if (!cell) {
            cell = [[LZChatMessageOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LZOrderContenView_cell_id"];
        }
        cell.cellFrame = model;
        return cell;
    }
    
    if (model.messageType == LYLZmessageBodyTypeRedPacket) {
        LZChatMessageRecPacketCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LZRecPacketCell_cell_id"];
        if (!cell) {
            cell = [[LZChatMessageRecPacketCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LZRecPacketCell_cell_id"];
        }
        cell.cellFrame = model;
        return cell;
    }
    
    
    
    
    return [[self alloc] init];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (CGFloat)cellHeight {
    return 0;
}
@end
