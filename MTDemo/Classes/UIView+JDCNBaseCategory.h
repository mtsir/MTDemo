//
//  UIView+JDCNBaseCategory.h
//  JDCN_BaseDepend
//
//  Created by liudou on 2018/5/25.
//  Copyright © 2018年 liudou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JDCNBaseCategory)

//sets frame.origin.x = left;
@property (nonatomic) CGFloat jdcnBaseDepend_left;
//sets frame.origin.y = top;
@property (nonatomic) CGFloat jdcnBaseDepend_top;
//sets frame.origin.x = right - frame.size.wigth;
@property (nonatomic) CGFloat jdcnBaseDepend_right;
//sets frame.origin.y = botton - frmae.size.height;
@property (nonatomic) CGFloat jdcnBaseDepend_bottom;
//sets frame.size.width = width;
@property (nonatomic) CGFloat jdcnBaseDepend_width;
//sets frame.size.height = height;
@property (nonatomic) CGFloat jdcnBaseDepend_height;
//sets center.x = centerX;
@property (nonatomic) CGFloat jdcnBaseDepend_centerX;
//sets center.y = centerY;
@property (nonatomic) CGFloat jdcnBaseDepend_centerY;
//frame.origin
@property (nonatomic) CGPoint jdcnBaseDepend_origin;
//frame.size
@property (nonatomic) CGSize jdcnBaseDepend_size;
//包含这个view的controller
-(UIViewController *)jdcnBaseDepend_viewcontroller;
-(void)jdcnBaseDepend_removeAllSubviews;
-(void)jdcnBaseDepend_setbackgroundImage:(UIImage *)img;

- (void)jdcnBaseDepend_bringToFront;

- (UIImage *)jdcnBaseDepend_imageByRenderingView;


@end
