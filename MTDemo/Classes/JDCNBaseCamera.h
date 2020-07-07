//
//  JDCNBaseCamera.h
//  Pods
//
//  Created by 刘豆 on 2019/1/15.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@protocol JDCNBaseCameraDelegete <NSObject>
@optional
- (void)getCameraOutPutImage:(UIImage*)outPutImage;

- (void)getCameraOutPutBuffer:(CMSampleBufferRef)outPutBuffer;

@end

@interface JDCNBaseCamera : NSObject

@property(weak,nonatomic)id <JDCNBaseCameraDelegete> delegete;
/**
 初始化相机各项配置 以及获取相机的各种对象和处理的最终结果数据。

 @param CameraPosition 设置相机的前后摄像头方向回调
 @param CameraViewBlock 返回值回调，返回值为需要设定d相机的view预览层。在这个block块内可以拿到各个属性 可以对相机配置重新配置
 @param Orientation 获取的图片方向 目前不支持镜像模式
 */
- (void)initCameraViewSetCameraDirection:(AVCaptureDevicePosition(^)(void))CameraPosition
                        setViewAndConfig:(UIView *(^)(AVCaptureSession *cameraSession,AVCaptureDevice *captureDevic,AVCaptureDeviceInput *captureVideoDataInput,AVCaptureVideoDataOutput *captureVideoDataOutput,AVCaptureVideoPreviewLayer *captureVideoPreviewLayer))CameraViewBlock
                     needImageOrientation:(UIImageOrientation)Orientation;
/**
 开启摄像头捕捉
 */
- (void)startCameraCapture;

/**
 停止摄像头捕捉
 */
- (void)stopCameraCapture;

@end

