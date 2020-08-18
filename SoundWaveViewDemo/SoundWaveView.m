//
//  SoundWaveView.m
//  IntelliCom
//
//  Created by LeonDeng on 2019/1/22.
//  Copyright © 2019 . All rights reserved.
//

#import "SoundWaveView.h"

// Helpers
#import <Masonry/Masonry.h>

@interface SoundWaveView()

@property (nonatomic, strong) UIColor *guageColor;
@property (nonatomic, assign) NSInteger dataCapasity;
@property (nonatomic, strong) NSMutableArray *soundVolumeDataArray;
@property (nonatomic, assign) CGFloat zeroHeight;
@property (nonatomic, assign) CGFloat guageWidth;
@property (nonatomic, assign) CGFloat guageInsect;

@property (nonatomic, strong) NSMutableArray *guageArray;

@end

@implementation SoundWaveView

- (void)dealloc {
    NSLog(@"Sound wave view dealloced : %@", self);
}


+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (CGFloat)guageInsect {
    // 间隔是自身宽度的3分之2
    return (self.frame.size.width / self.dataCapasity) * 0.7;
}

- (CGFloat)zeroHeight {
    return self.frame.size.height / 2;
}

- (CGFloat)guageWidth {
    return self.frame.size.width / self.dataCapasity - self.guageInsect;
}

- (instancetype)initWithFrame:(CGRect)frame GuageColor:(UIColor *)color DataCapasity:(NSInteger)capasity {
    self = [super initWithFrame:frame];
    if (self) {
        _guageColor = color;
        _dataCapasity = capasity;
        _soundVolumeDataArray = [NSMutableArray arrayWithCapacity:capasity];
        _guageArray = [NSMutableArray arrayWithCapacity:capasity];
        
        __weak typeof(self) weakSelf = self;
        void (^generateSoundGuageView)(NSInteger guageIndex) = ^(NSInteger guageIndex) {
            UIView *soundGage = [[UIView alloc] initWithFrame:CGRectZero];
            soundGage.backgroundColor = weakSelf.guageColor;
            [weakSelf.guageArray addObject:soundGage];
            [weakSelf addSubview:soundGage];
        };
        
        for (int i = 0; i < self.dataCapasity; i ++ ) {
            [self.soundVolumeDataArray addObject:@0];
            generateSoundGuageView(i);
        }
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    [self layoutIfNeeded];
    for (int i = 0; i < self.dataCapasity; i ++) {
        UIView *guage = self.guageArray[i];
        guage.layer.cornerRadius = self.guageWidth / 2;
        [guage mas_updateConstraints:^(MASConstraintMaker *make) {
            if (i - 1 < 0) {
                // 第一个音波要左移半个间隔，这样才能使图形在正中间
                make.left.mas_equalTo(self.guageInsect / 2);
            } else {
                UIView *previousGuage = self.guageArray[i - 1];
                make.left.mas_equalTo(previousGuage.mas_right).mas_offset(self.guageInsect);
            }
            make.height.mas_equalTo(self.zeroHeight);
            make.width.mas_equalTo(self.guageWidth);
            make.centerY.equalTo(@0);
        }];
    }
}

#pragma mark - delegate

- (void)updateGuageValue:(CGFloat)value {
    // 每次更新数据最后一位
    [self soundDataUpdate:value index:self.dataCapasity - 1];
    // 更新同步View的数据
    if (self.synchronizedView) {
        [self.synchronizedView soundDataUpdate:value index:self.dataCapasity - 1];
    }
}

- (void)soundDataUpdate:(CGFloat)data index:(NSInteger)index {
    // 更新guage动画
    UIView *guage = self.guageArray[index];
    [guage mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat heightWave = self.zeroHeight * data / 100;
        make.height.mas_equalTo(self.zeroHeight + heightWave);
        make.width.mas_equalTo(self.guageWidth);
    }];
    
    [UIView animateWithDuration:0.1f animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {

    }];
    
    NSNumber *lastData = self.soundVolumeDataArray[index];
    self.soundVolumeDataArray[index] = [NSNumber numberWithFloat:data];
    if (index > 0) {
        [self soundDataUpdate:lastData.floatValue index:index - 1];
    }
}


@end
