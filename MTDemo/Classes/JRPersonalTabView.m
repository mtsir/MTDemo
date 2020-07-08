//
//  JRPersonalTabView.m
//  JRHomeChannel
//
//  Created by MacTavish on 2020/3/3.
//

#import "JRPersonalTabView.h"
#import <JRUIKit/JRFootLogoView.h>
#import <JRFoundation/JRFooterManager.h>
#import <JRBUIKit/UIView+YuViewDisplayArea.h>
#import <SDWebImage/SDWebImageManager.h>
#import <JRCJumpCenter/JRJumpCenter.h>
#import <JRCUIKit/JRCNavigationUtils.h>
#import "JRPersonalTabViewModel.h"

static NSUInteger const kPesonalCenterFooter = 5;

@interface JRPersonalTabView ()

@property(nonatomic, strong) JRFootLogoView *footerView;

@property(nonatomic, strong) JRPersonalFloatWindowModel *floatModel;
@end

@implementation JRPersonalTabView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //initial
        [self addSubview:self.mainView];
        [self.mainView.tableView setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)personalTabCenterHeaderModel:(JRPersonalTopPartHeadModel *)topPartHeadModel isCache:(BOOL)isCache{    
    //头部
    [self.personalTabHeaderView renderPersonalTabHeaderView:topPartHeadModel.topSummaryModel];
    
    [self.mainView setTableHeaderViewAndAddExposureLogic:self.personalTabHeaderView];
    
    [self handleFloatWindow:topPartHeadModel.floatWindowModel cacheFlag:isCache];
}

- (void)personalTabCenterListModel:(NSArray<JRTFloorBaseModel *> *)resultList isCache:(BOOL)isCache{
    BOOL shouldHasFooter = resultList.count > 0;
    [self.mainView setFloorArray:resultList];
    [self displayFooterView:shouldHasFooter];
    if (shouldHasFooter && !isCache && !self.enterForeground) {
        [self.mainView restartExposure];
    }
    self.enterForeground = NO;
}
- (void)displayFooterView:(BOOL)flag
{
    if (!flag){
        self.mainView.tableView.tableFooterView = nil;
        return;
    }
    NSDictionary *dataDic = [[JRFooterManager shareInstance] getFootLogoDicWithType:kPesonalCenterFooter];
    if (dataDic) {
        JRFootLogoModel *footModel = [[JRFootLogoModel alloc] initWithDic:dataDic];
        self.footerView.frame = (footModel.help_icon) ? (CGRect){CGPointZero,(CGSize){UIScreen_W,154.0f}} : (CGRect){CGPointZero,(CGSize){UIScreen_W,105.0f}};
        [self.footerView reloadData:footModel];
    }else{
        self.footerView.frame = (CGRect){CGPointZero,(CGSize){UIScreen_W,105.0f}};
        [self.footerView reloadData:nil];
    }
    
    self.mainView.tableView.tableFooterView = self.footerView;
    
}
#pragma mark - 处理悬浮窗
- (void)handleFloatWindow:(JRPersonalFloatWindowModel*)floatModel cacheFlag:(BOOL)cacheFlag{
    self.floatModel = floatModel;
    if (floatModel.jumpEntity && floatModel.imgUrl) {
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:floatModel.imgUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (image) {
                if (!_floatImageView) {
                    [self prepareFloatImageView];
                }
                _floatImageView.hidden = NO;
                _floatImageView.image = image;
                [UIView animateWithDuration:.35f animations:^{
                    _floatImageView.x_jr = UIScreen_W - 75;
                }];
                //单独处理悬浮窗的曝光
                if (!cacheFlag) {
                    [JRPersonalTabViewModel personalTabLandMine:self.floatModel.trackData messageType:JRSocketMessageTypeForExposure];
                }
            }
        }];
    }else{
        _floatImageView.hidden = YES;
    }
}
-(void)prepareFloatImageView{
    _floatImageView = [[UIImageView alloc]initWithFrame:CGRectMake(UIScreen_W, UIScreen_H - (190 + HOME_INDICATOR_H), 75, 75)];
    _floatImageView.userInteractionEnabled = YES;
    [self addSubview:_floatImageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(floatClick)];
    [_floatImageView addGestureRecognizer:tap];
}
-(void)floatClick{
    [JRJumpCenter clictToView:self.floatModel.jumpEntity];
    [JRPersonalTabViewModel personalTabLandMine:self.floatModel.trackData messageType:JRSocketMessageTypeForClick];
}
- (BOOL)isTopPresentedVC {
    return [JRCNavigationUtils judgeIsTopVCForSubView:self.mainView];
}
#pragma mark - lazy

- (JRTContainerView *)mainView{
    if(!_mainView){
        _mainView = [[JRTContainerView alloc]initWithFrame:CGRectMake(0, 0, self.width_jr, self.height_jr)];
        _mainView.delegate = self;
        _mainView.tableView.estimatedRowHeight = 0.f;
        _mainView.tableView.estimatedSectionFooterHeight = 0.f;
        _mainView.tableView.estimatedSectionHeaderHeight = 0.f;
        _mainView.tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            if ([_mainView.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)])
                _mainView.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _mainView;
}

- (JRPersonalTabHeadView *)personalTabHeaderView {
    if (!_personalTabHeaderView) {
        _personalTabHeaderView = [[JRPersonalTabHeadView alloc]initWithFrame:CGRectMake(0, 0, UIScreen_W, StateBar_H+87.0f)];
        @JDJRWeakify(self);
        _personalTabHeaderView.backgroundColor = [UIColor whiteColor];
    }
    return _personalTabHeaderView;
}
-(JRFootLogoView *)footerView{
    if (!_footerView) {
        _footerView = [[JRFootLogoView alloc]initWithFrame:CGRectZero];
        _footerView.backgroundColor = [UIColor jrColorWithHex:@"#F4F5F7"];
    }
    return _footerView;
}

@end
