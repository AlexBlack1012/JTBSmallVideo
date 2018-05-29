//
//  JTBSmallVideoViewController.m
//  JTBSmallVideo
//
//  Created by 陈良峰 on 2018/5/22.
//  Copyright © 2018年 JTB. All rights reserved.
//

#import "JTBSmallVideoViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface JTBSmallVideoViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate>

@property (nonatomic,assign) JTBVideoViewShowType type;

//会话强引用  一定要强引用
@property (nonatomic,strong) AVCaptureSession *captureSession;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;

@end

static JTBSmallVideoViewController *__currentVideoVC = nil;


@implementation JTBSmallVideoViewController



- (void)startAnimationWithType:(JTBVideoViewShowType)type {
    _type = type;
    __currentVideoVC = self;
    [self setupSubViews];
    
    if (_type ==  JTBVideoViewShowTypeSingle) {
        jtb_dispatch_after(0.4, ^{
            self.view.hidden = NO;
        });
    }
    
    [self setupVideo];
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(30, 64, 50, 50)];
    [btn addTarget:self action:@selector(colseView) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor =  [UIColor blueColor];
    [self.view addSubview:btn];
}
#pragma mark 页面设置
- (void)setupSubViews  {
    _view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor redColor];
    self.view.hidden = YES;
    UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
    [keyWindow addSubview:self.view];
    

}
#pragma 设备设置
- (void)setupVideo {
    if (TARGET_IPHONE_SIMULATOR) {
        return;
    }
    
    //创建捕获会话，设置分辨率
    [self setupSession];
    
    //建立输入输出
    [self setupInput];
    [self setupOutput];
    
    //开启会话
    //在输入和输出建立一个连接
    [_captureSession startRunning];
    
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    previewLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:previewLayer];
    _previewLayer = previewLayer;
}


- (void)setupSession {
    AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];
    _captureSession = captureSession;
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        //设置分辨率
        captureSession.sessionPreset = AVCaptureSessionPreset1280x720;
    }
}

- (void)setupInput {
    //获取摄像头
    AVCaptureDevice *videoDevice = [self deviceWithPosition:AVCaptureDevicePositionBack];
    //获取麦克风
    NSArray *devicesAudio = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];
    AVCaptureDevice *audioDevice = devicesAudio[0];
    
    //设备输入对象
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
    AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:nil];
    //给会话添加输入
    if ([_captureSession canAddInput:videoInput]) {
        [_captureSession addInput:videoInput];
    }
    if ([_captureSession canAddInput:audioInput]) {
        [_captureSession addInput:audioInput];
    }
}

- (AVCaptureDevice *)deviceWithPosition:(AVCaptureDevicePosition)position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}


- (void)setupOutput {
    //视频输出,设置视频源数据设置：YUV,RGB
    //苹果不支持YUA，只支持RGB,所以要把YUV>RGB
    AVCaptureVideoDataOutput *videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    //一秒多少帧 videoOutput.minFrameDuration = CMTimeMake(1, 10);
    videoOutput.alwaysDiscardsLateVideoFrames = YES;
    //设置视频格式
    videoOutput.videoSettings = @{(NSString *)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)};
    
    //队列：串行，并行
    dispatch_queue_t queue = dispatch_queue_create("com.jtb.queue", DISPATCH_QUEUE_SERIAL);
    //设置代理:获取帧数据  异步串行队列
    [videoOutput setSampleBufferDelegate:self queue:queue];
    
    //给回话添加输出对象 给回话添加输入输出就会建立连接
    if ([_captureSession canAddOutput:videoOutput]) {
        [_captureSession addOutput:videoOutput];
    }
    
    
    //获取输入与输出的连接
    AVCaptureConnection *connection = [videoOutput connectionWithMediaType:AVMediaTypeVideo];
    //设置方向
    connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    //调整镜像
    connection.videoMirrored = YES;
    NSLog(@"%@",connection);
}


#pragma mark 设备代理方法
/*
 CMSampleBufferRef:帧缓存，描述当前帧信息
 获取数据：CMSampleBufferGet
 
 */
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    
}

#pragma mark 界面销毁后

- (void)colseView {
    [_captureSession stopRunning];
    [_previewLayer removeFromSuperlayer];
    _previewLayer = nil;
    [self.view removeFromSuperview];
    __currentVideoVC = nil;
}

- (void)dealloc {
    NSLog(@"dealloc --销毁---JTBSmallVideoViewController");
}



@end
