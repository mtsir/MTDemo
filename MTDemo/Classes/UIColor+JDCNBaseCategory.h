//
//  UIColor+JDCNBaseCategory.h
//  JDCN_BaseDepend
//
//  Created by liudou on 2018/5/30.
//  Copyright © 2018年 liudou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (JDCNBaseCategory)
/*
 * Creating
 */
+ (UIColor *)jdcnBaseDepend_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;
+ (UIColor *)jdcnBaseDepend_colorWithHexString:(NSString *)hexString;
+ (UIColor *)jdcnBaseDepend_randomColor;

/**
 项目表格边框所需五种随机颜色
 
 @return 随机颜色
 */
+ (UIColor *)jdcnBaseDepend_getRandomColor;
/*
 * Components
 */
- (CGFloat)jdcnBaseDepend_red;
- (CGFloat)jdcnBaseDepend_green;
- (CGFloat)jdcnBaseDepend_blue;
- (CGFloat)jdcnBaseDepend_alpha;
- (NSString *)jdcnBaseDepend_hexString;

@end
