//
//  JRPersonalTabNavView.m
//  JRHomeChannel
//
//  Created by MacTavish on 2020/3/3.
//

#import "JRPersonalTabNavView.h"
#import <JRUIKit/JRUIKitPublic.h>
#import <JDDUIKit/UIView+JDFrame.h>
#import <SDWebImage/UIButton+WebCache.h>
#import <JRCDataModule/UserPreference.h>
#import <JRCFoundation/AppNotice.h>
#import <JRCJumpCenter/JRJumpCenter.h>
#import <JRUITemplates/JRTTitleBaseLabel.h>
#import <JRBUIKit/JRBubbleView.h>
#import <JRBUIKit/UIButton+EnlargeTouchArea.h>
#import <JRFoundation/AppManager.h>
#import <JRUIKit/JRUitlsCommon.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <JRFoundation/CacheModel.h>
#import <MJExtension/MJExtension.h>
#import <JRUIKit/JRNoticeManager.h>
#import <JDDFoundation/NSMutableDictionary+Check.h>
#import "JRPersonalTabModel.h"
#import "JRImageForceCache.h"
#import "JRPersonalTabViewModel.h"

const NSUInteger kIconWidth = 44.0f;

#pragma mark - 头像

@implementation JRPersonalHeadImageBtn

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.headImageView];
        [self addTarget:self action:@selector(headImageClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)headImageClick{
    UserInfoModel *userModel = [UserPreference getCurrentUserInfoModel];
    if (userModel.auth) {
        ClickEntity *entity = [[ClickEntity alloc]init];
        entity.jumpType = 5;
        entity.jumpNavi = 5016;
        [JRJumpCenter clictToView:entity];
    }else{
        [AppManager getUserhasLogin:nil];
    }
    [JRPersonalTabViewModel personalTabLandMine:@{@"bid":@"geren6001"} messageType:JRSocketMessageTypeForClick];
}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width_jr, self.height_jr)];
        [JRUitlsCommon addCircleCornerToView:_headImageView Corner:UIRectCornerAllCorners cornerRadius:self.width_jr / 2 borderWidth:0.0f borderColor:nil];
    }
    return _headImageView;
}

@end

#pragma mark - 右侧icons

@implementation JRPersonalNaviIconBtn
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake((self.width_jr - 24)/2, (self.height_jr - 24)/2, 24, 24);
}
@end

#pragma mark - 承载右侧icons

@interface JRPersonalNaviIconBackView ()
//最多右侧承载4个btn
@property(nonatomic, strong) NSArray<JRPersonalNaviIconModel*> *realIconList;
@property(nonatomic, strong) NSMutableArray *exposureArray;
@property(nonatomic, strong) JRPersonalNaviIconBtn *messageBtn;
@property(nonatomic, strong) JRPersonalNaviIconBtn *settingBtn;
@property(nonatomic, strong) JRBubbleView *cornerView;
@end

@implementation JRPersonalNaviIconBackView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //默认加载本地
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPersonalUnreadNum) name:MessageNumNotification object:nil];
        [self addSubview:self.settingBtn];
        [self addSubview:self.messageBtn];
    }
    return self;
}

