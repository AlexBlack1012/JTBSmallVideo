//
//  JTBSmallVideoViewController.h
//  JTBSmallVideo
//
//  Created by 陈良峰 on 2018/5/22.
//  Copyright © 2018年 JTB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTBVideoConfig.h"

@interface JTBSmallVideoViewController : NSObject

//主界面
@property (nonatomic, strong, readonly) UIView *view;


- (void)startAnimationWithType:(JTBVideoViewShowType)type;

@end
