//
//UIImage+JDCNBaseCategory.h
//JDCN_BaseDepend
//
//  Created by liudou on 2018/5/30.
//  Copyright © 2018年 liudou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>
@interface UIImage (JDCNBaseCategory)
/**
 颜色生成图片
 
 @param color 传入的颜色
 @return 需要生成的图片
 */
+ (UIImage *)jdcnBaseDepend_imageWithColor:(UIColor *)color;

/**
 压缩图片到指定尺寸
 
 @param image 压缩原图
 @param size 压缩大小
 @return 压缩结果图
 */
+(UIImage *)jdcnBaseDepend_compressOriginalImage:(UIImage *)image toSize:(CGSize)size;

/**
 图片裁剪处理,截取指定rect的图片
 
 @param image 截取的图片
 @param rect 截取的frame
 @return 返回截取后的图片
 */
+ (UIImage *)jdcnBaseDepend_imageFromImage:(UIImage *)image inRect:(CGRect)rect;

/**
 图片横竖屏的转换
 
 @param image 原始图
 @param orientation 转换原方向
 @return 得到向上的图
 */
+ (UIImage *)jdcnBaseDepend_image:(UIImage *)image rotation:(UIImageOrientation)orientation;

/**
 imageBuffer  转image

 @param sampleBuffer imagebuffer
 @return 生成的图片
 */
+ (UIImage *)jdcnBaseDepend_imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer;



/**
 修正相机出图

 @return 返回修正后相机的图片
 */
- (UIImage *)jdcnBaseDepend_jdcnFixOrientationRight;
@end
