//
//  JDCNBaseDefineMacro.h
//  JDCN_BaseDepend
//
//  Created by liudou on 2018/5/24.
//  Copyright © 2018年 liudou. All rights reserved.
//

#ifndef JDCNBaseDefineMacro_h
#define JDCNBaseDefineMacro_h
#import "JDCN_Router.h"


//系统版本
#define JDCNBaseSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]

//获取屏幕宽高，以及bouns
#define JDCNBaseScreenWidth [[UIScreen mainScreen]bounds].size.width
#define JDCNBaseScreenHeight [[UIScreen mainScreen]bounds].size.height
#define JDCNBaseScreenBounds [UIScreen mainScreen].bounds
//当前展示的windows
#define JDCNBaseWindow          [[UIApplication sharedApplication].windows objectAtIndex:0]

//特定字体  上导航颜色字体
#define   JDCNBaseNavTitleFont    JDCNBaseBOLDSYSTEMFONT_6(18)
#define   JDCNBaseNavTitleColor   JDCNBaseBlackColor

//颜色设置 16进制
#define JDCNBaseColorwithHexString(HexString) [UIColor colorWithHexString:HexString]
#define JDCNBaseColorwithHexString_Alpha(HexString) [UIColor colorWithHexString:HexString alpha:Alpha]
//RGB 颜色 10进制
#define JDCNBaseColor(r, g, b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
//系统颜色
#define    JDCNBaseBlackColor      ([UIColor blackColor])    // 0.0 white
#define    JDCNBaseDarkGrayColor   ([UIColor darkGrayColor]) // 0.333 white
#define    JDCNBaseLightGrayColor  ([UIColor lightGrayColor])// 0.667 white
#define    JDCNBaseWhiteColor      ([UIColor whiteColor])    // 1.0 white
#define    JDCNBaseGrayColor       ([UIColor grayColor])     // 0.5 white
#define    JDCNBaseRedColor        ([UIColor redColor])      // 1.0, 0.0, 0.0 RGB
#define    JDCNBaseGreenColor      ([UIColor greenColor])    // 0.0, 1.0, 0.0 RGB
#define    JDCNBaseBlueColor       ([UIColor blueColor])     // 0.0, 0.0, 1.0 RGB
#define    JDCNBaseCyanColor       ([UIColor cyanColor])     // 0.0, 1.0, 1.0 RGB
#define    JDCNBaseYellowColor     ([UIColor yellowColor])   // 1.0, 1.0, 0.0 RGB
#define    JDCNBaseMagentaColor    ([UIColor magentaColor])  // 1.0, 0.0, 1.0 RGB
#define    JDCNBaseOrangeColor     ([UIColor orangeColor])   // 1.0, 0.5, 0.0 RGB
#define    JDCNBasePurpleColor     ([UIColor purpleColor])   // 0.5, 0.0, 0.5 RGB
#define    JDCNBaseBrownColor      ([UIColor brownColor])    // 0.6, 0.4, 0.2 RGB
#define    JDCNBaseClearColor      ([UIColor clearColor])    // 0.0 white, 0.0 alpha
/**
 * 设备的点和像素的缩放比例
 */
#define JDCNBaseDeviceScale [UIScreen mainScreen].scale



//项目的强弱引用宏定义
#define JDCNBaseWeakSelf(type)__weak typeof(type)weak##type = type;
#define JDCNBaseStrongSelf(type)__strong typeof(type)strong##type = weak##type;



//拼接字符串
#define JDCNBaseNSStringFormat(format,...)[NSString stringWithFormat:format,##__VA_ARGS__]


///字体
#define JDCNBaseBOLDSYSTEMFONT_6(FONTSIZE)[UIFont boldSystemFontOfSize:(FONTSIZE*JDCNBaseScaleWidth)]
#define JDCNBaseSYSTEMFONT_6(FONTSIZE)[UIFont systemFontOfSize:(FONTSIZE*JDCNBaseScaleWidth)]
#define JDCNBaseFONT_6(NAME,FONTSIZE)[UIFont fontWithName:(NAME)size:(FONTSIZE*JDCNBaseScaleWidth)]