#pragma mark - 本地按钮逻辑处理
- (CGFloat)localMessageProcessWith:(NSString*)msgUrl
                        settingUrl:(NSString*)settingUrl
                      localOriginX:(CGFloat)originX{
    //首先确定开关 控制本地兜底按钮的显示与否
    if ([CacheModel shareCache].sdkConfig.jrPersonalSettingFlag) {
        self.settingBtn.hidden = NO;
        UIImage *settingImg = [UIImage imageNamed:@"personalRightIcon_Setting" podName:@"JRHomeChannel"];
        if (settingUrl.length) {
            [JRImageForceCache jr_setImageWithButton:self.settingBtn urlStr:settingUrl forState:UIControlStateNormal placeholderImage:settingImg];
        }else{
            [self.settingBtn setImage:settingImg forState:UIControlStateNormal];
        }
    }else{
        self.settingBtn.hidden = YES;
    }
    
    if ([CacheModel shareCache].sdkConfig.jrPersonalMessageFlag) {
        self.messageBtn.hidden = NO;
        UIImage *messageImg = [UIImage imageNamed:@"personalRightIcon_Message" podName:@"JRHomeChannel"];
        if (msgUrl.length) {
            [JRImageForceCache jr_setImageWithButton:self.messageBtn urlStr:msgUrl forState:UIControlStateNormal placeholderImage:messageImg];
        }else{
            [self.messageBtn setImage:messageImg forState:UIControlStateNormal];
        }
        //主动读取未读数
        [self setLocalIconUnReadNumber:[JRNoticeManager shareInstance].unReadNumberString];
    }else{
        self.messageBtn.hidden = YES;
    }
    
    //计算localBtn的位置
    CGFloat localWidth = 88.0f;
    if (self.messageBtn.isHidden && !self.settingBtn.isHidden) {
        //仅设置显示
        localWidth = 44.0f;
        self.settingBtn.x_jr = originX;
    }else if (!self.messageBtn.isHidden && self.settingBtn.isHidden){
        //仅消息显示
        localWidth = 44.0f;
        self.messageBtn.x_jr = originX;
    }else if (!self.messageBtn.isHidden && !self.settingBtn.isHidden){
        //全部显示
        localWidth = 88.0f;
        self.messageBtn.x_jr = originX;
        self.settingBtn.x_jr = self.messageBtn.right_jr;
    }else{
        //都不显示
        localWidth = 0.0f;
        self.messageBtn.x_jr = originX;
        self.settingBtn.x_jr = self.messageBtn.right_jr;
    }
    
    return localWidth;
}

- (void)renderNaviBarIcons:(NSArray<JRPersonalNaviIconModel*> *)iconList
                messageUrl:(NSString*)msgUrl
                settingUrl:(NSString*)settingUrl{

    //先布局左侧下发icons
    for (JRPersonalNaviIconBtn *eachBtn in self.subviews) {
        if (eachBtn.tag == 10 || eachBtn.tag == 11) {
            [eachBtn removeFromSuperview];
        }
    }
    self.realIconList = iconList;
    @JDJRWeakify(self);
    [self.realIconList enumerateObjectsUsingBlock:^(JRPersonalNaviIconModel * _Nonnull iconModel, NSUInteger idx, BOOL * _Nonnull stop){
        @JDJRStrongify(self);
        JRPersonalNaviIconBtn *iconBtn = [JRPersonalNaviIconBtn buttonWithType:UIButtonTypeCustom];
        iconBtn.tag = 10+idx;
        iconBtn.frame = CGRectMake(kIconWidth * idx, 0, kIconWidth, kIconWidth);
        [iconBtn addTarget:self action:@selector(downloadIconClick:) forControlEvents:UIControlEventTouchUpInside];
        [JRImageForceCache jr_setImageWithButton:iconBtn urlStr:iconModel.iconUrl forState:UIControlStateNormal placeholderImage:nil];
        [self addSubview:iconBtn];
        //添加bubble
        [self appendIconUnReadNumber:iconModel.iconUrl.length ? iconModel.unReadNum : @"" withNaviIcon:iconBtn];
    }];
    
    //计算本地兜底icon所占宽度
    CGFloat localWidth = [self localMessageProcessWith:msgUrl
                                            settingUrl:settingUrl
                                          localOriginX:(iconList.count * kIconWidth)];

    //更新承载view的frame
    self.frame = CGRectMake(UIScreen_W - 8.0f - localWidth - kIconWidth*iconList.count, self.y_jr, kIconWidth*iconList.count + localWidth, kIconWidth);
    
}

