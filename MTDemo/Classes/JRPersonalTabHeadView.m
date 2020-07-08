//
//  JRPersonalTabHeadView.m
//  JRHomeChannel
//
//  Created by MacTavish on 2020/3/3.
//

#import "JRPersonalTabHeadView.h"
#import <JRUITemplates/JRCustomEdgeLabel.h>
#import <JRCDataModule/UserPreference.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <JRBFoundation/NSString+Additions.h>
#import <JRUITemplates/JRTTitleBaseLabel.h>
#import <JRFoundation/AppManager.h>
#import <JRCJumpCenter/JRJumpCenter.h>
#import <JRCFoundation/AppNotice.h>

#import "JRPersonalTabNavView.h"
#import "JRImageForceCache.h"

@interface JRPersonalTabHeadView ()

/**头像*/
@property(nonatomic, strong) JRPersonalHeadImageBtn *userImageBtn;
/**昵称*/
@property (nonatomic, strong) UILabel *nameLabel;
/**icon*/
@property(nonatomic, strong) JRPersonalNaviIconBackView *iconHeadBackView;
/**小白信用*/
@property(nonatomic, strong) JRTTitleBaseLabel *creditLabel;
/**账户保障*/
@property(nonatomic, strong) JRCustomEdgeLabel *accountProtectLabel;
/**账户保障左侧icon*/
@property(nonatomic, strong) UIImageView *iconImage;

/**未登录昵称右侧箭头*/
@property(nonatomic, strong) UIImageView *rightArrow;

@property(nonatomic, strong) JRTElementBaseView *creditControl;

@property(nonatomic, strong) JRTElementBaseView *accountProtectControl;

@end


@implementation JRPersonalTabHeadView
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MainRefreshoUserInfo object:nil];
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCurrentUI) name:MainRefreshoUserInfo object:nil];

        [self addSubview:self.userImageBtn];
        [self addSubview:self.nameLabel];
        [self addSubview:self.rightArrow];
        [self addSubview:self.iconHeadBackView];
        [self addSubview:self.creditLabel];
        [self addSubview:self.accountProtectLabel];

    }
    return self;
}

- (void)renderPersonalTabHeaderView:(JRPersonalTopSummaryModel *)topSummaryModel{
    
    //加载右侧icon
    NSArray<JRPersonalNaviIconModel*> *realIconList = topSummaryModel.iconList;
    if (realIconList.count > 2) {
        //截取前2个
        realIconList = [realIconList subarrayWithRange:NSMakeRange(0, 2)];
    }
    [self.iconHeadBackView renderNaviBarIcons:realIconList
                                   messageUrl:topSummaryModel.messageUrl
                                   settingUrl:topSummaryModel.settingUrl];
    
    //刷新头像昵称
    [self refreshCurrentUI];
    
    UserInfoModel *userModel = [UserPreference getCurrentUserInfoModel];
    if (userModel && userModel.auth){
        //小白信用
        CGFloat maxWidth = (self.width_jr - 20.5f - self.nameLabel.x_jr)/2.0f - 16.0f;
        NSString *xbCreditString = topSummaryModel.xbCredit.xbTitle.text;
        if (xbCreditString.length > 0) {
            self.creditLabel.hidden = NO;
            CGFloat realCreditWidth = [xbCreditString jr_integerSizeWithFont:_creditLabel.font].width;
            if (realCreditWidth > maxWidth) {
                realCreditWidth = maxWidth;
            }
            //信用点击及曝光
            [self.creditControl setElementViewUIModel:topSummaryModel.xbCredit];
            self.creditLabel.width_jr = realCreditWidth + 16.0f;
            self.creditControl.width_jr = self.creditLabel.width_jr;
            [self.creditLabel setTitleLabelWithInfo:topSummaryModel.xbCredit.xbTitle defaultTextColor:@"#C5AA85" defaultBgColor:@"#FFFFFF"];
            self.creditLabel.layer.borderColor = [UIColor jrColorWithHex:topSummaryModel.xbCredit.xbTitle.textColor?:@"#DFCBB0"].CGColor;
        }else{
            self.creditLabel.hidden = YES;
        }
        //账户保障
        NSString *accountProtectString = topSummaryModel.accountProtect.protectTitle.text;
        if (accountProtectString.length > 0) {
            self.accountProtectLabel.hidden = NO;
            self.accountProtectLabel.text = accountProtectString;
            self.accountProtectLabel.textColor = [UIColor jrColorWithHex:topSummaryModel.accountProtect.protectTitle.textColor?:@"#C5AA85"];
            self.accountProtectLabel.layer.borderColor = [UIColor jrColorWithHex:topSummaryModel.xbCredit.xbTitle.textColor?:@"#DFCBB0"].CGColor;
            
            //左侧icon
            self.iconImage.backgroundColor = [UIColor jrColorWithHex:@"#FAFAFA"];
            [self.iconImage sd_setImageWithURL:[NSURL URLWithString:topSummaryModel.accountProtect.imgUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    self.iconImage.backgroundColor = [UIColor clearColor];
                }
            }];
            
            CGFloat accountWidth = [accountProtectString jr_integerSizeWithFont:self.accountProtectLabel.font].width + 35.0f;
            self.accountProtectLabel.width_jr = (accountWidth > maxWidth+16.0f) ? maxWidth+16.0f : accountWidth;
            //账户保障点击及曝光
            [self.accountProtectControl setElementViewUIModel:topSummaryModel.accountProtect];
            self.accountProtectLabel.x_jr = self.creditLabel.right_jr + 4.5f;
        }else{
            self.accountProtectLabel.hidden = YES;
        }
        
    }
}

