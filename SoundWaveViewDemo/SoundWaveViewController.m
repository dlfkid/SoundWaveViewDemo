//
//  SoundWaveViewController.m
//  SoundWaveViewDemo
//
//  Created by LeonDeng on 2019/1/23.
//  Copyright © 2019 LeonDeng. All rights reserved.
//

#import "SoundWaveViewController.h"

#import "SoundWaveDataCollector.h"
#import "SoundWaveView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Ex.h"

@interface SoundWaveViewController()

@property (nonatomic, strong) UIButton *startRecordButton;
@property (nonatomic, strong) UIButton *stopRecordButton;

@property (nonatomic, strong) SoundWaveDataCollector *soundCollector;
@property (nonatomic, strong) SoundWaveView *soundWave;

@end

@implementation SoundWaveViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"SoundWaveViewDemo";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _startRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_startRecordButton setTitle:@"Start" forState:UIControlStateNormal];
    [_startRecordButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_startRecordButton addTarget:self action:@selector(startRecordButtonDidTappedAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.startRecordButton];
    
    _stopRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_stopRecordButton setTitle:@"Stop" forState:UIControlStateNormal];
    [_stopRecordButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_stopRecordButton addTarget:self action:@selector(stopButtonDidTappedAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.stopRecordButton];
    
    _soundCollector =  [[SoundWaveDataCollector alloc] init];
    
    _soundWave = [[SoundWaveView alloc] initWithFrame:CGRectZero GuageColor:[UIColor tintColor] DataCapasity:12];
    
    _soundCollector.delegate = _soundWave;
    
    [self.view addSubview:self.soundWave];
}

- (void)updateViewConstraints {
    
    [self.startRecordButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.bottom.mas_equalTo(-80);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(44);
    }];
    
    [self.stopRecordButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-50);
        make.bottom.mas_equalTo(-80);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(44);
    }];
    
    [self.soundWave mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@(-30));
        make.height.equalTo(@300);
        make.left.equalTo(@50);
        make.right.equalTo(@(-50));
    }];
    
    [super updateViewConstraints];
}

#pragma mark - Actions

- (void)startRecordButtonDidTappedAction {
    [self.soundCollector startRecording];
}

- (void)stopButtonDidTappedAction {
    [self.soundCollector stopRecording];
}

@end
