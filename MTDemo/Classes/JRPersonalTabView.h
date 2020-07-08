//
//  JRPersonalTabView.h
//  JRHomeChannel
//
//  Created by MacTavish on 2020/3/3.
//

#import <UIKit/UIKit.h>
#import <JRUITemplates/JRTContainerView.h>
#import "JRPersonalTabHeadView.h"

@interface JRPersonalTabView : UIView

@property(nonatomic, strong) JRTContainerView *mainView;

@property (nonatomic,strong) UIImageView *floatImageView;

@property(nonatomic, strong) JRPersonalTopPartHeadModel *topPartHeadModel;

@property(nonatomic, strong) JRPersonalTabHeadView *personalTabHeaderView;

@property(nonatomic, assign) BOOL enterForeground;


/**
 顶部model传入 渲染UI

 @param topPartModel topModel
 @param isCache 是否是缓存
 */
- (void)personalTabCenterHeaderModel:(JRPersonalTopPartHeadModel*)topPartHeadModel isCache:(BOOL)isCache;


/**
 下部列表

 @param resultList 列表
 @param isCache 是否是缓存
 */
- (void)personalTabCenterListModel:(NSArray<JRTFloorBaseModel*>*)resultList isCache:(BOOL)isCache;

@end
