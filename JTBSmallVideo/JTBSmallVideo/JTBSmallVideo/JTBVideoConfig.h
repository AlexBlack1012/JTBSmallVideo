//
//  JTBVideoConfig.h
//  JTBSmallVideo
//
//  Created by 陈良峰 on 2018/5/22.
//  Copyright © 2018年 JTB. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JTBVideoViewShowType) {
    JTBVideoViewShowTypeSmall,  // 小屏幕 ...聊天界面的
    JTBVideoViewShowTypeSingle, // 全屏 ... 朋友圈界面的
};

extern void jtb_dispatch_after(float time,dispatch_block_t block);

@interface JTBVideoConfig : NSObject

@end