- (void)refreshCurrentUI{
    UserInfoModel *userModel = [UserPreference getCurrentUserInfoModel];
    if (userModel.auth) {
        self.rightArrow.hidden = YES;
        
        [self.userImageBtn.headImageView sd_setImageWithURL:[NSURL URLWithString:userModel.imageUrl] placeholderImage:[UIImage imageNamed:@"main_avatar"]];

        //登录情况下重新调整昵称位置
        self.nameLabel.y_jr = self.userImageBtn.y_jr;
        self.nameLabel.width_jr = self.iconHeadBackView.isHidden ? (self.width_jr - self.nameLabel.x_jr - 16.0f) : self.iconHeadBackView.x_jr - self.nameLabel.x_jr - 16.0f;
        self.nameLabel.text = userModel.nickName;
    }else{
        self.rightArrow.hidden = NO;
        self.nameLabel.text = @"登录/注册";
        self.userImageBtn.headImageView.image = [UIImage imageNamed:@"main_avatar"];
        //调整昵称位置
        self.nameLabel.centerY_jr = self.userImageBtn.centerY_jr;
        self.nameLabel.width_jr = [self.nameLabel.text jr_integerSizeWithFont:self.nameLabel.font].width;
        self.rightArrow.x_jr = self.nameLabel.right_jr;
        
        self.creditLabel.hidden = YES;
        self.accountProtectLabel.hidden = YES;
    }
}

#pragma mark - lazy

