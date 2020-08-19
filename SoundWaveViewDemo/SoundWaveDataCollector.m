//
//  SoundWaveDataCollector.m
//
//
//  Created by LeonDeng on 2019/1/21.
//  Copyright © 2019. All rights reserved.
//

#import "SoundWaveDataCollector.h"

// Controllers
#import <PSTAlertController/PSTAlertController.h>

// Helpers
#import "WeakProxy.h"
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <Masonry/Masonry.h>
#import "UIColor+Ex.h"

@interface SoundWaveDataCollector()<AVAudioRecorderDelegate>

{
    NSInteger arrayCapasity;
}

// 用于储存音量大小的数组
@property (nonatomic, strong) NSMutableArray *soundVolumeArray;

@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic, strong) dispatch_queue_t timerQueue;

@end

static NSString * const kTimerQueueName = @"SoundWaveView.Timer.Queue";

@implementation SoundWaveDataCollector

- (instancetype)init {
    if (self = [super init]) {
        _timerQueue = dispatch_queue_create(kTimerQueueName.UTF8String, DISPATCH_QUEUE_SERIAL);
    }
    return self;;
}

-(void)dealloc {
    dispatch_source_cancel(self.timer);
}

#pragma mark - Actions

-  (void)collectWithFrequency:(NSTimeInterval)frequency {
    __weak typeof(self) weakSelf = self;
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.timerQueue);
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, (uint64_t)frequency * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.timer, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf updateSoundVolumeArray];
    });
    dispatch_resume(self.timer);
    [self.dataSource startCollecting];
}

- (void)updateSoundVolumeArray {
    Float64 volumeValue = 0;
    if (self.dataSource.isCollecting) {
        volumeValue = self.dataSource.volume;
    }
    if ([self.delegate respondsToSelector:@selector(updateGuageValue:)]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.delegate updateGuageValue:volumeValue];
        });
    }
}

- (void)stopCollecting {
    [self.dataSource stopCollecting];
}

@end
