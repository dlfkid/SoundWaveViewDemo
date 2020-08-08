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
- (void)updateGuageValue:(Float64)value;

@end

@protocol SoundWaveDataCollectorDataSource

@required
@property (nonatomic, assign, readonly, getter =  isRecording) BOOL recording;

@property (nonatomic, assign, readonly) Float64 volume;

- (void)startRecording;

- (void)stopRecording;

@end

@interface SoundWaveDataCollector : NSObject

@property (nonatomic, weak) UIView <SoundWaveDataCollectorDelegate> *delegate;
@property (nonatomic, strong) id <SoundWaveDataCollectorDataSource> dataSource;

/// 开始采集音量数据
/// @param frequency 频率
- (void)collectWithFrequency:(NSTimeInterval)frequency;

/// 停止采集
- (void)stopCollecting;

@end

NS_ASSUME_NONNULL_END
