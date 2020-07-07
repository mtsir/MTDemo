//
//  JDCNBaseWebView.h
//  Pods
//
//  Created by 刘豆 on 2018/7/24.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

#define JDCNBaseWeakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x; \
_Pragma("clang diagnostic pop")

#define JDCNBaseStrongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __typeof__(x) x = __weak_##x##__; if (!x)return;\
_Pragma("clang diagnostic pop")

@protocol JDCNBaseWebViewDelegate <NSObject>
@optional

- (void)webViewDidStartLoad:(id)webView;
- (void)webViewDidFinishLoad:(id)webView;
- (void)webView:(id)webView didFailLoadWithError:(NSError *)error;

@end

@interface JDCNBaseWebView : UIView
///是否根据视图大小来缩放页面  默认为YES
@property (nonatomic,assign) BOOL scalesPageToFit;
@property (copy, nonatomic) void (^changeWebTitle)(NSString *title);
@property (copy, nonatomic) void (^webViewProgress)(CGFloat progress);

/**
 每一步进行的请求url拦截。  可配合jdcnWebViewGetInfoJsContentWithMehodName进行js交互。
 */
@property (copy, nonatomic) BOOL (^JDCN_WillLoadUrlStringBlock)(NSString *willLoadStr);

@property(weak,nonatomic)id<JDCNBaseWebViewDelegate> delegate;

- (void)loadRequest:(NSURLRequest *)request;
- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL;


/**
 通用web与js进行交互。  被js调用 获取js数据传过来的数据

 @param methodName  h5那边定义的方法
 @param getWebInfo 获取到js数据
 */
- (void)jdcnWebViewGetInfoJsContentWithMehodName:(NSString*)methodName getWebInfoBlock:(void(^)(NSDictionary *getInfoDic))getWebInfo;

/**
 前端调用js方法 向js透传数据

 @param methodName 调用的js方法
 @param postjsString 上传的json字符串
 @param postWebInfo 上传结果。 wkwebview有相应结果。wkwebview这个返回的是空的
 */
- (void)jdcnWebViewPostInfoJsContentWithMehodName:(NSString*)methodName postlocalInfo:(NSString*)postjsString postWebInfoBlock:(void(^)(NSDictionary *getInfoDic))postWebInfo;


@end
