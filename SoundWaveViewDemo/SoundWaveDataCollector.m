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
// 定时获取音量的计时器
@property (nonatomic, strong) NSTimer *soundDataCaptureTimer;
// 录音时间
@property (nonatomic, assign) CGFloat recordTime;
// 录音机对象
@property (nonatomic, strong) AVAudioRecorder *recorder;
// 录音目录
@property (nonatomic, copy) NSString *audioFilePath;


@end

static CGFloat const kwaveUpdateFrequency = 0.1f;

@implementation SoundWaveDataCollector

- (NSString *)audioFilePath {
    if (!_audioFilePath) {
        _audioFilePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/MySound.caf"];
    }
    return _audioFilePath;
}

-(void)dealloc {
    // 在本对象释放之前要先将计时器从Runloop中移除，否则将造成内存泄漏
    [self stopRecording];
    NSLog(@"Sound Data recorder dealloced : %@", self);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] init];
        [recordSettings setValue :[NSNumber numberWithInt:kAudioFormatAppleIMA4] forKey:AVFormatIDKey];
        [recordSettings setValue:[NSNumber numberWithFloat:16000.0] forKey:AVSampleRateKey];
        [recordSettings setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
        
        NSError *error = nil;
        
        self.recordTime = 0;
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        
        [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&error];
        if(error){
            NSLog(@"audioSession: %@ %ld %@", [error domain], (long)[error code], [[error userInfo] description]);
        }
        
        error = nil;
        
        [audioSession setActive:YES error:&error];
        if(error){
            NSLog(@"audioSession: %@ %ld %@", [error domain], (long)[error code], [[error userInfo] description]);
        }
        
        NSURL *url = [NSURL URLWithString:self.audioFilePath];
        
        error = nil;
        
        NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&error];
        if(audioData)
        {
            NSFileManager *fm = [NSFileManager defaultManager];
            [fm removeItemAtPath:[url path] error:&error];
        }
        
        error = nil;
        
        _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&error];
        
        if(!self.recorder){
            PSTAlertController *controller = [PSTAlertController alertControllerWithTitle:@"Recorder failed to initialized" message:error.localizedDescription preferredStyle:PSTAlertControllerStyleAlert];
            PSTAlertAction *cancelAction = [PSTAlertAction actionWithTitle:@"OK" handler:^(PSTAlertAction * _Nonnull action) {
                NSLog(@"recorder: %@ %ld %@", [error domain], (long)[error code], [[error userInfo] description]);
            }];
            [controller addAction:cancelAction];
            [controller showWithSender:nil controller:nil animated:YES completion:nil];
        }
        
        self.recorder.delegate = self;
        [self.recorder prepareToRecord];
        self.recorder.meteringEnabled = YES;
        
        BOOL audioHWAvailable = audioSession.isInputAvailable;
        if (!audioHWAvailable) {
            PSTAlertController *controller = [PSTAlertController alertControllerWithTitle:@"Recorder failed to initialized" message:@"Audio input hardware not available" preferredStyle:PSTAlertControllerStyleAlert];
            PSTAlertAction *cancelAction = [PSTAlertAction actionWithTitle:@"OK" handler:^(PSTAlertAction * _Nonnull action) {
                
            }];
            [controller addAction:cancelAction];
            [controller showWithSender:nil controller:nil animated:YES completion:nil];
        }
    }
    return self;
}

#pragma mark - Actions

- (void)startRecording {
    // 开始录音
    [self.recorder record];
    
    // 采集录音数据,防止重复赋值
    if (!self.soundDataCaptureTimer) {
        self.soundDataCaptureTimer = [NSTimer scheduledTimerWithTimeInterval:kwaveUpdateFrequency target:self selector:@selector(updateSoundVolumeArray) userInfo:nil repeats:YES];
    }
}

- (void)updateSoundVolumeArray {
    if (!self.recorder.isRecording) {
        return;
    }
    [self.recorder updateMeters];
    // 根据需要选择峰值音量或是平均音量
    NSLog(@"meter:%5f", [self.recorder averagePowerForChannel:0]);
    if (([self.recorder averagePowerForChannel:0] < -60.0) && (self.recordTime > 3.0)) {
        [self stopRecording];
        return;
    }
    self.recordTime += kwaveUpdateFrequency;
    if ([self.delegate respondsToSelector:@selector(updateGuageValue:)]) {
        [self.delegate updateGuageValue:[self.recorder averagePowerForChannel:0]];
    }
}


- (void)stopRecording {
    if (self.recorder.isRecording) {
        [self.recorder stop];
        [self.recorder deleteRecording];
    }
    if (self.soundDataCaptureTimer) {
        [self.soundDataCaptureTimer invalidate];
        self.soundDataCaptureTimer = nil;
    }
}

@end
