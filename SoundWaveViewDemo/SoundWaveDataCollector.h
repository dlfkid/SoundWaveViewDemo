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
@property (nonatomic, assign, readonly, getter =  isCollecting) BOOL collection;

@property (nonatomic, assign, readonly) Float64 volume;

- (void)startCollecting;

- (void)stopCollecting;

@end

@interface SoundWaveDataCollector : NSObject

/// 代理, 用于处理采集到的音量值
@property (nonatomic, weak) UIView <SoundWaveDataCollectorDelegate> *delegate;

/// 数据源, 通常是录音机等音频输入对象
@property (nonatomic, strong) id <SoundWaveDataCollectorDataSource> dataSource;

/// 开始采集音量数据
/// @param frequency 频率
- (void)collectWithFrequency:(NSTimeInterval)frequency;

/// 停止采集
- (void)stopCollecting;

@end

NS_ASSUME_NONNULL_END
