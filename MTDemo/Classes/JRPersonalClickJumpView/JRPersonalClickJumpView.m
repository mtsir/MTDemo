//
//  JRPersonalClickJumpView.m
//  JRHomeChannel
//
//  Created by 刘爽 on 2020/04/03.
//

#import "JRPersonalClickJumpView.h"
#import <JDDUIKit/UIFont+Extend.h>
#import <JDDUIKit/UIView+JDFrame.h>
#import <JDDUIKit/UIColor+Extend.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <JRBFoundation/JRBFoundationMacro.h>
#import <JRBUIKit/JRBUIMacro.h>

static NSString * const kClickJumpAnimation = @"kClickJumpAnimation";

@interface JRPersonalClickJumpView()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIImageView *arrow;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation JRPersonalClickJumpView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.layer.cornerRadius =4;
        self.layer.masksToBounds = YES;
        
        [self.layer addSublayer:self.gradientLayer];
        [self addSubview:self.icon];
        [self addSubview:self.arrow];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)reloadPersonalClickJumpModel:(JRPersonalElevatorModel*)jumpModel{
    self.jumpModel =  jumpModel;
    if (jumpModel.bgColor1 && jumpModel.bgColor2){
        if ([jumpModel.bgColor1 isEqualToString:jumpModel.bgColor2]){
            self.backgroundColor = [UIColor jrColorWithHex:jumpModel.bgColor1];
            self.gradientLayer.hidden = YES;
        }else{
            self.backgroundColor = [UIColor clearColor];
            UIColor* bColor = [UIColor jrColorWithHex:jumpModel.bgColor1];
            UIColor* eColor = [UIColor jrColorWithHex:jumpModel.bgColor2];
            [self.gradientLayer setColors:@[(id)[bColor CGColor],(id)[eColor CGColor]]];
            self.gradientLayer.hidden = NO;
        }
    }else{
        self.backgroundColor =[UIColor colorWithWhite:0 alpha:0.8];
        self.gradientLayer.hidden = YES;
    }
    @JDJRWeakify(self);
    [self.icon sd_setImageWithURL:[NSURL URLWithString:jumpModel.imgUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        @JDJRStrongify(self);
        if (image)
        {
            self.icon.image = image;
            self.icon.backgroundColor = [UIColor clearColor];
        }else
        {
            self.icon.image = nil;
            self.icon.backgroundColor = [UIColor jrColorWithHex:@"#FAFAFA"];
        }
    }];
    
    self.titleLabel.text = jumpModel.title1.text;
    self.titleLabel.textColor = [UIColor jrColorWithHex:jumpModel.title1.textColor?:@"#FFFFFF"];
}

- (void)removeAnimation{
    [self.layer removeAnimationForKey:kClickJumpAnimation];
}

- (void)shakeAnimation{
    CGPoint endPosition = CGPointMake(self.layer.position.x, self.layer.position.y + 6);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:self.layer.position]];
    [animation setToValue:[NSValue valueWithCGPoint:endPosition]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.8f];
    [animation setRepeatCount:HUGE_VALF];
    [animation setRemovedOnCompletion:NO];
    [self.layer addAnimation:animation forKey:kClickJumpAnimation];
}

#pragma mark - 懒加载
- (CAGradientLayer *)gradientLayer{
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
        _gradientLayer.cornerRadius = 4;
        //从左至右
        _gradientLayer.startPoint = CGPointMake(0.0f, 0.5f);
        _gradientLayer.endPoint = CGPointMake(1.0f, 0.5f);
        _gradientLayer.locations = @[@0.0,@1.0];
        _gradientLayer.hidden = YES;
    }
    return _gradientLayer;
}

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [UIImageView new];
        _icon.frame = CGRectMake(6,6,self.height_jr-12,self.height_jr-12);
        _icon.layer.cornerRadius = 1;
        _icon.layer.masksToBounds = YES;
    }
    return _icon;
}

- (UIImageView *)arrow{
    if (!_arrow){
        _arrow =[UIImageView new];
        _arrow.frame = CGRectMake(self.width_jr-13-21,0, 21,self.height_jr);
        _arrow.image = [UIImage imageNamed:@"jr_credit_quick_jump"];
        _arrow.contentMode = UIViewContentModeCenter;
    }
    return _arrow;
}

-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.right_jr+10, 0,self.arrow.x_jr-self.icon.right_jr-20, self.height_jr)];
        _titleLabel.font = [UIFont getSystemFont:14 Weight:KFontWeightMedium];
    }
    return _titleLabel;
}

@end
