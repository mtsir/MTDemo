//
//  JDCNBaseTools.h
//  JDCN_BaseDepend
//
//  Created by 刘豆 on 2018/10/22.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JDCNAFNetworkReachabilityStatus) {
    JDCNAFNetworkReachabilityStatusUnknown          = -1,
    JDCNAFNetworkReachabilityStatusNotReachable     = 0,
    JDCNAFNetworkReachabilityStatusReachableViaWWAN = 1,
    JDCNAFNetworkReachabilityStatusReachableViaWiFi = 2,
};

typedef NS_ENUM(NSInteger, JDCNCamerNowStatus) {
    JDCNCamerNowisAskSystem = -1,      //询问系统全选
    JDCNCamerNowisUnavailable     = 0, //相机不可用
    JDCNCamerNowisAvailable         = 1, //相机可用
};

@interface JDCNBaseTools : NSObject

/**
 获取当前的网络状态

 @return 网络状态。
 
 typedef NS_ENUM(NSInteger, JDCNAFNetworkReachabilityStatus) {
 AFNetworkReachabilityStatusUnknown          = -1,
 AFNetworkReachabilityStatusNotReachable     = 0,
 AFNetworkReachabilityStatusReachableViaWWAN = 1,
 AFNetworkReachabilityStatusReachableViaWiFi = 2,
 };
 */
+ (JDCNAFNetworkReachabilityStatus)get_NetWorkStatus;

/**
 直接获取当前的网络 是否可用

 @return 是否联网
 */
+ (BOOL)check_NetWorkStatus;

/**
 检测相机组件是否可用

 @param camerResult 系统询问后弹出的alter 一般首次安装系统询问权限
 @param isShowAlter 用户关闭相机权限，再次使用相机会弹出去设置等tips 是否需要弹出alter询问权限
 @param userChoose 用户选择按钮的回调 点击后消失  index=0 确定
 @return  相机状态
 */
+ (JDCNCamerNowStatus)JDCNCheck_CameraPermissionOneStepAskSystem:(void(^)(BOOL makeSureCamer))camerResult TwoStepAskUserIsShowAlter:(BOOL)isShowAlter andTwoStepUserChoose:(void(^)(NSInteger alterIndex))userChoose;


/**
 上传服务端的设备信息 数据 与服务端约定ok

 @return 数据信息
 */
+ (NSDictionary*)JDCNGetDeviceinfoToServers;

/**
 检查参数是否不合法
 
 @return YES不合法 NO合法
 */
+ (BOOL)check_ParameterIllegalWith:(NSString *)parameter;

/**
 获取当前系统时间戳
 
 @return 返回当前时间戳
 */
+ (NSString *)currentTimeStr;

/**
 事件触发间隔时间是否在规定时间内。多由于防止多点 点击事件。  default 1s  默认1s
 
 @return 是否允许再次出发
 */
+ (BOOL)spacingIntervalTime;

/**
 事件触发间隔时间是否在规定时间内。多由于防止多点 点击事件。  default 1s  默认1s
 
 @param controlTime  规定时常
 @return 在规定时常内是否允许再次触发
 */
+ (BOOL)spacingIntervalTime:(NSTimeInterval)controlTime;

@end