#pragma mark - 处理点击
- (void)downloadIconClick:(UIButton *)sender{
    JRPersonalNaviIconModel *model = [self.realIconList objectAtIndexCheck:(sender.tag-10)];
    [JRJumpCenter clictToView:model.jumpEntity];
    [JRPersonalTabViewModel personalTabLandMine:model.trackData messageType:JRSocketMessageTypeForClick];
}

- (void)localBtnPress:(UIButton *)sender{
    
    //8-左边消息 6-右边设置
    NSInteger iconTag = sender.tag;
    
    ClickEntity *entity = [[ClickEntity alloc]init];
    entity.jumpType = 5;
    entity.jumpNavi = iconTag;
    [JRJumpCenter clictToView:entity];
    
    [JRPersonalTabViewModel personalTabLandMine:[self obtainLocalIconTrackData:iconTag] messageType:JRSocketMessageTypeForClick];
}

- (NSDictionary*)obtainLocalIconTrackData:(NSInteger)tag{
    //区分登录未登录
    UserInfoModel *userModel = [UserPreference getCurrentUserInfoModel];
    NSString *posid = [NSString stringWithFormat:@"%@",userModel.auth ? @"*24365*40821" : @"*24372*40831"];
    
    NSString *loginMatid = userModel.auth?@"*未读消息*":@"*消息*";//区分登录未登录
    NSString *matid = [NSString stringWithFormat:@"%@",tag == 8 ? loginMatid : @"*设置*"];
    
    NSString *ordid = [NSString stringWithFormat:@"%@",tag == 8 ? @"*0*0-0" : @"*0*1-0"];
    
    NSMutableDictionary *paramJsonDic = [NSMutableDictionary dictionary];
    [paramJsonDic setObjectCheck:posid forKey:@"posid"];
    [paramJsonDic setObjectCheck:@"mc-mkt-cms" forKey:@"sysCode"];
    [paramJsonDic setObjectCheck:matid forKey:@"matid"];
    [paramJsonDic setObjectCheck:@"1" forKey:@"pagid"];
    [paramJsonDic setObjectCheck:ordid forKey:@"ordid"];
    
    NSString *pJson = [paramJsonDic mj_JSONString];
    
    NSDictionary *trackDic = [NSDictionary dictionaryWithObjectsAndKeys:@"72818",@"bid",@"73186",@"ctp",(pJson?:@""),@"paramJson", nil];
    
    return trackDic;
}

#pragma mark - 设置下发及本地的气泡

- (void)appendIconUnReadNumber:(NSString *)number withNaviIcon:(JRPersonalNaviIconBtn*)icon{
    JRBubbleView *cornerView = [self generateCornerView];
    if (number.length > 0 && ![number isEqualToString:@"0"]) {
        [cornerView setText:number maxWidth:28];
        cornerView.centerX_jr = icon.width_jr - (number.length >= 3 ? 12.0f : 10.0f);
        [icon addSubview:cornerView];
    }else{
        [cornerView setText:@"" maxWidth:28];
    }
}

- (void)setLocalIconUnReadNumber:(NSString *)number{
    if (number.length > 0 && ![number isEqualToString:@"0"]) {
        [self.cornerView setText:number maxWidth:28];
        self.cornerView.centerX_jr = kIconWidth - (number.length >= 3 ? 12.0f : 10.0f);
    }else{
        [self.cornerView setText:@"" maxWidth:28];
    }
}
//通知更改未读消息
- (void)refreshPersonalUnreadNum{
    //被动接收未读数
    [self setLocalIconUnReadNumber:[JRNoticeManager shareInstance].unReadNumberString];
}

- (JRBubbleView *)generateCornerView{
    JRBubbleView *cornerView = [[JRBubbleView alloc]initWithFrame:CGRectMake(27.0f, 5.0f, 16.0f, 16.0f)];
    [cornerView setTextColor:[UIColor jrColorWithHex:@"#ffffff"]];
    [cornerView setCorners:UIRectCornerAllCorners];
    [cornerView setTextFont:[UIFont getSystemFont:10 Weight:KFontWeightSemibold]];
    [cornerView setBackgroundColor:[UIColor jrColorWithHex:@"#EF4034"]];
    [cornerView setLineWidth:1.0f];
    return cornerView;
}

