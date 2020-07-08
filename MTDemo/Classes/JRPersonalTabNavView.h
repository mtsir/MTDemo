//
//  JRPersonalTabNavView.h
//  JRHomeChannel
//
//  Created by MacTavish on 2020/3/3.
//

#import <UIKit/UIKit.h>
#import <JRUITemplates/JRTExposureBaseView.h>

NS_ASSUME_NONNULL_BEGIN

@class JRPersonalTopSummaryModel;
@class JRPersonalNaviIconModel;

extern const NSUInteger kIconWidth;

@interface JRPersonalHeadImageBtn : UIButton
@property(nonatomic, strong) UIImageView *headImageView;
- (void)headImageClick;
@end

@interface JRPersonalNaviIconBtn : UIButton

@end

@interface JRPersonalNaviIconBackView : JRTExposureBaseView

- (void)renderNaviBarIcons:(NSArray<JRPersonalNaviIconModel*> *)iconList
                messageUrl:(NSString*)msgUrl
                settingUrl:(NSString*)settingUrl;
@end

@interface JRPersonalTabNavView : UIView

- (void)setNaviViewAlpha:(CGFloat)alpha;

- (void)setMidRightAlpha:(CGFloat)alpha;

- (void)setLeftHeadAlpha:(CGFloat)alpha;

- (void)renderNaviBarViewWith:(JRPersonalTopSummaryModel *)topSummaryModel;

@end

NS_ASSUME_NONNULL_END
