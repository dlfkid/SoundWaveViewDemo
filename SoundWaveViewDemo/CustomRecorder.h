//
//  CustomRecorder.h
//  SoundWaveViewDemo
//
//  Created by LeonDeng on 2020/8/8.
//  Copyright © 2020 LeonDeng. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "SoundWaveDataCollector.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomRecorder : AVAudioRecorder <SoundWaveDataCollectorDataSource>

@end

NS_ASSUME_NONNULL_END