- (NSArray *)exposureData{
    [self.exposureArray removeAllObjects];
    
    //获取本地及下发的icon进行曝光 8-左边消息 6-右边设置
    if (!self.messageBtn.isHidden) {
        [self.exposureArray addObjectCheck:[self obtainLocalIconTrackData:8]];
    }
    if (!self.settingBtn.isHidden) {
        [self.exposureArray addObjectCheck:[self obtainLocalIconTrackData:6]];
    }
    for (JRPersonalNaviIconModel *iconObj in self.realIconList) {
        [self.exposureArray addObjectCheck:iconObj.trackData];
    }
    return self.exposureArray;
}

- (NSMutableArray *)exposureArray {
    if (!_exposureArray) {
        _exposureArray = [NSMutableArray new];
    }
    return _exposureArray;
}
- (JRPersonalNaviIconBtn *)settingBtn {
    if (!_settingBtn) {
        _settingBtn = [[JRPersonalNaviIconBtn alloc]initWithFrame:CGRectMake(self.width_jr - kIconWidth, 0, kIconWidth, kIconWidth)];
        [_settingBtn setImage:[UIImage imageNamed:@"personalRightIcon_Setting" podName:@"JRHomeChannel"] forState:UIControlStateNormal];
        [_settingBtn addTarget:self action:@selector(localBtnPress:) forControlEvents:UIControlEventTouchUpInside];
        _settingBtn.tag = 6;
    }
    return _settingBtn;
}
- (JRPersonalNaviIconBtn *)messageBtn {
    if (!_messageBtn) {
        _messageBtn = [[JRPersonalNaviIconBtn alloc]initWithFrame:CGRectMake(_settingBtn.x_jr - kIconWidth, 0, kIconWidth, kIconWidth)];
        [_messageBtn setImage:[UIImage imageNamed:@"personalRightIcon_Message" podName:@"JRHomeChannel"] forState:UIControlStateNormal];
        [_messageBtn addTarget:self action:@selector(localBtnPress:) forControlEvents:UIControlEventTouchUpInside];
        [_messageBtn addSubview:self.cornerView];
        _messageBtn.tag = 8;
    }
    return _messageBtn;
}
- (JRBubbleView *)cornerView {
    if (!_cornerView) {
        _cornerView = [[JRBubbleView alloc]initWithFrame:CGRectMake(27.0f, 5.0f, 16.0f, 16.0f)];
        [_cornerView setTextColor:[UIColor jrColorWithHex:@"#ffffff"]];
        [_cornerView setCorners:UIRectCornerAllCorners];
        [_cornerView setTextFont:[UIFont getSystemFont:10 Weight:KFontWeightSemibold]];
        [_cornerView setBackgroundColor:[UIColor jrColorWithHex:@"#EF4034"]];
        [_cornerView setLineWidth:1.0f];
    }
    return _cornerView;
}
@end

#pragma mark - 导航条

@interface JRPersonalTabNavView ()
@property(nonatomic, strong) JRPersonalHeadImageBtn *leftHead;
@property(nonatomic, strong) JRTTitleBaseLabel *centerLabel;
@property(nonatomic, strong) JRPersonalNaviIconBackView *iconBackView;
@end