//定义UIImage对象

#define JDCNBaseBundleImage(imageName,bundelName) [UIImage imageNamed:imageName inBundle:[NSBundle bundleWithPath:[[[NSBundle bundleForClass:[[JDCN_Router router] routerClassName:@"JDCN_Router"]] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.bundle",bundelName]]] compatibleWithTraitCollection:nil]

#define JDCNBaseGetSource(sourceName,sourceType,bundelName) [[NSBundle bundleWithPath:[[[NSBundle bundleForClass:[[JDCN_Router router] routerClassName:@"JDCN_Router"]] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.bundle",bundelName]]] pathForResource:sourceName ofType:sourceType]

//#define JDCNBaseImageWithFileJD(_pointer)[UIImage imageWithContentsOfFile:([[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@@%dx",_pointer,(int)[UIScreen mainScreen].nativeScale]ofType:@"png"])]

//数据验证

#define JDCNBaseCheckStr(f)(f!=nil &&[f isKindOfClass:[NSString class]]&& ![f isEqualToString:@""])
#define JDCNBaseSafeStr(f)(JDCNBaseCheckStr(f)?f:@"")
#define JDCNBaseContainString(str,eky)([str rangeOfString:key].location!=NSNotFound)
#define JDCNBaseCheckDict(f)(f!=nil &&[f isKindOfClass:[NSDictionary class]])
#define JDCNBaseSafeDict(f)(JDCNBaseCheckDict(f)?f:@{})
#define JDCNBaseCheckArray(f)(f!=nil &&[f isKindOfClass:[NSArray class]]&&[f count]>0)
#define JDCNBaseCheckNum(f)(f!=nil &&[f isKindOfClass:[NSNumber class]])
#define JDCNBaseCheckClass(f,cls)(f!=nil &&[f isKindOfClass:[cls class]])
#define JDCNBaseCheckData(f)(f!=nil &&[f isKindOfClass:[NSData class]])

//获取一段时间间隔
#define JDCNBaseStartTime      CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
#define JDCNBaseEndTimeNSLog NSLog(@"Time: %f",CFAbsoluteTimeGetCurrent()- start)

//打印当前方法名
#define JDCNBaseLOGMethodName()  ITTDPRINT(@"%s",__PRETTY_FUNCTION__)

//GCD
#define JDCNBaseDISPATCH_ASYNC_BLOCK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),block)
#define JDCNBaseDISPATCH_MAIN_BLOCK(block) dispatch_async(dispatch_get_main_queue(),block)

//GCD -一次性执行
#define JDCNBaseDISPATCH_ONCE_BLOCK(onceBlock)static dispatch_once_t onceToken;dispatch_once(&onceToken,onceBlock);

//通知宏定义
#define JDCNBaseNotificationAddObserve(n, f)       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(f) name:n object:nil]
#define JDCNBaseNotificationPostName(n, o) [[NSNotificationCenter defaultCenter] postNotificationName:n object:o]
#define JDCNBaseNotificationremove()               [[NSNotificationCenter defaultCenter] removeObserver:self]


#pragma --mark  不常使用区域

//UILabel,UITextField,UITextView,UIImageView,UIButton  初始化宏定义
#define  JDCNBaseCreatLable(lable,frameRect,text,Alignment,font,textcolor)    lable = [[UILabel alloc]initWithFrame:frameRect];[lable  setText:text];[lable  setTextAlignment:Alignment];[lable  setFont:font];[lable  setTextColor:textcolor];

#define  JDCNBaseCreatTextField(textfield,frameRect,text,Alignment,font,textcolor)    textfield = [[UITextField alloc]initWithFrame:frameRect];[textfield  setText:text];[textfield  setTextAlignment:Alignment];[textfield  setFont:font];[textfield  setTextColor:textcolor];

