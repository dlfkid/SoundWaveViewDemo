//
//  SoundWaveDataCollector.h
//
//
//  Created by LeonDeng on 2019/1/21.
//  Copyright © 2019 All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SoundWaveDataCollectorDelegate <NSObject>

@optional
- (void)updateGuageValue:(CGFloat)value;

@end

@interface SoundWaveDataCollector : NSObject

@property (nonatomic, weak) UIView <SoundWaveDataCollectorDelegate> *delegate;

- (void)startRecording;

// 终止录音
- (void)stopRecording;

@end

NS_ASSUME_NONNULL_END