@implementation JRPersonalTabNavView

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MainRefreshoUserInfo object:nil];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNaviItem) name:MainRefreshoUserInfo object:nil];
        [self addSubview:self.leftHead];
        [self addSubview:self.centerLabel];
        [self addSubview:self.iconBackView];
    }
    return self;
}
#pragma mark - 刷新左侧头像
- (void)refreshNaviItem{
    UserInfoModel *userModel = [UserPreference getCurrentUserInfoModel];
    if (userModel.auth) {
        self.centerLabel.hidden = NO;
        [self.leftHead.headImageView sd_setImageWithURL:[NSURL URLWithString:userModel.imageUrl] placeholderImage:[UIImage imageNamed:@"main_avatar"]];
    }else{
        self.centerLabel.hidden = YES;
        self.leftHead.headImageView.image = [UIImage imageNamed:@"main_avatar"];
    }
}

#pragma mark - 滑动渐隐

-(void)setNaviViewAlpha:(CGFloat)alpha{
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:FCMP_G(alpha, 1.0f) ? 1.0f : alpha];
}

-(void)setMidRightAlpha:(CGFloat)alpha{
    self.centerLabel.alpha = FCMP_G(alpha, 1.0f) ? 1.0f : alpha;
    self.iconBackView.alpha = FCMP_G(alpha, 1.0f) ? 1.0f : alpha;
}

- (void)setLeftHeadAlpha:(CGFloat)alpha{
    self.leftHead.alpha = FCMP_G(alpha, 1.0f) ? 1.0f : alpha;
    self.leftHead.userInteractionEnabled = (self.leftHead.alpha > 0.0f);
}


#pragma mark - 加载导航条

- (void)renderNaviBarViewWith:(JRPersonalTopSummaryModel *)topSummaryModel{
    //头像及label刷新
    [self refreshNaviItem];
    //中间文本
    [self.centerLabel setTitleLabelWithInfo:topSummaryModel.nameTitle defaultTextColor:@"#333333"];
    if (!topSummaryModel.nameTitle.text.length) {
        self.centerLabel.text = @"我的";
    }
    //加载右侧icon
    NSArray<JRPersonalNaviIconModel*> *realIconList = topSummaryModel.iconList;
    if (realIconList.count > 2) {
        //截取前4个
        realIconList = [realIconList subarrayWithRange:NSMakeRange(0, 2)];
    }
    [self.iconBackView renderNaviBarIcons:realIconList
                               messageUrl:topSummaryModel.messageUrl
                               settingUrl:topSummaryModel.settingUrl];
}

#pragma mark - lazy

- (JRPersonalHeadImageBtn *)leftHead {
    if (!_leftHead) {
        _leftHead = [[JRPersonalHeadImageBtn alloc]initWithFrame:CGRectMake(10.0f, self.height_jr - 36.5f, 29.0f, 29.0f)];
        [_leftHead setEnlargeEdgeWithTop:15 right:10 bottom:10 left:10];
        _leftHead.alpha = 0.0f;
//        _leftHead.headImageView.image = [UIImage imageNamed:@"main_avatar"];
    }
    return _leftHead;
}

- (JRTTitleBaseLabel *)centerLabel {
    if (!_centerLabel) {
        _centerLabel = [[JRTTitleBaseLabel alloc]initWithFrame:CGRectMake((self.width_jr - 40.0f)/2.0f, StateBar_H+10.0f, 40, 24)];
        _centerLabel.centerY_jr = _leftHead.centerY_jr;
        _centerLabel.font = [UIFont getSystemFont:17.0f Weight:KFontWeightMedium];
        _centerLabel.textAlignment = NSTextAlignmentCenter;
        _centerLabel.alpha = 0.0f;
//        _centerLabel.text = @"我的";
    }
    return _centerLabel;
}

- (JRPersonalNaviIconBackView *)iconBackView {
    if (!_iconBackView) {
        _iconBackView = [[JRPersonalNaviIconBackView alloc] initWithFrame:CGRectMake(UIScreen_W - 8.0f - kIconWidth * 2, 0, kIconWidth * 2, kIconWidth)];
        _iconBackView.centerY_jr = self.centerLabel.centerY_jr;
        _iconBackView.alpha = 0.0f;
    }
    return _iconBackView;
}

@end
