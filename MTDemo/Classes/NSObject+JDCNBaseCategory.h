//
//  NSObject+JDCNBaseCategory.h
//  JDCN_BaseDepend
//
//  Created by 刘豆 on 2018/6/21.
//  Copyright © 2018年 liudou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JDCNBaseCategory)

//用于取值   数据不规范状态下  返回空字符使用
- (id)objectForKeySafely_jdcnBaseDepend:(NSString*)key;

@end
