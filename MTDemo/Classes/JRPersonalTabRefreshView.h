//
//  JRPersonalTabRefreshView.h
//  JRHomeChannel
//
//  Created by MacTavish on 2020/3/3.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JRPullRefreshViewState) {
    JRPullRefreshViewStateNormal,
    JRPullRefreshViewStatePulling,
    JRPullRefreshViewStateRefreshing,
};

@interface JRPersonalTabRefreshView : UIView

/**
 单纯下拉刷新
 */
@property(nonatomic, copy) void (^refreshBlock)(void);

/**刷新文案*/
@property(nonatomic, strong) UILabel *refreshLabel;

/**刷新状态*/
@property (nonatomic,assign) JRPullRefreshViewState currenState;

/**
 结束刷新
 */
- (void)endRefreshing;

@end
