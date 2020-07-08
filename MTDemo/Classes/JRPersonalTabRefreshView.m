//
//  JRPersonalTabRefreshView.m
//  JRHomeChannel
//
//  Created by MacTavish on 2020/3/3.
//

#import "JRPersonalTabRefreshView.h"
#import <Masonry/Masonry.h>
#import <JRBUIKit/JRBUIMacro.h>
#import <JRBUIKit/UIFont+Additions.h>
#import <JDDUIKit/UIColor+Extend.h>

static NSString *const JRRefreshContentOffset = @"contentOffset";
static void * privateContext = @"PersonalTabRefreshKey";

#define kPullRefreshHeight  ((JR_BangScreen_Iphone) ? -65.5f : -60.5f)

@interface JRPersonalTabRefreshView ()
{
    CGFloat pullingOffset;
}
/**父组件*/
@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation JRPersonalTabRefreshView

-(void)dealloc{
    [self removeObserver];
}
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        [self addSubview:self.refreshLabel];
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    
    [self.refreshLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 18.5f));
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-0.0f);
    }];
}

//当self加到父view时调用此方法
-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if ([newSuperview isKindOfClass:[UIScrollView class]]) {
        self.scrollView = (UIScrollView *)newSuperview;
        [self addObserver];
    }
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    pullingOffset = self.scrollView.contentOffset.y;
    
    if (pullingOffset > 0) return;
        
    //根据拖动的程度不同 来切换状态
    if (object == _scrollView && [keyPath isEqualToString:JRRefreshContentOffset]) {
        if (self.scrollView.isDragging) {
            
            BOOL normalAndDaySign = (pullingOffset < kPullRefreshHeight);
            
            if ((self.currenState == JRPullRefreshViewStateNormal) && normalAndDaySign) {
                self.currenState = JRPullRefreshViewStatePulling;
            }else if ((self.currenState == JRPullRefreshViewStatePulling) && pullingOffset >= kPullRefreshHeight){
                self.currenState = JRPullRefreshViewStateNormal;
            }
            
        }else{
            if (self.currenState == JRPullRefreshViewStatePulling) {
                self.currenState = JRPullRefreshViewStateRefreshing;
            }
        }
    }
}

#pragma mark - 切换状态

- (void)setCurrenState:(JRPullRefreshViewState)currenState{
    _currenState = currenState;
    switch (_currenState) {
        case JRPullRefreshViewStateNormal:
        {
            self.refreshLabel.text = @"下拉刷新";
        }
            break;
        case JRPullRefreshViewStatePulling:
        {
            self.refreshLabel.text = @"释放即可刷新";
        }
            break;
        case JRPullRefreshViewStateRefreshing:
        {
            self.refreshLabel.text = @"刷新中...";
            
            [UIView animateWithDuration:0.25f animations:^{
                self.scrollView.contentInset = UIEdgeInsetsMake(self.scrollView.contentInset.top - kPullRefreshHeight, self.scrollView.contentInset.left, self.scrollView.contentInset.bottom, self.scrollView.contentInset.right);
            }];
            
            if (self.refreshBlock) {
                self.refreshBlock();
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)endRefreshing{
    if (_currenState == JRPullRefreshViewStateRefreshing) {
        self.currenState = JRPullRefreshViewStateNormal;
        [UIView animateWithDuration:0.25f animations:^{
            self.scrollView.contentInset = UIEdgeInsetsMake(self.scrollView.contentInset.top + kPullRefreshHeight, self.scrollView.contentInset.left, self.scrollView.contentInset.bottom, self.scrollView.contentInset.right);
        }];
    }
}

#pragma mark - 添加和移除
- (void)addObserver {
    [self.scrollView addObserver:self forKeyPath:JRRefreshContentOffset options:NSKeyValueObservingOptionNew context:privateContext];
}
- (void)removeObserver {
    @try {
        [self.scrollView removeObserver:self forKeyPath:JRRefreshContentOffset context:privateContext];
    }
    @catch (NSException *exception) {
        NSLog(@"移除kvo异常");
    }
    
}

#pragma mark - Lazy load

- (UILabel *)refreshLabel{
    if (!_refreshLabel) {
        _refreshLabel = [[UILabel alloc] init];
        _refreshLabel.font = [UIFont getSystemFont:13.0f Weight:KFontWeightRegular];
        _refreshLabel.textAlignment = NSTextAlignmentCenter;
        _refreshLabel.adjustsFontSizeToFitWidth = YES;
        _refreshLabel.text = @"下拉刷新";
        _refreshLabel.textColor = [UIColor jrColorWithHex:@"#7F7F7F"];
    }
    return _refreshLabel;
}

@end
