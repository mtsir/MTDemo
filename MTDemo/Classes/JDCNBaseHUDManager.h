//
//  JDCNBaseHUDManager.h
//  Pods
//
//  Created by 刘豆 on 2019/8/5.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface JDCNBaseHUDManager : NSObject

/**
  展示loading框

 @param addView 需要展示的父view
 @param showString 展示的描述
 @param image 需要展示图片
 */
- (void)loadShowView:(UIView*)addView String:(NSString*)showString image:(UIImage*)image;


/// loading 进度
/// @param progreass 进度值   0~~1
- (void)loadProGress:(double)progreass;

/**
 消失loading

 @param complet 消失完成回掉
 */
- (void)disMissHudView:(void(^)(void))complet;


/// hud完全释放  
- (void)hudManagerRelease;
@end

