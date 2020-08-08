//
//  CustomRecorder.m
//  SoundWaveViewDemo
//
//  Created by LeonDeng on 2020/8/8.
//  Copyright © 2020 LeonDeng. All rights reserved.
//

#import "CustomRecorder.h"

@interface CustomRecorder()

@end

@implementation CustomRecorder

- (instancetype)init {
    NSString *audioFilePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/MySound.caf"];
    
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] init];
    [recordSettings setValue :[NSNumber numberWithInt:kAudioFormatAppleIMA4] forKey:AVFormatIDKey];
    [recordSettings setValue:[NSNumber numberWithFloat:16000.0] forKey:AVSampleRateKey];
    [recordSettings setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
    
    NSError *error = nil;
    
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
    
    NSURL *url = [NSURL URLWithString:audioFilePath];
    
    error = nil;
    
    NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&error];
    if(audioData)
    {
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:[url path] error:&error];
    }
    
    error = nil;
    
    self = [super initWithURL:url settings:recordSettings error:&error];
    
    [self prepareToRecord];
    self.meteringEnabled = YES;
    
    return self;
}

#pragma mark - SoundWaveViewDataSource

- (Float64)volume {
    [self updateMeters];
    return [self averagePowerForChannel:0];
}

- (void)startRecording {
    [self record];
}

- (void)stopRecording {
    [self stop];
}


@end
