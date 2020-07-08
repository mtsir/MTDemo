//
//  JRPersonalTabHeadView.h
//  JRHomeChannel
//
//  Created by MacTavish on 2020/3/3.
//

#import <UIKit/UIKit.h>
#import "JRPersonalTabModel.h"
#import <JRUITemplates/JRTExposureScrollableView.h>

NS_ASSUME_NONNULL_BEGIN

@interface JRPersonalTabHeadView : JRTExposureScrollableView

- (void)renderPersonalTabHeaderView:(JRPersonalTopSummaryModel *)topSummaryModel;

@end

NS_ASSUME_NONNULL_END
