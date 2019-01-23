//
//  SoundWaveView.h
//  IntelliCom
//
//  Created by LeonDeng on 2019/1/22.
//  Copyright © 2019 . All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SoundWaveDataCollector.h"

NS_ASSUME_NONNULL_BEGIN

@interface SoundWaveView : UIView <SoundWaveDataCollectorDelegate>

// 同步对象，若需要采用同一个声源的多个View时，赋值此属性，则每当View需要更新的时候它会发消息给属性进行同样的更新。
@property (nonatomic, weak) SoundWaveView *synchronizedView;

- (instancetype)initWithFrame:(CGRect)frame GuageColor:(UIColor *)color DataCapasity:(NSInteger)capasity;

@end

NS_ASSUME_NONNULL_END
