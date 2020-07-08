//
//  JRPersonalClickJumpView.h
//  JRHomeChannel
//
//  Created by 刘爽 on 2020/04/03.
//  [个人页-电梯(一键到达)]

#import <UIKit/UIKit.h>
#import "JRPersonalTabModel.h"

@interface JRPersonalClickJumpView : UIControl

@property (nonatomic, strong) JRPersonalElevatorModel *jumpModel;

/**
 一键跳转浮窗加载
 */
- (void)reloadPersonalClickJumpModel:(JRPersonalElevatorModel*)jumpModel;

/**
 执行动画
 */
- (void)shakeAnimation;

/**
 移除动画
 */
- (void)removeAnimation;

@end
