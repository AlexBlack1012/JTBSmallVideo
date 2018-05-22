//
//  JTBVideoConfig.m
//  JTBSmallVideo
//
//  Created by 陈良峰 on 2018/5/22.
//  Copyright © 2018年 JTB. All rights reserved.
//

#import "JTBVideoConfig.h"

@implementation JTBVideoConfig

void jtb_dispatch_after(float time,dispatch_block_t block)
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

@end
