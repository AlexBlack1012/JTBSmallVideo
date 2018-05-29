//
//  ViewController.m
//  JTBSmallVideo
//
//  Created by 陈良峰 on 2018/5/22.
//  Copyright © 2018年 JTB. All rights reserved.
//

#import "ViewController.h"
#import "JTBSmallVideoViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *takeBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    takeBtn.backgroundColor = [UIColor redColor];
    [takeBtn addTarget:self action:@selector(takeVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:takeBtn];
}

- (void)takeVideo {
    JTBSmallVideoViewController *videoVC = [[JTBSmallVideoViewController alloc] init];
//    videoVC.delegate = self;
    [videoVC startAnimationWithType:JTBVideoViewShowTypeSingle];
//    [self  presentViewController:videoVC animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
