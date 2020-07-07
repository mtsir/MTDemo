//
//  NSMutableAttributedString+JDCNBaseCategory.h
//  JDCN_BaseDepend
//
//  Created by Nemo on 14-4-11.
//  Copyright (c) 2014年 mac iko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>
@interface NSMutableAttributedString (JDCNBaseCategory)

+ (NSMutableAttributedString *)jdcnBaseDepend_creatMutableAttributedString:(NSString *)string withFont:(UIFont *)font andColor:(UIColor *)color;
/*
 *若重复使用此方法，不会覆盖之前的设置
 */
- (void)jdcnBaseDepend_addKeyColor:(UIColor *)keyColor keyString:(NSString *)keyString;

@end
