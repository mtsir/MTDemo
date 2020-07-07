//
//  JDCNBaseJumpCenter.h
//JDCN_BaseDepend
//
//  Created by 刘豆 on 2018/7/6.
//  Copyright © 2018年 刘豆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JDCNBaseJumpCenter : NSObject

#pragma --mark  单利逻辑。
/**
 单例静态库管理器
 
 @return 返回静态库单利对象
 */
+ (JDCNBaseJumpCenter *) shareManager;

/**
 清除单利数据
 */
+ (void)clearnRequestDatainfo;
/**
 释放单利
 */
+ (void)managerRelease;

/**
 慎用操作。但必须使用。 决定屏幕 的是否开启免休眠。
 */
@property(assign,nonatomic)BOOL  JDCNBaseReciveIdleTimerDisabled;
/**
 进入sdk的三方业务界面
 */
@property(strong,nonatomic)UINavigationController *JDCNBaseJumpSDKNavCtrl;



#pragma --mark 跳转中心代码逻辑

/**
 唤起sdk 调用

 @param presentNav 承载sdk的UINavigationController 控制器。sdk控制权接过来，不使用业务的UINavigationController
 @param animated 是否需要动画
 */
+ (void)JDCNBaseJumpToSdkWithPrensent:(UINavigationController*)presentNav animated:(BOOL)animated completion:(void (^)(void))completion;


/**
 跳转某个指定的类，界面
 
 @param jumpViewController 跳转的目标类
 @param animated 是否需要动画
 */
+ (void)JDCNBaseJumpToViewController:(UIViewController*)jumpViewController animated:(BOOL)animated completion:(void (^)(void))completion;

/**
 返回前一个界面
 
 @param animated 是否需要动画
 */
+ (void)JDCNBaseBackToViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion;

/**
 返回到指定的某个类或者界面
 
 @param backViewController 返回的ViewCtrl
 @param animated 是否需要动画
 */
+ (void)JDCNBaseBackToViewController:(UIViewController*)backViewController animated:(BOOL)animated completion:(void (^)(void))completion;


/**
 跳出sdk 返回接入业务层
 
 @param animated 是否需要动画
 */
+ (void)JDCNFaceBaseJumpOutSdkAnimated:(BOOL)animated completion:(void (^)(void))completion;
/**
 获取当前屏幕显示的viewcontroller
 
 @return 当前屏幕显示的ctrl
 */
+ (UIViewController*)JDCNBaseGetCurrentViewControlller;
@end