- (JRPersonalHeadImageBtn *)userImageBtn{
    if (!_userImageBtn) {
        _userImageBtn = [[JRPersonalHeadImageBtn alloc] initWithFrame:CGRectMake(18,StateBar_H+20.0f,55,55)];
        //初始化时候就直接创建userImageBtn
        self.userImageBtn.headImageView.image = [UIImage imageNamed:@"main_avatar"];
    }
    return _userImageBtn;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userImageBtn.right_jr + 12.0f, _userImageBtn.y_jr, self.width_jr - 165.0f, 25.0f)];
        _nameLabel.font = [UIFont getSystemFont:18.0f Weight:KFontWeightSemibold];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = [UIColor jrColorWithHex:@"#333333"];
        _nameLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapName = [[UITapGestureRecognizer alloc]initWithTarget:self.userImageBtn action:@selector(headImageClick)];
        [_nameLabel addGestureRecognizer:tapName];
    }
    return _nameLabel;
}
- (UIImageView *)rightArrow {
    if (!_rightArrow) {
        _rightArrow = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 14.0f, 14.0f)];
        _rightArrow.centerY_jr = _userImageBtn.centerY_jr;
        UIImage *image = [UIImage imageNamed:@"com_arrow_to_right" podName:@"JRUITemplates"];
        _rightArrow.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _rightArrow.tintColor = [UIColor jrColorWithHex:@"#333333"];
        _rightArrow.hidden = YES;
    }
    return _rightArrow;
}
- (JRPersonalNaviIconBackView *)iconHeadBackView {
    if (!_iconHeadBackView) {
        _iconHeadBackView = [[JRPersonalNaviIconBackView alloc] initWithFrame:CGRectMake(UIScreen_W - 8.0f - kIconWidth * 2, self.userImageBtn.y_jr - 10.0f, kIconWidth * 2, kIconWidth)];
    }
    return _iconHeadBackView;
}
- (JRTTitleBaseLabel *)creditLabel {
    if (!_creditLabel) {
        _creditLabel = [[JRTTitleBaseLabel alloc]initWithFrame:CGRectMake(_nameLabel.x_jr, _nameLabel.bottom_jr + 8.0f, 98.0f, 21.0f)];
        _creditLabel.font = [UIFont getSystemFont:12.0f Weight:KFontWeightMedium];
        _creditLabel.textAlignment = NSTextAlignmentCenter;
        _creditLabel.layer.cornerRadius = 10.5f;
        _creditLabel.layer.masksToBounds = YES;
        _creditLabel.layer.borderColor = [UIColor jrColorWithHex:@"#DFCBB0"].CGColor;
        _creditLabel.layer.borderWidth = SINGLE_LINE_HEIGHT(1);
        _creditLabel.userInteractionEnabled = YES;
        [_creditLabel addSubview:self.creditControl];
        _creditLabel.hidden = YES;
    }
    return _creditLabel;
}

- (JRCustomEdgeLabel *)accountProtectLabel {
    if (!_accountProtectLabel) {
        _accountProtectLabel = [[JRCustomEdgeLabel alloc]initWithFrame:CGRectMake(102.5f, _creditLabel.y_jr, 93.0f, 21.0f)];
        _accountProtectLabel.font = [UIFont getSystemFont:JR_Big_Screen_Width ? 12.0f : 11.0f Weight:KFontWeightMedium];
        _accountProtectLabel.edgeInsets = UIEdgeInsetsMake(0, 25, 0, 8);
        _accountProtectLabel.layer.cornerRadius = 10.5f;
        _accountProtectLabel.layer.masksToBounds = YES;
        _accountProtectLabel.layer.borderColor = [UIColor jrColorWithHex:@"#DFCBB0"].CGColor;
        _accountProtectLabel.layer.borderWidth = SINGLE_LINE_HEIGHT(1);
        _accountProtectLabel.userInteractionEnabled = YES;
        [_accountProtectLabel addSubview:self.iconImage];
        [_accountProtectLabel addSubview:self.accountProtectControl];
        _accountProtectLabel.hidden = YES;
    }
    return _accountProtectLabel;
}
- (UIImageView *)iconImage {
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(8.0f,3.5f, 14.0f, 14.0f)];
    }
    return _iconImage;
}

- (JRTElementBaseView *)creditControl {
    if (!_creditControl) {
        _creditControl = [[JRTElementBaseView alloc]initWithFrame:_creditLabel.bounds];
        [_creditControl removeClickState];
    }
    return _creditControl;
}

- (JRTElementBaseView *)accountProtectControl {
    if (!_accountProtectControl) {
        _accountProtectControl = [[JRTElementBaseView alloc]initWithFrame:_accountProtectLabel.bounds];
        [_accountProtectControl removeClickState];
    }
    return _accountProtectControl;
}
@end