#define  JDCNBaseCreatTextView(textView,frameRect,text,Alignment,font,textcolor)    textView = [[UITextView alloc]initWithFrame:frameRect];[textView  setText:text];[textView  setTextAlignment:Alignment];[textView  setFont:font];[textView  setTextColor:textcolor];

#define  JDCNBaseCreatImageView(imageView,frameRect,image,ViewContentMode) imageView = [[UIImageView alloc]initWithFrame:frameRect];[imageView  setImage:image];[imageView  setContentMode:ViewContentMode?ViewContentMode:UIViewContentModeScaleAspectFit];

#define JDCNBaseCreatButtonImage(button,frameRect,backImagename) JDCNBaseCreatButtonAll(button,frameRect,backImagename,@"",@"",@"",nil,nil)
#define JDCNBaseCreatButtonTitle(button,frameRect,title,titlecolor,font) JDCNBaseCreatButtonAll(button,frameRect,@"",@"",@"",title,titlecolor,font)

#define  JDCNBaseCreatButtonAll(button,frameRect,backImage,normalImage,hightImage,title,titlecolor,font) button = [UIButton buttonWithType:UIButtonTypeCustom];button.frame = frameRect;button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;[button setBackgroundImage:backImage forState:UIControlStateNormal];[button  setImage:normalImage forState:UIControlStateNormal];[button  setImage:hightImage forState:UIControlStateHighlighted];[button  setTitle:title.length>0?title:nil forState:UIControlStateNormal];[button setTitleColor:titlecolor?titlecolor:nil forState:UIControlStateNormal];[button.titleLabel  setFont:font?font:JDCNBaseSYSTEMFONT_6(14)];[button  setAdjustsImageWhenHighlighted:NO];


//Masonry  使用适配。y-64。 死的。因为是以6 为基准适配。NormalStatusBarAndNavigationBarHeight_JD死的 需要加上。  YueShuBiliHeight活的，为实际当前屏幕的高度
#define JDCNBaseTOPY(Y)     ((Y-64)*JDCNBaseYueShuBiliHeight+JDCNBaseNormalStatusBarAndNavigationBarHeight)
#define JDCNBaseBottomY(Y)   Y*JDCNBaseYueShuBiliHeight
#define JDCNBaseLeftX(X)     (X)*JDCNBaseYueShuBiliWith
#define JDCNBaseRightX(X)    (X)*JDCNBaseYueShuBiliWith

//  以6为标准  获取设备比例
#define JDCNBaseScaleWidth  JDCNBaseScreenWidth/375.0
#define JDCNBaseScaleHeight  JDCNBaseScreenHeight/667.0
#define JDCNBaseIs_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125,2436), [[UIScreen mainScreen] currentMode].size) : NO)
//系统StatusBar的高度。  iphonex对应44。 其他机型对应20。 大坑
#define JDCNBaseCallOrWifiStatusBar [UIApplication sharedApplication].statusBarFrame.size.height
//配置状态。就是6状态下。对应的状态栏高度  即0。
#define JDCNBaseFitStatusBar    (JDCNBaseCallOrWifiStatusBar -((JDCNBaseIs_iPhoneX) ? 44.0f : 20.0f))

#define JDCNBaseFitViewCtrlViewHight  (JDCNBaseScreenHeight - JDCNBaseFitStatusBar)
#define JDCNBaseNormalStatusBarAndNavigationBarHeight ((JDCNBaseIs_iPhoneX) ? 88.0f : 64.0f)
#define JDCNBaseChanegeStatusBarAndNavigationBarHeight ((JDCNBaseIs_iPhoneX) ? (88.0f+JDCNBaseFitStatusBar) : (64.0f+JDCNBaseFitStatusBar))
#define JDCNBaseYueShuBiliWith  JDCNBaseScreenWidth/375.0
#define JDCNBaseYueShuBiliHeight  (JDCNBaseScreenHeight-JDCNBaseChanegeStatusBarAndNavigationBarHeight)/(667.0-64)

#endif /* JDCNBaseDefineMacro_h */



